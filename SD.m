%% SD: speed-density function with parameters of vMax vMin kJam a b 
function velEql = SD(x,vMax,vMin,kJam,a,b)
	velEql = vMin + (vMax - vMin)*(1-(x/kJam).^a).^b;
end
