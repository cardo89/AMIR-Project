close all
clc

%% Defining parameter
% Decomposition level
N = 5;
% Wavelets type
wType = 'sym4';

% Interval size;
% length = 25*10^-3; % window size in seconds

%% Computing input signal
% Reading audio (wav file)
%[x, fs, Nbits] = wavread('shine.wav');
[x, fs, Nbits] = wavread('/Users/cardo89/Downloads/Russians.wav');
x = x(:,1);

Px = mean(x.^2);
% generating AWGN
noise = (sqrt(0.1*Px))*rand(1,length(x)) - mean(noise);
noise = noise - mean(noise);
% computing noise power
Pnoise = mean(noise.^2);

%% dirty the signal
y = x + noise';

%% Computing wavelets transform

% Signal of the same length means "same decomposition scheme"
X = wavedec(x,N,wType);
[Y, L]= wavedec(y,N,wType);

%% Real signal deoinsing step
aSNR = mean(Y.^2,2)/Pnoise;
a = 1 - (1./(aSNR +1)); % Computing the denoising coefficients
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