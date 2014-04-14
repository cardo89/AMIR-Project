% AMIR Project DFT deoising
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc

%% Defining parameter

% Reading audio (wav file)
[x, fs, Nbits] = wavread('shine.wav');

x = x'; % making the transpose to use only row vector

% computing the power of clean signal
Px = sum(sum(x.^2));

% generating AWGN
noise = (1/sqrt(0.5*Px))*rand(1,length(x));

% Rescaling the noise to obtain the desire aSNR
Pnoise = sum(sum(noise.^2));

% Computing the apriori SNR
sigma = var(noise); % variance of the pseudo random noise


%% dirty the signal
y = x + noise;

%% Performing denoising
% Computing the dsp of the signal
DSP_Y = abs(fft(y)).^2;
DSP_X = abs(fft(x)).^2;
DSP_noise = abs(fft(noise)).^2;
Y = fft(y);
% showing the difference between clean and noisy signal
f = linspace(-0.5,0.5,length(y));
subplot(2,1,1), plot(f,fftshift(DSP_X));
subplot(2,1,2), plot(f,fftshift(DSP_Y),'r');

% normalizing dsp between [0;1]
DSP_Y = (DSP_Y - min(DSP_Y))/(max(DSP_Y) -min(DSP_Y));

% Simple method to compute threshold
mean_value = mean(abs(y));
threshold  = 0.01*mean_value; % Fine-tune this

Xh = Y;
Xh(DSP_Y < sigma) = 0;

% going back in time domain
xh = ifft(Xh);


