%% Border controllpontok megadï¿½sa
xlim_min = -2;
ylim_min= -3
xlim_max = 8;
ylim_max= 8;



Pj = [0,-0.5; 3 0; 6 3]
cp_j(1,3)= 1.5;                    % X2- Kontroll
cp_j(1,4)= -0.5;                    % Y2- Kontroll

number_of_segment = size(Pj,1)-1;
% soronkï¿½nt egy szegmens kontrollpontjai pl.: 3 szegmensnï¿½l: 3 sorbï¿½l ï¿½ll, 1 sor: [x1 y1 x2 y2
% x3y3 ]

for i=1:(number_of_segment)                   % Vï¿½gigfutunk az ï¿½sszes szegmensen
    cp_j(i,1)=Pj(i,1);             % X1k- Start
    cp_j(i,2)=Pj(i,2);             % Y1- Start
    cp_j(i,5)=Pj(i+1,1);           % X3- End
    cp_j(i,6)=Pj(i+1,2);           % Y3- End
end




if(number_of_segment>1)
    for i=2:(number_of_segment)                           % Vï¿½gigfutunk az ï¿½sszes szegmensen
        cp_j(i,3)=-cp_j(i-1,3)+2*cp_j(i-1,5);     % X2- Kontroll
        cp_j(i,4)=-cp_j(i-1,4)+2*cp_j(i-1,6);     % Y2- Kontroll
    end
end

rotation=1; % jobbra forgatï¿½s
bezier_offset=1.35;
cp_k = ofsetting_bezier_curve(number_of_segment,cp_j,bezier_offset,rotation)

rotation=1; % balra forgatï¿½s
cp_b = ofsetting_bezier_curve(number_of_segment,cp_j,2*bezier_offset,rotation)

 t = 0: 0.001:1;
make_corridor_new(cp_j, number_of_segment,t)
make_corridor_new(cp_k, number_of_segment,t)
make_corridor_new(cp_b, number_of_segment,t)
xlim([xlim_min xlim_max])
ylim([ylim_min ylim_max])
grid on
xlabel('x coordinates [m]')
ylabel('y coordinates [m]')

seb = [0.75, 0.5]
poz = [0.5 0]
ir_vec = seb-poz
angle_vel = rad2deg(atan2(seb(2)-poz(2), seb(1)-poz(1)))
                  
a = -ir_vec(2)
b = ir_vec(1)
c = a*poz(1)+ b*poz(2);
t_new = -1:0.1:7;
plot(t_new,-a/b*t_new+c/b,'g')

% P=P2
% elojel1 = a*P(1)+ b*P(2)-c

        %syms t1;
    %  t = vpasolve( (P0(1)*a+P0(2)*b)*(1-t1)^2 +(P1(1)*a+ P1(2)*b)*2*t1*(1-t1)+ (P2(1)*a+P2(2)*b)*t1^2 -c == 0, t1)
  cp = cp_k
  cp_int_vizsg = [ (sign(a*cp(:,1)+b* cp(:,2)-c) ~= sign(a*cp(:,3)+b* cp(:,4)-c)) + (sign(a*cp(:,3)+b* cp(:,4)-c) ~= sign(a*cp(:,5)+b* cp(:,6)-c))]
  
  
  intersection_points = ones(number_of_segment,2)*NaN;
  
  for i=1:number_of_segment
      if(cp_int_vizsg(i)>0)
          t2 = [ cp(i,1)*a+cp(i,2)*b+cp(i,5)*a+cp(i,6)*b-2*(cp(i,3)*a+ cp(i,4)*b)... %t^2
              -2*(cp(i,1)*a+cp(i,2)*b)+2*(cp(i,3)*a+ cp(i,4)*b)...  % t
              cp(i,1)*a+cp(i,2)*b-c ]  % constant
          t2 = roots(t2)
          hold on
          if isreal(t2) % van-e metszespont
              % adott segmensen belul van-e a metsz. pont:
              t2 = t2(t2<=1) 
              t2 = t2(t2>=0)
              % itt vigyázni kell, hogy lehet-e 2 metszéspont 1 szegmensen
              % belül, én most hajlok inkább a nemre
                  t= t2
                  a0 = (1-t).^2;
                  a1 = 2*t.*(1-t);
                  a2= t.^2;
                  x = cp(i,1)*a0 +cp(i,3)*a1 + cp(i,5)*a2;
                  y = cp(i,2)*a0 +cp(i,4)*a1 + cp(i,6)*a2;
                  
                  tav = sqrt((x-poz(1)).^2 +(y-poz(2)).^2);
                  x = x(find(tav==min(tav)));
                  y = y(find(tav==min(tav)));
                  
                  
                  plot(x,y,'ro')
                  angle_intersection = rad2deg(atan2(y-poz(2), x-poz(1)));
                  if((angle_intersection- angle_vel) < 0.0002)
                      intersection_points(i,:) = [x, y];
                  end
             
          end
      end
  end
  % Ahol nin nan, azok a jo metszespontok
  good_segment = find(~isnan(intersection_points(:,1)))
  
  % kul. szegmenseknel milyen tavra van a metsz pont a poz-tol
  segment_intersection_distance = sqrt((intersection_points(good_segment,1)-poz(1)).^2 +(intersection_points(good_segment,2)-poz(2)).^2)
  % kivalasztjuk a metszesek kozul azt, amelyik a legkozelebb van
  intersection_points(good_segment(find(segment_intersection_distance==min(segment_intersection_distance))),:)
  