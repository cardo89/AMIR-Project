% AMIR Project main file
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc

%% Defining parameter
% estimation parameter
beta1 = 0.5;
beta2 = 1;
lambda = 1.5;
alpha = 0.5;
% Decomposition level
N = 5;
% Wavelets type
wType = 'sym4';

% SNR of noisy signal
SNR = 10; % linear scale (3dB)

%% Computing input signal
% Reading audio (wav file)
[x, fs, Nbits] = wavread('shine.wav');
%[x, fs, Nbits] = wavread('/Users/cardo89/Downloads/Russians.wav');

x = x(:,1); % Selecting only one channel if is stereo
Px = mean(x.^2); % Power of the signal

% generating AWGN
noiseMean = 0;
noiseStandardDeviation = sqrt(Px/SNR);
noise = noiseMean + noiseStandardDeviation.*randn(size(x));
Pnoise = mean(noise.^2)
realSNR = 10*log10(Px/Pnoise)


%% dirty the signal
y = x + noise;

%% Computing wavelets transform
[Y, L]= wavedec(y,N,wType);
%[X, L]= wavedec(x,N,wType);
%NOISE = wavedec(noise,N,wType);

%% Computing the aPosteriori SNR

gamma = (abs(Y).^2)./(noiseStandardDeviation.^2);
xih = gamma - 1; % unbiased estimation of a priori SNR

%% Computing the attenuation coefficients
a = (1 - lambda*(1./(xih + 1)).^beta1)*beta2;
a(a <= 0) = 0;

%% Real signal deoinsing step
Xh = Y.*a;

%% Going back in time domain
xh = waverec(Xh,L,wType);

%% Writing result on wav files
%wavwrite(xh,fs,'shine_wavlets_denoise.wav');

%% Computing SNR
tmp = sprintf('The SNR of the noisy signal is %.2f', get_SNR(x,y));
disp(tmp)
tmp = sprintf('The SNR of the denoised signal is %.2f', get_SNR(x,xh));
disp(tmp)