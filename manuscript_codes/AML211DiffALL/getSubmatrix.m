function matrix = getSubmatrix(datamatrix,trial,condition,tlow,thigh,cluster)
if cluster == 100
    rows = (datamatrix.trial==trial & datamatrix.condition==condition & datamatrix.t>tlow & datamatrix.t<thigh);
else
    rows = (datamatrix.trial==trial & datamatrix.condition==condition & datamatrix.t>tlow & datamatrix.t<thigh & datamatrix.cluster==cluster);
end
    matrix = datamatrix(rows,:);
end