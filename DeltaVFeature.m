%% DeltaVFeature: function description
function [dVmean, dVstd, Vmean, Veq, SHmean, SHstd, density] = DeltaVFeature(data)

	firstFID = 3200;
	lanenum = 1;
	theLaneID = 1;
	a1 = -165.9;
	a2 = 15.54;

	feet2meter = 0.3048;
	WinLowerB = 400;
	WinUperB = 600;

	% Parse data
	Vehicle_ID=data(:,1);
	Frame_ID=data(:,2);
	%Total_Frames=data(:,3);
	%Global_Time=data(:,4);
	Local_X=data(:,5);
	Local_Y=data(:,6);
	%Global_X=data(:,7);
	%Global_Y=data(:,8);
	%v_Length=data(:,9);
	%v_Width=data(:,10);
	v_Class=data(:,11);
	v_Vel=data(:,12);
	%v_Acc=data(:,13);
	Lane_ID=data(:,14);
	%Preceding=data(:,15);
	%Following=data(:,16);
	Space_Headway=data(:,17);
	%Time_Headway=data(:,18); 

	

	idx1 = find(Frame_ID==firstFID);
	targetVID = Vehicle_ID(idx1((Local_Y(idx1)-WinLowerB).*(Local_Y(idx1)-WinUperB)<=0 ...
								& v_Class(idx1)~=1 ...
								& Lane_ID(idx1)==theLaneID));%vehicle in window (except motocycle)


	%find last Frame_ID
	lastFID = 1e+100;
	for i = 1:length(targetVID)
		idx2 = Vehicle_ID==targetVID(i);
		idx2_LC = idx2(Lane_ID(idx2)~=theLaneID);
		fr_LC = Frame_ID(idx2_LC);
		thislast = min(fr_LC(fr_LC>firstFID));
		if (isempty(thislast)) 
			return null;
		end
		lastFID = min(lastFID, thislast);
	end

	fnum = lastFID - firstFID + 1;

	cell_front = zeros(fnum,1);
	cell_length = zeros(fnum,1);
	num = zeros(fnum,1);
	k = zeros(fnum,1);
	Veq = zeros(fnum,1);
	Vmean = zeros(fnum,1);
	dVmean = zeros(fnum,1);
	dVstd = zeros(fnum,1);
	SHmean = zeros(fnum,1);
	SHstd = zeros(fnum,1);

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
		idx_nonzero = idx_selected(Space_Headway(idx_selected)~=0);


		% do statistic here
		cell_front(i) = max(Local_Y(idx_selected))*feet2meter;%unit m
		cell_length(i) = cell_front(i) - min(Local_Y(idx_selected))*feet2meter;%unit m
		num(i) = length(idx_selected);
		Vmean = v_Vel(idx_selected)*feet2meter;%unit m/s
		
		k(i) = 1/(mean(Space_Headway(idx_nonzero))*feet2meter);%unit veh/meter
		Veq(i) = a1*k(i)+a2;%unit m/s

		dV = v_Vel(idx_selected)*feet2meter-Veq(i);%unit m/s
		dVmean(i) = mean(dV);%unit m/s
		dVstd(i) = std(dV);%unit m/s

		SHmean(i) = mean(Space_Headway(idx_nonzero)*feet2meter);
		SHstd(i) = std(Space_Headway(idx_nonzero)*feet2meter);

        tmp1 = Space_Headway(idx_nonzero);
        tmp = sum(tmp1*feet2meter);
		delta = tmp - cell_length(i);
		
	end

	density = num./(cell_length*lanenum);% unit veh/meter
    
    

	%usingtime = toc(t);
end
