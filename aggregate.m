%% aggregate: aggregate raw micro data to macro quantities
function [AggLoopData] = aggregate(loopdata,interval)
feet2meter = 0.3048;
sampleFrequency = 10;%Hz
AggLoopData = [];

% 	MAT = load('loopdata.mat');
% 	loopdata = MAT.loopdata;

% 	Location=loopdata(:,1);
% 	VID=loopdata(:,2);
% 	FID=loopdata(:,3);
% 	LaneID=loopdata(:,4);
% 	v_Vel=loopdata(:,5);
% 	LS=loopdata(:,6);

[~,idx] = sort(loopdata(:,1));
loopdata = loopdata(idx,:);

[uniLocation,heads] = unique(loopdata(:,1));
tails = [heads(2:end);length(loopdata(:,1))];

for i = 1:length(heads)%location i
    d = loopdata(heads(i):tails(i),:);
    timePerid = floor(d(:,3)/sampleFrequency/interval) + 1;
    nLanes = max(d(:,4));
    
    m = range(timePerid)+1;
    m_first = min(timePerid);
    rows = zeros(m,8);
    for j = 1:m%period j
        jData = d(timePerid==j+m_first-1,:);
        [~,idx2] = sort(jData(:,4));
        jData = jData(idx2,:);
        [uniKLaneID, ~] = unique(jData(:,4));
        %tailsLID = [headsLID;length(jData(:,4))];
        DetectedLanes = length(uniKLaneID);
        if DetectedLanes==0%no veh pass location J
            rows(j,:) = [uniLocation(i) (j+m_first-1)*interval nLanes 0 ...
                0 0 0 0];
        else
            elements = zeros(DetectedLanes,3);
            for k = 1:DetectedLanes
                kjData = jData(jData(:,4)==uniKLaneID(k),:);
                %format: laneQ(veh/s) timeMeanSpeed(m/s) spaceMeanSpeed(m/s)
                elements(k,:) = [1/mean(kjData(:,7)),mean(kjData(:,5))*feet2meter,harmmean(kjData(:,5))*feet2meter];
            end
            Q_tot = sum(elements(:,1));
            K1_tot = sum (elements(:,1)./elements(:,2));
            k2_tot = sum(elements(:,1)./elements(:,3));
            %format: location timeEnd LaneNum Q(veh/s) ...
            %		 K1(veh/m) K2(veh/m) V1(m/s) V2(m/s)
            rows(j,:) = [uniLocation(i) (j+m_first-1)*interval nLanes Q_tot/nLanes ...
                		 K1_tot/nLanes k2_tot/nLanes Q_tot/K1_tot Q_tot/k2_tot];
        end
        
    end
    
    AggLoopData = [AggLoopData; rows];
end
