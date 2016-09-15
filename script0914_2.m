% load('data.mat')
% interval = 60;%seconds
% loopdata = loopdetect(data);

[~,idx] = sort(loopdata(:,1));
loopdata = loopdata(idx,:);
[uniLocation,~] = unique(loopdata(:,1));

figure
hold on
title('headway structure')
for i = 1:length(uniLocation)
    ld = loopdata(loopdata(:,1)==uniLocation(i),:);
    [~,idx2] = sort(ld(:,3));
    ld = ld(idx2,:);
    plot(ld(:,3)/10,ld(:,7))
end