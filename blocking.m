function [ Xi ] = blocking(X,height,width)
%%blocking divide the wavelts transform in block usefull to compute.....
%   X, height and width must be power of two

% Extracting the size of the input matrix
SX = size(X);

% Computing block number
NB = [SX(1)/height SX(2)/width];

% Making a cell of blocks
B = mat2cell(X, ones(1,NB(1))*height, ones(1,NB(2))*width);

% turning the cell elements into row of a matrix
i = 1;
Xi = zeros(NB(1)*NB(2),height*width);
for r = 1:NB(1)
    for c = 1:NB(2)
        Xi(i,:) = reshape(cell2mat(B(r,c))',1,height*width);
        i = i +1;
    end
end

end

