%this function generate a series of n track pairs, based on the cell type
%pair being queried
function Data = getTrackedPairs(datamatrix,clusterpair,numpair,fignum)

count = 0;
for i = 1:size(datamatrix,1)
    idx = randi([0 size(datamatrix,1)],1,1);
    cluster_now = datamatrix.cluster(idx);
    pos_now = datamatrix.pos(idx);
    t_now = datamatrix.t(idx);
    pcell = datamatrix.pcell(idx);
    df_next = datamatrix(datamatrix.pos == pos_now & datamatrix.t == t_now+1 & datamatrix.cell == pcell,:);
    if size(df_next,1) == 1
        cluster_next = df_next.cluster;
        if cluster_now==clusterpair(1) && cluster_next == clusterpair(2)
            im_now = imread(string(datamatrix.dirname(idx)));
            im_next = imread(string(df_next.dirname));
            paired_im = [im_now,im_next];
            count = count +1;
            Data{count} = paired_im;
            %keyboard
        end
    end
    
    
    if count == numpair
        break
    end
end

%figure(fignum)
for i = 1:numpair
    %keyboard
    subplot(numpair,1,i)
    imshow(imadjust(Data{i}./max(paired_im(:)),[0 1]))
end
end
