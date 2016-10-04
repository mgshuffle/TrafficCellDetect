load('data_i80_2.mat');

% Parse data
Frame_ID=data(:,2);
    
idx = [];

feet2meter = 0.3048;
WinLowerB = 100;%bound
WinUperB = 300;

firstFID = 1000;%initail problem >500 3500 3000 2400

TABLE = [];
FNUM = [];
nowFID = firstFID;
nextFID = 0;

endFID = max(Frame_ID);

while nextFID<6480
    [table,fnum,nextFID] = catchVehs2(data,nowFID,WinLowerB,WinUperB);
    TABLE = [TABLE; table];
    FNUM = [FNUM;fnum];
    nowFID = nextFID;
    disp(nowFID);
end