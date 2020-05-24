function [alphav,betav,dtauv,N]=b_AlphaBeta10_fun(fv,theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b,c,icase_model)
% Liebe (1989)
% function
%
% Pinhasi,GA
% Golovachev Y
% 15.01.2017
%======================================================
[N,NL,Nd,Nc,Nw,NR,N0]=c_N_fun(fv,theta,Press,pw,W0,R,g,...
    tableO2,tableH2O,table18a,table18b);
%-------------------------------------------------------------------------------

if icase_model==0 %(0- Leibe N model)
    % The  real  part  to  phase  dispersion
    %  Liebe (5b)
    betav=1.2008*real(N).*fv;  %  [deg/km] 
    % Group Delay [ps/km]
    dtauv =3.336*real(N);     %  [ps/km]  
    % Power  attenuation
    % Liebe (5a)
    % Power Attenuation [dB/km]
    alphav  =-imag(N).*fv*0.182; % [dB/km]
    %
elseif icase_model==1 %(1- Pinhasi eps model)
    [eps_Rev,eps_Imv]=c_eps_fun(fv,theta,Press,pw,W0,R,g,...
        tableO2,tableH2O,table18a,table18b);
    epsr=eps_Imv./eps_Rev;
    %
    lamdav=2*pi*fv*(10^9)/c;
    lamda2=lamdav/sqrt(2);
    %
    S1=sqrt(1+epsr.^2);
    S2=sqrt(S1-1);
    S3=sqrt(S1+1);
    %
    alphav=lamda2.*sqrt(eps_Rev).*S2;
    % alphav=lamda2.*sqrt(eps_Rev).*(sqrt(S1)-1)
    betav =lamda2.*sqrt(eps_Imv).*S3;  % Pinhasi 2018 (6)
    % betav =lamda2.*sqrt(eps_Imv).*sqrt(epsr)./S2;
    
    %
    [deps_Rev,deps_Imv]=c_deps_fun(fv,theta,Press,pw,W0,R,g,...
        tableO2,tableH2O,table18a,table18b);
    %
    A1=eps_Rev+fv.*deps_Rev/2;
    A2=eps_Imv+fv.*deps_Imv/2;
    %
    dalphav =lamdav.^2./fv.*( betav.*A2-alphav.*A1)./(alphav.^2+betav.^2);
    dbetav  =lamdav.^2./fv.*(alphav.*A2+ betav.*A1)./(alphav.^2+betav.^2);
    %
    dtauv=dbetav/(2*pi)-1/c;

end
%=======================================================

 








