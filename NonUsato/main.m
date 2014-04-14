% AMIR Project main file
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc

%% Defining parameter

% Reading audio (wav file)
%[x, fs, Nbits] = wavread('shine.wav');
[x, fs, Nbits] = wavread('/Users/cardo89/Downloads/Russians.wav');
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
waveletType = 'mexh';

% Block size;
height = 8;
width = 8;

%% dirty the signal
y = x + noise;

%% going in wavelts domain (Haar)
% X = cwt(x,1:scale,waveletType);
% Y = cwt(y,1:scale,waveletType);
XStruct = cwtft(x,'scales',1:scale,'wavelet',waveletType);
YStruct = cwtft(y,'scales',1:scale,'wavelet',waveletType);
X = getfield(XStruct, 'cfs');
Y = getfield(XStruct, 'cfs');
%% Computing the blocked signal
Xi = fastBlocking(X, height, width);
Yi = fastBlocking(Y, height, width);
%% comouting the a priori SNR
aSNR = mean(Xi.^2,2)/sigma;

%% Real signa deoinsing step
a = 1 - (1./(aSNR +1)); % Computing the denoising coefficients

Xhi = Yi.*(a*ones(1,64)); % denoised blocked coefficient

SY = size(Y);
Xh = fastDeblocking(Xhi,height, width, SY(1), SY(2));

%% Try to return in time domain after fourier transform
YStruct = setfield(YStruct,'cfs',Xh);
xh = icwtft(YStruct);
% reproducing the results
% sound(y,fs)
tmp = sprintf('The SNR of the noisy signal is %.2f', get_SNR(x,y));
disp(tmp)
tmp = sprintf('The SNR of the denoised signal is %.2f', get_SNR(x,xh));
disp(tmp)