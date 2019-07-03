function [solution_corr, solution_corr_der,  solution_corr_2der] = make_corridor(cp, number_of_segment,t)
% Ez a f�ggv�ny meghat�rozza a corridor pontjait a controlpontok alapj�n

% Input:
% cp: controlpontok
% number_of_segment: menniy szegmensb�l �p�l fel a folyos�
% t: az id�param�ter 0-1 k�z�tt adott feloszt�sban

% Output:
% solution_corr: az adott border �sszes pontja (2 oszlopb�l �ll, x-y koordin�t�k)
% solution_corr_der: a deriv�ltjai a corridornak
% solution_corr_2der: a 2. deriv�ltjai a corridornak


corr=[]; corr_der= []; corr_2der=[];
solution_corr=[]; solution_corr_der=[]; solution_corr_2der= [];


for i=1 : number_of_segment
    for j= 1 : length(t)
        % 2 oszlopos soronk�nt ker�lnek be  a fels� border pontjai, deriv�ltjai �s 2. deriv�ltjai
        % a corridor fels� r�sz�nek pontjainak kisz�m�t�sa: 2 oszlop: x-y koordin�t�k, annyi sor amennyi szegmensid�oszt�s
        corr(j,1) = cp(i,1)-2*cp(i,1)*t(j)+2*cp(i,3)*t(j) + cp(i,1)*t(j)^2- 2*cp(i,3)*t(j)^2+ cp(i,5)*t(j)^2 ;
        corr(j,2) = cp(i,2)-2*cp(i,2)*t(j)+2*cp(i,4)*t(j) + cp(i,2)*t(j)^2- 2*cp(i,4)*t(j)^2+ cp(i,6)*t(j)^2 ;
        % a corridor fels� r�sz�nek 1. deriv�ltj�nak pontjainak kisz�m�t�sa
        corr_der(j,1) = -2*cp(i,1) + 2*cp(i,3)*t(j) + 2*cp(i,1)*t(j) - 4*cp(i,3)*t(j)+ 2*cp(i,5)*t(j);
        corr_der(j,2) = -2*cp(i,2) + 2*cp(i,4)*t(j) + 2*cp(i,2)*t(j) - 4*cp(i,4)*t(j)+ 2*cp(i,6)*t(j);
        % a corridor fels� r�sz�nek 2. deriv�ltj�nak pontjainak kisz�m�t�sa
        corr_2der(j,1) = 2*cp(i,1) - 4* 2*cp(i,3) + 2*2*cp(i,5);
        corr_2der(j,2) = 2*cp(i,2) - 4* 2*cp(i,4) + 2*2*cp(i,6);
        
    end
    
    if (i==1)
        index_from=1;
    else
        index_from=2;
    end
 
    solution_corr = [solution_corr; corr(index_from:end,:)];  % v�gs� corridor pontok, deriv�ltak, 2. deriv�ltak
    solution_corr_der = [solution_corr_der; corr_der(index_from:end,:)];
    solution_corr_2der = [solution_corr_2der; corr_2der(index_from:end,:)];
    
end
end
