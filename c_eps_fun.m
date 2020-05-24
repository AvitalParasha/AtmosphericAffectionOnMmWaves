function [eps1v,eps2v]=c_eps_fun(fv,theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b)
% The permittivity
% Pinhasi (2018)
% function
%
% Pinhasi,GA
% 17.12.2017
%======================================================
% The relation between 
% the complex refractivity and complex permittivity 
[N,NL,Nd,Nc,Nw,NR,N0]=c_N_fun(fv,theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b);
% Real part
eps1v=1+2*(N0+real(N))*1E-6;
% Imaginary part     
eps2v=-2*imag(N)*1E-6; % !!!!!!!!!!!!! - !!!!!!!!!!!
%=======================================================



