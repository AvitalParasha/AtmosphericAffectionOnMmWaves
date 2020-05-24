function NR=d_Nr_fun(fv,R,table18a,table18b)
% The refrectivity: 
% Rain effects
% Liebe (1989)
% function
%
% Pinhasi,GA
% 17.12.2017
%======================================================
% Liebe (18)
fr=53-R*(.37-.0015*R); %[ GHz]  
yv=fv./fr;
%-------------------------------------------
[cr,z]=e_RainCoeff_fun(fv,table18a,table18b);
%
NR_tag2=cr.*R.^z;
NR_tag1=R.*(.012*R-3.7).*yv.^2.5./(fr.*(1+yv.^2.5));
%
NR=NR_tag1-1i*NR_tag2; % [ppm]
%=======================================================



