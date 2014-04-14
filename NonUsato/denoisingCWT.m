% AMIR Project main file
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc

%% Defining parameter
% STFT window size in sample
N = 512;
% Wavelets paramter
scale = (128); % maximum wavelets scale
waveletType = 'mexh';
% Block size;
height = 8;
width = 8;

%% Computing input signal
% Reading audio (wav file)
[x, fs, Nbits] = wavread('../shine.wav');
% [x, fs, Nbits] = wavread('/Users/cardo89/Downloads/Russians.wav');
% x = x(:,1);
% obtaining windows size in ms
Nms = ((N/fs)*1000);

% computing the power of clean signal
Px = mean(x.^2);

% generating AWGN
noise = (sqrt(0.1*Px))*rand(1,length(x));
noise = noise - mean(noise);
% Rescaling the noise to obtain the desire aSNR
Pnoise = mean(noise.^2);

%% dirty the signal
y = x + noise';

%% Computing CWT
XStruct = cwtft(x,'scales',1:scale,'wavelet',waveletType);
YStruct = cwtft(y,'scales',1:scale,'wavelet',waveletType);
NOISEStruct = cwtft(noise,'scales',1:scale,'wavelet',waveletType);
X = getfield(XStruct, 'cfs');
Y = getfield(XStruct, 'cfs');
NOISE = getfield(NOISEStruct, 'cfs');

%% Computing the blocked signal
[Yi, NBY] = fastBlocking(Y, height, width);
[Xi, NBX]= fastBlocking(X, height, width);
[NOISEi, NBnoise]= fastBlocking(NOISE, height, width);
%% Real signa deoinsing step
% aSNR = mean(abs(Xi).^2,2)/Pnoise; % supposing stationary noise

Pnoise = mean(abs(NOISEi).^2,2);
Pnoise(find(mean(abs(NOISEi).^2,2) == 0)) = 10^-50;
aSNR = mean(abs(Yi).^2,2)./Pnoise;
% aSNR = mean(abs(Xi).^2,2)./mean(abs(NOISEi).^2,2); % Compiting aSNR for each block

a = 1 - (1./(aSNR +1)); % Computing the denoising coefficients
% gamma = (abs(Yi).^2)./(var(noise));
% xih = gamma - 1; % unbiased estimation of a priori SNR

%% Computing the attenuation coefficients
% a = (1 - (1./(xih + 1)));
% a(a <= 0) = 0;
Xhi = Yi.*(a*ones(1,height*width)); % denoised blocked coefficient
%Xhi = Yi.*(a); % denoised blocked coefficient

SY = size(Y);
Xh = fastDeblocking(Xhi,height, width, NBX,SX);
Xh(size(Y,1):-1:(end+1)/2+1, :) = conj(Xh(2:(end+1)/2, :));
%% Going back in time domain
YStruct = setfield(YStruct,'cfs',Xh);
xh = icwtft(YStruct);

%% Writing result on wav files
%wavwrite(xh,fs,'shine_stft_denoise.wav');

%% Computing SNR
tmp = sprintf('The SNR of the noisy signal is %.2f', get_SNR(x,y));
disp(tmp)
tmp = sprintf('The SNR of the denoised signal is %.2f', get_SNR(x,xh));
disp(tmp)