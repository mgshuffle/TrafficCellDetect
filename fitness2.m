function fitVal = fitness2(x)

	MAT = load('data2Clibrate.mat');

	K = MAT.data(:,1);
	V = MAT.data(:,2);

	fitVal = mae(SD(K,x) - V);
end