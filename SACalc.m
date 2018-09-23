function [aFL, aFR, aRL, aRR] = SACalc(beta, delta, Vx, Ay, vehicle)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%Vx = sqrt(Ay*R);
%Vy = Vx*beta;
%r = Vx/R;
Vx = Vx*1000/3600;
r = (Ay*9.81)/Vx;
Vy = Vx * deg2rad(beta); 
R = Vx/r;


a=vehicle.chassis.mass.a;
b=vehicle.chassis.mass.b;
Tf = vehicle.chassis.fronttrack;
Tr = vehicle.chassis.reartrack; 

aFL = rad2deg((Vy+r*a)/(Vx-r*Tf/2)-deg2rad(delta));
aFR = rad2deg((Vy+r*a)/(Vx+r*Tf/2)-deg2rad(delta));
aRR = rad2deg((Vy-r*b)/(Vx+r*Tr/2));
aRL = rad2deg((Vy-r*b)/(Vx-r*Tr/2));

return
end

