
set(0,'DefaultFigureWindowStyle','docked')


lapsim.plotpooper=false;

%% 1. Chassis Initialization

% Structural
chassis.wheelbase= 1.524; % [m]
chassis.fronttrack = 1.2192; % [m]
chassis.reartrack = 1.1684; % [m]


% Mass Distribution
chassis.mass.totalmass = 275; % [kg]
chassis.mass.totalmassdistribution = 45; % [%] weight on front tires
chassis.mass.frontnonsusmass = 12; % [kg] front non suspended mass per wheel
chassis.mass.rearnonsusmass = 13; % [kg] rear non suspended mass per wheel
chassis.mass.susmass = chassis.mass.totalmass - 2*chassis.mass.frontnonsusmass - 2*chassis.mass.rearnonsusmass;


chassis.mass.a = chassis.wheelbase*chassis.mass.totalmassdistribution/100;
chassis.mass.b = chassis.wheelbase*(100-chassis.mass.totalmassdistribution)/100;

chassis.mass.cg = 294; % [mm] total mass cg height
chassis.mass.frontnonsusmassheight = 260; % [mm] front non suspended mass height
chassis.mass.rearnonsusmassheight = 260; % [mm] rear non suspended mass height

chassis.mass.susmassrollinertia = 200; % [kg.m^2] suspended mass roll inertia (ref SM CG - Ixx)

% Spring & ARB stiffnesses
chassis.spring.fspringstiff = 26.3; % [N/mm] front spring stiffness
chassis.spring.rspringstiff = 35.03; % [N/mm] rear spring stiffness
chassis.arb.fARBstiff = 19.27; % [N/mm]
chassis.arb.rARBstiff = 19.91; % [N/mm]

% Motion Ratios
chassis.spring.fspringMR = 1.25; % [mm/mm] front spring motion ratio
chassis.spring.rspringMR = 1.3; % [mm/mm] rear spring motion ratio
chassis.arb.fARBMR = 2.250; % [mm/mm]
chassis.arb.rARBMR = 2.250; % [mm/mm]
chassis.spring.FWR = 20.661; %Front Wheel Rate (N/mm)
chassis.spring.RWR = 22.727; %Rear Wheel Rate (N/mm)
% Roll
chassis.roll.fRCheight = 15; % [mm] front roll center height
chassis.roll.rRCheight = 40; % [mm] rear roll center height
chassis.roll.SMCGheight = 282.76;
% Aerodynamics
chassis.aero.DFcoeff = 0; % [] down force coefficient
chassis.aero.DFdist = 45; % [%] front down force distribution
chassis.aero.airdensity = 1.2255; % [kg/m^3] 
chassis.aero.frontalarea = 1.75; % [m^2]
chassis.aero.aerospeed = 187.2; % [km/h] vehicle speed for aero calcs
chassis.aero.Cd = 0.3;  %  [] drag coefficient

% Tire
chassis.tire.tireR=0.2286; %[m] tire radius
chassis.tire.rollingresistance=0.015; %[] coefficient of rolling resistance
chassis.tire.ftirestiff = 120; % [N/mm]
chassis.tire.rtirestiff = 120; % [N/mm]
% load(strcat(pwd,'\mat files\','tiredata.mat'));
% chassis.tire.Fypos=tiredata.Fypos;
% chassis.tire.Fxpos=tiredata.Fxpos;
% chassis.tire.Fyneg=tiredata.Fyneg;
% chassis.tire.Fxneg=tiredata.Fxneg;
% chassis.tire.Fzdata=tiredata.Fzdata;
lapsim.vehicle.chassis=chassis;
clear chassis %tiredata
