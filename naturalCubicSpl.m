function val = naturalCubicSpl(x,y,xx)

	if length(x(1,:))>1
		x = x';
	end%col vector

	if length(y(1,:))>1
		y = y';
	end%col vector


	n = length(x) - 1;
	nxx = length(xx);
	hy = diff(y);
	h = diff(x);
	lamda = h(2:end)./(h(1:end-1)+h(2:end));
	miu = h(1:end-1)./(h(1:end-1)+h(2:end));
	g = 3*(miu.*hy(2:end)./h(2:end)+lamda.*hy(1:end-1)./h(1:end-1));

	ff0 = 0;
	ffn = 0;
	g0 = 3*hy(1)/h(1)-h(1)/2*ff0;
	gn = 3*hy(end)/h(end)+h(end)/2*ffn;

	rowLamda = 2:n;
	colLamda = 1:n-1;
	rowMiu = rowLamda;
	colMiu = 3:n+1;

%	if length(lamda(:,1))>1
%		lamda = lamda';
%	end%row vector

%	if length(miu(:,1))>1
%		miu = miu';
%	end%row vector

%	if length(g(1,:))>1
%		g = g';
%	end%col vector

	lamda = lamda';%change to row vector
	miu = miu';%change to row vector

	MAT = sparse([rowLamda n+1 rowMiu 1 1:n+1],...
				 [colLamda n colMiu 2 1:n+1],...
				 [lamda 1 miu 1 2*ones(1,n+1)],...
				 n+1,n+1);

	G = [g0;g;gn];

	m = MAT\G;%col vector

	if length(xx(:,1))>1
		xx = xx';
	end%row vector

	tmp = (repmat(x(1:end-1),1,nxx)-repmat(xx,n,1)).*(repmat(x(2:end),1,nxx)-repmat(xx,n,1));
	[tmpRow,tmpCol] = find(tmp<0);
	[~,idx1] = sort(tmpCol);
	idx = tmpRow(idx1);

	xx = xx';%col vector now

	val = (h(idx)+2*(xx-x(idx))).*(xx-x(idx+1)).^2.*y(idx)./h(idx).^3 + ...
		  (h(idx)-2*(xx-x(idx+1))).*(xx-x(idx)).^2.*y(idx+1)./h(idx).^3 + ...
		  (xx-x(idx)).*(xx-x(idx+1)).^2.*m(idx)./h(idx).^2 + ...
		  (xx-x(idx+1)).*(xx-x(idx)).^2.*m(idx+1)./h(idx).^2;
end