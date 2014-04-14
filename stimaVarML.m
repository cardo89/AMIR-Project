function [ sigmaL sigmaH sigmaLH sigmaLHH sigmaLHHH sigmaLHHHH ] = stimaVarML(Y,L,M,sigmaN)
YL = appcoef(Y,L,'db8');
[YH, YLH, YLHH, YLHHH, YLHHHH] = detcoef(Y,L,1:5);

YL = [zeros((M-1)/2,1); YL; zeros((M-1)/2,1)];
YH = [zeros((M-1)/2,1); YH; zeros((M-1)/2,1)];
YLH = [zeros((M-1)/2,1); YLH; zeros((M-1)/2,1)];
YLHH = [zeros((M-1)/2,1); YLHH; zeros((M-1)/2,1)];
YLHHH = [zeros((M-1)/2,1); YLHHH; zeros((M-1)/2,1)];
YLHHHH = [zeros((M-1)/2,1); YLHHHH; zeros((M-1)/2,1)];

for k = (M-1)/2 + 1:length(YL)-(M-1)/2
    boh = (1/M)*sum((YL(k - (M-1)/2:k + (M-1)/2)).^2) - sigmaN.^2;
    sigmaL(k) = max(0,boh);
end
%sigmaL =sigmaL((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YH)-(M-1)/2
    boh = (1/M)*sum(YH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigmaH(k) = max(0,boh);
end
%sigmaH =sigmaH((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YLH)-(M-1)/2
    boh = (1/M)*sum(YLH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigmaLH(k) = max(0,boh);
end
%sigmaLH =sigmaLH((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YLHH)-(M-1)/2
    boh = (1/M)*sum(YLHH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigmaLHH(k) = max(0,boh);
end
%sigmaLHH =sigmaLHH((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YLHHH)-(M-1)/2
    boh = (1/M)*sum(YLHHH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigmaLHHH(k) = max(0,boh);
end
%sigmaLHHH =sigmaLHHH((M-1)/2 +1:end);

for k = (M-1)/2 + 1:length(YLHHHH)-(M-1)/2
    boh = (1/M)*sum(YLHHHH(k - (M-1)/2:k + (M-1)/2).^2) - sigmaN.^2;
    sigmaLHHHH(k) = max(0,boh);
end
%sigmaLHHHH =sigmaLHHHH((M-1)/2 +1:end);


end

