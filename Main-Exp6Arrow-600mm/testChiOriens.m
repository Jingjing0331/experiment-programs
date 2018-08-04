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
textSize = 23;
Screen('TextSize',w,textSize);
Screen('TextFont',w,'����');
HideCursor;

textPixel = [16,23]; 
space = 21;      
strokeSize = 3;      % �ı��̼��ıʻ���ϸ
patternSize = [130,170]; % ����Noise Mask�Ĵ�С����*���������ӽ�5������

arrowImg = imread('pics\arrow.jpg');
texid = Screen('MakeTexture',w,arrowImg);

 % ��ȡ�ڱδ̼�����3*4�����ķ�λ�ʣ���������
[maskChiOriens,maskRecord] = getChiOriens(3,4);
% o����3*4�����ķ�λ��
for i = 1:3
    for j = 1:4
        % ����ÿ�����ĵĳ���λ��
        x = a-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1));
        y = b-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2));
        Screen('DrawText',w
        ,maskChiOriens(i,j),x,y,maskCol);
    end
end

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