function MatrixPattern = getPatternMatrix(color1,color2,dotSize,maskSize)
% ��ȡPattern Mask���������
% color1,color2: colors of background and mask
% dotSize:Ŀ��̼��ıʻ���ϸ����Ҫ�÷Ŵ�����orz������*��
% maskSize: �ڱδ̼��Ĵ�С ��*��

for i = 1 : dotSize : maskSize(1)
    for j = 1 : dotSize : maskSize(2)
        flag = rand;
        if flag <= 0.5
           MatrixPattern(i:i+dotSize-1,j:j+dotSize-1) = color1;
        else MatrixPattern(i:i+dotSize-1,j:j+dotSize-1) = color2;
        end
    end
end