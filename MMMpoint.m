
function [Ay,N] = MMMpoint(beta,delta,Vx,vehicle,Fy,Mz,initialAy)

%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

gr = (sqrt(5)+1)/2;
a = -3;
b = 3;
c = b - (b-a)/gr;
d = a + (b-a)/gr;


Ay = initialAy;
AyOld = 0;

fzF = vehicle.chassis.mass.totalmass*vehicle.chassis.mass.totalmassdistribution/100;
fzR = vehicle.chassis.mass.totalmass-fzF;
fzFL = fzF/2;
fzFR = fzF/2;
fzRL = fzR/2;
fzRR = fzR/2;

scale = .7;
WTF =0;
WTR =0;
n=0;

while (abs(c-d)>.01)
n=n+1;
 
[aFL aFR aRL aRR] = SACalc(beta, delta, Vx, Ay, vehicle,AyOld);
AyOld = Ay;
 
SlipKeys = linspace(-15,15,61);
SlipValues = linspace(1,61,61);
SlipMap = containers.Map(SlipKeys,SlipValues);
LoadKeys = linspace(0,150,31);
LoadValues = linspace(1,31,31);
LoadMap = containers.Map(LoadKeys,LoadValues);

if aFL > 15 || aFL < -15
    aFL
    aFL = (aFL/abs(aFL))*15;
end
if  aFR > 15 || aFR < -15
    aFR
    aFR = (aFR/abs(aFR))*15;
end
if  aRL > 15 || aRL < -15
    aRL
    aRL = (aRL/abs(aRL))*15;
end
if  aRR > 15 || aRR < -15
    aRR
    aRR = (aRR/abs(aRR))*15;
end

fFL = cos(deg2rad(delta))*Fy(SlipMap(round(aFL/.5)*.5), LoadMap(round(fzFL/5)*5)) * scale;
fFR = cos(deg2rad(delta))*Fy(SlipMap(round(aFR/.5)*.5), LoadMap(round(fzFR/5)*5)) * scale;
fRL = Fy(SlipMap(round(aRL/.5)*.5), LoadMap(round(fzRL/5)*5)) * scale;
fRR = Fy(SlipMap(round(aRR/.5)*.5), LoadMap(round(fzRR/5)*5)) * scale;

MzFL = cos(deg2rad(delta))*Mz(SlipMap(round(aFL/.5)*.5), LoadMap(round(fzFL/5)*5)) * scale;
MzFR = cos(deg2rad(delta))*Mz(SlipMap(round(aFR/.5)*.5), LoadMap(round(fzFR/20)*5)) * scale;
MzRL = Mz(SlipMap(round(aRL/.5)*.5), LoadMap(round(fzRL/5)*5)) * scale;
MzRR = Mz(SlipMap(round(aRR/.5)*.5), LoadMap(round(fzRR/5)*5)) * scale;

fF = (fFL+fFR);
fR = (fRL+fRR);

iFy = fF+fR; %iFy = iterative Fy
iMz = MzFL + MzFR + MzRL + MzRR; %iterative Mz

Ay = iFy/vehicle.chassis.mass.totalmass/9.81;
N = (fF*vehicle.chassis.mass.a-fR*vehicle.chassis.mass.b + iMz)/(vehicle.chassis.mass.totalmass*vehicle.chassis.wheelbase*9.81); %N*m

if(abs(c - Ay) < abs(d - Ay))
    b = d;
else
    a = c;


end
c = b - (b-a)/gr;
d = a + (b-a)/gr;

end
[WTF,WTR]=WT(Ay,vehicle);
a0 = .002573;
a1 = -.00651;
b1 = -.1745;
a2 = .003365;
b2 = .1065;
w = .03591;
fuck1 = a0 + a1*cos(WTF*w) + b1*sin(WTF*w) + a2*cos(2*WTF*w) + b2*sin(2*WTF*w);
A0 = .003415;
A1 = -.007895;
B1 = -.1723;
A2 = .003952;
B2 = .1057;
W = .0314;
fuck2 = A0 + A1*cos(WTR*W) + B1*sin(WTR*W) + A2*cos(2*WTR*W) + B2*sin(2*WTR*W);
 Ay = AyOld + fuck1/2 + fuck2/2;
c0 = -.01707;
c1 = .02682;
d1 = .0473;
c2 = -.0104;
d2 = -.01634;
w2 = .02714;
fuckme1 = c0 + c1*cos(WTF*w2) + d1*sin(WTF*w2) + c2*cos(2*WTF*w2) + d2*sin(2*WTF*w2);
W2 = .02397;
fuckme2 = c0 + c1*cos(WTR*W2) + d1*sin(WTR*W2) + c2*cos(2*WTR*W2) + d2*sin(2*WTR*W2);
fuckme = fuckme1/2 + fuckme2/2;
if vehicle.chassis.mass.totalmassdistribution > 50
    N = N +fuckme;
elseif vehicle.chassis.mass.totalmassdistribution < 50
    N = N - fuckme;
end
return
end