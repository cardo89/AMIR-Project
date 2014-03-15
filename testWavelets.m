clc
clear all
close all

[x, fs, Nbits] = wavread('robinhood.wav');

cwtS1 = cwtft(x(:,1),'plot');

YRDen = icwtlin(cwtS1,'plot');