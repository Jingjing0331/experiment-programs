 function [angles,angToKeyboard,angRecord] = getArrowAngles(n,m)
% ��ȡ��ͷ�Ƕȵ��������
angles = [];          % ��ͷ�ĽǶ�����
angToKeyboard = [];   % �뷴Ӧ���Ӧ�ļ�������
angRecord =[];        % ����Ӧ���Ӧ�ļ�������ת��Ϊ�ַ������������¼ 
for i = 1:n
    for j = 1:m
        % ��ȡ����ĽǶ���
        angles(i,j) = 45 * randi(8);
        % ����ת�ĽǶ���С�����ϵ��������Ӧ
        switch angles(i,j)
            case 360 % ��ת360�㣬��0��
                angToKeyboard(i,j) = '6';
            case 45  % ��ת45��
                angToKeyboard(i,j) = '3';
            case 90  % ��ת90��
                angToKeyboard(i,j) = '2';
            case 135 % ��ת135��
                angToKeyboard(i,j) = '1';
            case 180 % ��ת180��
                angToKeyboard(i,j) = '4';
            case 225 % ��ת225��
                angToKeyboard(i,j) = '7';
            case 270 % ��ת270��
                angToKeyboard(i,j) = '8';
            case 315 % ��ת315��
                angToKeyboard(i,j) = '9';
        end
        angRecord = [angRecord,angToKeyboard(i,j)];
    end
end
