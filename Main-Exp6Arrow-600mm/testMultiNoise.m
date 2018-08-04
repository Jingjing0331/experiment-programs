
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
textSize = 24;
Screen('TextSize',w,textSize);
Screen('TextFont',w,'Arial');
HideCursor;

textPixel = [16,23]; 
space = 21;      
strokeSize = 3;      % 文本刺激的笔画粗细
patternSize = [130,170]; % 整个Noise Mask的大小，高*宽，在中心视角5°以内

arrowImg = imread('pics\arrow.jpg');
texid = Screen('MakeTexture',w,arrowImg);



% 绘制掩蔽刺激Noise---------------------------
sourcerect = [];     % 每个小噪音在整个pattern上的位置
destinationrect = [];% 每个小噪音绘制时的位置
width = 16;  % 单个noise的宽度
height = 23
; % 单个noise的高度
% 计算每个噪音刺激在整个pattern上截取的位置-----
for i = 1:3
    for j = 1:4
        sourcerect = [sourcerect;(j-1)*width,(i-1)*height,j*width,i*height];
    end
end
% 计算每个刺激绘制时的位置--------------------
for i = 1:3
    for j = 1:4
        x_1 = a-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1));
        y_1 = b-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2));
        x_2 = x_1 + width;
        y_2 = y_1 + height;
        destinationrect = [destinationrect;x_1,y_1,x_2,y_2];
    end
end

% 获取掩蔽刺激——整个Noise Mask的噪音纹理
maskNoise = getPatternMatrix(backgroundCol(1),maskCol(1),strokeSize,patternSize);
% 提前绘制整幅掩蔽刺激的pattern，后续呈现时再进行定点切割
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

 %关闭屏幕--------------------------------------
Screen('Close',w);
%显示光标
ShowCursor;