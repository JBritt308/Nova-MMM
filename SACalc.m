function [aFL, aFR, aRL, aRR] = SACalc(beta, delta, Vx, Ay, vehicle,AyOld)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%Vx = sqrt(Ay*R);
%Vy = Vx*beta;
%r = Vx/R;
if( Vx >= 100)
    Pr = .8;
elseif (Vx < 100 && Vx > 50)
    Pr = .5;
else
    Pr = .2;
end

[b,a] = butter(6,.6);
[d,c] = butter(6,.65/1.25);
Vx = Vx*1000/3600;
r_Old = (AyOld*9.81)/Vx;


r = (1-Pr)*((Ay*9.81)/Vx) + (Pr)*r_Old;

if Vx*3600/1000 > 50 && Vx*3600/1000 <= 100
    r = filter(b,a,r);
elseif Vx*3600/1000 <= 50
    r = filter(d,c,r);
end

Vy = Vx * tan(deg2rad(beta)); 

R = Vx/r;

a=vehicle.chassis.mass.a;
b=vehicle.chassis.mass.b;
Tf = vehicle.chassis.fronttrack;
Tr = vehicle.chassis.reartrack; 
ackermann = atan(vehicle.chassis.wheelbase/R);

aFL = rad2deg((Vy+r*a)/(Vx-r*Tf/2)-deg2rad(delta) ) ;
aFR = rad2deg((Vy+r*a)/(Vx+r*Tf/2)-deg2rad(delta)) ;
aRR = rad2deg((Vy-r*b)/(Vx+r*Tr/2));
aRL = rad2deg((Vy-r*b)/(Vx-r*Tr/2));

return
end

