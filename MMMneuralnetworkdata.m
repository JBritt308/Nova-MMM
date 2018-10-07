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
Fy = Fy(2:62,2:11);
Mz = Mz(2:62,2:11);

fzF = vehicle.chassis.mass.totalmass*vehicle.chassis.mass.totalmassdistribution/100;
fzR = vehicle.chassis.mass.totalmass-fzF;
SlipKeys = linspace(-15,15,61);
SlipValues = linspace(1,61,61);
SlipMap = containers.Map(SlipKeys,SlipValues);
LoadKeys = linspace(20,200,10);
LoadValues = linspace(1,10,10);
LoadMap = containers.Map(LoadKeys,LoadValues);

i = 0;
for Vx= 15:15:150
    for delta=-Delta:step:Delta
        initialAy = 0;
        for beta=-Beta:step:Beta
          i=i+1;
         [ymdA(i),ymdN(i),aFL(i),aFR(i),aRL(i),aRR(i)] = MMMpoint(beta,delta,Vx,vehicle,Fy,Mz,initialAy);
         initialAy = ymdA(i);
         [WTF(i),WTR(i)] = WT(ymdA(i),vehicle);
         
         fzFL = fzF/2 + WTF(i);
         fzFR = fzF/2 -WTF(i);
         fzRL = fzR/2 +WTF(i);
         fzRR = fzR/2 -WTR(i);
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
         
         fFL = cos(deg2rad(delta))*Fy(SlipMap(round(aFL(i)/.5)*.5), LoadMap(round(fzFL/20)*20)) * .7;
         fFR = cos(deg2rad(delta))*Fy(SlipMap(round(aFR(i)/.5)*.5), LoadMap(round(fzFR/20)*20)) * .7;
         fRL = Fy(SlipMap(round(aRL(i)/.5)*.5), LoadMap(round(fzRL/20)*20)) * .7;
         fRR = Fy(SlipMap(round(aRR(i)/.5)*.5), LoadMap(round(fzRR/20)*20)) * .7;
         fF = (fFL+fFR);
         fR = (fRL+fRR);
         iFy = fF+fR;
         AyTarget(i) = iFy/vehicle.chassis.mass.totalmass/9.81;
        end
    end
end
MMMnetInputs = vertcat(WTF,WTR,aFL,aFR,aRL,aRR);
MMMnetTargets = AyTarget;


end