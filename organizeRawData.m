%% organizeRawData: order the raw trajactory data
function [newData] = organizeRawData(filename)
	newData = [];
	data = xlsread(filename);
	for i = min(data(:,1)):max(data(:,1))
		idx = find(data(:,1)==i);
		if (~isempty(idx))
			newRows = data(idx,:);
			[~,idxOrder] = sort(newRows(:,2));
			newRows = newRows(idxOrder,:);
			newData = [newData;newRows];
		end
	end
end