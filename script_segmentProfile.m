load('enhanced_data_i80_2.mat')
interval = 60;%seconds
loopdata = loopdetect(data);
[AggLoopData] = aggregate(loopdata,interval);

[location,~] = unique(AggLoopData(:,1));
figure
hold on
for i = 1:length(location)-1 %1700feet location doesn't count
    ald = AggLoopData(AggLoopData(:,1)==location(i),:);
    subplot(2,2,1)
    hold on
    plot(ald(:,2)/60,ald(:,4)*3600)
    title('MeanQ');
    xlabel('time (min)')
    ylabel('lane average Q (veh/h)')
    subplot(2,2,2)
    hold on
    plot(ald(:,2)/60,ald(:,8)*3.6)
    title('SpaceMeanSpeed')
    xlabel('time (min)')
    ylabel('speed (km/h)')
    subplot(2,2,3)
    hold on
    plot(ald(:,2)/60,ald(:,6)*1000)
    title('MeanK')
    xlabel('time (min)')
    ylabel('lane mean density (veh/km)')
    subplot(2,2,4)
    hold on
    plot(ald(:,6)*1000,ald(:,8)*3.6,'.')
    title('SpeedDensity')
    xlabel('density (veh/km)')
    ylabel('speed (km/h)')
end
