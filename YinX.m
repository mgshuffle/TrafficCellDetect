%% YinX: find index of y in set x
function [idx] = YinX(x, y)
	[xx, yy] = meshgrid(x, y);
	[row, ~] = find(xx-yy==0);
	idx = row;
end
