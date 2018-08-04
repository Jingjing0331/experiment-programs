function [ChMatrix,numMatrix,numSequence] = getChiMatrix(n,m)
numMatrix(1:n,1:m) = 'A';
ChMatrix(1:n,1:m) = 'A';
numSequence(1:n*m) = 'A';
for i = 1:n
    for j = 1:m
        x = int16(rand*9);
        x = num2str(x);
        numMatrix(i,j) = x;
        numSequence((i-1)*4+j) = x;
        switch x
            case '1'
                ChMatrix(i,j) = 'Ҽ';
            case '2'
                ChMatrix(i,j) = '��';
            case '3'
                ChMatrix(i,j) = '��';
            case '4'
                ChMatrix(i,j) = '��';
            case '5'
                ChMatrix(i,j) = '��';
            case '6'
                ChMatrix(i,j) = '½';
            case '7'
                ChMatrix(i,j) = '��';
            case '8'
                ChMatrix(i,j) = '��';
            case '9'
                ChMatrix(i,j) = '��';
            case '0'
                ChMatrix(i,j) = '��';
        end
    end
end