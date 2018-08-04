function [numMatrix,numSequence] = getNumMatrix(n,m)
numMatrix(1:n,1:m) = 'A';
numSequence(1:n*m) = 'A';
for i = 1:n
    for j = 1:m
        x = int16(rand*9);
        x = num2str(x);
        numMatrix(i,j) = x;
        numSequence((i-1)*4+j) = x;
    end
end