% AMIR Project Discrete wavelets decomposition test file
% Author: Riccardo Fona, Alberto Ghitti, Davide Rocco, Nicola Simoni
clear all
close all
clc
[x, fs ,B] = wavread('shine.wav');

[cA, cD] = dwt(x, 'db4');
X = fft(x);
w = 1:length(cA);
t = 0:1/fs:length(x)/fs -1/fs;
f = -0.5:1/length(X):0.5 -1/length(X);


figure
subplot(2, 1, 1), plot(w/fs, cA)
title('Approximation coefficients'), xlabel('time'), ylabel('C_A')
subplot(2, 1, 2), plot(w/fs, cD)
title('Detail coefficients'), xlabel('time'), ylabel('C_D')

figure
subplot(2, 1, 1), plot(t, x)
title('Original signal'), xlabel('time')
subplot(2, 1, 2), plot(f',fftshift(abs(X)))
title('Fourier transform'), xlabel('frequency')