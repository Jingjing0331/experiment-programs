function [ChiOriens,ChiToKeys] = getChiOriens(n,m)
ChiOriens = [];
ChiToKeys = [];
for i = 1:n
    for j = 1:m
        x = randi(4);
        ChiToKeys = [ChiToKeys num2str(x)];
        switch x
            case 1
                ChiOriens(i,j) = 'ио';
            case 2
                ChiOriens(i,j) = 'об';
            case 3
                ChiOriens(i,j) = 'вС';
            case 4
                ChiOriens(i,j) = 'ср';
        end
    end
end
