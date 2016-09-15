% position in and position out test script

MAT = load('data.MAT');

data = MAT.data;

% Parse data
Vehicle_ID=data(:,1);
Frame_ID=data(:,2);
%Total_Frames=data(:,3);
%Global_Time=data(:,4);
Local_X=data(:,5);
Local_Y=data(:,6);
%Global_X=data(:,7);
%Global_Y=data(:,8);
v_Length=data(:,9);
%v_Width=data(:,10);
v_Class=data(:,11);
v_Vel=data(:,12);
%v_Acc=data(:,13);
Lane_ID=data(:,14);
%Preceding=data(:,15);
%Following=data(:,16);
Space_Headway=data(:,17);
Time_Headway=data(:,18);

v0 = min(Vehicle_ID);
vm = max(Vehicle_ID);

n = vm - v0 + 1;

PosIn = zeros(2,n);
PosOut = zeros(2,n);
FrameIn = zeros(1,n);
FrameOut = zeros(1,n);

%figure
%hold on

for i = 1:n
	idx = find(Vehicle_ID==v0+i-1);
	if (~isempty(idx))
		idx_in = idx(Frame_ID(idx)==min(Frame_ID(idx)));
		PosIn(:,i) = [Local_X(idx_in);Local_Y(idx_in)];

		idx_out = idx(Frame_ID(idx)==max(Frame_ID(idx)));
		PosOut(:,i) = [Local_X(idx_out);Local_Y(idx_out)];

		FrameIn(i) = idx_in;
		FrameOut(i) = idx_out;
		%plot([i i],[PosIn(2,i),PosOut(2,i)]);
	end
end
