%% DeltaVFeature: function description
function [output] = myselect(data)

	%firstFID = 3200;
	lanenum = 1;
	theLaneID = 1;
	a1 = -165.9;
	a2 = 15.54;

	feet2meter = 0.3048;
	%WinLowerB = 400;
	WinUperB = WinLowerB + 200;

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
			%do sth
			else
				lastFID = min(lastFID, thislast);
			end
		end
		
	end