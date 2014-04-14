clear all
close all 
clc

%%PARAMETER
fs=22050;
t=0:1/fs:3;
%snr=10  %%10db
snr=2  %%3db

%%signal
X=sin(2*pi*440*t);
Psignal=mean(X.^2)

%%noise
NoiseMean=0
NoiseStandardDeviation=(Psignal/snr)^0.5
n = NoiseMean + NoiseStandardDeviation.*randn(size(X));
Pnoise=mean(n.^2)

RealSNRdb=10*log10(Psignal/Pnoise)


%%wave%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Dal plot della dwt del
%%seganle noto le discontinuità fra le varie finestre quindi per la stima
%%dell'errore dall'ultima finestra conviene escludere alcuni campiioni dai
%%bordi

N=10;
[C,L] = wavedec(X,N,'sym4');


%%plot
s=0;
for k=1:length(L)-1
    s=s+L(k);
    yl=floor(min(C)):ceil(max(C));
    xl(k,:)=ones(size(yl)).*s;
    plot(xl,yl,'r')
    hold on
end
plot(C);


%%wave%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%plottando il segnale
%%rumoroso noto che nelle 'alte freq' c'è solo rumore. questo è vero solo
%%se la freq è bassa (prova a cambiare mettendo 5000 di freq)

N=10;
[C,L] = wavedec(n+X,N,'sym4');


%%plot
figure;
s=0;
for k=1:length(L)-1
    s=s+L(k);
    yl=floor(min(C)):ceil(max(C));
    xl2(k,:)=ones(size(yl)).*s;
    plot(xl2,yl,'r')
    hold on
end
plot(C);

%%compute sigma

%%prendo solo l'ultima 

C1=C(L(end-1):end);
EstimatedPnoise=mean(C1.^2)



%%%ora stimiamo l'errore al variare dlela frequenza, si nota che fino a
%%%2000 è corretta poi degenera

N=10;
f=100:100:11000;
for k=1:length(f)
    X=sin(2*pi*f(k)*t);
    [C,L] = wavedec(n+X,N,'sym4');
    C1=C(L(end-1):end);
    EstimatedPnoise(k)=mean(C1.^2);
end

figure;
plot(f,EstimatedPnoise);

%%%%però guardando la STFT di un segnale musicale si nota che oltre i
%%%%2000Hz la presenza delle armoniche è localizzata (punti gialli). questo
%%%%consente di risolvere il problema precedente valutando la sigma non in
%%%%base a una sola finestra ma cercando la minima di un gruppo(blocchi
%%%%1D)esempio di 4 o più finestre. Se il segnale rimanesse a potenza
%%%%costante potremmo calcolare il minimo di tutta la canzione, ma dato che
%%%%ciò non è vero si userà un intervallo di alcune finesre 4 8 16 o più


[x, fs, Nbits] = wavread('shine.wav');
figure;
%spectrogram(x)
spectrogram(x,1024,512,1024,fs)



N=10;
[C,L] = wavedec(x,N,'sym4');

figure;
%%plot
s=0;
for k=1:length(L)-1
    s=s+L(k);
    yl=floor(min(C)):ceil(max(C));
    xl3(k,:)=ones(size(yl)).*s;
    plot(xl3,yl,'r')
    hold on
end
plot(C);


SegnaleReale=1

%snr=10  %%10db
snr=10  %%10db

%%signal
Psignal=mean(x.^2)

%%noise
NoiseMean=0
NoiseStandardDeviation=(Psignal/snr)^0.5
n = NoiseMean + NoiseStandardDeviation.*randn(size(x));
Pnoise=mean(n.^2)

RealSNRdb=10*log10(Psignal/Pnoise)


N=10;
[C,L] = wavedec(x+n,N,'sym4');

figure;
%%plot
s=0;
for k=1:length(L)-1
    s=s+L(k);
    yl=floor(min(C)):ceil(max(C));
    xl4(k,:)=ones(size(yl)).*s;
    plot(xl3,yl,'r')
    hold on
end
plot(C);
