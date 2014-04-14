function [ sigmaN] = stimaSigma(y,N,wType)

[Y ,L] = wavedec(y,N,wType);
sigmaN = sqrt(mean(Y(L(end-1):end).^2));