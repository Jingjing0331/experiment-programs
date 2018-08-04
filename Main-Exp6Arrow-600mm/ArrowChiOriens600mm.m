function ArrowChiOriens600mm(subject,serialNum)
% 目标刺激为→，掩蔽刺激为中文的“上下左右”

try
   
    Screen('Preference','SkipSyncTests',1);
   
    % 定义全局变量----------------------------
    global screenNumber w wRect a b 
    % 定义刺激颜色----------------------------
    backgroundCol = [255*0.2,255*0.2,255*0.2];
    targetCol = [255*0.3,255*0.3,255*0.3];
    maskCol = [255*0.4,255*0.4,255*0.4];
    % 定义刺激大小----------------------------
    textSize = 24;       % 文本刺激的大小（该condition下只有“+”）
    textPixel = [16,23]; % 文本刺激的像素大小
    strokeSize = 3;      % 文本刺激的笔画粗细
    space = 21;          % 字间距
    
    % 打开屏幕-------------------------------
    screenNumber=max(Screen('Screens'));
    Screen('Resolution', screenNumber, [1280], [960], [85]);
    [w, wRect]=Screen('OpenWindow',screenNumber,backgroundCol,[],32,2);
    Screen('TextSize',w,textSize);
    Screen('TextFont',w,'Arial');
    [a,b]=WindowCenter(w);
    HideCursor;
    
    % 当前系统的键盘按键的命名方案统一转换为MacOX-X系统
    KbName('UnifyKeyNames');
    % 限制按键范围：【1,2,3,4,6,7,8,9】、Backspace、Return、ESCAPE
    RestrictKeysForKbCheck([97,98,99,100,102,103,104,105,8,13,27]);
    
    % 创建缓存屏幕-----------------------------
    [w1,w1Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w1 用于后台绘制目标刺激
    [a1,b1]=WindowCenter(w1);
    [w2,w2Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w2 用于后台绘制掩蔽刺激
    [a2,b2]=WindowCenter(w2);
    [w3,w3Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w3 始终空屏，用于擦除w1w2画布上的图像
    
    % 打开结果保存文件
    currentTime = datestr(now());
    currentTime(currentTime == ':') = '_';
    fid = fopen(['Results\',currentTime,'ArrowOriens600mm-',subject,'.txt'],'w');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Sub','ISI','MaskType','ReportType','CueDelay','RowCued','TargetOriginal','DigitWhole','Mask','Response','NumCorrect','Accuracy','BackgroundCol','TargetCol','MaskCol','TargetDura','ISIDura','MaskDura','CueDura','BlockOrder','ResponseTime');
    
    % 定义时间参数--------------------------------
    frameRate = Screen('FrameRate',w);
    frameDura = 1000/frameRate;
    % 设定呈现帧数--------------------------------
    fixFrames = 127;  % 注视点呈现120帧,1400ms
    targetFrames = 2; % 目标刺激呈现2帧,23.5ms
    blankFrames = 9;  % ISI，空屛呈现9帧,105.9ms
    maskFrames = 2;   % 掩蔽刺激呈现2帧,23.5ms
    cueDelayFrames = [1,38];  % 声音延迟时呈现的帧数
    cueDelay = [0,cueDelayFrames(2)*frameDura]; % 声音线索Cue的延迟时间 - 0ms 和 447ms
    % 计算注视点的呈现位置--------------------------
    desFix = [a-1/2*textPixel(1),b-1/2*textPixel(2)];  
    % 生成声音cue----------------------------------
    beep1 = MakeBeep(2500,0.5);  % 提示报告第一行
    beep2 = MakeBeep(850,0.5);   % 提示报告第二行
    beep3 = MakeBeep(200,0.5);   % 提示报告第三行
    Snd('Open');   % 打开音频通道
    
    % 定义实验条件的参数----------------------------
    maskType = 'ChiOriens';  % 掩蔽类型：单个的噪音掩蔽
    trialsPart = 60;  % 部分报告法block内重复60个trial（即每个cue delay重复60次）
    ISI = 105.9;  % ISI, target-to-mask,105.9ms
    % 计算block的呈现顺序
    if serialNum / 2 == 0
        orderBlock = [1,2];
    else
        orderBlock = [2,1];
    end 
    % 不同刺激的微调参数
    ajustArrow = [-4,5] % 每个箭头所需微调的参数（与之前实验的阿拉伯数字对齐）
    widthArrow = 25;
    heightArrow = 25;
    ajustChi = [-4,2];  % 每个中文所需微调的参数
    % 将键盘上反应按键转换为相应的角度数的矩阵
    KeyToAngles = [135,90,45,180,0,360,225,270,315];
    
    % 进行绘制刺激的准备工作--------------------------
    % 绘制目标刺激--------------------------------
    arrowImg = imread('pics\arrow.jpg');  % 读取箭头图片
    arrowTexture = Screen('MakeTexture',w,arrowImg); % 将获取的图片绘制到offscreen w1上
    
    % 读取指导语-----------------------------------------------
    welcome_img = imread('pics\welcome.jpg');              % 读取‘welcome’图片
    welcome_texture = Screen('MakeTexture',w,welcome_img); % 将读取的图片转换为Texture
    cueIns_img = imread('pics\InstructionsCue.jpg');       % 读取部分报告法指导语图片
    cueIns_texture = Screen('MakeTexture',w,cueIns_img);   % 将读取的图片转换为Texture
    % 呈现指导语-----------------------------------------------
    Screen('DrawTexture',w,welcome_texture);               % 呈现‘welcome’指导语
    Screen('Flip',w);
    % 释放所有按键，谨防卡住-------------------------------------
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prenvent CUP hogging
    end
    KbWait;
    Screen('DrawTexture',w,cueIns_texture);                % 呈现部分报告法指导语
    Screen('Flip',w);
    % 释放所有按键，谨防卡住-------------------------------------
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prenvent CUP hogging
    end
    KbWait;
    
    % 开始正式实验
    for indexBlock = 1:2
        
        % 声音线索随机化，共60个trial，每行报告20次---------------
        cuePosition = repmat([1,2,3],[1,20]);
        cuePosition = cuePosition(:,randperm(size(cuePosition,2)));
        
        % 呈现声音线索演示---------------------------------------
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
        % 释放所有按键，谨防卡住-------------------------------------
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prenvent CUP hogging
        end
        KbWait;
        
        % 实验主体
        for t = 1:trialsPart
            % 获取目标刺激——箭头的角度数+相对应的正确反应键盘按键
            [targetArrowAngles,targetArrowKeys,targetArrowRecord] = getArrowAngles(3,4);           
            % 提前绘制目标刺激----------------------------------------
            Screen('CopyWindow',w3,w1);  % 清空offScreen w1，用于绘制目标刺激
            % offScreen w1上绘制3*4的箭头刺激------------------
            for i = 1:3
                for j = 1:4
                    % 计算每个箭头的呈现位置
                    x_1 = a1-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1))+ajustArrow(1);
                    y_1 = b1-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2))+ajustArrow(2);
                    x_2 = x_1 + widthArrow;
                    y_2 = y_1 + heightArrow;
                    % 绘制箭头
                    Screen('DrawTexture',w1,arrowTexture,[],[x_1,y_1,x_2,y_2],[targetArrowAngles(i,j)],[],0);
                end
            end
            % 获取已在w1上画好的目标刺激图片
            targetImg = Screen('GetImage',w1);
            % 获得的目标刺激图片转换为w上可呈现的Texture
            targetTexture = Screen('MakeTexture',w,targetImg);
            
            % 获取掩蔽刺激——3*4的中文方位词：上下左右
            [maskChiOriens,maskRecord] = getChiOriens(3,4);
            % 提前绘制掩蔽刺激----------------------------------
            Screen('CopyWindow',w3,w2); % 清空offscreen w2，用于绘制掩蔽刺激
            % offscreen w2上绘制3*4的中文方位词
            for i = 1:3
                for j = 1:4
                    % 计算每个中文的呈现位置
                    x = a2-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1))+ajustChi(1);
                    y = b2-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2))+ajustChi(2);
                    Screen('DrawText',w2,maskChiOriens(i,j),x,y,maskCol);
                end
            end
            % 获取已在w2上画好的掩蔽刺激
            maskImg = Screen('GetImage',w2);
            % 获得的掩蔽刺激图片转换为w上可呈现的Texture
            maskTexture = Screen('MakeTexture',w,maskImg);
            
            
            % 刺激呈现------------------------------------------------
            % 呈现“+”注视点
            for r = 1:fixFrames
                Screen('DrawText',w,'+',desFix(1),desFix(2),targetCol);
                Screen('Flip',w);
            end
            % 呈现目标刺激，3*4箭头
            startTarget = GetSecs;
            for r = 1:targetFrames
                Screen('DrawTexture',w,targetTexture);
                Screen('Flip',w);
            end
            targetDura = GetSecs - startTarget;
            % 呈现空屏 ISI=105.9ms
            startBlank = GetSecs;
            for r = 1:blankFrames
                Screen('Flip',w);
            end
            blankDura = GetSecs - startBlank;
            % 呈现掩蔽刺激，中文的方位词
            startMask = GetSecs;
            for r = 1:maskFrames
                Screen('DrawTexture',w,maskTexture);
                Screen('Flip',w);
            end
            maskDura = GetSecs - startMask;
            
            % 一个trial结束，呈现不同的delayed cue-----------------------
            % 空屏等待不同的cue-delay
            cueStart = GetSecs;
            for r = 1:cueDelayFrames(orderBlock(indexBlock))
                Screen('Flip',w);
            end
            cueDura = GetSecs -cueStart;
            % 呈现声音cue，50ms，提示需报告的行数
            switch cuePosition(t)
                case 1   % 2.5k Hz，报告第一行
                    Snd('Play',beep1);
                case 2   % 850 Hz，报告第二行
                    Snd('Play',beep2);
                case 3   % 200 Hz，报告第三行
                    Snd('Play',beep3);
            end
            
            % 反应获取-------------------------------------------------
            strRes = [];            % 记录被试反应，字符串，方便输出
            matrixRes = [];         % 记录被试反应，数字，方便提取角度数据
            resTime = [];           % 记录被试的反应时间
            k = 0;
            % 反应记录循环
            while true
                % 释放所有按键，谨防卡住
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end  
                % 记录按键反应
                k = k + 1;
                [keyisdown,resTime(k),keycode] = KbCheck; % 得到一串keycode0/1
                index = find(keycode,1);                  % 找到被按下的键(值为1），且只返回排位最靠前的，防止switch出错
                num = index-96;
                if isempty(index)
                else
                    switch(index)     % 判断反应按键
                        % Enter或者Return键------------------------------------
                        case 13       
                            if length(strRes) == 4 % 被试输入的反应数目正确
                                break;
                            else
                                % 被试输入的反应数目过多或过少
                                DrawFormattedText(w,'输入个数不对，请按任意键继续修改输入','center','center',targetCol);
                                Screen('Flip',w);
                                % 释放所有按键，谨防卡住------------------------------
                                keyisdown = 1;
                                while(keyisdown) % first wait until all keys are released
                                    [keyisdown,secs,keycode] = KbCheck;
                                    WaitSecs(0.001); % delay to prenvent CUP hogging
                                end   
                                KbWait;
                                for n = 1:length(strRes)
                                    xRes_1 = a-3/2*space-2*textPixel(1)+(n-1)*(space+textPixel(1));
                                    yRes_1 = b-1/2*textPixel(2);
                                    xRes_2 = xRes_1 + textPixel(1);
                                    yRes_2 = yRes_1 + textPixel(2);
                                    Screen('DrawTexture',w,arrowTexture,[],[xRes_1,yRes_1,xRes_2,yRes_2],[KeyToAngles(matrixRes(n))],[],0);
                                end
                                Screen('Flip',w);                        
                            end
                        % Backspace键，删除------------------------------------
                        case 8
                            if ~isempty(strRes)
                                strRes = strRes(1:length(strRes)-1);
                                for n = 1:length(strRes)
                                    xRes_1 = a-3/2*space-2*textPixel(1)+(n-1)*(space+textPixel(1));
                                    yRes_1 = b-1/2*textPixel(2);
                                    xRes_2 = xRes_1 + textPixel(1);
                                    yRes_2 = yRes_1 + textPixel(2);
                                    Screen('DrawTexture',w,arrowTexture,[],[xRes_1,yRes_1,xRes_2,yRes_2],[KeyToAngles(matrixRes(n))],[],0);
                                end
                                Screen('Flip',w);
                            end
                        % ESCAPE键，用于退出，所有的循环后都要加一个if判断语句
                        case 27
                            break
                        % 其他的数字键，记录反应
                        otherwise
                            strRes = [strRes num2str(num)];  
                            matrixRes = [matrixRes num];
                            for n = 1:length(strRes)
                                xRes_1 = a-3/2*space-2*textPixel(1)+(n-1)*(space+textPixel(1));
                                yRes_1 = b-1/2*textPixel(2);
                                xRes_2 = xRes_1 + textPixel(1);
                                yRes_2 = yRes_1 + textPixel(2);
                                Screen('DrawTexture',w,arrowTexture,[],[xRes_1,yRes_1,xRes_2,yRes_2],[KeyToAngles(matrixRes(n))],[],0);
                            end
                            Screen('Flip',w);
                    end
                end
            end
            % 退出
            if index == 27
                break
            end
            
            % 记录被试反应------------------------------------------------
            arrowRowOriginal = targetArrowKeys(cuePosition(t),:);
            % 计算正确率
            [numCorrect,accuracy] = getAccuracy(arrowRowOriginal,strRes);
            numCorrect = numCorrect * 3;
            % 计算被试的反应时间
            responseTime = resTime(k)-resTime(1);
            % 写入文件
            fprintf(fid,'%s\t%d\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s\t%d\t%6.2f\t%6.4f\t%6.4f\t%6.4f\t%6.6f\t%6.6f\t%6.6f\t%6.6f\t%d%d\t%6.6f\n',...
                    subject,ISI,maskType,'P',cueDelay(orderBlock(indexBlock)),cuePosition(t),arrowRowOriginal,targetArrowRecord,maskRecord,strRes,numCorrect,accuracy,...
                    backgroundCol(1),targetCol(1),maskCol(1),targetDura,blankDura,maskDura,cueDura,orderBlock(1),orderBlock(2),responseTime);
            % 一个完整的trial结束------------------------------------------------------
            
            % 20个trial之后，提示被试休息---------------------------------
            if t == 20 | t == 40
                DrawFormattedText(w , '请休息一会.\n\n按"Enter"听提示音演示', 'center', 'center', targetCol);
                Screen('Flip',w);
                % 释放所有按键，谨防卡住---------------------------
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
                % 呈现声音线索演示---------------------------------
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
                % 释放所有按键，谨防卡住---------------------------
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            end
        end
        % 退出
        if index == 27
            break
        end
        
        % 判断block结束，还是整个实验结束，呈现相应指导语-------------------
        if indexBlock == 2
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

%关闭屏幕--------------------------------------
Screen('Close',w);
Screen('Closeall');
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