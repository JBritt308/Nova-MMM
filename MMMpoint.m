
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



Ay = 0;
%AyOld = 0;
fzF = vehicle.chassis.mass.totalmass*vehicle.chassis.mass.totalmassdistribution/100;
fzR = vehicle.chassis.mass.totalmass-fzF;
fzFL = fzF/2;
fzFR = fzF/2;
fzRL = fzR/2;
fzRR = fzR/2;
WTF =0;
WTR = 0;
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
%[WTF,WTR]=WT(Ay,vehicle);

fzFL = fzF/2 + WTF;
fzFR = fzF/2 -WTF;
fzRL = fzR/2 +WTR;
fzRR = fzR/2 -WTR;
    
AyOld = Ay;
%[fFL fFR fRL fRR]= TireReader(TireID, [aFL aFR aRL aRR], [fzFL fzFR fzRL fzRR]);

fFL = Fy(round((aFL + 15)*2) + 2, round(abs(fzFL/20)) + 1) * .6;%TireReader(TireID, aFL, fzFL);
fFR = Fy(round((aFR + 15)*2) + 2, round(abs(fzFR/20)) + 1) * .6;%TireReader(TireID, aFR, fzFR);
fRL = Fy(round((aRL + 15)*2) + 2, round(abs(fzRL/20)) + 1) * .6;%TireReader(TireID, aRL, fzRL);
fRR = Fy(round((aRR + 15)*2) + 2, round(abs(fzRR/20)) + 1) * .6;%(TireID, aRR, fzRR);

MzFL = Mz(round((aFL + 15)*2) + 2, round(abs(fzFL/20)) + 1) * .6;
MzFR = Mz(round((aFR + 15)*2) + 2, round(abs(fzFR/20)) + 1) * .6;
MzRL = Mz(round((aRL + 15)*2) + 2, round(abs(fzRL/20)) + 1) * .6 ;
MzRR = Mz(round((aRR + 15)*2) + 2, round(abs(fzRR/20)) + 1) * .6;

fF = fFL+fFR;
fR = fRL+fRR;

iFy = fF+fR; %iFy = iterative Fy
iMz = MzFL + MzFR + MzRL + MzRR; %iterative Mz

Ay = iFy/vehicle.chassis.mass.totalmass/9.81;
N = fF*vehicle.chassis.mass.a-fR*vehicle.chassis.mass.b + iMz; %N*m

percentDiff = abs(AyOld - Ay)/((AyOld + Ay)/2);
if percentDiff < 1
    converge = true;
end
% if (Ay > AyOld)
%     a1 = AyOld;
%     b1 =Ay;
%     AyI = abs(Ay-AyOld)/2 + AyOld;
% else
%     a1 = Ay;
%     b1 = AyOld;
%     AyI = abs(Ay-AyOld)/2 + Ay;
% end
% 
% c1 = b1 - (b1-a1)/gr;
% d1 = a1 + (b1-a1)/gr;
% while(abs(c1-d1)>.000001)
%     if(abs(c1-AyI) < abs(d1-AyI))
%         b1 = d1;
%     else
%         a1 = c1;
%     end
%     c1 = b1 - (b1-a1)/gr;
%     d1 = a1 + (b1-a1)/gr;
%         
%     [aFL aFR aRL aRR] = SACalc(beta, delta, Vx, AyI, vehicle);
%     fzFL = fzF/2 + WTF;
%     fzFR = fzF/2 -WTF;
%     fzRL = fzR/2 +WTR;
%     fzRR = fzR/2 -WTR;
%     
%     fFL = Fy(round((aFL + 15)*2) + 2, round(abs(fzFL/20)) + 1) * .6;%TireReader(TireID, aFL, fzFL);
% fFR = Fy(round((aFR + 15)*2) + 2, round(abs(fzFR/20)) + 1) * .6;%TireReader(TireID, aFR, fzFR);
% fRL = Fy(round((aRL + 15)*2) + 2, round(abs(fzRL/20)) + 1) * .6;%TireReader(TireID, aRL, fzRL);
% fRR = Fy(round((aRR + 15)*2) + 2, round(abs(fzRR/20)) + 1) * .6;%(TireID, aRR, fzRR);
% 
% MzFL = Mz(round((aFL + 15)*2) + 2, round(abs(fzFL/20)) + 1) * .6;
% MzFR = Mz(round((aFR + 15)*2) + 2, round(abs(fzFR/20)) + 1) * .6;
% MzRL = Mz(round((aRL + 15)*2) + 2, round(abs(fzRL/20)) + 1) * .6 ;
% MzRR = Mz(round((aRR + 15)*2) + 2, round(abs(fzRR/20)) + 1) * .6;
% 
% fF = fFL+fFR;
% fR = fRL+fRR;
% 
% iFy = fF+fR; %iFy = iterative Fy
% iMz = MzFL + MzFR + MzRL + MzRR; %iterative Mz
% 
% AyI = iFy/vehicle.chassis.mass.totalmass/9.81;
% N = fF*vehicle.chassis.mass.a-fR*vehicle.chassis.mass.b + iMz; %N*m
% [WTF,WTR]=WT(AyI,vehicle);
%  
% end
%   Ay = (b1+a1)/2;  
% 
% if(abs(c - Ay) < abs(d - Ay))
%     b = d;
% else
%     a = c;
% end
% c = b - (b-a)/gr;
% d = a + (b-a)/gr;
% 

  
end

%Ay = (b+a)/2;
converge = false;
return
end