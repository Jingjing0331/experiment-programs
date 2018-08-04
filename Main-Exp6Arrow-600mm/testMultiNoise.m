
Screen('Preference', 'SkipSyncTests', 1);
% ����ȫ�ֱ���
global screenNumber w wRect a b

%����̼���ɫ-----------------------------------------
backgroundCol = [255*0.2,255*0.2,255*0.2];
targetCol = [255*0.3,255*0.3,255*0.3];
maskCol = [255*0.4,255*0.4,255*0.4];

 %����Ļ-------------------------------------
screenNumber=max(Screen('Screens'));

Screen('Resolution', screenNumber, [1280], [960], [60]);
[w, wRect]=Screen('OpenWindow',screenNumber,backgroundCol,[],32,2);
[a,b]=WindowCenter(w);
textSize = 24;
Screen('TextSize',w,textSize);
Screen('TextFont',w,'Arial');
HideCursor;

textPixel = [16,23]; 
space = 21;      
strokeSize = 3;      % �ı��̼��ıʻ���ϸ
patternSize = [130,170]; % ����Noise Mask�Ĵ�С����*���������ӽ�5������

arrowImg = imread('pics\arrow.jpg');
texid = Screen('MakeTexture',w,arrowImg);



% �����ڱδ̼�Noise---------------------------
sourcerect = [];     % ÿ��С����������pattern�ϵ�λ��
destinationrect = [];% ÿ��С��������ʱ��λ��
width = 16;  % ����noise�Ŀ��
height = 23
; % ����noise�ĸ߶�
% ����ÿ�������̼�������pattern�Ͻ�ȡ��λ��-----
for i = 1:3
    for j = 1:4
        sourcerect = [sourcerect;(j-1)*width,(i-1)*height,j*width,i*height];
    end
end
% ����ÿ���̼�����ʱ��λ��--------------------
for i = 1:3
    for j = 1:4
        x_1 = a-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1));
        y_1 = b-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2));
        x_2 = x_1 + width;
        y_2 = y_1 + height;
        destinationrect = [destinationrect;x_1,y_1,x_2,y_2];
    end
end

% ��ȡ�ڱδ̼���������Noise Mask����������
maskNoise = getPatternMatrix(backgroundCol(1),maskCol(1),strokeSize,patternSize);
% ��ǰ���������ڱδ̼���pattern����������ʱ�ٽ��ж����и�
maskNoiseTexture = Screen('MakeTexture',w,maskNoise);
Screen('DrawTextures',w,maskNoiseTexture,sourcerect',destinationrect');

for i = 1:3
    for j = 1:4
        x = a-3/2*space-2*textPixel(1)+(j-1)*(spaceV+textPixel(1));
        y = b-space-3/2*textPixel(2)+(i-1)*(spaceH+textPixel(2));
        x_1 = x+space;
        y_1 = y+space;
        ang = 45 * randi(8);
        Screen('DrawTexture',w,texid,[],[x,y,x_1,y_1],[ang],[],0);
    end
end


Screen('Flip',w);
KbWait;

 %�ر���Ļ--------------------------------------
Screen('Close',w);
%��ʾ���
ShowCursor;