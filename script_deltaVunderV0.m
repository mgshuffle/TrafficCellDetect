load('data_i80_2.mat');

% Parse data
Frame_ID=data(:,2);
	
idx = [];

feet2meter = 0.3048;
WinLowerB = 100;%bound
WinUperB = 300;

firstFID = 3000;%initail problem >500 3500 3000 2400

rawDeltaV = {};
Ve_all = [];
k_all = [];
meanDV = [];
stdDV = [];
nowFID = firstFID;
nextFID = 0;

endFID = max(Frame_ID);

while nextFID<4800
	[cell_front,cell_end,k,Ve,rDV,mDV,sDV,nextFID] = catchVehs(data,nowFID,WinLowerB,WinUperB);
	rawDeltaV(length(rawDeltaV)+1) = {rDV};
    Ve_all = [Ve_all;Ve];
    k_all = [k_all;k];
	meanDV = [meanDV; mDV];
	stdDV = [stdDV; sDV];
	nowFID = nextFID;
    disp(nowFID);
    
    figure
    
    subplot(1,3,1)
    plot(Ve*3.6);
    title('Ve')
    
    subplot(1,3,2)
    plot(meanDV*3.6);
    title('MeanDV')
    
    subplot(1,3,3)
    plot(stdDV*3.6);
    title('StdDV')
end