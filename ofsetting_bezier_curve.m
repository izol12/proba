function cp_sol = ofsetting_bezier_curve(number_of_segment,cp_f,bezier_offset,rotation)


for segment=1:number_of_segment
    for i=1:2:3
        dis_x = cp_f(segment,i+2)-cp_f(segment,i); % x koordin�ta: cp3-cp1 vagy cp5-cp3
        dis_y = cp_f(segment,i+3)-cp_f(segment,i+1);    % y koordin�ta: cp4-cp2 vagy cp6-cp4

        % norm�lvektor hossza:
        n_dist = sqrt(dis_x^2 +dis_y^2);

        % az egys�ghossz� norm�lvektor megkaphat� a hossz leoszt�s�val:        
        % minden szegmensn�l 2 norm�lvektor lesz
        
         % norm�lvektor megkap�sa:
         if(rotation==1)
            % balra forgat�s
            nx(segment, (i+1)/2) = -dis_y / n_dist; % a fels� controllpontok vannak megadva, ez�rt bal ir�nyba toljuk a controllpontokat
            ny(segment, (i+1)/2)= dis_x / n_dist;
         else
            % jobbra forgat�s
            nx(segment, (i+1)/2) = dis_y / n_dist; % a fels� controllpontok vannak megadva, ez�rt bal ir�nyba toljuk a controllpontokat
            ny(segment, (i+1)/2)= -dis_x / n_dist;
    
         end
    end

% kisz�m�tjuk az eltol�si vektorokat, 2 kell, mert az els�n�l egy�rtelm�,
% megn�zz�k, hogy hogy is legyen
trans_direction_x1 = nx(segment,1);  % meg kell n�zni, hogy nem tolja el el nagyon 
trans_direction_y1 = ny(segment,1);  % ugyanaz, mint el�bb
trans_direction_x2 = (nx(segment,1)+ nx(segment,2)) / sqrt ((nx(segment,1)+ nx(segment,2))^2 + (ny(segment,1)+ ny(segment,2))^2);
trans_direction_y2 = (ny(segment,1)+ ny(segment,2)) / sqrt ((nx(segment,1)+ nx(segment,2))^2 + (ny(segment,1)+ ny(segment,2))^2);
trans_direction_x3 = nx(segment,2);
trans_direction_y3 = ny(segment,2);

%eltolt vektorok hosszai
% m�sodrend� g�rbe elej�n �s v�g�n az offset a t�vols�g:
trans_length1 = bezier_offset;
%nevez�ben skal�ris szorz�s:
trans_length2 = bezier_offset / (nx(segment,1)*trans_direction_x2+ ny(segment,1)*trans_direction_y2);
trans_length3 = bezier_offset;

cp_sol(segment,1) = cp_f(segment,1) + trans_direction_x1*trans_length1;
cp_sol(segment,2) = cp_f(segment,2) + trans_direction_y1*trans_length1;
cp_sol(segment,3) = cp_f(segment,3) + trans_direction_x2*trans_length2;
cp_sol(segment,4) = cp_f(segment,4) + trans_direction_y2*trans_length2;
cp_sol(segment,5) = cp_f(segment,5) + trans_direction_x3*trans_length3;
cp_sol(segment,6) = cp_f(segment,6) + trans_direction_y3*trans_length3;
 
end
end
