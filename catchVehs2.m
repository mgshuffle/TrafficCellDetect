function [table,fnum,nextFID] = catchVehs2(data,firstFID,WinLowerB,WinUperB)

    %theLane = 2;
    totalLaneNum = 6;%total lane num of the sagment

	%Para
	feet2meter = 0.3048;
	%a1 = -165.9;%i80-1
	%a2 = 15.54;
	a1 = -128.4;%i80-2
	a2 = 13.33;

	% Parse data
	Vehicle_ID=data(:,1);
	Frame_ID=data(:,2);
	Local_X=data(:,5);
	Local_Y=data(:,6);
	v_Length=data(:,9);
	v_Class=data(:,11);
	v_Vel=data(:,12);
    Lane_ID=data(:,14);
    Preceding=data(:,15);
	%Following=data(:,16);
	Space_Headway=data(:,17);

	idx1 = find(Frame_ID==firstFID & v_Class~=1); %(except motocycle)
	targetVID = Vehicle_ID(idx1((Local_Y(idx1)-WinLowerB).*(Local_Y(idx1)-WinUperB)<=0 ...
								));%vehicle in window  & Lane_ID(idx1)==theLane

	idx1_tarVeh = idx1(YinX(targetVID,Vehicle_ID(idx1)));
    tailVID = targetVID(find(min(Local_Y(idx1_tarVeh))));
	idx1_tailVeh = find(Vehicle_ID==tailVID);
	idx1_tailVeh = idx1_tailVeh(Local_Y(idx1_tailVeh)>WinUperB);
	idx1_nextFr = idx1_tailVeh(find(min(Local_Y(idx1_tailVeh))));
	nextFID = Frame_ID(idx1_nextFr);
	
	%find last Frame_ID
	lastFID = 1e+100;
	for i = 1:length(targetVID)
		thislastx = max(Frame_ID(Vehicle_ID==targetVID(i)));
		lastFID = min(lastFID, thislastx);
	end
	
	fnum = lastFID - firstFID + 1;

	%Output
	cell_front = zeros(fnum,1);
	cell_end = zeros(fnum,1);
	cell_ahead = zeros(fnum,1);
	num = zeros(fnum,1);
	truckNum = zeros(fnum,1);
    kSgm = zeros(fnum,1);
    VeSgm = zeros(fnum,1);
    kCell = zeros(fnum,1);
    VeCell = zeros(fnum,1);
	%rawVi = cell(fnum,1);
	meanVi = zeros(fnum,1);
	stdVi = zeros(fnum,1);
	meanV_Truck = zeros(fnum,1);
	stdV_Truck = zeros(fnum,1);
	meanV_Other = zeros(fnum,1);
	stdV_Other = zeros(fnum,1);

	table = zeros(fnum,15);%format:

% 	figure

	for i = 1:fnum
		idx_ = find(Frame_ID==firstFID+i-1 & v_Class~=1);
		idx_tVeh = idx_(YinX(targetVID,Vehicle_ID(idx_)));

		% no lateral boundary	
		ymin = min(Local_Y(idx_tVeh));
		ymax = max(Local_Y(idx_tVeh));
	
		idx_selected = idx_((Local_Y(idx_)-ymin).*(Local_Y(idx_)-ymax)<=0 );% & Lane_ID(idx_)==theLane
	
		% do statistic here
		cell_front(i) = max(Local_Y(idx_selected))*feet2meter;
		cell_end(i) = min(Local_Y(idx_selected)-v_Length(idx_selected))*feet2meter;%to last veh's rear bumper

		num(i) = length(idx_selected);

		%k(i) = num(i)/integral(@laneCount,cell_end(i),cell_front(i))/feet2meter;%veh/m to be proved
        kSgm(i) = length(idx_)/range(Local_Y)/totalLaneNum/feet2meter;
		VeSgm(i) = max(0,a1*kSgm(i)+a2);

% 		idx_ahead = idx_selected(Preceding(idx_selected)~=0);
% 		if isempty(idx_ahead)
% 			cell_ahead(i) = max(Local_Y)*feet2meter;
%         else
%             if length(idx_ahead)~=length(idx_(YinX(Preceding(idx_ahead),Vehicle_ID(idx_))))
%                 g=1;
%             end
%             tmpVar = Local_Y(idx_ahead) + Space_Headway(idx_ahead) - v_Length(idx_(YinX(Preceding(idx_ahead),Vehicle_ID(idx_))));
%             tmpVar = tmpVar(tmpVar*feet2meter>cell_front(i));
% 			cell_ahead(i) = min(tmpVar)*feet2meter;
% 		end
% 		kCell(i) = num(i)/integral(@laneCount,cell_end(i)/feet2meter,cell_ahead(i)/feet2meter)/feet2meter;
% 		VeCell(i) = max(0,a1*kSgm(i)+a2);
        cell_ahead(i) = NaN;
        kCell(i) = NaN;
        VeCell(i) = NaN;
        
		vi = v_Vel(idx_selected)*feet2meter;
        %rawVi(i) = {vi};
		meanVi(i) = mean(vi);
		stdVi(i) = std(vi);

		idx_truck = idx_selected(v_Class(idx_selected)==3);		
		truckNum(i) = length(idx_truck);
		if truckNum==0
			meanV_Other(i) = meanVi(i);
			stdV_Other(i) = stdVi(i);
			meanV_Truck(i) = 0;
			stdV_Truck(i) = 0;
		else
			meanV_Truck(i) = mean(v_Vel(idx_truck))*feet2meter;
			stdV_Truck(i) = std(v_Vel(idx_truck))*feet2meter;
			idx_other = setdiff(idx_selected,idx_truck);
			meanV_Other(i) = mean(v_Vel(idx_other))*feet2meter;
			stdV_Other(i) = std(v_Vel(idx_other))*feet2meter;
		end
		
		table(i,:) = [cell_ahead(i) cell_front(i) cell_end(i) ...
		              num(i) truckNum(i) ...
		              kSgm(i) VeSgm(i) kCell(i) VeCell(i)... 
		              meanVi(i) stdVi(i)... 
		              meanV_Truck(i) stdV_Truck(i)...
		              meanV_Other(i) stdV_Other(i)];
                  
                  
        
% 		subplot(1,2,1)
%     	hist(vi*3.6,20)
% 		xlabel('speed km/h')
% 		ylabel('frequency veh')
%     	title('deltaV Distribution')

%     	subplot(1,2,2)
%     	cla
%     	hold on
%         for l = 1:8
%             plot((l-1)*12*feet2meter*ones(1,100),linspace(cell_end(i),cell_front(i),100),'k')
%         end
%         for v = 1:length(idx_selected)
%             plot(Local_X(idx_selected(v))*ones(1,2)*feet2meter,[Local_Y(idx_selected(v)) Local_Y(idx_selected(v))-v_Length(idx_selected(v))]*feet2meter,'b')
%             text(Local_X(idx_selected(v))*feet2meter,Local_Y(idx_selected(v))*feet2meter,num2str(v_Vel(idx_selected(v))*feet2meter*3.6,2))
%         end
% 		title('position')
	end



end