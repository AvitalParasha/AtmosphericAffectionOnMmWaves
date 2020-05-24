% Propagation of linear FM signals in dielectric media
% data
%
% Pinhasi,GA
% 17.12.2017
%==========================================================================
% Data

freq0=94;% [GHz]  Frequency (test program01)
%
hi=0;     % [km]  Height
 T0c=20; % [C]  Graund Air temperature
P0=101; % [kPa] =1atm
%
 RH=80;   %  [%] Relative humidity  (RH)
 ID=2; % Aerosol Species: (RH=99.99) 
        % 1-Rural, 2-Urban, 3-Maritime, 4-3+Strong Wind
 
cl=5.83;

 R=0;     %  [mm/hr] Rain-  rainfall  rate

W0=0;   % [g/m^3]  W -Water droplets
iW=4;
W0v=[0.01,0.1,0.5,1]; % [g/m^3] W -Water droplets
%-------------------------------------------------------------------------
% Linear FM Signal
delta_f=4E9;    % [Hz]  Frequency Span 
T=30E-3;        % [s]   Sweep Time 
%
% Medium
d=1E3;          %  [m] Distance 
%    
f0=94E9;      %  [Hz]  Resonance Frequency 
%---------------------------------------------------------------------
% Physical parameters
c=3E8;      % Speed of light [m/s] 
% Numerical parameters
NN=1.001;   % 2
%==================================
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
AerosolType=AerosolTypev(ID);
cl=C1v(ID);
g1=gv(ID); % g (99.9 %RH)
%==================================

