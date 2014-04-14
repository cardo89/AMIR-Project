function [sig_stim] = stimaVar(X,M,sig)
%STIMA Summary of this function goes here
%   Detailed explanation goes here

 sig_stim = zeros(1,length(X));
 cc = floor(M/2);
 
 for i=1:length(X)
     if i-cc <=0
          
        boh = ((sum(X(1:i+cc).^2))/M)-sig.^2;
        sig_stim(i) = max(0,boh);
        
     elseif i+cc >length(X)
        
        boh = ((sum(X(i-cc:end).^2))/M)-sig^2;
        sig_stim(i) = max(0,boh);
    
     else
        
        boh = ((sum(X(i-cc:i+cc).^2))/M)-sig^2;
        sig_stim(i) = max(0,boh);
        
    end
end



end

