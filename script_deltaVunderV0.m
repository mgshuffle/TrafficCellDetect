load('data_i80_2.mat');

% Parse data
Frame_ID=data(:,2);
	
idx = [];

feet2meter = 0.3048;
WinLowerB = 100;%bound
WinUperB = 300;

firstFID = 3000;%initail problem >500 3500 3000 2400

rawData = {};
Ve_all = [];
k_all = [];
meanVi = [];
stdVi = [];
Y=[];
X=[];
FNUM=[];
nowFID = firstFID;
nextFID = 0;

endFID = max(Frame_ID);

figure

while nextFID<4800
	[cell_front,cell_end,k,Ve,rData,mv,sv,nextFID] = catchVehs3(data,nowFID,WinLowerB,WinUperB);
	rawData(length(rawData)+1) = {rData};
    Ve_all = [Ve_all;Ve];
    k_all = [k_all;k];
	meanVi = [meanVi; mv];
	stdVi = [stdVi; sv];
    y=mv-Ve;
    Y = [Y;y];
    x=sv.^2;
    X = [X;x];
    FNUM = [FNUM;length(y)];
	nowFID = nextFID;
    disp(nowFID);
    
    plot(x,y,'.')
%     subplot(1,3,1)
%     plot(k*1000,mv*3.6,'.')
%     %plot(Ve_all*3.6,'k')
%     
%     subplot(1,3,2)
%     cla
%     hold on
%     plot(Ve*3.6,'k')
%     plot(mv*3.6,'b')
%     plot((mv-sv)*3.6,'--')
%     plot((mv+sv)*3.6,'--')
%     
%     subplot(1,3,3)
%     plot(mv*3.6-Ve*3.6,'.')

%     subplot(1,3,1)
%     plot(Ve*3.6);
%     title('Ve')
%     
%     subplot(1,3,2)
%     plot(meanVi*3.6);
%     title('MeanVi')
%     
%     subplot(1,3,3)
%     plot(stdVi*3.6);
%     title('StdVi')
end