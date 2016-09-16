%% loopdetect: function description
function [redata] = loopdetect(data)

	sampleFrequency = 10;%Hz
	RdLen = 1700;%road length 1700 feet
	buffer = 100;%distance between feet
	passTime = zeros(max(data(:,14)),floor(RdLen/buffer)+1);%initial passTime at Lane i(row) of Location j(column) is 0 laneIDNum*locationNum
	passTimeGlobal = zeros(1,floor(RdLen/buffer)+1);
	records = [];

	[~,idx] = sort(data(:,2));
	data = data(idx,:);
	[m,~] = size(data);

% 	Gdata = gpuArray(data);
% 	records = gpuArray(records);
    Gdata = data;

	
	[uniFID,heads] = unique(data(:,2));
	tails = [heads(2:end)-1; m];
    fnum = length(heads);

	for i = 1:fnum-1
		former = Gdata(heads(i):tails(i),:);
		latter = Gdata(heads(i+1):tails(i+1),:);
		[~,ia,ib] = intersect(former(:,1),latter(:,1));
		former = former(ia,:);
		latter = latter(ib,:);

		Location = (floor(former(:,6)/buffer) + 1) * buffer;

		judgeMat = (former(:,6)-Location).*(latter(:,6)-Location);
		idx_J = find(judgeMat<=0);
        if (~isempty(idx_J))
			LaneID = former(idx_J,14);
			loIdx = Location(idx_J)/buffer;
			timeNow = uniFID(i)/sampleFrequency;
			headway = zeros(length(idx_J),1);
			headwayGlobal = zeros(length(idx_J),1);
			for k = 1:length(idx_J)
				headway(k) = timeNow - passTime(LaneID(k),loIdx(k));
				passTime(LaneID(k),loIdx(k)) = timeNow;
				headwayGlobal(k) = timeNow - passTimeGlobal(loIdx(k));
				passTimeGlobal(loIdx(k)) = timeNow;
			end
			%fix v_vel==0
			idxZeroV = idx_J(former(idx_J,12)==0);
			former(idxZeroV,12) = (latter(idxZeroV,6)-former(idxZeroV,6))/0.1;
			%format: 1#Location 2#VID 3#FID(time) 4#LaneID 5#v_Vel(feet/s) 6#LS 7#headway
			records = [records; Location(idx_J) former(idx_J,1:2) LaneID former(idx_J,12) former(idx_J,5)-12*former(idx_J,14)+6 headway headwayGlobal];
        end
	end

% 	redata = gather(records);
    redata = records;

end
