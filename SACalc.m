function [aFL, aFR, aRL, aRR] = SACalc(beta, delta, R, Ay, vehicle)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Vx = sqrt(Ay*R);
Vy = Vx*beta;
r = Vx/R;

a=vehicle.chassis.mass.a;
b=vehicle.chassis.mass.b;
Tf = vehicle.chassis.fronttrack;
Tr = vehicle.chassis.reartrack; 

aFL = (Vy+r*a)/(Vx-r*Tf/2)-delta;
aFR = (Vy+r*a)/(Vx+r*Tf/2)-delta;
aRR = (Vy-r*b)/(Vx+r*Tr/2);
aRL = (Vy-r*b)/(Vx-r*Tr/2);

return
end

