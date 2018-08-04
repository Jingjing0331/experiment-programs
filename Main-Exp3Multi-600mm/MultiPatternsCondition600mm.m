function MultiPatternsCondition600mm(subject,block)
% 掩蔽刺激为多个白噪音，位置与目标刺激相对应；显示器尺寸为268*360视距为60cm，Arabic digit高度为6.42mm
Screen('Preference', 'SkipSyncTests', 1);
try
    % 定义全局变量-------------------------------------------
    global screenNumber w wRect a b
    % 定义刺激颜色-------------------------------------------
    backgroundCol = [255*0.2,255*0.2,255*0.2];
    targetCol = [255*0.3,255*0.3,255*0.3];
    maskCol = [255*0.4,255*0.4,255*0.4];
    % 定义刺激大小-------------------------------------------
    textSize = 24;  % 阿拉伯数字的字号大小，高6.42mm
    textPixel = [21,27]; % 单个Pattern所截取的大小
    strokeSize = 3;      % 阿拉伯数字的笔画粗细
    space = 21;          % 字间距
    patternSize = [130,170];  % 整个Pattern Mask的大小，高*宽，在中心视角5°以内
    
    % 打开屏幕----------------------------------------------
    screenNumber = max(Screen('Screens'));
    Screen('Resolution',screenNumber,[1280],[960],[85]);
    [w,wRect] = Screen('OpenWindow',screenNumber,backgroundCol,[],32,2);
    Screen('TextSize',w,textSize);
    Screen('TextFont',w,'Arial');
    [a,b]=WindowCenter(w);
    HideCursor;
    
    % 当前系统的键盘按键的命名方案统一转换为MacOX-X系统--------
    KbName('UnifyKeyNames');
    % 限制按键范围-------------------------------------------
    RestrictKeysForKbCheck([96,97,98,99,100,101,102,103,104,105,8,13,27]);
    
    % 创建缓存屏幕-------------------------------------------
    [w1,w1Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w1 用于后台绘制目标刺激
    Screen('TextSize',w1,textSize);
    Screen('TextFont',w1,'Arial');
    [a1,b1]=WindowCenter(w1);
    [w2,w2Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w2 用于后台绘制掩蔽刺激
    [a2,b2]=WindowCenter(w2);
    [w3,w3Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2);  % offScreen w3 始终空屏，用于擦除w2画布上的图像
    %打开结果保存文件
    fid = fopen(['Results\','MultiPatterns600mm-',subject,'.txt'],'w');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Sub','ISI','MaskType','ReportType','CueDelay','RowCued','RowOriginal','DigitWhole','Mask','Response','NumCorrect','Accuracy','BackgroundCol','TargetCol','MaskCol','TargetDura','ISIDura','MaskDura','CueDura','BlockOrder','ResponseTime');
    
    % 定义时间参数-------------------------------------------
    frameRate = Screen('FrameRate',w);
    frameDura = 1000/frameRate;
    % 设定呈现帧数，计算呈现时间------------------------------
    fixFrames = 127;  % 注视点呈现120帧,1400ms
    targetFrames = 2; % 目标刺激呈现2帧,23.5ms
    blankFrames = 9;  % ISI，空屛呈现9帧,105.9ms
    maskFrames = 2;   % 掩蔽刺激呈现2帧,23.5ms
    cueDelayFrames = {'',1,38};  % 声音延迟时呈现的帧数
    cueDelay = {'',0,cueDelayFrames{3}*frameDura}; % 声音线索Cue的延迟时间 - 0ms 和 447ms
    % 计算呈现位置--------------------------------------------
    desFix = [a-1/2*textPixel(1),b-1/2*textPixel(2)];  % 注视点位置
    % 生成声音cue---------------------------------------------
    beep1 = MakeBeep(2500,0.5);  % 提示报告第一行
    beep2 = MakeBeep(850,0.5);   % 提示报告第二行
    beep3 = MakeBeep(200,0.5);   % 提示报告第三行
    Snd('Open');   % 打开音频通道
    % 定义不同实验条件的参数-----------------------------------
    maskType = 'PatternSingle';  % 掩蔽类型：单个的噪音掩蔽
    trialsPart = 60;  % 部分报告法block内重复60个trial（即每个cue delay重复60次）
    trialsWhole = 20; % 全部报告法block内重复20个trial
    ISI = 105.9;  % ISI, target-to-mask,105.9ms
    % 绘制多个textures需要的参数-------------------------------
    sourcerect = [];     % 每个小噪音在整个pattern上的位置
    destinationrect = [];% 每个小噪音绘制时的位置
    % 计算每个噪音刺激在整个pattern上截取的位置
    for i = 1:3
        for j = 1:4
            sourcerect = [sourcerect;(j-1)*textPixel(1),(i-1)*textPixel(2),j*textPixel(1),i*textPixel(2)];
        end
    end
    % 计算每个早刺激绘制时的位置
    for i = 1:3
        for j = 1:4
            destinationrect = [destinationrect;a-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1)),b-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2)),a-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1))+textPixel(1),b-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2))+textPixel(2)];
        end
    end
    
    
    %呈现主指导语----------------------------------------------
    generalIns_img = imread('Instructions\general.jpg'); %读取总指导语
    generalIns = Screen('MakeTexture',w,generalIns_img); %将图片转换为Texture
    Screen('DrawTexture',w,generalIns);
    Screen('Flip',w); %呈现总指导语
    KbWait;
    %释放所有按键，谨防卡住-------------------------------------
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prenvent CUP hogging
    end
    KbWait;
    
    for blockIndex = 1:3
        
        % Block1 全部报告法-------------------------------------------------
        if block(blockIndex) == 1
            % 呈现全部报告法指导语--------------------------------
            wholeIns_img = imread('Instructions\startW.jpg'); % 读取全部报告法指导语的图片
            wholeIns = Screen('MakeTexture',w,wholeIns_img);  % 将图片转化为Texture
            Screen('DrawTexture',w,wholeIns); % 呈现全部报告法的指导语
            Screen('Flip',w);
            % 释放所有按键，谨防卡住-------------------------------
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prenvent CUP hogging
            end
            KbWait;
            
            % 全部报告法的实验主体------------------------------------------
            for t = 1:trialsWhole
                % 获取目标刺激和掩蔽刺激的Matrix---------------------------
                [targetMatrix,targetSequence]=getNumMatrix(3,4);  % Target, 3*4数组
                patternMatrix = getPatternMatrix(backgroundCol(1),maskCol(1),strokeSize,patternSize); % Mask的整体噪音纹理
                % 提前绘制目标刺激----------------------------------------
                Screen('CopyWindow',w3,w1);  % 清空offscreens w1，用于绘制目标刺激
                % 在offscreen w1上绘制目标刺激，3*4数列-------------------
                for i = 1:3
                    for j = 1:4
                        Screen('DrawText',w1,targetMatrix(i,j),a1+2-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1)),b1-4-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2)),targetCol);
                    end
                end
                targetImg = Screen('GetImage',w1);                   % 获取已在w1上画好的目标刺激图片
                targetTexture = Screen('MakeTexture',w,targetImg);   % 获得的目标刺激图片转换为w上可呈现的Texture
                % 提前绘制掩蔽刺激
                patternTexture = Screen('MakeTexture',w,patternMatrix);  % 首先绘制整幅pattern，后续再进行定点切割
                
                % 刺激呈现-------------------------------------------------
                % 呈现“+”注视点--------------------------------------
                for r = 1:fixFrames
                    Screen('DrawText',w,'+',desFix(1),desFix(2),targetCol);
                    Screen('Flip',w);
                end
                % 呈现目标刺激 3*4数列-----------------------------------
                startTarget = GetSecs;
                for r = 1:targetFrames
                    Screen('DrawTexture',w,targetTexture);
                    Screen('Flip',w);
                end
                targetDura = GetSecs - startTarget;
                % 呈现空屏 ISI=100ms-------------------------------------
                startBlank = GetSecs;
                for r = 1:blankFrames
                    Screen('Flip',w);
                end
                blankDura = GetSecs - startBlank;
                % 呈现掩蔽刺激，多个白噪音---------------------------------
                startMask = GetSecs;
                for r = 1:maskFrames
                    Screen('DrawTextures',w,patternTexture,sourcerect',destinationrect');
                    Screen('Flip',w);
                end
                maskDura = GetSecs - startMask;
                % trial结束，呈现空屏------------------------------------
                Screen('Flip',w);
                
                % 反应获取-----------------------------------------------
                strRes = '';     % 被试反应的数列
                resTime = [];    % 记录被试的反应时间
                k = 0;
                while true
                    % 释放所有按键，谨防卡住------------------------------
                    keyisdown = 1;
                    while(keyisdown) % first wait until all keys are released
                        [keyisdown,secs,keycode] = KbCheck;
                        WaitSecs(0.001); % delay to prenvent CUP hogging
                    end           
                    % 记录按键反应-----------------------------------------
                    k=k+1;
                    [keyisdown,resTime(k),keycode] = KbCheck;  % 用KbCheck获取反应字符，！！！！！！getchar这没用的东西！！！！
                    index = find(keycode);
                    num = num2str(index-96);
                    if isempty(index)
                    else
                        switch(index)
                            case 13   % Enter键或Returen键
                                if length(strRes) < 12   % 被试反应不完全
                                    DrawFormattedText(w ,'输入不完整，请按"Enter"继续输入' , 'center', 'center', targetCol);
                                    Screen('Flip',w);
                                    %释放所有按键，谨防卡住
                                    keyisdown = 1;
                                    while(keyisdown) % first wait until all keys are released
                                        [keyisdown,secs,keycode] = KbCheck;
                                        WaitSecs(0.001); % delay to prenvent CUP hogging
                                    end  
                                    KbWait;
                                    DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                                    Screen('Flip',w);
                                else
                                    break;
                                end
                            case 8     % Backspace键
                                if ~isempty(strRes)
                                    strRes = strRes(1:length(strRes)-1);
                                    DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                                    Screen('Flip',w);
                                end
                            case 27   % escape键，用于退出
                                break
                            otherwise  % 记录反应
                                strRes = [strRes num];
                                DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                                Screen('Flip',w);
                        end
                    end
                end
                if index==27
                    break
                end
                
                % 反应记录------------------------------------------------
                [numCorrect,accuracy] = getAccuracy(targetSequence,strRes); % 计算正确率
                responseTime = resTime(k)-resTime(1);  % 记录被试反应时间
                % 写入文件------------------------------------------------
                fprintf(fid,'%s\t%d\t%s\t%s\t%s\t%d\t%s\t%s\t%s\t%s\t%d\t%6.2f\t%6.4f\t%6.4f\t%6.4f\t%6.6f\t%6.6f\t%6.6f\t%6.6f\t%d%d%d\t%6.6f\n',...
                    subject,ISI,maskType,'W','','','',targetSequence,'',strRes,numCorrect,accuracy,backgroundCol(1),targetCol(1),maskCol(1),...
                    targetDura,blankDura,maskDura,'',block(1),block(2),block(3),responseTime);
                % 10个trial之后，提示被试休息------------------------------
                if t == 10
                    DrawFormattedText(w , '请休息一会，按"Enter"继续', 'center', 'center', targetCol);
                    Screen('Flip',w);
                    % 释放所有按键，谨防卡住---------------------------
                    keyisdown = 1;
                    while(keyisdown) % first wait until all keys are released
                        [keyisdown,secs,keycode] = KbCheck;
                        WaitSecs(0.001); % delay to prenvent CUP hogging
                    end
                    KbWait;
                end
            end
            if index==27
                break
            end
            % 判断block结束，还是整个实验结束，呈现指导语-------------------
            if blockIndex == 3
                % 呈现实验结束指导语--------------------------------
                DrawFormattedText(w , '本轮实验已结束，谢谢参与。\n\n请呼叫主试', 'center', 'center', targetCol);
                Screen('Flip',w);
                % 释放所有按键，谨防卡住----------------------------
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            else
                % 呈现block结束指导语-------------------------
                DrawFormattedText(w , '本组实验已结束，请稍事休息。\n\n就绪后按"Enter"继续', 'center', 'center', targetCol);
                Screen('Flip',w);
                % 释放所有按键，谨防卡住
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            end
        end
        
        % Block2&3 -- 部分报告法，cue-delay = 0ms 或者447ms ----------------
        if block(blockIndex) == 2 | block(blockIndex) == 3 
            % 声音线索随机化，共60个trial，每行报告20次----------------------
            cuePosition = repmat([1,2,3],[1,20]);
            cuePosition = cuePosition(:,randperm(size(cuePosition,2)));
            % 呈现部分报告法指导语------------------------------------------
            partIns_img = imread('Instructions\startP.jpg'); % 读取全部报告法指导语的图片
            partIns = Screen('MakeTexture',w,partIns_img);  % 将图片转化为Texture
            Screen('DrawTexture',w,partIns); % 呈现全部报告法的指导语
            Screen('Flip',w);
            % 释放所有按键，谨防卡住----------------------------------------
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prenvent CUP hogging
            end
            KbWait;
            % 呈现声音线索演示----------------------------------------------
            DrawFormattedText(w ,'高音：报告第一行' , 'center', 'center', targetCol);
            Screen('Flip',w);
            Snd('Play',beep1);
            WaitSecs(1.5);
            DrawFormattedText(w ,'中音：报告第二行' , 'center', 'center', targetCol);
            Screen('Flip',w);
            Snd('Play',beep2);
            WaitSecs(1.5);
            DrawFormattedText(w ,'低音：报告第三行' , 'center', 'center', targetCol);
            Screen('Flip',w);
            Snd('Play',beep3);
            WaitSecs(1.5);
            DrawFormattedText(w,'演示已结束，请按"Enter"开始正式实验。','center','center',targetCol);
            Screen('Flip',w);
            % 释放所有按键，谨防卡住----------------------------------------
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prenvent CUP hogging
            end
            KbWait;
            
            % 部分报告法的实验主体------------------------------------------
            for t = 1:trialsPart
                % 获取目标刺激和掩蔽刺激的Matrix---------------------------
                [targetMatrix,targetSequence]=getNumMatrix(3,4);  % Target, 3*4数组
                patternMatrix = getPatternMatrix(backgroundCol(1),maskCol(1),strokeSize,patternSize); % Mask的整体噪音纹理
                % 提前绘制目标刺激----------------------------------------
                Screen('CopyWindow',w3,w1);  % 清空offscreens w1，用于绘制目标刺激
                % 在offscreen w1上绘制目标刺激，3*4数列-------------------
                for i = 1:3
                    for j = 1:4
                        Screen('DrawText',w1,targetMatrix(i,j),a1+2-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1)),b1-4-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2)),targetCol);
                    end
                end
                targetImg = Screen('GetImage',w1);                   % 获取已在w1上画好的目标刺激图片
                targetTexture = Screen('MakeTexture',w,targetImg);   % 获得的目标刺激图片转换为w上可呈现的Texture
                % 提前绘制掩蔽刺激
                patternTexture = Screen('MakeTexture',w,patternMatrix);  % 首先绘制整幅pattern，后续再进行定点切割
                
                % 刺激呈现-------------------------------------------------
                % 呈现“+”注视点--------------------------------------
                for r = 1:fixFrames
                    Screen('DrawText',w,'+',desFix(1),desFix(2),targetCol);
                    Screen('Flip',w);
                end
                % 呈现目标刺激 3*4数列-----------------------------------
                startTarget = GetSecs;
                for r = 1:targetFrames
                    Screen('DrawTexture',w,targetTexture);
                    Screen('Flip',w);
                end
                targetDura = GetSecs - startTarget;
                % 呈现空屏 ISI=100ms-------------------------------------
                startBlank = GetSecs;
                for r = 1:blankFrames
                    Screen('Flip',w);
                end
                blankDura = GetSecs - startBlank;
                % 呈现掩蔽刺激，多个白噪音---------------------------------
                startMask = GetSecs;
                for r = 1:maskFrames
                    Screen('DrawTextures',w,patternTexture,sourcerect',destinationrect');
                    Screen('Flip',w);
                end
                maskDura = GetSecs - startMask;
                
                %一个trial结束，呈现空屏，两种Cue-Delay的呈现帧数不同，0ms：1帧；450ms：根据计算结果
                cueStart = GetSecs;
                for r = 1:cueDelayFrames{block(blockIndex)}
                    Screen('Flip',w);
                end
                cueDura = GetSecs - cueStart;
                
                % 呈现声音刺激，50ms，提示需报告的行数---------------------
                switch cuePosition(t)
                    case 1   % 2.5k Hz 报告第一行
                        Snd('Play',beep1);
                    case 2   % 850 Hz 报告第二行
                        Snd('Play',beep2);
                    case 3   % 200 Hz 报告第三行
                        Snd('Play',beep3);
                end
                
                % 反应获取-----------------------------------------------
                strRes = '';     % 被试反应的数列
                resTime = [];    % 记录被试的反应时间
                k = 0;
                while true
                    % 释放所有按键，谨防卡住------------------------------
                    keyisdown = 1;
                    while(keyisdown) % first wait until all keys are released
                        [keyisdown,secs,keycode] = KbCheck;
                        WaitSecs(0.001); % delay to prenvent CUP hogging
                    end           
                    % 记录按键反应-----------------------------------------
                    k=k+1;
                    [keyisdown,resTime(k),keycode] = KbCheck;  % 用KbCheck获取反应字符，！！！！！！getchar这没用的东西！！！！
                    index = find(keycode);
                    num = num2str(index-96);
                    if isempty(index)
                    else
                        switch(index)
                            case 13   % Enter键或Returen键
                                if length(strRes) < 4   % 被试反应不完全
                                    DrawFormattedText(w ,'输入不完整，请按"Enter"继续输入' , 'center', 'center', targetCol);
                                    Screen('Flip',w);
                                    % 释放所有按键，谨防卡住
                                    keyisdown = 1;
                                    while(keyisdown) % first wait until all keys are released
                                        [keyisdown,secs,keycode] = KbCheck;
                                        WaitSecs(0.001); % delay to prenvent CUP hogging
                                    end  
                                    KbWait;
                                    DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                                    Screen('Flip',w);
                                else
                                    break;
                                end
                            case 8     % Backspace键
                                if ~isempty(strRes)
                                    strRes = strRes(1:length(strRes)-1);
                                    DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                                    Screen('Flip',w);
                                end
                            case 27   % escape键，用于退出
                                break
                            otherwise  % 记录反应
                                strRes = [strRes num];
                                DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                                Screen('Flip',w);
                        end
                    end
                end
                if index==27
                    break
                end
                
                % 反应记录
                rowOriginal = targetMatrix(cuePosition(t),:);
                [numCorrect,accuracy] = getAccuracy(rowOriginal,strRes); % 计算正确率
                numCorrect = numCorrect*3;
                responseTime = resTime(k)-resTime(1); % 记录被试反应时间
                % 写入文件
                fprintf(fid,'%s\t%d\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s\t%d\t%6.2f\t%6.4f\t%6.4f\t%6.4f\t%6.6f\t%6.6f\t%6.6f\t%6.6f\t%d%d%d\t%6.6f\n',...
                    subject,ISI,maskType,'P',cueDelay{block(blockIndex)},cuePosition(t),rowOriginal,targetSequence,'',strRes,numCorrect,accuracy,...
                    backgroundCol(1),targetCol(1),maskCol(1),targetDura,blankDura,maskDura,cueDura,block(1),block(2),block(3),responseTime);
                % 20个trial之后，提示被试休息-------------------------------
                if t == 20 | t == 40
                    DrawFormattedText(w , '请休息一会.\n\n按"Enter"听提示音演示', 'center', 'center', targetCol);
                    Screen('Flip',w);
                    % 释放所有按键，谨防卡住--------------------------------
                    keyisdown = 1;
                    while(keyisdown) % first wait until all keys are released
                        [keyisdown,secs,keycode] = KbCheck;
                        WaitSecs(0.001); % delay to prenvent CUP hogging
                    end
                    KbWait;
                    % 呈现声音线索演示-------------------------------------
                    DrawFormattedText(w ,'高音：报告第一行' , 'center', 'center', targetCol);
                    Screen('Flip',w);
                    Snd('Play',beep1);
                    WaitSecs(1.5);
                    DrawFormattedText(w ,'中音：报告第二行' , 'center', 'center', targetCol);
                    Screen('Flip',w);
                    Snd('Play',beep2);
                    WaitSecs(1.5);
                    DrawFormattedText(w ,'低音：报告第三行' , 'center', 'center', targetCol);
                    Screen('Flip',w);
                    Snd('Play',beep3);
                    WaitSecs(1.5);
                    DrawFormattedText(w,'演示已结束，请按"Enter"开始正式实验。','center','center',targetCol);
                    Screen('Flip',w);
                    % 释放所有按键，谨防卡住-------------------------------
                    keyisdown = 1;
                    while(keyisdown) % first wait until all keys are released
                        [keyisdown,secs,keycode] = KbCheck;
                        WaitSecs(0.001); % delay to prenvent CUP hogging
                    end
                    KbWait;
                end
            end
            if index==27
                    break
            end
            % 判断block结束，还是整个实验结束，呈现指导语--------------------
            if blockIndex == 3
                % 呈现实验结束指导语---------------------------------------
                DrawFormattedText(w , '本轮实验已结束，谢谢参与。\n\n请呼叫主试', 'center', 'center', targetCol);
                Screen('Flip',w);
                % 释放所有按键，谨防卡住------------------------------------
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            else
                % 呈现block结束指导语--------------------------------------
                DrawFormattedText(w , '本组实验结束，请稍事休息。\n\n就绪后按"Enter"继续', 'center', 'center', targetCol);
                Screen('Flip',w);
                % 释放所有按键，谨防卡住------------------------------------
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            end
        end
    end
    
    
    %关闭屏幕--------------------------------------
    Screen('Close',w);
    %关闭音频通道-----------------------------------
    Snd('Close');
    %关闭数据文件-----------------------------------
    fclose(fid);
    %显示光标--------------------------------------
    ShowCursor;



catch
    Screen('Closeall')
    rethrow(lasterror)
end