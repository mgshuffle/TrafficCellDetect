figure
%hold on
a = 1;
for i = 1:length(FNUM)
    x = X(a:a+FNUM(i)-1,:);
    y = Y(a:a+FNUM(i)-1,:);
    a = a + FNUM(i);
    plot(x.^0.5,y,'.')
end