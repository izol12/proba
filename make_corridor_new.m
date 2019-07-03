function make_corridor_new(cp, number_of_segment,t)
% Ez a föggvény meghatározza a corridor pontjait a controlpontok alapján

% Input:
% cp: controlpontok
% number_of_segment: menniy szegmensbõl épül fel a folyosó
% t: az idõparaméter 0-1 között adott felosztásban

b0 = (1-t).^2;
b1 = 2*t.*(1-t);
b2= t.^2;
for i=1:number_of_segment
x = cp(i,1)*b0 +cp(i,3)*b1 + cp(i,5)*b2;  
y = cp(i,2)*b0 +cp(i,4)*b1 + cp(i,6)*b2;
plot([cp(i,1) cp(i,3) cp(i,5)], [cp(i,2) cp(i,4) cp(i,6)],'gx','LineWidth',2)
hold on
plot(x,y,'b','LineWidth',2)
hold on
end

end
