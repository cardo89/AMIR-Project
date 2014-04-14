% AMIR Project main file
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc

%% Defining parameter
% Decomposition level
N = 5;
% Wavelets type
wType = 'db8';

% Number of neighbourhood to use for the estimation of sigma
M = 7;

% SNR of noisy signal
%SNR = 30; % linear scale (3dB)

%% Loading file
% Reading audio (wav file)
[x, fs, Nbits] = wavread('shine.wav');
%[x, fs, Nbits] = wavread('/Users/cardo89/Downloads/Russians.wav');
%[x, fs, Nbits] = wavread('/Users/cardo89/Downloads/vasco1.wav');
x = x(:,1); % making the transpose to use only row vector

% computing the power of clean signal
Px = mean(x.^2);

% generating AWGN
noiseMean = 0;
devstd = 0.01:0.01:0.1;
for i = 1:length(devstd)
noiseStandardDeviation = devstd(i) %sqrt(Px/SNR);
noise = noiseMean + noiseStandardDeviation.*randn(size(x));
Pnoise = mean(noise.^2)
%realSNR = 10*log10(Px/Pnoise);

%% dirty the signal
y = x + noise;
% Computing PSNR of noisy signal
MSE = (sum((y - x).^2))/length(x);
PSNR(i) = 10*log10(1./MSE)
%% Denoising
noiseStandardDeviationEstimation(i) = stimaSigma(y,N,wType);
[xhML_noiseEst, XhML, Y, L] = denoising( y,noiseStandardDeviationEstimation(i),N,M,wType );
[xhMAP_noiseEst, XhMAP, Y, L] = denoisingMAP( y,noiseStandardDeviationEstimation(i),N,M,wType );
[xhML, XhML, Y, L] = denoising( y,noiseStandardDeviation,N,M,wType );
[xhMAP, XhMAP, Y, L] = denoisingMAP( y,noiseStandardDeviation,N,M,wType );
%% Computing PSNR after denoising
% PSNR with real sigma
MSE = (sum((xhML.' - x).^2))/length(x);
PSNR_ML_(i) = 10*log10(1./MSE)

MSE = (sum((xhMAP.' - x).^2))/length(x);
PSNR_MAP(i) = 10*log10(1./MSE)


% PSNR with estimated sigma
MSE = (sum((xhML_noiseEst.' - x).^2))/length(x);
PSNR_ML_noiseEst(i) = 10*log10(1./MSE)

MSE = (sum((xhMAP_noiseEst.' - x).^2))/length(x);
PSNR_MAP_noiseEst(i) = 10*log10(1./MSE)
end

%% Showing results
% plotting signal
% figure
% plot(linspace(0,length(x)/fs,length(x)),x), title('original signal'), grid on, axis tight;
% figure
% plot(linspace(0,length(x)/fs,length(x)),y), title('noisy signal'), grid on, axis tight;
% figure
% plot(linspace(0,length(x)/fs,length(x)),xh), title('denoised signal'), grid on, axis tight;
% 
% % Plotting wavlets tranform
% figure
% s=0;
% for k=1:length(L)-1
%     s=s+L(k);
%     yl=floor(min(Y)):ceil(max(Y));
%     xl2(k,:)=ones(size(yl)).*s;
%     plot(xl2,yl,'r')
%     hold on
% end
% plot(Y), title('DWT of noisy signal'), grid on, axis tight;
% figure
% s=0;
% for k=1:length(L)-1
%     s=s+L(k);
%     yl=floor(min(Xh)):ceil(max(Xh));
%     xl2(k,:)=ones(size(yl)).*s;
%     plot(xl2,yl,'r')
%     hold on
% end
% plot(Xh), title('DWT of denoised signal'), grid on, axis tight;
% 
% % Plotting histogram (pdf) of wavelets coefficients
% figure
% hist(Y,1000), title('noisy signal'), grid on, axis tight;
% figure
% hist(Xh,1000), title('denoised signal'), grid on, axis tight;
% figure
% hist(wavedec(x,N,wType),1000), title('original signal'), grid on, axis tight;

%% Writing resulta
% wavwrite(xhML,fs,'shine_denoisedML004.wav')
% wavwrite(xhMAP,fs,'shine_denoisedMAP004.wav');
% wavwrite(y,fs,'shine_noisy004.wav');
