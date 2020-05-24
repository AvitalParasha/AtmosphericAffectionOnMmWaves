function Nc=d_Nc_fun(fv,theta,Press,pw)
% The refrectivity: 
% water vapor continuum spectrum;
% Liebe (1989)
% function
%
% Pinhasi,GA
% 17.12.2017
%======================================================
% Liebe (7)
bs=3.57*theta^7.5;
bf= .113;
b0= .998;
Nc_tag2=fv.*(bs*pw+bf*Press)*(1E-5)*pw*theta^3;
Nc_tag1=fv.^2*b0*(1-.2*theta)*(1E-5)*pw*theta^2.7;
%
Nc=Nc_tag1-1i*Nc_tag2;
%=======================================================



