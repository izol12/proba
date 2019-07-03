%% Border controllpontok megad�sa
xlim_min = -2;
ylim_min= -3
xlim_max = 8;
ylim_max= 8;

% Külön branchen nézzük
% Változtatunk
% itt elkezdj�k a k�z�ps� s�v megad�s�t:

Pj = [0,-0.5; 3 0; 6 3]
cp_j(1,3)= 1.5;                    % X2- Kontroll
cp_j(1,4)= -0.5;                    % Y2- Kontroll

number_of_segment = size(Pj,1)-1;
% soronk�nt egy szegmens kontrollpontjai pl.: 3 szegmensn�l: 3 sorb�l �ll, 1 sor: [x1 y1 x2 y2
% x3y3 ]

for i=1:(number_of_segment)                   % V�gigfutunk az �sszes szegmensen
    cp_j(i,1)=Pj(i,1);             % X1k- Start
    cp_j(i,2)=Pj(i,2);             % Y1- Start
    cp_j(i,5)=Pj(i+1,1);           % X3- End
    cp_j(i,6)=Pj(i+1,2);           % Y3- End
end




if(number_of_segment>1)
    for i=2:(number_of_segment)                           % V�gigfutunk az �sszes szegmensen
        cp_j(i,3)=-cp_j(i-1,3)+2*cp_j(i-1,5);     % X2- Kontroll
        cp_j(i,4)=-cp_j(i-1,4)+2*cp_j(i-1,6);     % Y2- Kontroll
    end
end

rotation=1; % jobbra forgat�s
bezier_offset=1.35;
cp_k = ofsetting_bezier_curve(number_of_segment,cp_j,bezier_offset,rotation)

rotation=1; % balra forgat�s
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

a = - ir_vec(2)
b=  ir_vec(1)
c = a*poz(1)+ b*poz(2);
t_new = -1:0.1:7;
plot(t_new,-a/b*t_new+c/b,'g')

% P=P2
% elojel1 = a*P(1)+ b*P(2)-c

        syms t1;
      t = vpasolve( (P0(1)*a+P0(2)*b)*(1-t1)^2 +(P1(1)*a+ P1(2)*b)*2*t1*(1-t1)+ (P2(1)*a+P2(2)*b)*t1^2 -c == 0, t1)
 % Egy�tthat�k szerint sz�tszedve
      t2 = [ P0(1)*a+P0(2)*b+P2(1)*a+P2(2)*b-2*(P1(1)*a+ P1(2)*b)... %t^2
             -2*(P0(1)*a+P0(2)*b)+2*(P1(1)*a+ P1(2)*b)...  % t
             P0(1)*a+P0(2)*b-c ]  % constant
      t2 = roots(t2)
 hold on 
 if isreal(t2)
     t2 = t2(t2<=1)
     t2 = t2(t2>=0)
     for i=1:size(t2,1)
         t= t2(i)
        a0 = (1-t).^2;
        a1 = 2*t.*(1-t);
        a2= t.^2;     
        x = P0(1)*a0 +P1(1)*a1 + P2(1)*a2;  
        y = P0(2)*a0 +P1(2)*a1 + P2(2)*a2;

        plot(x,y,'ro')

     end
 end