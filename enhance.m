function [s, v, a] = enhance(rawS,sampleFreq)

	feet2meter = 0.3048;
	if isempty(sampleFreq)
		sampleFreq = 10;
	end

	rawS = rawS*feet2meter;
	rawV = diff(rawS)*sampleFreq;
	rawA = diff(rawV)*sampleFreq;

	sampleCount = length(rawS);

	%Step1 remove outliers and use natural cubic spline to interpolate 
	%with windows of 1s before and after the outliers

	s1 = rawS;

	%Pick out outliers
	unPhyAcc = 30%m/s^2
	idx_outlierInAcc = find(rawA>unPhyAcc);
	idx_out = idx_outlierInAcc + 1;%Outlier in S

	%interpolation
	bufferTimeWin = 1%s
	bffNum = bufferTimeWin*sampleFreq
	if ~isempty(idx_out)
		idx_beforeOut = idx_out - bffNum;
		idx_beforeOut = max(1,idx_beforeOut);
		idx_beforeOut = min(sampleCount,idx_beforeOut);
		idx_afterOut = idx_out + bffNum;
		idx_afterOut = max(1,idx_afterOut);
		idx_afterOut = min(sampleCount,idx_afterOut);
		for i=1:length(idx_out)
			outP = idx_out(i);
			refP = setdiff(idx_beforeOut:idx_afterOut,idx_out);
			if length(refP<10)
				error('refPoints not enough')
			else
				s1(outP) = naturalCubicSpl(refP/sampleFreq,rawS(refP),outP/sampleFreq);
			end
		end
	end
%	if ~isempty(idx_out)
%		pNow = 1;
%		Ps = 1;
%		if idx_out(1)<11
%			beforePoints = rawS(1:idx_out-1);
%		else
%			beforePoints = rawS(idx_out-10:idx_out-1);
%		end
%		while(pNow<=length(idx_out))
%			if idx_out(pNow)+10<idx_out(pNow+1) || pNow==length(idx_out) %last point
%				%add afterPoints
%				%do enhance
%			else
%				%Ps++
%				%pNow++
%			end
%			pNow = pNow+1;
%		end
%	end
	v1 = diff(s1)*sampleFreq;

	%Step2: 1st order Butterworth lowpass filtering in speed profile
	fc = 1.25%Hz
	[paraB,paraA] = butter(1,fc/(sampleFreq/2));
	v2 = filter(paraB,paraA,v1);
	a2 = diff(v2)*sampleFreq;

	%step3 & 4 ignored temporary

	s = s1;
	v = v2;
	a = a2;
end