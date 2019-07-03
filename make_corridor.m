function [solution_corr, solution_corr_der,  solution_corr_2der] = make_corridor(cp, number_of_segment,t)
% Ez a föggvény meghatározza a corridor pontjait a controlpontok alapján

% Input:
% cp: controlpontok
% number_of_segment: menniy szegmensbõl épül fel a folyosó
% t: az idõparaméter 0-1 között adott felosztásban

% Output:
% solution_corr: az adott border összes pontja (2 oszlopból áll, x-y koordináták)
% solution_corr_der: a deriváltjai a corridornak
% solution_corr_2der: a 2. deriváltjai a corridornak


corr=[]; corr_der= []; corr_2der=[];
solution_corr=[]; solution_corr_der=[]; solution_corr_2der= [];


for i=1 : number_of_segment
    for j= 1 : length(t)
        % 2 oszlopos soronként kerülnek be  a felsõ border pontjai, deriváltjai és 2. deriváltjai
        % a corridor felsõ részének pontjainak kiszámítása: 2 oszlop: x-y koordináták, annyi sor amennyi szegmensidõosztás
        corr(j,1) = cp(i,1)-2*cp(i,1)*t(j)+2*cp(i,3)*t(j) + cp(i,1)*t(j)^2- 2*cp(i,3)*t(j)^2+ cp(i,5)*t(j)^2 ;
        corr(j,2) = cp(i,2)-2*cp(i,2)*t(j)+2*cp(i,4)*t(j) + cp(i,2)*t(j)^2- 2*cp(i,4)*t(j)^2+ cp(i,6)*t(j)^2 ;
        % a corridor felsõ részének 1. deriváltjának pontjainak kiszámítása
        corr_der(j,1) = -2*cp(i,1) + 2*cp(i,3)*t(j) + 2*cp(i,1)*t(j) - 4*cp(i,3)*t(j)+ 2*cp(i,5)*t(j);
        corr_der(j,2) = -2*cp(i,2) + 2*cp(i,4)*t(j) + 2*cp(i,2)*t(j) - 4*cp(i,4)*t(j)+ 2*cp(i,6)*t(j);
        % a corridor felsõ részének 2. deriváltjának pontjainak kiszámítása
        corr_2der(j,1) = 2*cp(i,1) - 4* 2*cp(i,3) + 2*2*cp(i,5);
        corr_2der(j,2) = 2*cp(i,2) - 4* 2*cp(i,4) + 2*2*cp(i,6);
        
    end
    
    if (i==1)
        index_from=1;
    else
        index_from=2;
    end
 
    solution_corr = [solution_corr; corr(index_from:end,:)];  % végsõ corridor pontok, deriváltak, 2. deriváltak
    solution_corr_der = [solution_corr_der; corr_der(index_from:end,:)];
    solution_corr_2der = [solution_corr_2der; corr_2der(index_from:end,:)];
    
end
end
