figure
%hold on
a = 1;
for i = 1:length(FNUM)
    table = TABLE(a:a+FNUM(i)-1,:);
    a = a + FNUM(i);
    plot3(table(:,6)*1000,table(:,5),table(:,10))
end