clear

load('enhanced_data_i80_2.mat')
interval = 60;%seconds
loopdata = loopdetect(data);
[AggLoopData] = aggregate(loopdata,interval);

AggLoopData=AggLoopData(AggLoopData(:,1)<=500,:);
data = [AggLoopData(:,5)*1000 AggLoopData(:,7)*3.6];
save('data2Clibrate');

x = particleswarm(@fitness2,5,[50 0 50 -10 -10],[80 20 200 10 10]);
disp(x);
gbestval = fitness2(x);
disp(gbestval);

figure
hold on
plot(data(:,1),data(:,2),'.')
%plot(data(:,1),SD(data(:,1),x),'x')

kmin=0;
% mode 1
kmax=max(data(:,1));
k=linspace(kmin,kmax,1e+5);
plot(k,SD(k,x))
plot(k,SD(k,x)+gbestval);
plot(k,SD(k,x)-gbestval);


% % mode 2
% kjam = x(3);
% k=linspace(kmin,max(kjam,180),1e+5);
% plot(k,SD(k,x))
% plot(k,SD(k,[60 0 180 1.8584969 1.9001582]))
% plot(k,SD(k,[64 0 180 1.8584969 1.9001582]))
% plot(k,SD(k,[75 0 180 1.8584969 1.9001582]))