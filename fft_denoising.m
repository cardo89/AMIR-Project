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

% Computing the dsp of the signal
DSP_X = conj(fft(y)).*fft(y);
DSP_noise = conj(fft(noise))'*fft(noise);