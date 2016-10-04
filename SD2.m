function velEql = SD(K,para)
	vMax = para(1);
	vMin = para(2);
	kJam = para(3);
	a = para(4);
	b = para(5);
	velEql = vMin + (vMax - vMin)*(1-(K/kJam).^a).^b;
end