%% Limits of the pictures
xlim_min = -2;
ylim_min= -3
xlim_max = 8;
ylim_max= 8;


Pj = [0,-0.5; 3 0; 6 3]
cp_j(1,3)= 1.5;                    % X2- Kontroll
cp_j(1,4)= -0.5;  

%The number of the segments:
number_of_segment = size(Pj,1)-1;
% the controlpoints of a segment is in one row: pl.: 3 segments--> 3 rows, 1 row: [x1 y1 x2 y2
% x3y3 ]

for i=1:(number_of_segment)                   % structure all controlpoints
    cp_j(i,1)=Pj(i,1);             % X1k- Start
    cp_j(i,2)=Pj(i,2);             % Y1- Start
    cp_j(i,5)=Pj(i+1,1);           % X3- End
    cp_j(i,6)=Pj(i+1,2);           % Y3- End
end

% Calculating the middle controlpoint of a segment
if(number_of_segment>1)
    for i=2:(number_of_segment)                          
        cp_j(i,3)=-cp_j(i-1,3)+2*cp_j(i-1,5);     % X2- Kontroll
        cp_j(i,4)=-cp_j(i-1,4)+2*cp_j(i-1,6);     % Y2- Kontroll
    end
end

rotation=1; % rotate left
bezier_offset=1.35; % distance between the borders
cp_k = ofsetting_bezier_curve(number_of_segment,cp_j,bezier_offset,rotation) % contropints of the middle 

rotation=1;
cp_b = ofsetting_bezier_curve(number_of_segment,cp_j,2*bezier_offset,rotation)

 t = 0: 0.001:1;
make_corridor_new(cp_j, number_of_segment,t)
make_corridor_new(cp_k, number_of_segment,t)
make_corridor_new(cp_b, number_of_segment,t)
xlim(xlimits);
ylim(ylimits);
grid on
xlabel('x coordinates [m]')
ylabel('y coordinates [m]')

seb = [0.75, 0.5] % the actual velocity vector of the robot (x,y coordinates)
poz = [0.5 0] % the actual position of the robot (x,y coordinates)
plot(poz(1),poz(2),'bx')


ir_vec = seb-poz
angle_vel = rad2deg(atan2(seb(2)-poz(2), seb(1)-poz(1)))

% for the calculation of the line we use the normal equation of the lane:
% ax+by = c
a = -ir_vec(2)
b = ir_vec(1)
c = a*poz(1)+ b*poz(2);
t_new = -1:0.1:7;
plot(t_new,-a/b*t_new+c/b,'g')
plot([poz(1) seb(1)], [poz(2) seb(2)],'r')
% P=P2
% elojel1 = a*P(1)+ b*P(2)-c

        %syms t1;
    %  t = vpasolve( (P0(1)*a+P0(2)*b)*(1-t1)^2 +(P1(1)*a+ P1(2)*b)*2*t1*(1-t1)+ (P2(1)*a+P2(2)*b)*t1^2 -c == 0, t1)
  cp = cp_j;
  
  % Az osszes szegmenst meg kell vizsgalni, hogy atmegy-e rajta az egyenes,
  % csak ott kell vizsgalni a metszespontot az egyenessel (2 szomszedos controlpontot behelyettesitve az egyenesbe k�l elojelet ad, akkor azon a szegmensen megy at az egyenes)
  % [number_of_segment*1-es mx, 0 az �rt�k, ha nincs metszespont az adott
  % szegmensen belul
  cp_int_vizsg = [ (sign(a*cp(:,1)+b* cp(:,2)-c) ~= sign(a*cp(:,3)+b* cp(:,4)-c)) + (sign(a*cp(:,3)+b* cp(:,4)-c) ~= sign(a*cp(:,5)+b* cp(:,6)-c))]
  
  % Letrehozunk egy number_of_segment2-es matrixot a metszespontoknak 
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
              % itt vigy�zni kell, hogy lehet-e 2 metsz�spont 1 szegmensen,
              % altalanosan megoldva lehet, ugy szamolunk
              t= t2
              a0 = (1-t).^2;
              a1 = 2*t.*(1-t);
              a2= t.^2;
              x = cp(i,1)*a0 +cp(i,3)*a1 + cp(i,5)*a2;
              y = cp(i,2)*a0 +cp(i,4)*a1 + cp(i,6)*a2;
              plot(x,y,'ro')
              
              % Meg kell n�zni, hogy ha 1 szegmensen belul tobb metszespont
              % van, akkor melyek neznek jo iranyba
              angle_intersection = rad2deg(atan2(y-poz(2), x-poz(1)));
              x = x(abs(angle_intersection- angle_vel) < 0.0002);
              y = y(abs(angle_intersection- angle_vel) < 0.0002);
              
              % a metszespontok kozul kiszamitjuk azt, amelyik legkozelebb
              % van a robotpoziciohoz, ha jo iranyba nez a seb vektor
              if (~isempty(x))
              tav = sqrt((x-poz(1)).^2 +(y-poz(2)).^2);
              intersection_points(i,:) = [ x(tav==min(tav)) y(tav==min(tav))];
              end                 
          end
      end
  end
  % Ahol nin nan, azok a jo metszespontok
  good_segment = find(~isnan(intersection_points(:,1)))
  if isempty(good_segment)
      % ekkor nincs metszes az adott gorbe es a poz-seb vektor egyenese
      % kozott
  end
  % kul. szegmenseknel milyen tavra van a metsz pont a poz-tol
  segment_intersection_distance = sqrt((intersection_points(good_segment,1)-poz(1)).^2 +(intersection_points(good_segment,2)-poz(2)).^2)
  % kivalasztjuk a metszesek kozul azt, amelyik a legkozelebb van
  metsz = intersection_points(good_segment(find(segment_intersection_distance==min(segment_intersection_distance))),:)
  