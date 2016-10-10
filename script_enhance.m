%unit test
load('data_test_1882');
[s, v] = enhance(data(:,6),10);

% load('data_i80_2');
% [m,~] = size(data);
% [uniVeh, heads] = unique(data(:,1));
% tails = [heads(2:end)-1;m];
% 
% for i = 1:length(uniVeh)
%     disp(i/length(uniVeh));
%     dt = data(heads(i):tails(i),:);
%     [s,v] = enhance(dt(:,6),10);
%     data(heads(i):tails(i),6) = s/0.3048;%back to unit feet
%     data(heads(i):tails(i)-1,12) = v/0.3048;%unit feet/s
% end