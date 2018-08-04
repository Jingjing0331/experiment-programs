
Screen('Preference', 'SkipSyncTests', 1);
% ����ȫ�ֱ���
global screenNumber w wRect a b

%����̼���ɫ-----------------------------------------
backgroundCol = [255*0.2,255*0.2,255*0.2];
targetCol = [255*0.3,255*0.3,255*0.3];

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
spaceV = 21;   
spaceH = 21;
% ����ע�ӵ�ĳ���λ��--------------------------
desFix = [a-1/2*textPixel(1),b-1/2*textPixel(2)];  

arrowImg = imread('pics\arrow.jpg');
texid = Screen('MakeTexture',w,arrowImg);

for i = 1:3
    for j = 1:4
        x = a-3/2*spaceV-2*textPixel(1)+(j-1)*(spaceV+textPixel(1));
        y = b-spaceH-3/2*textPixel(2)+(i-1)*(spaceH+textPixel(2));
        x_1 = x+spaceV;
        y_1 = y+spaceH;
        ang = 45 * randi(8);
        Screen('DrawTexture',w,texid,[],[x,y,x_1,y_1],[ang],[],0);
    end
end

%��offscreen w1�ϻ���Ŀ��̼���3*4����-----------------------------------
for i = 1:3
    for j = 1:4
        Screen('DrawText',w,'8',a-3/2*spaceV-2*textPixel(1)+(j-1)*(spaceV+textPixel(1)),b-spaceH-3/2*textPixel(2)+(i-1)*(spaceH+textPixel(2)),targetCol);
    end
end

Screen('DrawText',w,'+',desFix(1),desFix(2),targetCol);

Screen('Flip',w);
KbWait;

 %�ر���Ļ--------------------------------------
Screen('Close',w);
%��ʾ���
ShowCursor;