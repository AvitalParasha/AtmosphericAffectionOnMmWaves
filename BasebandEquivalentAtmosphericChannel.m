function [BasebandResponse]=BasebandEquivalentAtmosphericChannel(T0c,P0,RH,W0,R,ID,hi,d,CenterFreq,BW,NSamp)

c = physconst('LightSpeed');

Temp = T0c + 273.15; % Converstion from Celsius to Kelvin
% Load Data
[tableO2] =   xlsread('data/tables1.xlsx','O2'   ,'b2:h45');
[tableH2O]=   xlsread('data/tables1.xlsx','H2O'  ,'b2:h31');
[table03NUM,table03TXT,RAW]=xlsread('data/tables1.xlsx','Tab03','b2:e5');
%[table03] =   xlsread('data/tables1.xlsx','Tab03','d2:e5');
[table18a]=   xlsread('data/tables1.xlsx','Tab18','b2:e5');
[table18b]=   xlsread('data/tables1.xlsx','Tab18','g2:j5');
%
%==================================
AerosolTypev=table03TXT(:,2); % Aerosol Species:
C1v=table03NUM(:,1);
gv =table03NUM(:,2);
%
cl=C1v(ID);
g1=gv(ID);

freqv = linspace(CenterFreq - (BW/2) + (BW/(2*NSamp)),CenterFreq + (BW/2) + (BW/(2*NSamp)),NSamp)/1e9;
icaseh=1; % 0- T; 1- T(h) Temperature with height
[Temp,theta,Press,pw,g]=e_AtmThermo10_fun(Temp,P0,hi,RH,cl,icaseh);

clear alphav0 betav0 tauv0 Nv0;
for i=1:length(freqv)
%
    icase_model=0; %(0- Leibe N model, 1- Pinhasi eps model)
    [alphav0(i),betav0(i),tauv0(i),Nv0(i)]=...
        b_AlphaBeta10_fun(freqv(i),theta,Press,pw,W0,R,g,...
        tableO2,tableH2O,table18a,table18b,c,icase_model);
%
end

gainResp = 10.^(-alphav0*d/(20*1000)); %Calculation of Magnitude Response of the Channel
phaseResp = exp(1j*betav0*(pi/180)*10^(-3)*d); % Calculation of the Phase Response of the Channel
BasebandResponse = gainResp.*phaseResp; % Finding the Complex Response
BasebandResponse = ifftshift(BasebandResponse); % Shifted to allow application to Fourier Transform of Signal.





