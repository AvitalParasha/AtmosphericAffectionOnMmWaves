function NL=d_Nl_fun(fv,theta,Press,pw,tableO2,tableH2O)
% The refrectivity: 
% moist air resonance:H2O & O2
% Liebe (1989)
% function
%
% Pinhasi,GA
% 17.12.2017
%======================================================
% resonat H2O & O2 line of absorption and dispersion 

[n_O2,  m_O2]    =size(tableO2);
[n_H2O, m_H2O]   =size(tableH2O);
%
%----------------------------------------------
% N_L: Local  Line  Absorption  and  Dispersion 
NL_O2=0;
%
for k=1:n_O2
    nee0=tableO2(k,1);
    a1=tableO2(k,2);
    a2=tableO2(k,3);
    a3=tableO2(k,4);
    a4=tableO2(k,5);
    a5=tableO2(k,6);
    a6=tableO2(k,7);
    %
    delta=(a5+a6*theta)*1E-3*Press*theta^0.8;     % Liebe (12)
    gamma=a3*1E-3*(Press*theta^(0.8-a4)+1.1*pw*theta);
    %
    A=gamma.*fv./nee0;
    B=(nee0^2+gamma^2)/nee0;
    X=(nee0-fv).^2+gamma^2;
    Y=(nee0+fv).^2+gamma^2;
    % Liebe (9)
    F_tag1=(B-fv)./X+(B+fv)./Y-2/nee0+delta*(A./X-A./Y);
    F_tag2=A./X+A./Y-delta.*(fv./nee0).*((nee0-fv)./X+(nee0+fv)./Y);
    S=a1*1E-6*Press*theta^3*exp(a2*(1-theta));
    % 
    NL_O2=NL_O2+S*(F_tag1-1i*F_tag2); % SUM
end
%----------------------------------------------
% sum for H2O line of absorption and dispersion 30
%
NL_H2O=fv.*0;
%
for k=1:n_H2O
    nee0=tableH2O(k,1);
    b1=tableH2O(k,2);
    b2=tableH2O(k,3);
    b3=tableH2O(k,4);
    b4=tableH2O(k,5);
    b5=tableH2O(k,6);
    b6=tableH2O(k,7);
    %   
    delta=0;
    gamma=b3*0.001*(Press*theta^b4+b5*pw*theta^b6);
    S=b1*pw*theta^3.5*exp(b2*(1-theta));
    %
    A=gamma.*fv/nee0;
    B=(nee0^2+gamma^2)./nee0;
    X=(nee0-fv).^2+gamma^2;
    Y=(nee0+fv).^2+gamma^2;
    %
    F_tag1=(B-fv)./X+(B+fv)./Y-2/nee0;
    F_tag2=A./X+A./Y;
    NL_H2O=NL_H2O+S*(F_tag1-1i*F_tag2); % SUM
end
%----------------------------------------------
%
NL=NL_H2O+NL_O2;
%NN=-imag(NL);
%=======================================================



