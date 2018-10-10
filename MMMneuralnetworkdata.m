function [MMMnetInputs,MMMnetTargets] = MMMneuralnetworkdata(Delta,Beta,step)
% Function for generating training and test data for fitting 
% a neural network for the MMM generator
% Inputs generated for chosen lateral g's, chassis slip, and steer
% Function inputs become targets for network
% Fit based on weight transfer, slip angle, and longitudinal velocity
Vehicle_Initialization();
vehicle=lapsim.vehicle;

SheetFy = strcat('Fy',int2str(1));
SheetMz = strcat('Mz',int2str(1));
Fy = xlsread('TireDatabase.xls',SheetFy);
Mz = xlsread('TireDatabase.xls',SheetMz);
Fy = Fy(2:62,2:32);
Mz = Mz(2:62,2:32);

fzF = vehicle.chassis.mass.totalmass*vehicle.chassis.mass.totalmassdistribution/100;
fzR = vehicle.chassis.mass.totalmass-fzF;
SlipKeys = linspace(-15,15,61);
SlipValues = linspace(1,61,61);
SlipMap = containers.Map(SlipKeys,SlipValues);
LoadKeys = linspace(0,150,31);
LoadValues = linspace(1,31,31);
LoadMap = containers.Map(LoadKeys,LoadValues);

i = 0;
for Vx= 15:15:150
    for delta=-Delta:step:Delta 
        if Beta - delta > 0
            initialAy = 1.5;
        elseif Beta - delta < 0
            initialAy = -1.5;
        else
            initialAy = 0;
        end
        for beta=-Beta:step:Beta
          i=i+1;
         [ymdA(i),ymdN(i),aFL(i),aFR(i),aRL(i),aRR(i)] = MMMpoint(beta,delta,Vx,vehicle,Fy,Mz,initialAy);
         initialAy = ymdA(i);
         [WTF(i),WTR(i)] = WT(ymdA(i),vehicle);
         
         fzFL(i) = fzF/2 + WTF(i);
         fzFR(i) = fzF/2 -WTF(i);
         fzRL(i) = fzR/2 +WTR(i);
         fzRR(i) = fzR/2 -WTR(i);
    
         fFL(i) = cos(deg2rad(delta))*Fy(SlipMap(round(aFL(i)/.5)*.5), LoadMap(round(fzFL(i)/5)*5)) * .7;
         fFR(i) = cos(deg2rad(delta))*Fy(SlipMap(round(aFR(i)/.5)*.5), LoadMap(round(fzFR(i)/5)*5)) * .7;
         fRL(i) = Fy(SlipMap(round(aRL(i)/.5)*.5), LoadMap(round(fzRL(i)/5)*5)) * .7;
         fRR(i) = Fy(SlipMap(round(aRR(i)/.5)*.5), LoadMap(round(fzRR(i)/5)*5)) * .7;
         fF(i) = (fFL(i)+fFR(i));
         fR(i) = (fRL(i)+fRR(i));
         iFy = fF(i)+fR(i);
         AyTarget(i) = iFy/vehicle.chassis.mass.totalmass/9.81;
         NTarget(i) = (fF(i)*vehicle.chassis.mass.a-fR(i)*vehicle.chassis.mass.b)/(vehicle.chassis.mass.totalmass*vehicle.chassis.wheelbase*9.81);
         V(i) = Vx;
        end
    end
MMMnetInputs = vertcat(WTF,WTR,ymdA,V);
MMMnetTargets = vertcat(AyTarget-ymdA,NTarget-ymdN);

end