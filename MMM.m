
function MMM(Vx,TireID,plotter)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

Vehicle_Initialization();

SheetFy = strcat('Fy',int2str(TireID));
SheetMz = strcat('Mz',int2str(TireID));
Fy = xlsread('TireDatabase.xls',SheetFy);
Mz = xlsread('TireDatabase.xls',SheetMz);
Fy = Fy(2:62,2:32);
Mz = Mz(2:62,2:32);

vehicle=lapsim.vehicle;
i=0;
x = -7;
y = 7;
step =1;

initialAy = 0;
for delta=x:step:y
    initialAy = 0;
    for beta=x:step:y
        i=i+1;
        [ymdA(i),ymdN(i)] = MMMpoint(beta,delta,Vx,vehicle,Fy,Mz,initialAy);
        YMD(i,:) = [beta delta ymdA(i) ymdN(i)] ;
        initialAy = ymdA(i);
    end
end

s = size(YMD);
d = step*(y+x) + 1;
color = linspace(1,10,s(1)/d);
colorMat = zeros(0);
for t = 1:1:s(1)/d
    colorMat = horzcat(colorMat,color(t)*ones(d));
end

scatter(ymdA,ymdN,10,colorMat,'filled')
axis([-3 3 -1 1])
grid on

%max(abs(ymdA))
%max(abs(ymdN))
if plotter == true
i = 0;
for beta=x:step:y
    initialAy = 0;
    for delta=x:step:y
        i=i+1;
        [ymdA2(i),ymdN2(i)] = MMMpoint(beta,delta,Vx,vehicle,Fy,Mz,initialAy);
        initialAy = ymdA2(i);
    end
end


for y=1:1:15
    xspline = YMD(1 + (y-1)*15:15 + (y-1)*15,3);
    yspline = YMD(1 + (y-1)*15:15 + (y-1)*15,4);
    xx = linspace(min(xspline),max(xspline),100);
    pp = spline(xspline,yspline);
    yy = ppval(pp,xx);
    
    figure(2);
    plot(xspline,yspline,xx,yy);
    L = findobj(2,'type','line');
    copyobj(L,findobj(1,'type','axes'));
    close(2);
    %length(ymdA)
end

for z=1:1:15
    xspline = ymdA2(1 + (z-1)*15:15 + (z-1)*15);
    yspline = ymdN2(1 + (z-1)*15:15 + (z-1)*15);
    xx = linspace(min(xspline),max(xspline),100);
    pp2 = spline(xspline,yspline);
    yy = ppval(pp2,xx);
    
    figure(2);
    plot(xspline,yspline,xx,yy);
    L = findobj(2,'type','line');
    copyobj(L,findobj(1,'type','axes'));
    close(2);
end
end

end

