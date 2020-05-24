
% Data
a_AtmTrans00_data
%--------------------------------------------------------------------------
%Units
UC2K=273.15; % [K]
%--------------------------------------------------------------------------
% Initalization of Parameters    
% Frequency
fmin=-2;     % < 2.9GHz
fmax=log10(350);   % < 180GHz
%df=1;     % GHz (resolution of frequency)
L = 50; %Distance from Base Station(m)
NNf=2000;
Fs = 700*10^9;
Ts = 1/Fs;
%-------------------------------------------------------------------------
% vectors
freqv=logspace(fmin,fmax,NNf+1); % [GHz] Frequency
%-------------------------------------------------------------------------
% Thermo
Temp=T0c+UC2K; % [K]
%
icaseh=0; % 0- T; 1- T(h) Temperature with height
[Temp,theta,Press,pw,g]=e_AtmThermo10_fun(Temp,P0,hi,RH,cl,icaseh);
%
%---------------------------
for i=1:length(freqv)
%
icase_model=0; %(0- Leibe N model, 1- Pinhasi eps model)
[alphav0(i),betav0(i),tauv0(i),Nv0(i)]=...
    b_AlphaBeta10_fun(freqv(i),theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b,c,icase_model);
end
%
%=======================================================

gainResp = 10.^(-alphav0*L/(20*1000)); %Calculation of Magnitude Response of the Channel
phaseResp = exp(-1j*betav0*(pi/180)*10^(-3)*L); % Calculation of the Phase Response of the Channel
resp = gainResp.*phaseResp; % Finding the Complex Response
Hfrd = idfrd(resp,freqv*10^9,Ts,'FrequencyUnit','Hz'); %Building the channel

