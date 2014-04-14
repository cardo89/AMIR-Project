function [x] = sigma_noise(y,Lms,overlap,fs)

%L=256;
%R=L/2;
%h=window(@hann,L);

%Compute the STFT of the signal
%Y=spectrogram(y,h,R,1024,fs).';
Y = STFT(y,Lms,overlap,fs).';
%Y = Y(1:round(end/2));
%Extract the dimensions
[l_size k_size]=size(Y);

%Power spectral density
PP=Y.*conj(Y);

%Initialization of some values
P=PP(1,:);

sigma2_N=P;    %noise power
alpha_max=0.96;
alphac=1;

P_hat=P;
P2_hat=P.^2;
Pmin_u=P;

U=1;
V=4;
D=V*U;

DM=[1,2,5,8,10,15,20,30,40,60,80,120,140,160];
M=[0 0.26 0.48 0.58 0.61 0.668 0.705 0.762 0.8 0.841 0.865 0.89 0.9 0.91];
q=1:160;
m=interp1(DM,M,q,'linear');
MD=m(D);
MV=m(V);

subwc=V;
actmin_stored=zeros(l_size,k_size);
lmin_flag=zeros(1,k_size);

actmin=Inf(1,k_size);
actmin_sub=Inf(1,k_size);
act_buffer=Inf(U,k_size);

ibuf=0;

x=zeros(size(Y));

for l=1:l_size
    Y_aux=PP(l,:);
    
    alphac_tilde=1/(1+(sum(P)/sum(Y_aux)-1)^2);
    alphac=0.7*alphac+0.3*max(alphac_tilde,0.7);
    alpha_hat=alpha_max*alphac./(1+(P./sigma2_N-1).^2);
    
    P=alpha_hat.*P+(1-alpha_hat).*Y_aux;
    
    beta=min(alpha_hat.^2,0.8);
    P_hat=beta.*P_hat+(1-beta).*P;
    P2_hat=beta.*P2_hat+(1-beta).*P.^2;    
    
    Qeq=2*sigma2_N.^2./(P2_hat-P_hat.^2);
    Qi=sum(1./Qeq)/k_size;
    Bc=1+2.12*sqrt(Qi);
    
    Qeq_tilde=(Qeq-2*MD)/(1-MD);
    Bmin=1+(D-1)*2./Qeq_tilde;
    
    Qeq_tilde_sub=(Qeq-2*MV)/(1-MV);
    Bmin_sub=1+(V-1)*2./Qeq_tilde_sub;

    kmod=Bc*P.*Bmin < actmin;
    if any(kmod)
        actmin(kmod)=Bc*P(kmod).*Bmin(kmod);
        actmin_sub(kmod)=Bc*P(kmod).*Bmin_sub(kmod);
    end
    
    if subwc>1 && subwc<V
        lmin_flag=lmin_flag|kmod;
        Pmin_u=min(actmin_sub,Pmin_u);
        sigma2_N=Pmin_u;
    else
        if subwc>=V
            ibuf=1+rem(ibuf,U);
            act_buffer(ibuf,:)=actmin;
            Pmin_u=min(act_buffer,[],1);

            if Qi <= 0.06 && Qi > 0.05
                noise_slope_max=2;
                    else if Qi <= 0.05 && Qi > 0.03
                        noise_slope_max=4;
                            else if Qi <= 0.03
                                noise_slope_max=8;
                                else
                                    noise_slope_max=1.2;
                                  end
                          end
            end

            lmin=lmin_flag & actmin_sub < noise_slope_max*Pmin_u & actmin_sub>Pmin_u;
            if any(lmin)
                Pmin_u(lmin)=actmin_sub(lmin);
                act_buffer(:,lmin)=repmat(Pmin_u(lmin),U,1);
            end

            lmin_flag(:)=0;
            actmin(:)=Inf;
            subwc=0;
        end
    end
    
    subwc=subwc+1;
    x(l,:)=(sigma2_N);
end

end

