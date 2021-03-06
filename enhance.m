%输入必须是等时间间距的序列
function [s, v] = enhance(rawS,sampleFreq)

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
idx_out = idx_outlierInAcc + 1;%Outlier in S

%interpolation
bufferTimeWin = 1.0;%s
bffNum = bufferTimeWin*sampleFreq;
if ~isempty(idx_out)
    idx_beforeOut = idx_out - bffNum;
    idx_beforeOut = max(1,idx_beforeOut);
    idx_beforeOut = min(sampleCount,idx_beforeOut);
    idx_afterOut = idx_out + bffNum;
    idx_afterOut = max(1,idx_afterOut);
    idx_afterOut = min(sampleCount,idx_afterOut);
    for i=1:length(idx_out)
        outP = idx_out(i);
        refP = setdiff(idx_beforeOut(i):idx_afterOut(i),idx_out);%upgrade
        crNum = ceil(0.85*2*bffNum);
        if length(refP)<crNum
            rest = setdiff((1:sampleCount)',idx_out);
            dist = abs(rest-outP);
            [~,order] = sort(dist);
            rest = rest(order);
            if length(rest)>2*bffNum
                refP = rest(1:2*bffNum);
                refP = sort(refP);
            else
                warning('not enough refP')
            end
        end
        if length(refP)<crNum || outP>max(refP)
            warning('give up interpolation refPoints not enough or xx out of range')
        else
            s1(outP) = naturalCubicSpl(refP/sampleFreq,rawS(refP),outP/sampleFreq);
        end
    end
end
%s1 = myfun(30,rawA,rawS,sampleFreq,sampleCount);
v1 = diff(s1)*sampleFreq;

%Step2: 1st order Butterworth lowpass filtering in speed profile
fc = 1.25;%Hz
[paraB,paraA] = butter(1,fc/(sampleFreq/2));
vtmp = v1 - v1(1);%shifting to 0
v2 = filter(paraB,paraA,vtmp)+v1(1);

%step3 & 4 ignored temporary

%a2 = diff(v2)*sampleFreq;
%v3 = myfun(10,a2,v2,sampleFreq,sampleCount);

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

% function s1 = myfun(unPhyAcc,rawA,rawS,sampleFreq,sampleCount)
% s1 = rawS;
% %Pick out outliers
% %unPhyAcc = 30;%m/s^2
% idx_outlierInAcc = find(abs(rawA)>unPhyAcc);
% idx_out = idx_outlierInAcc + 1;%Outlier in S
% 
% %interpolation
% bufferTimeWin = 1.0;%s
% bffNum = bufferTimeWin*sampleFreq;
% if ~isempty(idx_out)
%     idx_beforeOut = idx_out - bffNum;
%     idx_beforeOut = max(1,idx_beforeOut);
%     idx_beforeOut = min(sampleCount,idx_beforeOut);
%     idx_afterOut = idx_out + bffNum;
%     idx_afterOut = max(1,idx_afterOut);
%     idx_afterOut = min(sampleCount,idx_afterOut);
%     for i=1:length(idx_out)
%         outP = idx_out(i);
%         refP = setdiff(idx_beforeOut(i):idx_afterOut(i),idx_out);%upgrade
%         crNum = ceil(0.85*2*bffNum);
%         if length(refP)<crNum
%             rest = setdiff((1:sampleCount)',idx_out);
%             dist = abs(rest-outP);
%             [~,order] = sort(dist);
%             rest = rest(order);
%             if length(rest)>2*bffNum
%                 refP = rest(1:2*bffNum);
%                 refP = sort(refP);
%             else
%                 warning('not enough refP')
%             end
%         end
%         if length(refP)<crNum || outP>max(refP)
%             warning('give up interpolation refPoints not enough or xx out of range')
%         else
%             s1(outP) = naturalCubicSpl(refP/sampleFreq,rawS(refP),outP/sampleFreq);
%         end
%     end
% end
% end