function MatrixPattern = getPatternMatrix(color1,color2,dotSize,maskSize)
% 获取Pattern Mask的随机矩阵
% color1,color2: colors of background and mask
% dotSize:目标刺激的笔画粗细（又要用放大镜照了orz），高*宽
% maskSize: 掩蔽刺激的大小 高*宽

for i = 1 : dotSize : maskSize(1)
    for j = 1 : dotSize : maskSize(2)
        flag = rand;
        if flag <= 0.5
           MatrixPattern(i:i+dotSize-1,j:j+dotSize-1) = color1;
        else MatrixPattern(i:i+dotSize-1,j:j+dotSize-1) = color2;
        end
    end
end