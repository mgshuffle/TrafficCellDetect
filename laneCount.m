function num = laneCount(location)%feet
	tmp = (location-269.7460).*(location-666.5580);
	num = zeros(size(tmp));
	num(tmp<=0) = 7;
	num(tmp>0) = 6;
end