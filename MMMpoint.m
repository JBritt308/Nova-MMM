
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
%[WTF,WTR]=WT(Ay,vehicle);

 fzFL = fzF/2 + WTF;
 fzFR = fzF/2 -WTF;
 fzRL = fzR/2 +WTF;
 fzRR = fzR/2 -WTR;

AyOld = Ay;

SlipKeys = linspace(-15,15,61);
SlipValues = linspace(1,61,61);
SlipMap = containers.Map(SlipKeys,SlipValues);
LoadKeys = linspace(20,200,10);
LoadValues = linspace(1,10,10);
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

if  fzFL < 20
    fzFL = 20;
end
if  fzFR < 20
    fzFR = 20;
end
if  fzRL < 20
    fzRL = 20;
end
if  fzRR < 20
    fzRR = 20;
end
fFL = cos(deg2rad(delta))*Fy(SlipMap(round(aFL/.5)*.5), LoadMap(round(fzFL/20)*20)) * scale;%TireReader(TireID, aFL, fzFL);
fFR = cos(deg2rad(delta))*Fy(SlipMap(round(aFR/.5)*.5), LoadMap(round(fzFR/20)*20)) * scale;%TireReader(TireID, aFR, fzFR);
fRL = Fy(SlipMap(round(aRL/.5)*.5), LoadMap(round(fzRL/20)*20)) * scale;%TireReader(TireID, aRL, fzRL);
fRR = Fy(SlipMap(round(aRR/.5)*.5), LoadMap(round(fzRR/20)*20)) * scale;%(TireID, aRR, fzRR);

MzFL = cos(deg2rad(delta))*Mz(SlipMap(round(aFL/.5)*.5), LoadMap(round(fzFL/20)*20)) * scale;
MzFR = cos(deg2rad(delta))*Mz(SlipMap(round(aFR/.5)*.5), LoadMap(round(fzFR/20)*20)) * scale;
MzRL = Mz(SlipMap(round(aRL/.5)*.5), LoadMap(round(fzRL/20)*20)) * scale;
MzRR = Mz(SlipMap(round(aRR/.5)*.5), LoadMap(round(fzRR/20)*20)) * scale;

fF = (fFL+fFR);
fR = (fRL+fRR);

iFy = fF+fR; %iFy = iterative Fy
iMz = MzFL + MzFR + MzRL + MzRR; %iterative Mz

Ay = iFy/vehicle.chassis.mass.totalmass/9.81;
N = fF*vehicle.chassis.mass.a-fR*vehicle.chassis.mass.b + iMz; %N*m

if(abs(c - Ay) < abs(d - Ay))
    b = d;
else
    a = c;
end
c = b - (b-a)/gr;
d = a + (b-a)/gr;

end

return
end