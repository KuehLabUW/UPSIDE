clear

%This scripts make csv list of all live/dead/div mannually annoted cells
%and add to the original annotated file
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
annotated_name = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/AML211_LargeMask_Annotated.csv'; %this is from old AML211data
csvfilenameLargeMask =  'CombinedMaskDirFluo.csv';
cd(code_dir)


matrix = readtable(annotated_name,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f');

matrix_LargeMask = readtable(strcat(root_dir,csvfilenameLargeMask),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f %f %f %f %f %f');

cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/mat')
load('INDEX.mat') %INDEX
load('DEAD.mat')   %DEAD




new_annotated_table_name = 'AML211DiffALL_LargeMask_Annotated.csv';


%Define column names for annotated table
dirname = [];
pos = [];
t = [];
cell = [];
live = [];
dead = [];
%div  = [];

for i = 1:numel(INDEX)
   dirname = [dirname; string(matrix_LargeMask.dirname(INDEX(i)))];
   pos = [pos; matrix_LargeMask.pos(INDEX(i))];
   t = [t; matrix_LargeMask.t(INDEX(i))];
   cell = [cell; matrix_LargeMask.cell(INDEX(i))];
   %keyboard
   if DEAD(i) == 1
       live = [live; 0];
       dead = [dead; 1];
       %div  = [div; 0];
   elseif DEAD(i) == 2
       live = [live; 1];
       dead = [dead; 0];
       %div  = [div; 0];
   elseif DEAD(i) == 3
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

%T_out = [matrix;T];
T_out = [T];

writetable(T_out,strcat(root_dir,new_annotated_table_name));