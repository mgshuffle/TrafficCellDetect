%% dostatistic: get statistical results
%dostatistic(firstFID, data, lanenum)

%t = tic();
load('data_i80_1.mat');
firstFID = 3200;
lanenum = 1;
theLaneID = 1;
feet2meter = 0.3048;
a1 = -165.9;
a2 = 15.54;

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
	
idx = [];

%feet2meter = 0.3048;
WinLowerB = 400;
WinUperB = 600;

idx1 = find(Frame_ID==firstFID);
targetVID = Vehicle_ID(idx1((Local_Y(idx1)-WinLowerB).*(Local_Y(idx1)-WinUperB)<=0 ...
							& v_Class(idx1)~=1 & Lane_ID(idx1)==theLaneID));%vehicle in window (except motocycle)


%find last Frame_ID
lastFID = 1e+100;
for i = 1:length(targetVID)
	thislastx = max(Frame_ID(Vehicle_ID==targetVID(i)));
	lastFID = min(lastFID, thislastx);
end

fnum = lastFID - firstFID + 1;

cell_front = zeros(fnum,1);
cell_length = zeros(fnum,1);
num = zeros(fnum,1);
k = zeros(fnum,1);
Ve = zeros(fnum,1);	
Gap = Space_Headway - v_Length;
Gap(Gap<0) = 0;
LS = Local_X - 12*Lane_ID + 6;

properties1 = [v_Vel LS];
prop_names1 = {'v_Vel' 'LS'};
[~,cols1] = size(properties1);
mean_results1 = zeros(fnum,cols1);
std_results1 = zeros(fnum,cols1);

properties2 = [Space_Headway Time_Headway Gap];
prop_names2 = {'Space_Headway' 'Time_Headway' 'Gap'};
[~,cols2] = size(properties2);
mean_results2 = zeros(fnum,cols2);
std_results2 = zeros(fnum,cols2);

for i = 1:fnum
	idx_ = find(Frame_ID==firstFID+i-1);
	idx_tVeh = idx_(YinX(targetVID,Vehicle_ID(idx_)));

	% lateral boundary
	%xmin = min(Local_X(idx_tVeh));
	%xmax = max(Local_X(idx_tVeh));
		
	% no lateral boundary
	xmin = 0;
	xmax = 1e+100;

	ymin = min(Local_Y(idx_tVeh));
	ymax = max(Local_Y(idx_tVeh));

	idx_selected = idx_((Local_X(idx_)-xmin).*(Local_X(idx_)-xmax)<=0 & ...
							(Local_Y(idx_)-ymin).*(Local_Y(idx_)-ymax)<=0);


	% do statistic here
	cell_front(i) = max(Local_Y(idx_selected))*feet2meter;
	cell_length(i) = cell_front(i) - min(Local_Y(idx_selected))*feet2meter;
	num(i) = length(idx_selected);

	mean_results1(i,:) = mean(properties1(idx_selected,:));
	std_results1(i,:) = std(properties1(idx_selected,:));
	idx_nonzero = idx_selected(Space_Headway(idx_selected)~=0);
	mean_results2(i,:) = mean(properties2(idx_nonzero,:));
	std_results2(i,:) = std(properties2(idx_nonzero,:));

	idx=[idx;idx_selected];

	idx_nonzero = idx_selected(Space_Headway(idx_selected)~=0);
	k(i) = 1/(mean(Space_Headway(idx_nonzero))*feet2meter);
	Ve(i) = a1*k(i)+a2;

    hold on
	subplot(2,3,1)
    cla    
    hist(v_Vel(idx_selected)*feet2meter-Ve(i),10)
    title('{\Deltav} Distribution')
    subplot(2,3,2)
    cla    
	hist(Space_Headway(idx_nonzero),10)
    title('Space Headway Distribution')
    subplot(2,3,3)
    cla    
    plot(Local_Y(idx_selected)-min(Local_Y(idx_selected)),0,'x')
    title('Position')
    subplot(2,3,4)
    plot(firstFID+i-1,num(i),'x');
    title('number of vehs')
    subplot(2,3,5)
    plot(firstFID+i-1,Ve(i),'x');
end

density = num./(cell_length*feet2meter*lanenum);% unit veh/feet
prop_names = [prop_names1 prop_names2];
mean_results = [mean_results1 mean_results2];
std_results = [std_results1 std_results2];

%usingtime = toc(t);
