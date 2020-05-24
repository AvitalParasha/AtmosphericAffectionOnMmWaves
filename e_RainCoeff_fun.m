function [cR,z]=d_RainCoeff_fun(freq,table18a,table18b)
% Rain Coeff
% Liebe (1989)
% function
%
% Pinhasi,GA
% 17.12.2017
%=============================
% Liebe (1989) -18
% x1, y1
%if (freq>=table18a(1,1))&&(freq<table18a(1,2)),
if (freq<table18a(1,2))
    x1=table18a(1,3);
    y1=table18a(1,4);
elseif (freq>=table18a(2,1))&&(freq<table18a(2,2))
    x1=table18a(2,3);
    y1=table18a(2,4);
elseif (freq>=table18a(3,1))&&(freq<table18a(3,2))
    x1=table18a(3,3);
    y1=table18a(3,4);    
elseif (freq>=table18a(4,1))&&(freq<=table18a(4,2))
    x1=table18a(3,3);
    y1=table18a(3,4);
else
    'Error x1,y1'
end
%----------------------------
% x2, y2
%if (freq>=table18b(1,1))&&(freq<table18b(1,2)),
if (freq<table18b(1,2))
    x2=table18b(1,3);
    y2=table18b(1,4);
elseif (freq>=table18b(2,1))&&(freq<table18b(2,2))
    x2=table18b(2,3);
    y2=table18b(2,4);
elseif (freq>=table18b(3,1))&&(freq<table18b(3,2))
    x2=table18b(3,3);
    y2=table18b(3,4);    
elseif (freq>=table18b(4,1))&&(freq<=table18b(4,2))
    x2=table18b(3,3);
    y2=table18b(3,4);
else
    'Error x2,y2'
end
%----------------------------
cR=x1.*freq.^y1;
z   =x2.*freq.^y2;
%=======================================
