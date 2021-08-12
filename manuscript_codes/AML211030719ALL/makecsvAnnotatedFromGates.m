clear
%this script creates a csv file that is labeled according to the gating
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
mat_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/';
outputcsv = 'AML_LIVE_Cat_Annotated.csv';
gatefilename = 'LIVE_gates_ALL_dropout.mat';

load(strcat(mat_dir,gatefilename));

gatename1 = "root:A1"; label1 = 1;
gatename2 = "root:A3"; label2 = 2;
gatename3 = "root:E3"; label3 = 2;
gatename4 = "root:D1"; label4 = 3;
gatename5 = "root:E1"; label5 = 3;
gatename6 = "root:F"; label6 = 4;
gatename7 = "root:E4"; label7 = 5;

showgatenames = [gatename1,gatename2,gatename3,gatename4,gatename5,gatename6,gatename7];
labels = [label1,label2,label3,label4,label5,label6,label7];

dirname = [];
cat1 = [];
cat2 = [];
cat3 = [];
cat4 = [];
cat5 = [];

for i = 1:7
    %find gate numberobjects
    for g = 1:numel(gatenames)
        if strcmp(showgatenames(i),char(gatenames(g))) == 1
            gate_ind = g-1;
            break
        end
    end
    %extract dirname and label that picture
    disp(i)
    for t = 1:numel(objects)
        for cell = 1:numel(objects(t).obj)
            if objects(t).obj(cell).gate == gate_ind
                dirname = [dirname;string(objects(t).obj(cell).dir)];
                cat1 = [cat1; (1 == labels(i))];
                cat2 = [cat2; (2 == labels(i))];
                cat3 = [cat3; (3 == labels(i))];
                cat4 = [cat4; (4 == labels(i))];
                cat5 = [cat5; (5 == labels(i))];
            end
        end
    end
end

T = table(dirname,cat1,cat2,cat3,cat4,cat5);
writetable(T,strcat(root_dir,outputcsv))
