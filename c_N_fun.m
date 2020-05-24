function [N,NL,Nd,Nc,Nw,NR,N0]=c_N_fun(fv,theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b)
% The refrectivity 
% Liebe (1989)
% function
%
% Pinhasi,GA
% 17.12.2017
%======================================================
% N0
% Nondispersive refractivity                                                              
%------------------------------------------------------
% Liebe (17) 
epsilon_0=77.66+103.3.*(theta-1); 
W=g*W0;
%
%Liebe  (6) 
N1=2.588*Press.*theta;
N2=(41.63*theta+2.39).*pw.*theta;
N3=W*(3/2)*(1-3./(epsilon_0+2));
%N4=R*(3.7-.021*R)/Kr--    ??
N0=N1+N2+N3;   %+N4;                                                                                                                              
%------------------------------------------------------
% N_L: Local  Line  Absorption  and  Dispersion 
%
NL=d_Nl_fun(fv,theta,Press,pw,tableO2,tableH2O);
%-------------------------------------------------------
%Nd-  % Nonresonant dry air spectrum   
%
Nd=d_Nd_fun(fv,theta,Press,pw);
%------------------------------------------------------
%Nc- %Water vapor continuum spectrum                                                 
% Liebe (7)
Nc=d_Nc_fun(fv,theta,Press,pw);
%-------------------------------------------------------
% N_W-  Suspended water droplet refractivity 
% Liebe (17)
Nw=d_Nw_fun(fv,theta,W0,g);
%-------------------------------------------------------
% N_R- Rain effects         
% Liebe (18)
NR=d_Nr_fun(fv,R,table18a,table18b);
%-------------------------------------------------------
% Liebe (7)
%N=(NL+Nd+Nc)+Nw+NR+N0;
N=(NL+Nd+Nc)+Nw+NR;
%=======================================================



