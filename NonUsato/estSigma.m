function [ sigma ] = estSigma(Y,L)
%[ sigma ] = estSigma(Y,L) Estimate the noise variance using only the high
%pass coefficients of wavelets decomposition
%   Detailed explanation goes here
D = detcoef(Y,L,1);
sigma = mean(D.^2);


end

