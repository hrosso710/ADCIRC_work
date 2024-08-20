%% Read in fort.61 data for both OWI and HOL and load in max elevation as array 30k
load('/Users/haleyrosso/Documents/ADCIRC_work/adcirc_util/IO/3D_mesh_plot.mat')

fort61_OWI = read_adcirc_fort61('OWI_fort.61',[2022,09,19,12,0,0]);
fort61_HOL = read_adcirc_fort61('HOL_fort.61',[2022,09,19,12,0,0]);

tbl = readtable("HOL_maxele63.txt");
arr = table2array(tbl);
HOL_maxele63 = arr(2:31436,:); 

tbl2 = readtable("OWI_maxele63.txt");
arr = table2array(tbl2);
OWI_maxele63 = arr(2:31436,:); 

%% mesh and max ele 3D Plots using Max ele 30k

figure()
scatter3(S(:,1),S(:,2),S(:,3),5.5,'MarkerFaceColor',[0 .75 .75])
title('Mesh Visualization')
xlabel('Latitude')
ylabel('Longitude')
zlabel('Water Depth')

figure()
scatter3(S(:,1),S(:,2),S(:,3),'MarkerFaceColor',[0 .75 .75])
hold on
scatter3(S(:,1),S(:,2),HOL_maxele63(:,2),'MarkerEdgeColor',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.9290 0.6940 0.1250]);
zlim([-7500,3000])
title('Bathymetry vs. Maximum Elevation of Surge', 'Holland Wind Model')
xlabel('Latitude')
ylabel('Longitude')
zlabel('Depth/Elevation')
legend('Water Depth', 'Surge Elevation')
grid on

figure()
scatter3(S(:,1),S(:,2),HOL_maxele63(:,2),'MarkerEdgeColor',[0.8500 0.3250 0.0980],'MarkerFaceColor',[0.9290 0.6940 0.1250]);
title('Maximum Elevation','Holland Wind Model: 09/22/2022 - 10/02/2022')
xlabel('Latitude')
ylabel('Longitude')
zlabel('Elevation (m?)')
grid on
zlim([450,2500])

%% Line plots of elevation at the 11 stations 30k

% figure()
% plot(fort61_HOL.zeta(:,1),'LineWidth',2.0)
% hold on
% plot(fort61_HOL.zeta(:,2),'LineWidth',2.0)
% plot(fort61_HOL.zeta(:,3),'LineWidth',2.0)
% plot(fort61_HOL.zeta(:,4),'LineWidth',2.0)
% plot(fort61_HOL.zeta(:,5),'LineWidth',2.0)
% title('Elevation Data at 11 Stations', 'OWI Wind Model')
% legend('1','2','3','4','5')
% xlim([1400 2500])

% figure()
% hold on
% plot(fort61_HOL.zeta(:,6),'LineWidth',2.0)
% plot(fort61_HOL.zeta(:,7),'LineWidth',2.0)
% plot(fort61_HOL.zeta(:,8),'LineWidth',2.0)
% plot(fort61_HOL.zeta(:,9),'LineWidth',2.0)
% plot(fort61_HOL.zeta(:,10),'LineWidth',2.0)
% plot(fort61_HOL.zeta(:,11),'LineWidth',2.0)
% legend('6','7','8','9','10','11')
% xlim([1400 2500])


figure() % comparing OWI and HOL
subplot(2,2,1)
plot(fort61_HOL.zeta(:,1),'LineWidth',2.0,'Color','#2AB8AB')
hold on
plot(fort61_OWI.zeta(:,1),'LineWidth',2.0,'Color','#C12283')
xlim([1400 2500])
ylim([-0.6 1.75])
title('Station 1','Interpreter','latex','FontSize', 18)
ylabel('Surge Elevation','Interpreter','latex','FontSize', 15)
xlabel('Time Step (s)','Interpreter','latex','FontSize', 15)

subplot(2,2,3)
plot(fort61_HOL.zeta(:,6),'LineWidth',2.0,'Color','#2AB8AB')
hold on
plot(fort61_OWI.zeta(:,6),'LineWidth',2.0,'Color','#C12283')
xlim([1400 2500])
ylim([-0.6 1.75])
title('Station 6','Interpreter','latex','FontSize', 18)
legend('Holland','OWI','Interpreter','latex','FontSize', 15)
ylabel('Surge Elevation','Interpreter','latex','FontSize', 15)
xlabel('Time Step (s)','Interpreter','latex','FontSize', 15)


subplot(2,2,4)
plot(fort61_HOL.zeta(:,11),'LineWidth',2.0,'Color','#2AB8AB')
hold on
plot(fort61_OWI.zeta(:,11),'LineWidth',2.0,'Color','#C12283')
xlim([1400 2500])
ylim([-0.6 1.75])
title('Station 11','Interpreter','latex','FontSize', 18)
ylabel('Surge Elevation','Interpreter','latex','FontSize', 15)
xlabel('Time Step (s)','Interpreter','latex','FontSize', 15)

subplot(2,2,2)
plot(fort61_HOL.zeta(:,2),'LineWidth',2.0,'Color','#2AB8AB')
hold on
plot(fort61_OWI.zeta(:,2),'LineWidth',2.0,'Color','#C12283')
xlim([1400 2500])
ylim([-0.6 1.75])
title('Station 2','Interpreter','latex','FontSize', 18)
ylabel('Surge Elevation','Interpreter','latex','FontSize', 15)
xlabel('Time Step (s)','Interpreter','latex','FontSize', 15)
sgtitle('Recorded Elevation at Various Stations','Interpreter','latex','FontSize', 20)







%% 2D maxele scatterplot with colorbar 30k

% plot of Holland maxele
figure()
hold on
scatter(S(:,1),S(:,2),50,HOL_maxele63(:,2),'filled')
scatter(-78.973,33.500,50,'o','filled','MarkerFaceColor','black')
scatter(-79.090,32.400,50,'o','filled','MarkerFaceColor','black')
scatter(-79.040,30.900,50,'o','filled','MarkerFaceColor','black')
scatter(-79.850,31.000,50,'o','filled','MarkerFaceColor','black')
scatter(-79.740,29.300,50,'o','filled','MarkerFaceColor','black')
scatter(-82.540,26.300,50,'o','filled','MarkerFaceColor','black')
scatter(-82.790,25.600,50,'o','filled','MarkerFaceColor','black')
scatter(-79.240,29.900,50,'o','filled','MarkerFaceColor','black')
scatter(-80.340,30.900,50,'o','filled','MarkerFaceColor','black')
scatter(-82.600,25.700,50,'o','filled','MarkerFaceColor','black')
colorbar
colormap jet
clim([500 3000]) 
title('Maximum Elevation with Holland Wind Model','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)


% plot of OWI maxele
figure()
scatter(S(:,1),S(:,2),50,OWI_maxele63(:,2),'filled')
colorbar
colormap jet
clim([500 3000]) 
title('Maximum Elevation with OWI Wind Model','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)
%%
% D1 = normalize(OWI_maxele63(:,2));
% D2 = normalize(HOL_maxele63(:,2));
% diff = (D1 - D2).^2;
diff = sqrt(diff_maxele.^2);
diff = diff(1:31431,:);
figure()
scatter(S(1:31431,1),S(1:31431,2),25,diff,'filled')
colorbar
colormap jet
clim([0 1.65e+03])
title('Difference Between Holland and OWI','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)
