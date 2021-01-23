%this function save csv file from data specified in the mat file. Each
%column is a field from mat file.
%currently set to 6 fields: dir pos t cell Xcenter YCentrer

function save_csvfrommat(matfile,csvname,dirname)

cd(dirname.csvs)
MM = matfile;

M1 = []; M2 = []; M3 = []; M4 = []; M5 = []; M6 = [];
%keyboard
for i = 1:numel(MM)
    M1 = [M1;string(MM(i).dir)];
    M2 = [M2;MM(i).pos];
    M3 = [M3;MM(i).t];
    M4 = [M4;MM(i).cell];
    M5 = [M5;MM(i).Xcenter];
    M6 = [M6;MM(i).Ycenter];
end
dirname = cellstr(M1);
pos     = num2cell(M2);
t       = num2cell(M3);
cell    = num2cell(M4);
Xcenter = num2cell(M5);
Ycenter = num2cell(M6);

T = table(dirname,pos,t,cell,Xcenter,Ycenter);
writetable(T,csvname)
%keyboard
end