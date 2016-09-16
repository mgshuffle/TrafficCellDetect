% load('data.mat')
% interval = 60;%seconds
% loopdata = loopdetect(data);

[~,idx] = sort(loopdata(:,1));% sort by location
loopdata = loopdata(idx,:);
[uniLocation,~] = unique(loopdata(:,1));

figure
hold on
title('headway structure')
for i = 1:length(uniLocation)-1%except 1700feet location 
    ld = loopdata(loopdata(:,1)==uniLocation(i)&loopdata(:,3)>1000,:);%this location and time>100s (get rid of initial environment) 
    [~,idx2] = sort(ld(:,4));%sort by laneid
    ld = ld(idx2,:);
    [uniLaneID,~]=unique(ld(:,4));
    
%     % each lane headway
%     for j = 1:length(uniLaneID)
%     	ld2 = ld(ld(:,4)==uniLaneID(j),:);
%     	[~,idx3] = sort(ld2(:,3));%sort by time
%     	ld2 = ld2(idx3,:);
%     	plot3(ld2(:,3)/10,ld2(:,4),ld2(:,7),'x')%[0;diff(ld2(:,7))]
%     end
    
    %global headway
    [~,idx3] = sort(ld(:,3));%sort by time
    ld = ld(idx3,:);
    subplot(3,1,1)
    hold on
    plot(ld(:,3)/10,(i-1)*0.5+zeros(length(ld(:,1)),1),'.');%enter points
    title('enter points');    
    subplot(3,1,2)
%     hold on
    plot(ld(:,3)/10,ld(:,8))%headway fig
    title('headway fig');    
    subplot(3,1,3)
%     hold on
    plot(ld(:,3)/10,[0;diff(ld(:,8))]);%delta headway fig
    title('delta headway fig');
    

end
% view(0,90)