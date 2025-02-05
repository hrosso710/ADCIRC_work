%% Read in fort.61 data for both OWI and HOL and load in max elevation as array 30k
fort61_OWI = read_adcirc_fort61('OWI_data/30k_mesh/fort.61',[2022,09,19,12,0,0]);
fort61_HOL = read_adcirc_fort61('Holland_data/fort.61',[2022,09,19,12,0,0]);

tbl = readtable("Holland_data/HOL_maxele63.txt");
arr = table2array(tbl);
HOL_maxele63 = arr(2:31436,:); 

tbl2 = readtable("OWI_data/30k_mesh/OWI_maxele63.txt");
arr = table2array(tbl2);
OWI_maxele63 = arr(2:31436,:); 


writematrix(OWI_maxele63, 'OWI_data/30k_mesh/maxele63.csv');
writematrix(HOL_maxele63, 'Holland_data/maxele63.csv');

writematrix(fort61_HOL.zeta', 'Holland_data/fort61_matrix.csv')
writematrix(fort61_OWI.zeta', 'OWI_data/30k_mesh/fort61_matrix.csv')