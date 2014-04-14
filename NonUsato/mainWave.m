% AMIR Project main file
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc

%% Defining parameter
% Decomposition level
N = 2;
% Wavelets type
wType = 'sym4';

% Number of neighbourhood to use for the estimation of sigma
M = 1;

% SNR of noisy signal
SNR = 20; % linear scale (3dB)

%% Loading file
% Reading audio (wav file)
[x, fs, Nbits] = wavread('../shine.wav');

x = x(:,1); % making the transpose to use only row vector

% computing the power of clean signal
Px = mean(x.^2);

% generating AWGN
noiseMean = 0;
noiseStandardDeviation = sqrt(Px/SNR);
noise = noiseMean + noiseStandardDeviation.*randn(size(x));
Pnoise = mean(noise.^2)
realSNR = 10*log10(Px/Pnoise)

%% dirty the signal
y = x + noise;
MSE = (sum((y - x).^2))/length(x);
PSNR = 10*log10(1./MSE)
%% Computing wavelets transform
[Y, L]= wavedec(y,N,wType);

%% Computing denoised wavelets coefficients

% Splitting the wavelets transform in the various scale
Y1 = [zeros((M-1)/2,1); Y; zeros((M-1)/2,1)];

for k = (M-1)/2+1:length(Y1) - (M-1)/2
    boh = (1/M)*sum((Y1(k-(M-1)/2:k+(M-1)/2)).^2) - noiseStandardDeviation.^2;
    sigma(k) = max(0,boh);
end
sigma = sigma((M-1)/2+1:end);
Xh = Y.*sigma';
%% Going back in time domain
xh = waverec(Xh,L,wType);
MSE = (sum((xh - x).^2))/length(x);
PSNR_ML = 10*log10(1./MSE)
