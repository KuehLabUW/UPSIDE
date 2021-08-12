%this function save csv file from data specified in the mat file. Each
%column is a field from mat file.
%currently set to 9 fields: pos t cell Xcenter YCentrer w2_APC_corr
%w2_APC w3_PE_corr w3_PE

function save_csvfrommatfluo(matfile,csvname,dirname)

cd(dirname.csvs)
MM = matfile;

M1 = []; M2 = []; M3 = []; M4 = []; M5 = []; M6 = []; M7 = [];
M8 = []; M9 = [];
%keyboard
for i = 1:numel(MM)
    M1 = [M1;MM(i).pos];
    M2 = [M2;MM(i).t];
    M3 = [M3;MM(i).cell];
    M4 = [M4;MM(i).Xcenter];
    M5 = [M5;MM(i).Ycenter];
    M6 = [M6;MM(i).w2_APC_corr];
    M7 = [M7;MM(i).w2_APC];
    M8 = [M8;MM(i).w3_PE_corr];
    M9 = [M9;MM(i).w3_PE];
end

pos     = num2cell(M1);
t       = num2cell(M2);
cell    = num2cell(M3);
Xcenter = num2cell(M4);
Ycenter = num2cell(M5);
APC_corr = num2cell(M6);
APC = num2cell(M7);
PE_corr = num2cell(M8);
PE = num2cell(M9);

T = table(pos,t,cell,Xcenter,Ycenter,APC_corr,APC,PE_corr,PE);
writetable(T,csvname)
%keyboard
end