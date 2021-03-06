function pipeline2(indir, basenames, outdir, paramfile, varargin)

%% PRE-PROCESS AND TRACK IMAGES %%
%% PROCESSING STARTS
p = load(paramfile);
S = p.S;  % the number of stage positions

% load the optional argument to specify range of stage positions to process
if (~isempty(varargin))
    positions = varargin{1};  % vector listing stage positions to process
else
    positions = 1:S;
end


parfor i = positions    % loop over all stage positions
%for i = 16:S
    disp('position')
    disp(i)
    disp('%%%%%%%%%%%%%%%%%%%%%')
    outdir1 = [outdir '/pos ' num2str(positions(i))];  % output directory for the specific file offset    
    preprocess(indir, basenames, outdir1, positions(i));  % Metamorph preprocessing
    seg(outdir1,i);    % Cell segmentation
    
end
