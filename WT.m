function [WTF,WTR] = WT(Ay,vehicle)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

EWT_Fr = (Ay * vehicle.chassis.mass.susmass * vehicle.chassis.roll.dz*(vehicle.chassis.roll.AR_FrontSpring+vehicle.chassis.roll.AR_FrontARB)/vehicle.chassis.roll.AR_Total)/(vehicle.chassis.fronttrack*1000); %Elastic Weight Transfer Front
 EWT_Rr = (Ay * vehicle.chassis.mass.susmass * vehicle.chassis.roll.dz*(vehicle.chassis.roll.AR_RearSpring+vehicle.chassis.roll.AR_RearARB)/vehicle.chassis.roll.AR_Total)/(vehicle.chassis.reartrack*1000); %Elastic Weight Transfer Rear
 GWT_Fr = (vehicle.chassis.mass.susmass *vehicle.chassis.mass.totalmassdistribution/100*Ay*vehicle.chassis.roll.fRCheight)/(vehicle.chassis.fronttrack*1000); %Geometric Weight Transfer on Front
 GWT_Rr = (vehicle.chassis.mass.susmass*(1-vehicle.chassis.mass.totalmassdistribution/100)*Ay*vehicle.chassis.roll.rRCheight)/(vehicle.chassis.reartrack*1000); %Geometric Weight Transfer on Rear
 NWT_Fr = (vehicle.chassis.mass.frontnonsusmass*2)*Ay*vehicle.chassis.mass.frontnonsusmassheight/(vehicle.chassis.fronttrack*1000); %Nonsuspended weight transfer on front
 NWT_Rr = (vehicle.chassis.mass.rearnonsusmass*2)*Ay*vehicle.chassis.mass.rearnonsusmassheight/(vehicle.chassis.reartrack*1000); %Nonsuspended weight transfer on rear
 WTF = EWT_Fr + GWT_Fr + NWT_Fr; %Lateral Weight Transfer on Front 
 WTR = EWT_Rr + GWT_Rr + NWT_Rr; %Lateral Weight Transfer on Rear

end

