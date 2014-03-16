function [ Xi ] = fastBlocking(X,height,width)
%blocking divide the wavelts transform in block usefull to compute.....
%   X, height and width must be power of two

% Extracting the size of the input matrix
SX = size(X);

% Computing block number
NB = [SX(1)/height SX(2)/width];

% Making a cell of blocks
B = mat2cell(X, ones(1,NB(1))*height, ones(1,NB(2))*width);

%put all blocks in one column
B2 = reshape(B',NB(1)*NB(2),1);

%come back to the matrix
Xi2=cell2mat(B2);

%put all line of a block in one line
Xi = reshape(Xi2',height*width,NB(1)*NB(2))';

end