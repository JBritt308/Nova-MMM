
function [myFz, myMz] = TireReader(TireId, slip, Fz)
SheetFy = strcat('Fy',int2str(TireId));
SheetMz = strcat('Mz',int2str(TireId));
Fy = xlsread('TireDatabase.xls',SheetFy);
Mz = xlsread('TireDatabase.xls',SheetMz);
myFz = Fy(round((slip + 15)*2) + 2, round(abs(Fz/20)) + 1);
myMz = Mz(round((slip + 15)*2) + 2, round(abs(Fz/20)) + 1);
