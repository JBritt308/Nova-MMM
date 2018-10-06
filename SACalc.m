function [aFL, aFR, aRL, aRR] = SACalc(beta, delta, Vx, Ay, vehicle,AyOld)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%Vx = sqrt(Ay*R);
%Vy = Vx*beta;
%r = Vx/R;
if( Vx > 100)
    Pr = .8;
elseif (Vx <= 100 && Vx > 50)
    Pr = .5;
else
    Pr = .25;
end

[b,a] = butter(6,.35/.5);
[d,c] = butter(6,.65/1.25);
Vx = Vx*1000/3600;
r_Old = (AyOld*9.81)/Vx;

if AyOld == 0
    r = 0;
else
    r = (1-Pr)*((Ay*9.81)/Vx) + (Pr)*r_Old;
end
if Vx > 50
    r = filter(b,a,r);
else
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
% 
% aFL = rad2deg(deg2rad(beta) + a/R - deg2rad(delta));
% aFR = aFL;
% aRR = rad2deg(deg2rad(beta) - b/R);
% aRL = aRR;
return
end

