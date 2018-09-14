
function [Ay,N] = MMMpoint(beta,delta,R,vehicle,Fy,Mz)
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
Ay = 1;
AyOld = 0;
fzF = vehicle.chassis.mass.totalmass*vehicle.chassis.mass.totalmassdistribution/100;
fzR = vehicle.chassis.mass.totalmass-fzF;
fzFL = fzF/2;
fzFR = fzF/2;
fzRL = fzR/2;
fzRR = fzR/2;

AR_FrontSpring = ((vehicle.chassis.fronttrack.^2)*tan(deg2rad(1)) * vehicle.chassis.spring.FWR * 1000)/2; %Anti-roll stiffness from front spring (Nm/deg)
AR_RearSpring = ((vehicle.chassis.reartrack.^2)*tan(deg2rad(1)) * vehicle.chassis.spring.RWR * 1000)/2; %Anti-roll stiffness from rear spring (Nm/deg)

AR_FrontARB = ((vehicle.chassis.arb.fARBstiff*1000)*(vehicle.chassis.fronttrack.^2)*tan(deg2rad(1)))/(vehicle.chassis.arb.fARBMR.^2); %Anti-roll stiffness from front ARB (Nm/deg)
AR_RearARB = (vehicle.chassis.arb.rARBstiff*1000* (vehicle.chassis.reartrack.^2)*tan(deg2rad(1)))/(vehicle.chassis.arb.rARBMR.^2); %Anti-roll stiffness from rear ARB (Nm/deg)
AR_Total = AR_FrontSpring + AR_RearSpring + AR_FrontARB + AR_RearARB; %Total Anti-roll stiffness
dz = vehicle.chassis.roll.SMCGheight -(((vehicle.chassis.roll.rRCheight-vehicle.chassis.roll.fRCheight)/(vehicle.chassis.wheelbase*1000) * ((1-(vehicle.chassis.mass.totalmassdistribution/100))*(vehicle.chassis.wheelbase*1000))) + vehicle.chassis.roll.fRCheight); % Z distance from SM CG to roll axis at the SM CG

n=0;
while(abs(c-d)>.00001) %abs((Ay-AyOld)/((Ay+AyOld)/2))>.005
n=n+1;
    
[aFL aFR aRL aRR] = SACalc(beta, delta, R, Ay, vehicle);
 EWT_Fr = (Ay * vehicle.chassis.mass.susmass * dz*(AR_FrontSpring+AR_FrontARB)/AR_Total)/(vehicle.chassis.fronttrack*1000); %Elastic Weight Transfer Front
 EWT_Rr = (Ay * vehicle.chassis.mass.susmass * dz*(AR_RearSpring+AR_RearARB)/AR_Total)/(vehicle.chassis.reartrack*1000); %Elastic Weight Transfer Rear
 GWT_Fr = (vehicle.chassis.mass.susmass *vehicle.chassis.mass.totalmassdistribution/100*Ay*vehicle.chassis.roll.fRCheight)/(vehicle.chassis.fronttrack*1000); %Geometric Weight Transfer on Front
 GWT_Rr = (vehicle.chassis.mass.susmass*(1-vehicle.chassis.mass.totalmassdistribution/100)*Ay*vehicle.chassis.roll.rRCheight)/(vehicle.chassis.reartrack*1000); %Geometric Weight Transfer on Rear
 NWT_Fr = (vehicle.chassis.mass.frontnonsusmass*2)*Ay*vehicle.chassis.mass.frontnonsusmassheight/(vehicle.chassis.fronttrack*1000); %Nonsuspended weight transfer on front
 NWT_Rr = (vehicle.chassis.mass.rearnonsusmass*2)*Ay*vehicle.chassis.mass.rearnonsusmassheight/(vehicle.chassis.reartrack*1000); %Nonsuspended weight transfer on rear
 WTF = EWT_Fr + GWT_Fr + NWT_Fr; %Lateral Weight Transfer on Front 
 WTR = EWT_Rr + GWT_Rr + NWT_Rr; %Lateral Weight Transfer on Rear

%fzFL = fzF/2 + WTF;
%fzFR = fzF/2 -WTF;
%fzRL = fzR/2 +WTF;
%fzRR = fzR/2 -WTR;

AyOld = Ay;
%[fFL fFR fRL fRR]= TireReader(TireID, [aFL aFR aRL aRR], [fzFL fzFR fzRL fzRR]);

fFL = Fy(round((aFL + 15)*2) + 2, round(abs(fzFL/20)) + 1) * .7;%TireReader(TireID, aFL, fzFL);
fFR = Fy(round((aFR + 15)*2) + 2, round(abs(fzFR/20)) + 1) * .7;%TireReader(TireID, aFR, fzFR);
fRL = Fy(round((aRL + 15)*2) + 2, round(abs(fzRL/20)) + 1) * .7;%TireReader(TireID, aRL, fzRL);
fRR = Fy(round((aRR + 15)*2) + 2, round(abs(fzRR/20)) + 1) * .7;%(TireID, aRR, fzRR);

MzFL = Mz(round((aFL + 15)*2) + 2, round(abs(fzFL/20)) + 1) * .7;
MzFR = Mz(round((aFR + 15)*2) + 2, round(abs(fzFR/20)) + 1) * .7;
MzRL = Mz(round((aRL + 15)*2) + 2, round(abs(fzRL/20)) + 1) * .7 ;
MzRR = Mz(round((aRR + 15)*2) + 2, round(abs(fzRR/20)) + 1) * .7;

fF = fFL+fFR;
fR = fRL+fRR;

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
Ay = (b+a)/2;
return
end