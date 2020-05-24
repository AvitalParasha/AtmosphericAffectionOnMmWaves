function Nw=d_Nw_fun(fv,theta,W0,g)
% The refrectivity: 
% Suspended water droplet refractivity 
% Liebe (1989)
% function
%
% Pinhasi,GA
% 17.12.2017
%======================================================
% Liebe (17)
epsilon_0=77.66+103.3.*(theta-1); 
W=g*W0;

epsilon_1=5.48;
epsilon_2=3.51;
% epsilon_0=77.66+103.3*(teta(i)-1);
fp=20.09-142*(theta-1)+294*(theta-1)^2;   %[GHz]
fs=590 -1500*(theta-1);                                    %[GHz]
%
epsilon_tag2=(epsilon_0-epsilon_1)*fv./(fp.*(1+(fv./fp).^2))...
                 +(epsilon_1-epsilon_2)*fv./(fs.*(1+(fv./fs).^2));
epsilon_tag1=(epsilon_0-epsilon_1)./((1+(fv./fp).^2))...
                 +(epsilon_1-epsilon_2)./((1+(fv./fs).^2))+epsilon_2;
eata=(2+epsilon_tag1)./epsilon_tag2;
%
Nw_tag1=W*(9/2)*(1./(epsilon_0+2)-eata./(epsilon_tag2.*(1+eata.^2)));
Nw_tag2=W*(9/2)*(epsilon_tag2.*(1+eata.^2)).^-1;
%
Nw=Nw_tag1-1i*Nw_tag2;
%=======================================================



