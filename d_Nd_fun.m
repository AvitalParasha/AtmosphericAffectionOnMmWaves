function Nd=d_Nd_fun(fv,theta,Press,pw)
% The refrectivity: 
% Nonresonant dry air spectrum
% Liebe (1989)
% function
%
% Pinhasi,GA
% 17.12.2017
%======================================================
% Table 1
Sd=6.14E-4*Press.*theta.^2;
gamma_0=5.6E-3*(Press+1.1*pw).*theta;
ap=1.4E-10.*(1-1.2E-5.*fv.^1.5);  % 
%
% Liebe (13)
Nd_tag1=Sd./(1.+(fv./gamma_0).^2)-Sd; %h=0
Nd_tag2=Sd*fv./(gamma_0.*(1+(fv./gamma_0).^2))...
        +ap.*fv.*Press^2*theta^3.5; %h=0
%
Nd=Nd_tag1-1i*Nd_tag2;   
%=======================================================



