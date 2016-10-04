a=1;
b=7200;

feet2meter = 0.3048;
local_X = -y;
local_Y = x;

myVideo = VideoWriter('record.avi');
myVideo.FrameRate = 20; %default 30
myVideo.Quality = 100; %defaulet 100
open(myVideo);
for i=a:b
    %draw network
    hold on
    axis equal
    for l = 1:8
        plot(linspace(min(x)*feet2meter,max(x)*feet2meter,100),-(l-1)*12*feet2meter*ones(1,100),'k')
    end
    
    %draw vehs
    t=find(FRAME==i);
    if (t)
        plot(X(t),Y(t),'o')
    end
    
    g=getframe(gcf);
    writeVideo(myVideo, g);
    
    clf
end
close(myVideo);