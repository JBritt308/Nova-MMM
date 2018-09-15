
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
x = -7;
y = 7;
step =.5;
for beta=x:step:y
    
    for delta=x:step:y
        i=i+1;
        [ymdA(i),ymdN(i)] = MMMpoint(beta,delta,R,vehicle,Fy,Mz);
        YMD(i,:) = [beta delta ymdA(i) ymdN(i)] ;
    end
end
s = size(YMD);
d = step*(x+y) + 1;
color = linspace(1,10,s(1)/d);
colorMat = zeros(0);
for t = 1:1:s(1)/d
    colorMat = horzcat(colorMat,color(t)*ones(d));
end
scatter(ymdA,ymdN,10,colorMat,'filled')
axis([-3 3 -5000 5000])
grid on

max(abs(ymdA))
max(abs(ymdN))
YMD(1,:)
end

