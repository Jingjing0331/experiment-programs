Screen('Preference', 'SkipSyncTests', 1);
% 定义全局变量
global screenNumber w wRect a b

%定义刺激颜色-----------------------------------------
backgroundCol = [255*0.2,255*0.2,255*0.2];
targetCol = [255*0.3,255*0.3,255*0.3];
maskCol = [255*0.4,255*0.4,255*0.4];

 %打开屏幕-------------------------------------
screenNumber=max(Screen('Screens'));

Screen('Resolution', screenNumber, [1280], [960], [60]);
[w, wRect]=Screen('OpenWindow',screenNumber,backgroundCol,[],32,2);
[a,b]=WindowCenter(w);
textSize = 23;
Screen('TextSize',w,textSize);
Screen('TextFont',w,'宋体');
HideCursor;

textPixel = [16,23]; 
space = 21;      
strokeSize = 3;      % 文本刺激的笔画粗细
patternSize = [130,170]; % 整个Noise Mask的大小，高*宽，在中心视角5°以内

arrowImg = imread('pics\arrow.jpg');
texid = Screen('MakeTexture',w,arrowImg);

 % 获取掩蔽刺激——3*4的中文方位词：上下左右
[maskChiOriens,maskRecord] = getChiOriens(3,4);
% o绘制3*4的中文方位词
for i = 1:3
    for j = 1:4
        % 计算每个中文的呈现位置
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

 %关闭屏幕--------------------------------------
Screen('Close',w);
%显示光标
ShowCursor;