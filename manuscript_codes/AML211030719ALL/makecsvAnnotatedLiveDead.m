%This scripts make csv list of all live/dead/div mannually annoted cells
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
root_dirPI = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211041219PI/csvs/'; 
csvfilename = 'AML211_ALLSubstractedDir.csv';
csvfilenamePI = 'CombinedSubstractedDirFluo.csv';
cd(code_dir)


matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %s %f %f %f %f %f');
matrixPI = readtable(strcat(root_dirPI,csvfilenamePI),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f');

cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211041219PI/mat/')
load('INDEXPI.mat') %INDEXPI
load('DEADPI.mat') %DEADPI

cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat')
load('INDEX_Round.mat') %INDEX_Round
load('DEAD_Round.mat')   %DEAD_Round
load('INDEX.mat') %INDEX
load('DEAD.mat') %DEAD


annotated_table_name = 'AML211_Annotated.csv';


INDEX_total = [INDEX INDEX_Round];
DEAD_total = [DEAD DEAD_Round];

%Define column names for annotated table
dirname = [];
pos = [];
t = [];
cell = [];
live = [];
dead = [];
%div  = [];
for i = 1:numel(INDEX_total)
   dirname = [dirname; string(matrix.dirname(INDEX_total(i)))];
   pos = [pos; matrix.pos(INDEX_total(i))];
   t = [t; matrix.t(INDEX_total(i))];
   cell = [cell; matrix.cell(INDEX_total(i))];
   %keyboard
   if DEAD_total(i) == 1
       live = [live; 0];
       dead = [dead; 1];
       %div  = [div; 0];
   elseif DEAD_total(i) == 2
       live = [live; 1];
       dead = [dead; 0];
       %div  = [div; 0];
   elseif DEAD_total(i) == 3
       live = [live; 1];
       dead = [dead; 0];
       %div  = [div; 1];
   else
       live = [live; 1];
       dead = [dead; 0];
       %div  = [div; 0];
   end
end


for i = 1:numel(INDEXPI)
   dirname = [dirname; string(matrixPI.dirname(INDEXPI(i)))];
   pos = [pos; matrix.pos(INDEXPI(i))];
   t = [t; matrix.t(INDEXPI(i))];
   cell = [cell; matrix.cell(INDEXPI(i))];
   %keyboard
   if DEADPI(i) == 1
       live = [live; 0];
       dead = [dead; 1];
       %div  = [div; 0];
   elseif DEADPI(i) == 2
       live = [live; 1];
       dead = [dead; 0];
       %div  = [div; 0];
   elseif DEADPI == 3
       live = [live; 1];
       dead = [dead; 0];
       %div  = [div; 1];
   else
       live = [live; 1];
       dead = [dead; 0];
       %div  = [div; 0];
   end
end


T = table(dirname,pos,t,cell,live,dead);

%T = [T;T_PI];
writetable(T,strcat(root_dir,annotated_table_name));