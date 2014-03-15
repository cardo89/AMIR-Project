% AMIR Project main file
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc

%% Defining parameter

% Reading audio (wav file)
[x, fs, Nbits] = wavread('shine.wav');

x = x'; % making the transpose to use only row vector
% Making the signal length a power of two
x = [x zeros(1, 2^(ceil(log2(length(x)))) - length(x))];

% computing the power of clean signal
Px = sum(sum(x.^2));

% generating AWGN
noise = (1/sqrt(0.5*Px))*rand(1,length(x));

% Rescaling the noise to obtain the desire aSNR
Pnoise = sum(sum(noise.^2));

% Computing the apriori SNR
sigma = var(noise); % variance of the pseudo random noise

% Wavelets paramter
scale = (256); % maximum wavelets scale
waveletType = 'haar';

% Block size;
height = 8;
width = 8;

%% dirty the signal
y = x + noise;

%% going in wavelts domain (Haar)
X = cwt(x,1:scale,waveletType);
Y = cwt(y,1:scale,waveletType);

%% Computing the blocked signal
Xi = blocking(X, height, width);
Yi = blocking(Y, height, width);
%% comouting the a priori SNR
aSNR = mean(Xi.^2,2)/sigma;

%% Real signa deoinsing step
a = 1 - (1./(aSNR +1)); % Computing the denoising coefficients

Xhi = Yi.*(a*ones(1,64)); % denoised blocked coefficient

SY = size(Y);
Xh = deblocking(Xhi,height, width, SY(1), SY(2));

% reproducing the results
% sound(y,fs)
