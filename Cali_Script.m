%cali script
ft = fittype('SD(x,vMax,vMin,kJam,a,b)');

idx = find(AggLoopData(:,1)==600);

y = AggLoopData(idx,5);
x =  AggLoopData(idx,3)./y;
f = fit(x,y,ft);