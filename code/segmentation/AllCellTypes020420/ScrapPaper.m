imagedir = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/CellTypes112319/';

name = 'EXP1_w3Camera CellTrace_s60_t5.TIF';
nameBF = 'EXP1_w1Camera BF_s60_t5.TIF';
a = imread([imagedir name]);
a_og = a;
aBF = imread([imagedir nameBF]);
seg = cellseg120518MLCellTrace(a);

imtool(aBF)

imtool(seg)

thresh = 3;
a(a < thresh) = 0;
h1 = fspecial('gaussian',[5 5], 2); % 2D guassian filter was 30
i1 = imfilter(a,h1);   % gaussian filtered image
%watershed algorithm based on signal intensity
A = imbinarize(i1);
%imtool(A)
B = bwdist(~A);
%imtool(B)
C = -B;
%imtool(C)
D = imhmin(C,1);%was 0.55
%imtool(D)
L = watershed(D);
a_og(L==0) = 0;
imtool(a_og);
