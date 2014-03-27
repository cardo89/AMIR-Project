function f_rec = ISTFT(STFTcoef, time_win, factor_redund, f_sampling, length_f)
%
% Inverse windowed Fourier transform. 
%
% Input:
% - STFTcoef: Spectrogram. Column: frequency axis from -pi to pi. Row: time
%   axis. (Output of STFT). 
% - time_win: window size in time (in millisecond).
% - factor_redund: logarithmic redundancy factor. The actual redundancy
%   factor is 2^factor_redund. When factor_redund=1, it is the minimum
%   twice redundancy. 
% - f_sampling: the signal sampling frequency in Hz.
% - length_f: length of the signal. 
%
% Output:
% - f_rec: reconstructed signal. 
%
% Remarks:
% 1. The last few samples at the end of the signals that do not compose a complete
%    window are ignored in the forward transform STFT of Version 1. 
% 2. Note that the reconstruction will not be exact at the beginning and
%    the end of, each of half window size. 
%
% See also:
% STFT
%
% Guoshen Yu
% Version 1, Sept 15, 2006

% Window size
size_win = round(time_win/1000 * f_sampling);

% Odd size for MakeHanning
if mod(size_win, 2) == 0
    size_win = size_win + 1;
end
halfsize_win =  (size_win - 1) / 2;

Nb_win = floor(length_f / size_win * 2);

% Reconstruction
f_rec = zeros(1, length_f);

shift_k = round(halfsize_win / 2^(factor_redund-1));

% Loop over windows 
for k = 1 : 2^(factor_redund-1)
    for j = 1 : Nb_win - 1
        f_win_rec = ifft(STFTcoef(:, (k-1)+2^(factor_redund-1)*j));
        f_rec(shift_k*(k-1)+(j-1)*halfsize_win+1 : shift_k*(k-1)+(j-1)*halfsize_win+size_win) =  f_rec(shift_k*(k-1)+(j-1)*halfsize_win+1 : shift_k*(k-1)+(j-1)*halfsize_win+size_win) +  (f_win_rec');
    end
end

f_rec = f_rec / 2^(factor_redund-1);