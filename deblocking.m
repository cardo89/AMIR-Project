function [ X ] = deblocking( Xi, height, width, rows, cols )
%deblocking reshape the denoised signal in order to obtain the matrix of
%the wavelets tranform
%   rows and cols are the rows and coloumn of the original matrix (the
%   wavelts transform)

% Computing block size
NB = [rows/height cols/width];

% turning the cell elements into row of a matrix
i = 1;

for r = 1:NB(1)
    for c = 1:NB(2)
        B(r,c) = {(reshape(Xi(i,:),width,height))'};
        i = i +1;
    end
end
X = cell2mat(B);
end

