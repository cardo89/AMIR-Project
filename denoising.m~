function [ xh, Xh, Y,L ] = denoising( y,sigmaN,N,M,wType )

[Y, L]= wavedec(y,N,wType);

% Separating subbband
YL = appcoef(Y,L,wType);
[YH, YLH, YLHH, YLHHH, YLHHHH] = detcoef(Y,L,1:N);

%% zero padding Padding
YL = [zeros((M-1)/2,1); YL; zeros((M-1)/2,1)];
YH = [zeros((M-1)/2,1); YH; zeros((M-1)/2,1)];
YLH = [zeros((M-1)/2,1); YLH; zeros((M-1)/2,1)];
YLHH = [zeros((M-1)/2,1); YLHH; zeros((M-1)/2,1)];
YLHHH = [zeros((M-1)/2,1); YLHHH; zeros((M-1)/2,1)];
YLHHHH = [zeros((M-1)/2,1); YLHHHH; zeros((M-1)/2,1)];

% YL = [YL(1:(M-1)/2); YL; YL(end - (M-1)/2+1: end)];
% YH = [YH(1:(M-1)/2); YH; YH(end - (M-1)/2+1: end)];
% YLH = [YLH(1:(M-1)/2); YLH; YLH(end - (M-1)/2+1: end)];
% YLHH = [YLHH(1:(M-1)/2); YLHH; YLHH(end - (M-1)/2+1: end)];
% YLHHH = [YLHHH(1:(M-1)/2); YLHHH; YLHHH(end - (M-1)/2+1: end)];
% YLHHHH = [YLHHH(1:(M-1)/2); YLHHHH; YLHHHH(end - (M-1)/2+1: end)];

min = 0.000;


for k = (M-1)/2 + 1:length(YL)-(M-1)/2
    boh = (1/M)*sum(YL(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigma = max(min,boh);
    XhL(k) = (sigma/(sigma + sigmaN^2))*YL(k);
end
XhL =XhL((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YH)-(M-1)/2
    boh = (1/M)*sum(YH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigma = max(min,boh);
    XhH(k) = (sigma/(sigma + sigmaN^2))*YH(k);
end
XhH =XhH((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YLH)-(M-1)/2
    boh = (1/M)*sum(YLH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigma = max(min,boh);
    XhLH(k) = (sigma/(sigma + sigmaN^2))*YLH(k);
end
XhLH = XhLH((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YLHH)-(M-1)/2
    boh = (1/M)*sum(YLHH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigma = max(min,boh);
    XhLHH(k) = (sigma/(sigma + sigmaN^2))*YLHH(k);
end
XhLHH =XhLHH((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YLHHH)-(M-1)/2
    boh = (1/M)*sum(YLHHH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigma = max(min,boh);
    XhLHHH(k) = (sigma/(sigma + sigmaN^2))*YLHHH(k);
end
XhLHHH =XhLHHH((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YLHHHH)-(M-1)/2
    boh = (1/M)*sum(YLHHHH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigma = max(min,boh);
    XhLHHHH(k) = (sigma/(sigma + sigmaN^2))*YLHHHH(k);
end
XhLHHHH =XhLHHHH((M-1)/2 +1:end);

Xh = [XhL XhLHHHH XhLHHH XhLHH XhLH XhH];

xh = waverec(Xh,L,wType);
