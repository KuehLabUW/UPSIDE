% this script lets you specify a list of features and a biological feature
% of interest and it will genera example images

clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211Total/';


cd(code_dir)

% enter properties name
prop_name_ini = 'APC_corr'; % 'APC_corr','PE_corr','distance'
% enter the list of features
flist = [{'m47','m77','m11','m38','m45','m30','m23','m27','m18','m31','m58'}];
flist = [{'m47','m80','m77','t48','m17','t54','m5','m52','m1','m51','m25',...
't4','t45','m13','t49','t82','m33','m98','m11','t93','m38','m55','m16','t63','t0',...
'm99','m45','t9','t81','m30','m23','m63','m62','t29','t68','m27','t6','m18','t65',...
'm87','t24','m31','t60','t64','m58','m76','m7','t35','m21','t99','t61','m53','t53',...
't22','t58','t33','m75','t94','m92','m81','t66','t40','t77','t75','t28','m4','t74',...
'm85','t13','t21','m24','m19','m61','t26','m46','t17','t51','t79','t47','t78'}];
%flist = [{'t21'}];
%% decide which data to load
if strcmp(prop_name_ini,'distance') == 1
    root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';
    datadirfile = 'cluster_tracked_dist_area_dist_cond.csv';
    rawtif(1)= {'/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack1/'};
    rawtif(2)= {'/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack2/'};
    datacolumn = 217;
    Text = ['%s'];
    for i = 1:datacolumn
        Text = [Text ' %f'];
    end
    matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
    matrix = matrix(matrix.pcell~=0,:);
else
    root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
    datadirfile = 'Dataset1CompleteAreaEdgeFluoClusterCenter.csv';
    raw_tif = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/Differentiation/';
    datacolumn = 219;
    Text = ['%s'];
    for i = 1:datacolumn
        Text = [Text ' %f'];
    end
    
    
    matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
    matrix = matrix(matrix.trial ~= 2,:);
end
%%
matrix_total = matrix;
Rlist1 = [];
Nonreslist1 = [];

Rlist2 = [];
Nonreslist2 = [];
for t = [1,3]
    matrix = matrix_total(matrix_total.trial== t,:);
    
    for j = flist
        prop = log10(matrix.PE_corr + 1);
        eval(sprintf('feature = matrix.%s;',char(j)));
        threshf =2.0;

        idx = find(feature < threshf);
        data = [prop(idx),feature(idx)];

        [H,c] = hist3(data,'Nbins',[20,20]); % row = prop; col = feature

        c_prop = c(1); c_prop = c_prop{:};
        c_feature = c(2); c_feature = c_feature{:};
        H_raw = H;
        
        if t == 1
            Nonreslist1 = [Nonreslist1 sum(H(1,:))/sum(H,'all')];
        else
            Nonreslist2 = [Nonreslist2 sum(H(1,:))/sum(H,'all')];
        end
        
        H(1,:) = 0; % get rid of cells with feature but no APC

        % loop through each bin of feature and calculate mean prop
        m_trend = [];
        n_trend = [];

        for i = 1:numel(H(1,:))
            %disp(numel(H(:,i)))
            n_trend = [n_trend sum(H(:,i)>0)];
            if sum(H(:,i)>0) > 0
                %figure(i)
                f = fit(c_prop',H(:,i),'gauss1');
                m_trend = [m_trend f.b1];
                %bar(c_prop,H(:,i))
                hold on
                %plot(f)
            end

            %
        end
        %figure()
        %scatter(c_feature(1:numel(m_trend)),m_trend)
        R = corrcoef(c_feature(1:numel(m_trend)),m_trend);
        
        if t == 1
            Rlist1 = [Rlist1 R(2,1)];
        else
            Rlist2 = [Rlist2 R(2,1)];
        end
        %disp(R(2,1))
        %keyboard
    end
end
%%
Rlistm = mean([Rlist1',Rlist2'],2); [Rlistm_s,Ridx] = sort(Rlistm);
%Rlists = std([Rlist1',Rlist2'],0,2)/sqrt(2);
Rlists = std([Rlist1',Rlist2'],0,2);

Nonreslistm = mean([Nonreslist1',Nonreslist2'],2);
Nonreslists = std([Nonreslist1',Nonreslist2'],0,2);
%%
figure()

bar(categorical(flist(Ridx),flist(Ridx)),Rlistm_s)
hold on

er = errorbar(categorical(flist(Ridx),flist(Ridx)),Rlistm_s,Rlists(Ridx),Rlists(Ridx)); 
er.Color = [0 0 0];                            
er.LineStyle = 'none';