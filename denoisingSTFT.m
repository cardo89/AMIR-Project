% AMIR Project main file
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc

%% Defining parameter
% STFT window size
N = 512;

% Block size;
height = 8;
width = 8;

%% Computing input signal
% Reading audio (wav file)
[x, fs, Nbits] = wavread('shine.wav');

% computing the power of clean signal
Px = mean(x.^2);

% generating AWGN
noise = (sqrt(0.1*Px))*rand(1,length(x));

% Rescaling the noise to obtain the desire aSNR
Pnoise = mean(noise.^2);

%% dirty the signal
y = x + noise';

%aSNR = Px/Pnoise; % apriori SNR

%% Computing spectrogram
%w = hanning(N); % STFT window

%[X F T] = spectrogram(x,w,N/2,N,fs);
%Y = spectrogram(y,w,N/2,N,fs);
Y = STFT(y,((512/fs)*1000),1,fs);
X = STFT(x,((512/fs)*1000),1,fs);
NOISE = STFT(noise,((512/fs)*1000),1,fs);
SX = size(X); % extracting the size of the original signal before blocking
%spectrogram(y,w,N/2,N,fs,'yaxis');

%% Computing the blocked signal
[Yi, NBY] = fastBlocking(Y, height, width);
[Xi, NBX]= fastBlocking(X, height, width);
[NOISEi, NBnoise]= fastBlocking(NOISE, height, width);

%% Real signa deoinsing step
%aSNR = mean(Xi.^2,2)/Pnoise;
aSNR = mean(abs(Xi).^2,2)./mean(abs(NOISEi).^2,2); % Compiting aSNR for each block
%aSNR = mean((Xi).^2,2)./mean((NOISEi).^2,2); % Compiting aSNR for each block
a = 1 - (1./(aSNR +1)); % Computing the denoising coefficients

Xhi = Yi.*(a*ones(1,height*width)); % denoised blocked coefficient

SY = size(Y);
Xh = fastDeblocking(Xhi,height, width, NBX,SX);

%% Going back in time domain
xh = ISTFT(Xh,((512/fs)*1000),1,fs,length(x));

%% Writing result on wav files
%wavwrite(xh,fs,'shine_stft_denoise.wav');