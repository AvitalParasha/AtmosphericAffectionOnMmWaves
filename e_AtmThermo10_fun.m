function [Temp,theta,Press,pw,g]=e_AtmThermo10_fun(T0,P0,h,RH,cl,icaseh)
% AtmThermo
% Liebe (1989)
% function
%
% Pinhasi,GA
% 17.12.2017
%==================================
%h=0
Temp=T0;
Press=P0;
if icaseh==1
    Temp=T0-6.5*h; %  [K deg] Temperature with height
    Press=P0*exp(-h./7);    %[kPa]
end
%
theta=300./Temp;          %[1/K deg]
pw0=0.241E9*RH*theta^4*exp(-22.64*theta);     % ??[kPa]   Normal 1.36
pw =pw0;
%
if icaseh==1
    pw =pw0.*exp(-h./2.5);
end
% Relative Humidity
if RH==100 % (??)
    RH=99.9;
end
g=0.001*(20*cl+80-RH)/(cl*(100-RH)); % Liebe (3)
%==================================