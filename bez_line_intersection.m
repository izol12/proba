 t = 0: 0.001:1;
b0 = (1-t).^2;
b1 = 2*t.*(1-t);
b2= t.^2;
P0 = [1 1]; % point: x-y coordinates
P1 = [2 3];
P2 = [3, 2];


x = P0(1)*b0 +P1(1)*b1 + P2(1)*b2;  
y = P0(2)*b0 +P1(2)*b1 + P2(2)*b2;

plot([P0(1),P1(1), P2(1)], [P0(2),P1(2),P2(2)],'bx')
hold on
plot(x,y)
xlim([-2, 5])
ylim([-1, 7])
xlabel('x[m]')
ylabel('y[m]')
grid on
hold on
a = 1
b= 1
A = [1,1]; % (a,b)
c = 3;
t_new = 0:0.1:7;
plot(t_new,-a/A(2)*t_new+c/b,'g')

P=P2
elojel1 = a*P(1)+ b*P(2)-c

        syms t1;
      t = vpasolve( (P0(1)*a+P0(2)*b)*(1-t1)^2 +(P1(1)*a+ P1(2)*b)*2*t1*(1-t1)+ (P2(1)*a+P2(2)*b)*t1^2 -c == 0, t1)
 % Együtthatók szerint szétszedve
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
 
 hold on
% t= 0.0691
% a0 = (1-t).^2;
% a1 = 2*t.*(1-t);
% a2= t.^2;     
% x = P0(1)*a0 +P1(1)*a1 + P2(1)*a2;  
% y = P0(2)*a0 +P1(2)*a1 + P2(2)*a2;
% 
% plot(x,y,'ro')
% xlim([-2, 5])
% ylim([-1, 4])
   %Errõl az oldalról szedtem:     
%% https://math.stackexchange.com/questions/2347733/intersections-aetween-a-cuaic-a%C3%A9zier-curve-and-a-line?rq=1