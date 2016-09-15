MAT = load('data.mat');

data = MAT.data;

[idx,cell_front,cell_length,num,density,mean_results,std_results,prop_names] = dostatistic(3200, data, 6);

raw = data(idx,:);