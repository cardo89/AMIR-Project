clc
clear all
close all

[x, fs, Nbits] = wavread('robinhood.wav');

X = cwtft(x(:,1),'scales',1:32,'wavelet','mexh');

Xrec = icwtlin(X);