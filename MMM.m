
function MMM(R,TireID)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
Vehicle_Initialization();

SheetFy = strcat('Fy',int2str(TireID));
SheetMz = strcat('Mz',int2str(TireID));
Fy = xlsread('TireDatabase.xls',SheetFy);
Mz = xlsread('TireDatabase.xls',SheetMz);


vehicle=lapsim.vehicle;
i=0;
for beta=-7:.5:7
    
    for delta=-7:.5:7
        i=i+1;
        [ymdA(i),ymdN(i)] = MMMpoint(beta,delta,R,vehicle,Fy,Mz);
    end
end
scatter(ymdA,ymdN,10,'filled')
axis([-3 3 -5000 5000])
grid on

max(abs(ymdA))
max(abs(ymdN))
end

