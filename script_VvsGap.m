load('data_i80_1');
figure
hold on

for i = min(data(:,1)):max(data(:,1))
	idx = find(data(:,1)==i);
	if ~isempty(idx)
		subplot(2,2,1)
		hold on
		plot(data(:,17),data(:,12),'.')
		title('Vel vs. Space Headway')

		subplot(2,2,2)
		hold on
		plot(max(0,(data(:,17)-data(:,9))),data(:,12),'.')
		title('Vel vs. Gap')

		subplot(2,2,3)
		hold on
		plot(data(:,17).^(-1),data(:,12),'.')
		title('Vel vs. inverse of Space Headway');
	end
end