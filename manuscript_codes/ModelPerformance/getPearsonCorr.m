%this function gets pearson correlation values between two images
function corr = getPearsonCorr(Im_fake,Im_real)

%get mean intensity of each image
mean_fake = mean(Im_fake,'all');
mean_real = mean(Im_real,'all');

%calculate pearson coefficient
dIm_fake = Im_fake - mean_fake;
dIm_real = Im_real - mean_real;

Sumprod = sum(dIm_fake.*dIm_real,'all');

SumdIm_fakesq = sum(dIm_fake.^2,'all');

SumdIm_realsq = sum(dIm_real.^2,'all');

corr = Sumprod/sqrt(SumdIm_fakesq*SumdIm_realsq);


end