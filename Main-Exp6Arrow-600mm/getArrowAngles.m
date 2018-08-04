 function [angles,angToKeyboard,angRecord] = getArrowAngles(n,m)
% 获取箭头角度的随机数组
angles = [];          % 箭头的角度数组
angToKeyboard = [];   % 与反应相对应的键盘数字
angRecord =[];        % 将反应相对应的键盘数字转换为字符串方便输出记录 
for i = 1:n
    for j = 1:m
        % 获取随机的角度数
        angles(i,j) = 45 * randi(8);
        % 将旋转的角度与小键盘上的数字相对应
        switch angles(i,j)
            case 360 % 旋转360°，即0°
                angToKeyboard(i,j) = '6';
            case 45  % 旋转45°
                angToKeyboard(i,j) = '3';
            case 90  % 旋转90°
                angToKeyboard(i,j) = '2';
            case 135 % 旋转135°
                angToKeyboard(i,j) = '1';
            case 180 % 旋转180°
                angToKeyboard(i,j) = '4';
            case 225 % 旋转225°
                angToKeyboard(i,j) = '7';
            case 270 % 旋转270°
                angToKeyboard(i,j) = '8';
            case 315 % 旋转315°
                angToKeyboard(i,j) = '9';
        end
        angRecord = [angRecord,angToKeyboard(i,j)];
    end
end
