%[gfp_all, complete_all, tlength_all, meantime_all] = pact('schgate36_lin_all');
[gfp_pro, complete_pro, tlength_pro, meantime_pro] = pact('schgate37_lin_pro','k');
[gfp_mac, complete_mac, tlength_mac, meantime_mac] = pact('schgate37_lin_mac','b');
% close all;
% figure(10); hist(gfp_pro(find(complete_pro)), 20); %set(gca,'Xlim',[3 9])
% 
% figure(11); hist(gfp_mac(find(complete_mac)), 20 ,'r'); %set(gca,'Xlim',[3 9])
% 
% 
% mean(gfp_pro(tlength(complete_pro)))
% 
% mean(gfp_mac(tlength(complete_mac)))
