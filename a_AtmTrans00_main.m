% Propagation of linear FM signals in dielectric media
% main
%
% Pinhasi,GA
% Golovachev Y
% 15.01.2017
%==========================================================================
clear all
% close all
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
NNf=200;
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
% W -suspended water droplet concentration (g/m3)
W0=0;
for i=1:length(freqv)
%
icase_model=0; %(0- Leibe N model, 1- Pinhasi eps model)
[alphav0(i),betav0(i),tauv0(i),Nv0(i)]=...
    b_AlphaBeta10_fun(freqv(i),theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b,c,icase_model);
%
icase_model=0; %(0- Leibe N model, 1- Pinhasi eps model)
[alphav1(i),betav1(i),tauv1(i),Nv1(i)]=...
    b_AlphaBeta10_fun(freqv(i),theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b,c,icase_model);
[N(i),NL(i),Nd(i),Nc(i),Nw(i),NR(i),N0(i)]=c_N_fun(freqv(i),theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b);
%
end
%
%=======================================================
figure(1)
semilogy(freqv,alphav0,'LineWidth',2)
title('Liebe \alpha')
%axis([0,350,1E-2,2E2])
xlabel('Frequency [GHz]','Fontsize',12);
ylabel('Power Attenuation [dB/km]','Fontsize',12);
legend(['W=',num2str(W0),' [g/m^3]']);
set(gca,'Fontsize',12)
grid on
% 
figure(2)
semilogy(freqv,alphav1*1E4,'LineWidth',2)
title('Analytical \alpha')
%axis([0,350,1E-2,2E2])
xlabel('Frequency [GHz]','Fontsize',12);
ylabel('Power Attenuation [dB/km]','Fontsize',12);
legend(['W=',num2str(W0),' [g/m^3]']);
set(gca,'Fontsize',12)
grid on

% %-------------------------------------------------------------------------
figure(3)
plot(freqv,betav0*(2*pi/360)*10^(-3),'LineWidth',2);
title('Liebe \beta')
xlabel('Frequency [GHz]','fontsize',12);
ylabel('\beta [rad/m]','fontsize',12);
legend(['W=',num2str(W0),' [g/m^3]']);
set(gca,'Fontsize',12)
grid on

figure(4)
plot(freqv,real(betav1),'LineWidth',2);
title('Analytical \beta')
xlabel('Frequency [GHz]','fontsize',12);
ylabel('\beta [rad/m]','fontsize',12);
legend(['W=',num2str(W0),' [g/m^3]']);
set(gca,'Fontsize',12)
grid on

figure(5)
plot(freqv,(2*pi*(10^9)*freqv/c.*(1+(real(N)+N0)*10^(-6))),'LineWidth',2);
title('Definition \beta')
xlabel('Frequency [GHz]','fontsize',12);
ylabel('\beta [rad/m]','fontsize',12);
legend(['W=',num2str(W0),' [g/m^3]']);
set(gca,'Fontsize',12)
grid on

figure(6)
plot(freqv,tauv0,'LineWidth',2);
title('Liebe \Delta \tau')
xlabel('Frequency [GHz]','fontsize',12);
ylabel('\Delta \tau [psec/km]','fontsize',12);
legend(['W=',num2str(W0),' [g/m^3]']);
set(gca,'Fontsize',12)
grid on

figure(7)
plot(freqv,-tauv1,'LineWidth',2);
title('Analytical \Delta \tau')
xlabel('Frequency [GHz]','fontsize',12);
ylabel('\Delta \tau [sec/m]','fontsize',12);
legend(['W=',num2str(W0),' [g/m^3]']);
set(gca,'Fontsize',12)
grid on

% %-------------------------------------------------------------------------
% figure(10)
% clf;
% text(0.1,0.9,['Aerosol Type=',AerosolType],'Units','normalized','Fontsize',12);
% text(0.1,0.8,['T_a_i_r=',num2str(T0c),' [C]'],'Units','normalized','fontsize',12)
% text(0.1,0.7,['RH=',num2str(RH),' [%]'],'Units','normalized','fontsize',12)
% text(0.1,0.6,['Rain=',num2str(R),' [mm/hr]'],'Units','normalized','fontsize',12)
% text(0.1,0.5,['Water droplets=',num2str(W0),' [g/m^3]'],'Units','normalized','fontsize',12)
% 
% %-------------------------------------------------------------------------

%==========================================================================

