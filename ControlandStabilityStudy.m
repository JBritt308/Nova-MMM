% Stability and balance study
% Looking at the effect of springs, tires, tire pressure, ARB stiffness 
% Start by varying independently then establish matrix
% Intend to use matrix entries on testing days to verify results

% Possibly entries to follow
% Tires - See Tire Database
% Tire Pressure - 8,12,14
% ARB Front Stiffnesses - 0,21.1, 29.33
% ARB Rear Stiffnesses - 0,19.65,27.34
% Spring Stiffnesses - 65,55,50,45,40,35,30,27.5,25,20

%% Comparison of Tire Pressure Effects
% Only Comparing 8 psi with lightly worn 12 psi tires of same make
[YMD1,balance1] = MMM(50,1,false);
[YMD2,balance2] = MMM(50,2,false);
[YMD3,balance3] = MMM(50,5,false);
[YMD4,balance4] = MMM(50,4,false);
close all;
Vehicle_Initialization();
vehicle = lapsim.vehicle;

figure(1);
xspline1 = YMD1(1+7*15:15+7*15,3);
yspline1 = YMD1(1+7*15:15+7*15,5);
xx1 = linspace(min(xspline1),max(xspline1),100);
pp1 = spline(xspline1,yspline1);
yy1 = ppval(pp1,xx1);

xspline2 = YMD2(1+7*15:15+7*15,3);
yspline2 = YMD2(1+7*15:15+7*15,5);
xx2 = linspace(min(xspline2),max(xspline2),100);
pp2 = spline(xspline2,yspline2);
yy2 = ppval(pp2,xx2);

plot(xx1,yy1,xx2,yy2);
xlabel('Lateral Acceleration (g)');
ylabel('Stability (dN/d\beta)');
title('Stability thru Origin for Hoosier 16x7.5-10 R25b');
legend('8 psi','12 psi')

figure(2);
xspline1 = YMD1(1+7*15:15+7*15,3);
yspline1 = YMD1(1+7*15:15+7*15,6);
xx1 = linspace(min(xspline1),max(xspline1),100);
pp1 = spline(xspline1,yspline1);
yy1 = ppval(pp1,xx1);

xspline2 = YMD2(1+7*15:15+7*15,3);
yspline2 = YMD2(1+7*15:15+7*15,6);
xx2 = linspace(min(xspline2),max(xspline2),100);
pp2 = spline(xspline2,yspline2);
yy2 = ppval(pp2,xx2);

plot(xx1,yy1,xx2,yy2);
xlabel('Lateral Acceleration (g)');
ylabel('Control (dN/d\alpha)');
title('Control thru Origin for Hoosier 16x7.5-10 R25b');
legend('8 psi','12 psi')

fprintf('The difference between 8 and 12 psi in balance is %2.2f Nm \n',(abs(balance1)-abs(balance2))*(vehicle.chassis.mass.totalmass*vehicle.chassis.wheelbase*9.81))

%% Different Tires
% LCO vs R25b
figure(3);
xspline1 = YMD1(1+7*15:15+7*15,3);
yspline1 = YMD1(1+7*15:15+7*15,5);
xx1 = linspace(min(xspline1),max(xspline1),100);
pp1 = spline(xspline1,yspline1);
yy1 = ppval(pp1,xx1);

xspline2 = YMD3(1+7*15:15+7*15,3);
yspline2 = YMD3(1+7*15:15+7*15,5);
xx2 = linspace(min(xspline2),max(xspline2),100);
pp2 = spline(xspline2,yspline2);
yy2 = ppval(pp2,xx2);

plot(xx1,yy1,xx2,yy2);
xlabel('Lateral Acceleration (g)');
ylabel('Stability (dN/d\beta)');
title('Stability thru Origin for Hoosier 16x7.5-10');
legend('R25b','LCO')

figure(4);
xspline1 = YMD1(1+7*15:15+7*15,3);
yspline1 = YMD1(1+7*15:15+7*15,6);
xx1 = linspace(min(xspline1),max(xspline1),100);
pp1 = spline(xspline1,yspline1);
yy1 = ppval(pp1,xx1);

xspline2 = YMD3(1+7*15:15+7*15,3);
yspline2 = YMD3(1+7*15:15+7*15,6);
xx2 = linspace(min(xspline2),max(xspline2),100);
pp2 = spline(xspline2,yspline2);
yy2 = ppval(pp2,xx2);

plot(xx1,yy1,xx2,yy2);
xlabel('Lateral Acceleration (g)');
ylabel('Control (dN/d\alpha)');
title('Control thru Origin for Hoosier 16x7.5-10');
legend('R25b','LCO')

fprintf('The difference between R25b and LCO in balance is %2.2f Nm\n',(abs(balance1)-abs(balance3))*(vehicle.chassis.mass.totalmass*vehicle.chassis.wheelbase*9.81))

% 16" vs 18"
figure(5);
xspline1 = YMD1(1+7*15:15+7*15,3);
yspline1 = YMD1(1+7*15:15+7*15,5);
xx1 = linspace(min(xspline1),max(xspline1),100);
pp1 = spline(xspline1,yspline1);
yy1 = ppval(pp1,xx1);

xspline2 = YMD4(1+7*15:15+7*15,3);
yspline2 = YMD4(1+7*15:15+7*15,5);
xx2 = linspace(min(xspline2),max(xspline2),100);
pp2 = spline(xspline2,yspline2);
yy2 = ppval(pp2,xx2);

plot(xx1,yy1,xx2,yy2);
xlabel('Lateral Acceleration (g)');
ylabel('Stability (dN/d\beta)');
title('Stability thru Origin for Hoosier R25b');
legend('16"','18"')

figure(6);
xspline1 = YMD1(1+7*15:15+7*15,3);
yspline1 = YMD1(1+7*15:15+7*15,6);
xx1 = linspace(min(xspline1),max(xspline1),100);
pp1 = spline(xspline1,yspline1);
yy1 = ppval(pp1,xx1);

xspline2 = YMD4(1+7*15:15+7*15,3);
yspline2 = YMD4(1+7*15:15+7*15,6);
xx2 = linspace(min(xspline2),max(xspline2),100);
pp2 = spline(xspline2,yspline2);
yy2 = ppval(pp2,xx2);

plot(xx1,yy1,xx2,yy2);
xlabel('Lateral Acceleration (g)');
ylabel('Control (dN/d\alpha)');
title('Control thru Origin for Hoosier R25b');
legend('16"','18"')

fprintf('The difference between 16\" and 18\" in balance is %2.2f Nm \n',(abs(balance1)-abs(balance4))*(vehicle.chassis.mass.totalmass*vehicle.chassis.wheelbase*9.81))