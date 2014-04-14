function [ xh ] = denoising(y,wType, N, win, fs)
%[ xh ] = denoising(y,wType, N, window) Require in input the dirty signal, the desired wavelets, the
%decomposition level, the interval length and the sample frequency
%   Non diagonal denoising algorithm that esimate the sigma from the high
%   frequency.
%   Return in output the denoised signal

% computing the numer of sample per window
% Note that this value is "rescaled" in function fo the number of sample of
% each scale

[Y, L]= wavedec(y,N,wType);
% Noise power estimation
Pn = estSigma(Y,L);
%Extracting detailed and approximeted coefficients
A = appcoef(Y,L,wType);
D = detcoef(Y,L,'cell');

% By now to test the code I use diagonal estimation 
aSNR = mean(Y.^2,2)/Pn; % supposing stationary noise
a = 1 - (1./(aSNR +1)); % Computing the denoising coefficients
Xh = Y.*a;

xh = waverec(Xh,L,wType);


end

