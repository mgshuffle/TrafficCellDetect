%输入必须是等时间间距的序列
function [s, v] = enhance2(rawS,sampleFreq)

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
unPhyAcc = 30;%m/s^2
idx_outlierInAcc = find(abs(rawA)>unPhyAcc);
idx_out = [idx_outlierInAcc;idx_outlierInAcc+1;idx_outlierInAcc+2];%Outlier in S
idx_out = unique(idx_out);

%interpolation
bufferTimeWin = 1.0;%s
bffNum = bufferTimeWin*sampleFreq;
if ~isempty(idx_out)
    dis_out = diff(idx_out);
    idx_BrkPnt = find(dis_out>bffNum*2);

    if min(interPnts)==1
        left = [];
        warning('left edge');
    else
        left = [max(1,min(interPnts)-bffNum) min(interPnts)-1];
    end
    if max(interPnts)==sampleCount
        right = [];
        warning('right edge');
    else
        right = [max(interPnts)+1 min(sampleCount,max(interPnts)+bffNum)];
    end

    if isempty(idx_BrkPnt)
        interPnts = [min(idx_out) max(idx_out)];
        ref = [left right];
    else
        interPnts = [[ids_out(1);ids_out(idx_BrkPnt+1)] [idx_out(idx_BrkPnt);idx_out(end)]];
        ref = [[left; [ids_out(idx_BrkPnt+1)-bffNum ids_out(idx_BrkPnt+1)-1]] [[idx_out(idx_BrkPnt)+1 idx_out(idx_BrkPnt)+bffNum]; right]];
    end

    for i = 1:length(interPnts(:,1))
        xx = (interPnts(i,1):interPnts(i,2))';
        refX = ([ref(i,1):ref(i,2) ref(i,3):ref(i,4)])';
        refY = rawS(refX);
        s1(xx) = naturalCubicSpl(refX,refY,xx);
    end
end

v1 = diff(s1)*sampleFreq;

%Step2: 1st order Butterworth lowpass filtering in speed profile
fc = 1.25;%Hz
[paraB,paraA] = butter(1,fc/(sampleFreq/2));
vtmp = v1 - v1(1);%shifting to 0
v2 = filter(paraB,paraA,vtmp)+v1(1);

%step3 & 4 ignored temporary

%debuging
figure
subplot(3,1,1)
hold on
plot(rawS)
plot(idx_out,rawS(idx_out),'o')
plot(s1)
subplot(3,1,2)
hold on
ylim([0 50])
plot(rawV*3.6)
plot(idx_out,rawV(idx_out)*3.6,'o')
plot(v1*3.6,'--')
plot(v2*3.6,':')
subplot(3,1,3)
hold on
plot(rawA,'--.')
plot(idx_out-1,rawA(idx_out-1),'o')

s = s1;
v = v2;
end