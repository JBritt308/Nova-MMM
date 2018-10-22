
function [balance] = MMM(Vx,TireID,plotter)
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
xlabel('Lateral Acceleration (g)');
ylabel('Yaw Coefficient');
title(['Milliken Moment Diagram for ',int2str(Vx),' mph']);

for i=-7:1:7 %Calculate Stability&Control
cindex=find(YMD(:,1)==i); %Form Control index for beta=i
sindex=find(YMD(:,2)==i); %Form Stability index for delta=i

YMD(cindex(1),6)=YMD(cindex(2),4)-YMD(cindex(1),4);
YMD(sindex(1),5)=YMD(sindex(2),4)-YMD(sindex(1),4);

for j=2:1:(size(cindex,1)-1)
YMD(cindex(j),6)=(YMD(cindex(j),4)-YMD(cindex(j-1),4)+YMD(cindex(j+1),4)-YMD(cindex(j),4))/2;
YMD(sindex(j),5)=(YMD(sindex(j),4)-YMD(sindex(j-1),4)+YMD(sindex(j+1),4)-YMD(sindex(j),4))/2;
end

YMD(cindex(size(cindex,1)),6)=YMD(cindex(size(cindex,1)),4)-YMD(cindex(size(cindex,1)-1),4);
YMD(sindex(size(sindex,1)),5)=YMD(sindex(size(sindex,1)),4)-YMD(sindex(size(sindex,1)-1),4);

end

lbalance = YMD(find(YMD(:,3)==max(YMD(:,3))),4);
rbalance = YMD(find(YMD(:,3)==min(YMD(:,3))),4);

balance = (abs(rbalance)+abs(lbalance))/2*sign(lbalance)

if plotter == true
    
    i = 0;
for beta=x:step:y %Assemble beta-iterative array
  index = find(YMD(:,1)==beta);
  j=0;
    for delta=x:step:y
        i=i+1;
        j=j+1;
            ymdA2(i) = YMD(index(j),3);
            ymdN2(i) = YMD(index(j),4);
    end 
end

for y=1:1:15
    xspline = YMD(1 + (y-1)*15:15 + (y-1)*15,3);
    yspline = YMD(1 + (y-1)*15:15 + (y-1)*15,4);
    xx = linspace(min(xspline),max(xspline),100);
    pp = spline(xspline,yspline);
    yy = ppval(pp,xx);
    
    figure(2);
    plot(xx,yy,'blue');
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
    plot(xx,yy,'red');
    L = findobj(2,'type','line');
    copyobj(L,findobj(1,'type','axes'));
    close(2);
end

figure(3);
xspline = YMD(1+7*15:15+7*15,3);
yspline = YMD(1+7*15:15+7*15,5);
xx = linspace(min(xspline),max(xspline),100);
pp2 = spline(xspline,yspline);
yy = ppval(pp2,xx);
plot(xx,yy);
xlabel('Lateral Acceleration (g)');
ylabel('Stability (dN/dD)');
title('Stability thru Origin');

figure(4);
yspline = YMD(1+7*15:15+7*15,6);
xx = linspace(min(xspline),max(xspline),100);
pp2 = spline(xspline,yspline);
yy = ppval(pp2,xx);
plot(xx,yy);
xlabel('Lateral Acceleration (g)');
ylabel('Control (dN/dB)');
title('Control thru Origin');
end

end

