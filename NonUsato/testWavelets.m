clc
clear all
close all

[x, fs, Nbits] = wavread('robinhood.wav');

x = x(:,1);
X = cwtft(x(:,1),'scales',1:256,'wavelet','mexh');

xRec = icwtft(X);


% % Normilizing recontructed signal in order to have the same dinamic of x
% xRec = (xRec - min(xRec))/(max(xRec) -min(xRec)); % Normalizing between [0;1]
% xRec = xRec*(max(x) - min(x)) + min(x); %Rescaling the recontructe signal to thge same dynamics of x

plot(x(:,1)), hold on, plot(xRec,'r');