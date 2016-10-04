% output raw data
function [cell_front,cell_end,k,Ve,rawData,meanVi,stdVi,nextFID] = catchVehs3(data,firstFID,WinLowerB,WinUperB)

    %theLane = 2;


	%Para
	feet2meter = 0.3048;
	%a1 = -165.9;%i80-1
	%a2 = 15.54;
	a1 = -128.4;%i80-2
	a2 = 13.33;
    sdPara =[50,15.6946188969802,114.313208506104,2.21680315505852,9.98014217655979];

	% Parse data
	Vehicle_ID=data(:,1);
	Frame_ID=data(:,2);
	Local_X=data(:,5);
	Local_Y=data(:,6);
	v_Length=data(:,9);
	v_Class=data(:,11);
	v_Vel=data(:,12);
    Lane_ID=data(:,14);
	%Following=data(:,16);

	idx1 = find(Frame_ID==firstFID & v_Class~=1);
	targetVID = Vehicle_ID(idx1((Local_Y(idx1)-WinLowerB).*(Local_Y(idx1)-WinUperB)<=0 ...
								));%vehicle in window (except motocycle) & Lane_ID(idx1)==theLane

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
	num = zeros(fnum,1);
    k = zeros(fnum,1);
    Ve = zeros(fnum,1);
	rawData = cell(fnum,1);
	meanVi = zeros(fnum,1);
	stdVi = zeros(fnum,1);

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
		cell_end(i) = min(Local_Y(idx_selected))*feet2meter;

		num(i) = length(idx_selected);

		%k(i) = num(i)/integral(@laneCount,cell_end(i),cell_front(i))/feet2meter;%veh/m to be proved
        k(i) = length(idx_)/range(Local_Y)/6/feet2meter;
		%Ve(i) = max(0,a1*k(i)+a2);
        Ve(i) = SD2(k(i)*1000,sdPara)./3.6;

		tmp = v_Vel(idx_selected)*feet2meter;%
        rawData(i) = {data(idx_selected,:)};
		meanVi(i) = mean(tmp);
		stdVi(i) = std(tmp);

		
% 		subplot(1,2,1)
%     	hist(tmp*3.6,20)
% 		xlabel('speed km/h')
% 		ylabel('frequency veh')
%     	title('V Distribution')
% 
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