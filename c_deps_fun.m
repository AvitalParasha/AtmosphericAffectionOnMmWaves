function [deps_Rev,deps_Imv]=c_deps_fun(f,theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b)
% Gad Pinhasi
% 9.3.17
%===========================
df=0.1;
%
[eps_Rev1,eps_Imv1]=c_eps_fun(f-df,theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b);
[eps_Rev2,eps_Imv2]=c_eps_fun(f+df,theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b);
%
deps_Rev=(eps_Rev2-eps_Rev1)/(2*df);
deps_Imv=(eps_Imv2-eps_Imv1)/(2*df);
%===========================

