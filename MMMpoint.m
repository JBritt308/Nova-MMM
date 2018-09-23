
function [Ay,N] = MMMpoint(beta,delta,Vx,vehicle,Fy,Mz)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% SheetFy = strcat('Fy',int2str(TireID));
% SheetMz = strcat('Mz',int2str(TireID));
% Fy = xlsread('TireDatabase.xls',SheetFy);
% Mz = xlsread('TireDatabase.xls',SheetMz);


gr = (sqrt(5)+1)/2;
a = -3;
b = 3;
c = b - (b-a)/gr;
d = a + (b-a)/gr;


Ay = 0.60;
%AyOld = 0;
fzF = vehicle.chassis.mass.totalmass*vehicle.chassis.mass.totalmassdistribution/100;
fzR = vehicle.chassis.mass.totalmass-fzF;
fzFL = fzF/2;
fzFR = fzF/2;
fzRL = fzR/2;
fzRR = fzR/2;

% AR_FrontSpring = ((vehicle.chassis.fronttrack.^2)*tan(deg2rad(1)) * vehicle.chassis.spring.FWR * 1000)/2; %Anti-roll stiffness from front spring (Nm/deg)
% AR_RearSpring = ((vehicle.chassis.reartrack.^2)*tan(deg2rad(1)) * vehicle.chassis.spring.RWR * 1000)/2; %Anti-roll stiffness from rear spring (Nm/deg)
% 
% AR_FrontARB = ((vehicle.chassis.arb.fARBstiff*1000)*(vehicle.chassis.fronttrack.^2)*tan(deg2rad(1)))/(vehicle.chassis.arb.fARBMR.^2); %Anti-roll stiffness from front ARB (Nm/deg)
% AR_RearARB = (vehicle.chassis.arb.rARBstiff*1000* (vehicle.chassis.reartrack.^2)*tan(deg2rad(1)))/(vehicle.chassis.arb.rARBMR.^2); %Anti-roll stiffness from rear ARB (Nm/deg)
% AR_Total = AR_FrontSpring + AR_RearSpring + AR_FrontARB + AR_RearARB; %Total Anti-roll stiffness
% dz = vehicle.chassis.roll.SMCGheight -(((vehicle.chassis.roll.rRCheight-vehicle.chassis.roll.fRCheight)/(vehicle.chassis.wheelbase*1000) * ((1-(vehicle.chassis.mass.totalmassdistribution/100))*(vehicle.chassis.wheelbase*1000))) + vehicle.chassis.roll.fRCheight); % Z distance from SM CG to roll axis at the SM CG

n=0;
converge = false;

while (converge == false)
n=n+1;
    
[aFL aFR aRL aRR] = SACalc(beta, delta, Vx, Ay, vehicle);

[WTF,WTR]=WT(Ay,vehicle);

 fzFL = fzF/2 + WTF;
 fzFR = fzF/2 -WTF;
 fzRL = fzR/2 +WTF;
 fzRR = fzR/2 -WTR;

AyOld = Ay;
%[fFL fFR fRL fRR]= TireReader(TireID, [aFL aFR aRL aRR], [fzFL fzFR fzRL fzRR]);

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

fFL = Fy(SlipMap(round(aFL/.5)*.5), LoadMap(round(fzFL/20)*20)) * .7;%TireReader(TireID, aFL, fzFL);
fFR = Fy(SlipMap(round(aFR/.5)*.5), LoadMap(round(fzFR/20)*20)) * .7;%TireReader(TireID, aFR, fzFR);
fRL = Fy(SlipMap(round(aRL/.5)*.5), LoadMap(round(fzRL/20)*20)) * .7;%TireReader(TireID, aRL, fzRL);
fRR = Fy(SlipMap(round(aRR/.5)*.5), LoadMap(round(fzRR/20)*20)) * .7;%(TireID, aRR, fzRR);

MzFL = Mz(SlipMap(round(aFL/.5)*.5), LoadMap(round(fzFL/20)*20)) * .7;
MzFR = Mz(SlipMap(round(aFR/.5)*.5), LoadMap(round(fzFR/20)*20)) * .7;
MzRL = Mz(SlipMap(round(aRL/.5)*.5), LoadMap(round(fzRL/20)*20)) * .7 ;
MzRR = Mz(SlipMap(round(aRR/.5)*.5), LoadMap(round(fzRR/20)*20)) * .7;

fF = fFL+fFR;
fR = fRL+fRR;

iFy = fF+fR; %iFy = iterative Fy
iMz = MzFL + MzFR + MzRL + MzRR; %iterative Mz

Ay = iFy/vehicle.chassis.mass.totalmass/9.81;
N = fF*vehicle.chassis.mass.a-fR*vehicle.chassis.mass.b + iMz; %N*m

per_diff = abs(AyOld-Ay)/((AyOld+Ay)/2);
if per_diff < 1
    converge = true;
end

if(abs(c - Ay) < abs(d - Ay))
    b = d;
else
    a = c;
end
c = b - (b-a)/gr;
d = a + (b-a)/gr;


    %Ay = (b+a)/2;
%  [A,B]=WT(Ay,vehicle)
% if(abs(sum([WTF,WTR]))-abs(sum([A,B]))>2)
%      abs(sum([WTF,WTR]))-abs(sum([A,B]))
%  end
end

%Ay = (b+a)/2;
converge = false;
return
end