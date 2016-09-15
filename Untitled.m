sampleFrequency = 10;%Hz
RdLen = 1700;%road length 1700 feet
buffer = 100;%distance between feet
passTime = zeros(max(data(:,14)),floor(RdLen/buffer)+1);%initial passTime at Lane i(row) of Location j(column) is Inf
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
    	if (~isempty(find(former(idx_J,12)==0)))
            P=1;
        end
    end
    
end
    
    