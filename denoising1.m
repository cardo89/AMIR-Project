function [xh, Xh, Y,L] = denoising1(y,sigmaN,N,M,wType)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[Y, L]= wavedec(y,N,wType);
YL = appcoef(Y,L,wType);
[YH, YLH, YLHH, YLHHH, YLHHHH] = detcoef(Y,L,1:N);

sig_stim_L = stimaVar(YL,M,sigmaN);
XhL = (sig_stim_L ./(sig_stim_L + sigmaN.^2)).*YL';
%XhL = YL'.*(1 - (1./(sig_stim_L +1)));

[sig_stim_LHHHH] = stimaVar(YLHHHH,M,sigmaN);
XhLHHHH = (sig_stim_LHHHH ./(sig_stim_LHHHH + sigmaN.^2)).*YLHHHH';
%XhLHHHH = YLHHHH'.*(1 - (1./(sig_stim_LHHHH +1)));

[sig_stim_LHHH] = stimaVar(YLHHH,M,sigmaN);
XhLHHH = (sig_stim_LHHH ./(sig_stim_LHHH + sigmaN.^2)).*YLHHH';
%XhLHHH = YLHHH'.*(1 - (1./(sig_stim_LHHH +1)));

[sig_stim_LHH] = stimaVar(YLHH,M,sigmaN);
XhLHH = (sig_stim_LHH ./(sig_stim_LHH + sigmaN.^2)).*YLHH';
%XhLHH = YLHH'.*(1 - (1./(sig_stim_LHH +1)));

[sig_stim_LH] = stimaVar(YLH,M,sigmaN);
XhLH = (sig_stim_LH ./(sig_stim_LH + sigmaN.^2)).*YLH';
%XhLH = YLH'.*(1 - (1./(sig_stim_LH +1)));

[sig_stim_H] = stimaVar(YH,M,sigmaN);
XhH = (sig_stim_H ./(sig_stim_H + sigmaN.^2)).*YH';
%XhH = YH'.*(1 - (1./(sig_stim_H +1)));

Xh = [XhL XhLHHHH XhLHHH XhLHH XhLH XhH];

xh = waverec(Xh,L,wType);
end

