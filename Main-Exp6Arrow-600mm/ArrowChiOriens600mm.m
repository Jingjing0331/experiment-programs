function ArrowChiOriens600mm(subject,serialNum)
% Ŀ��̼�Ϊ�����ڱδ̼�Ϊ���ĵġ��������ҡ�

try
   
    Screen('Preference','SkipSyncTests',1);
   
    % ����ȫ�ֱ���----------------------------
    global screenNumber w wRect a b 
    % ����̼���ɫ----------------------------
    backgroundCol = [255*0.2,255*0.2,255*0.2];
    targetCol = [255*0.3,255*0.3,255*0.3];
    maskCol = [255*0.4,255*0.4,255*0.4];
    % ����̼���С----------------------------
    textSize = 24;       % �ı��̼��Ĵ�С����condition��ֻ�С�+����
    textPixel = [16,23]; % �ı��̼������ش�С
    strokeSize = 3;      % �ı��̼��ıʻ���ϸ
    space = 21;          % �ּ��
    
    % ����Ļ-------------------------------
    screenNumber=max(Screen('Screens'));
    Screen('Resolution', screenNumber, [1280], [960], [85]);
    [w, wRect]=Screen('OpenWindow',screenNumber,backgroundCol,[],32,2);
    Screen('TextSize',w,textSize);
    Screen('TextFont',w,'Arial');
    [a,b]=WindowCenter(w);
    HideCursor;
    
    % ��ǰϵͳ�ļ��̰�������������ͳһת��ΪMacOX-Xϵͳ
    KbName('UnifyKeyNames');
    % ���ư�����Χ����1,2,3,4,6,7,8,9����Backspace��Return��ESCAPE
    RestrictKeysForKbCheck([97,98,99,100,102,103,104,105,8,13,27]);
    
    % ����������Ļ-----------------------------
    [w1,w1Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w1 ���ں�̨����Ŀ��̼�
    [a1,b1]=WindowCenter(w1);
    [w2,w2Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w2 ���ں�̨�����ڱδ̼�
    [a2,b2]=WindowCenter(w2);
    [w3,w3Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w3 ʼ�տ��������ڲ���w1w2�����ϵ�ͼ��
    
    % �򿪽�������ļ�
    currentTime = datestr(now());
    currentTime(currentTime == ':') = '_';
    fid = fopen(['Results\',currentTime,'ArrowOriens600mm-',subject,'.txt'],'w');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Sub','ISI','MaskType','ReportType','CueDelay','RowCued','TargetOriginal','DigitWhole','Mask','Response','NumCorrect','Accuracy','BackgroundCol','TargetCol','MaskCol','TargetDura','ISIDura','MaskDura','CueDura','BlockOrder','ResponseTime');
    
    % ����ʱ�����--------------------------------
    frameRate = Screen('FrameRate',w);
    frameDura = 1000/frameRate;
    % �趨����֡��--------------------------------
    fixFrames = 127;  % ע�ӵ����120֡,1400ms
    targetFrames = 2; % Ŀ��̼�����2֡,23.5ms
    blankFrames = 9;  % ISI���Ռγ���9֡,105.9ms
    maskFrames = 2;   % �ڱδ̼�����2֡,23.5ms
    cueDelayFrames = [1,38];  % �����ӳ�ʱ���ֵ�֡��
    cueDelay = [0,cueDelayFrames(2)*frameDura]; % ��������Cue���ӳ�ʱ�� - 0ms �� 447ms
    % ����ע�ӵ�ĳ���λ��--------------------------
    desFix = [a-1/2*textPixel(1),b-1/2*textPixel(2)];  
    % ��������cue----------------------------------
    beep1 = MakeBeep(2500,0.5);  % ��ʾ�����һ��
    beep2 = MakeBeep(850,0.5);   % ��ʾ����ڶ���
    beep3 = MakeBeep(200,0.5);   % ��ʾ���������
    Snd('Open');   % ����Ƶͨ��
    
    % ����ʵ�������Ĳ���----------------------------
    maskType = 'ChiOriens';  % �ڱ����ͣ������������ڱ�
    trialsPart = 60;  % ���ֱ��淨block���ظ�60��trial����ÿ��cue delay�ظ�60�Σ�
    ISI = 105.9;  % ISI, target-to-mask,105.9ms
    % ����block�ĳ���˳��
    if serialNum / 2 == 0
        orderBlock = [1,2];
    else
        orderBlock = [2,1];
    end 
    % ��ͬ�̼���΢������
    ajustArrow = [-4,5] % ÿ����ͷ����΢���Ĳ�������֮ǰʵ��İ��������ֶ��룩
    widthArrow = 25;
    heightArrow = 25;
    ajustChi = [-4,2];  % ÿ����������΢���Ĳ���
    % �������Ϸ�Ӧ����ת��Ϊ��Ӧ�ĽǶ����ľ���
    KeyToAngles = [135,90,45,180,0,360,225,270,315];
    
    % ���л��ƴ̼���׼������--------------------------
    % ����Ŀ��̼�--------------------------------
    arrowImg = imread('pics\arrow.jpg');  % ��ȡ��ͷͼƬ
    arrowTexture = Screen('MakeTexture',w,arrowImg); % ����ȡ��ͼƬ���Ƶ�offscreen w1��
    
    % ��ȡָ����-----------------------------------------------
    welcome_img = imread('pics\welcome.jpg');              % ��ȡ��welcome��ͼƬ
    welcome_texture = Screen('MakeTexture',w,welcome_img); % ����ȡ��ͼƬת��ΪTexture
    cueIns_img = imread('pics\InstructionsCue.jpg');       % ��ȡ���ֱ��淨ָ����ͼƬ
    cueIns_texture = Screen('MakeTexture',w,cueIns_img);   % ����ȡ��ͼƬת��ΪTexture
    % ����ָ����-----------------------------------------------
    Screen('DrawTexture',w,welcome_texture);               % ���֡�welcome��ָ����
    Screen('Flip',w);
    % �ͷ����а�����������ס-------------------------------------
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prenvent CUP hogging
    end
    KbWait;
    Screen('DrawTexture',w,cueIns_texture);                % ���ֲ��ֱ��淨ָ����
    Screen('Flip',w);
    % �ͷ����а�����������ס-------------------------------------
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prenvent CUP hogging
    end
    KbWait;
    
    % ��ʼ��ʽʵ��
    for indexBlock = 1:2
        
        % �����������������60��trial��ÿ�б���20��---------------
        cuePosition = repmat([1,2,3],[1,20]);
        cuePosition = cuePosition(:,randperm(size(cuePosition,2)));
        
        % ��������������ʾ---------------------------------------
        DrawFormattedText(w ,'�����������һ��' , 'center', 'center', targetCol);
        Screen('Flip',w);
        Snd('Play',beep1);
        WaitSecs(1.5);
        DrawFormattedText(w ,'����������ڶ���' , 'center', 'center', targetCol);
        Screen('Flip',w);
        Snd('Play',beep2);
        WaitSecs(1.5);
        DrawFormattedText(w ,'���������������' , 'center', 'center', targetCol);
        Screen('Flip',w);
        Snd('Play',beep3);
        WaitSecs(1.5);
        DrawFormattedText(w,'��ʾ�ѽ������밴"Enter"��ʼ��ʽʵ�顣','center','center',targetCol);
        Screen('Flip',w); 
        % �ͷ����а�����������ס-------------------------------------
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prenvent CUP hogging
        end
        KbWait;
        
        % ʵ������
        for t = 1:trialsPart
            % ��ȡĿ��̼�������ͷ�ĽǶ���+���Ӧ����ȷ��Ӧ���̰���
            [targetArrowAngles,targetArrowKeys,targetArrowRecord] = getArrowAngles(3,4);           
            % ��ǰ����Ŀ��̼�----------------------------------------
            Screen('CopyWindow',w3,w1);  % ���offScreen w1�����ڻ���Ŀ��̼�
            % offScreen w1�ϻ���3*4�ļ�ͷ�̼�------------------
            for i = 1:3
                for j = 1:4
                    % ����ÿ����ͷ�ĳ���λ��
                    x_1 = a1-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1))+ajustArrow(1);
                    y_1 = b1-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2))+ajustArrow(2);
                    x_2 = x_1 + widthArrow;
                    y_2 = y_1 + heightArrow;
                    % ���Ƽ�ͷ
                    Screen('DrawTexture',w1,arrowTexture,[],[x_1,y_1,x_2,y_2],[targetArrowAngles(i,j)],[],0);
                end
            end
            % ��ȡ����w1�ϻ��õ�Ŀ��̼�ͼƬ
            targetImg = Screen('GetImage',w1);
            % ��õ�Ŀ��̼�ͼƬת��Ϊw�Ͽɳ��ֵ�Texture
            targetTexture = Screen('MakeTexture',w,targetImg);
            
            % ��ȡ�ڱδ̼�����3*4�����ķ�λ�ʣ���������
            [maskChiOriens,maskRecord] = getChiOriens(3,4);
            % ��ǰ�����ڱδ̼�----------------------------------
            Screen('CopyWindow',w3,w2); % ���offscreen w2�����ڻ����ڱδ̼�
            % offscreen w2�ϻ���3*4�����ķ�λ��
            for i = 1:3
                for j = 1:4
                    % ����ÿ�����ĵĳ���λ��
                    x = a2-3/2*space-2*textPixel(1)+(j-1)*(space+textPixel(1))+ajustChi(1);
                    y = b2-space-3/2*textPixel(2)+(i-1)*(space+textPixel(2))+ajustChi(2);
                    Screen('DrawText',w2,maskChiOriens(i,j),x,y,maskCol);
                end
            end
            % ��ȡ����w2�ϻ��õ��ڱδ̼�
            maskImg = Screen('GetImage',w2);
            % ��õ��ڱδ̼�ͼƬת��Ϊw�Ͽɳ��ֵ�Texture
            maskTexture = Screen('MakeTexture',w,maskImg);
            
            
            % �̼�����------------------------------------------------
            % ���֡�+��ע�ӵ�
            for r = 1:fixFrames
                Screen('DrawText',w,'+',desFix(1),desFix(2),targetCol);
                Screen('Flip',w);
            end
            % ����Ŀ��̼���3*4��ͷ
            startTarget = GetSecs;
            for r = 1:targetFrames
                Screen('DrawTexture',w,targetTexture);
                Screen('Flip',w);
            end
            targetDura = GetSecs - startTarget;
            % ���ֿ��� ISI=105.9ms
            startBlank = GetSecs;
            for r = 1:blankFrames
                Screen('Flip',w);
            end
            blankDura = GetSecs - startBlank;
            % �����ڱδ̼������ĵķ�λ��
            startMask = GetSecs;
            for r = 1:maskFrames
                Screen('DrawTexture',w,maskTexture);
                Screen('Flip',w);
            end
            maskDura = GetSecs - startMask;
            
            % һ��trial���������ֲ�ͬ��delayed cue-----------------------
            % �����ȴ���ͬ��cue-delay
            cueStart = GetSecs;
            for r = 1:cueDelayFrames(orderBlock(indexBlock))
                Screen('Flip',w);
            end
            cueDura = GetSecs -cueStart;
            % ��������cue��50ms����ʾ�豨�������
            switch cuePosition(t)
                case 1   % 2.5k Hz�������һ��
                    Snd('Play',beep1);
                case 2   % 850 Hz������ڶ���
                    Snd('Play',beep2);
                case 3   % 200 Hz�����������
                    Snd('Play',beep3);
            end
            
            % ��Ӧ��ȡ-------------------------------------------------
            strRes = [];            % ��¼���Է�Ӧ���ַ������������
            matrixRes = [];         % ��¼���Է�Ӧ�����֣�������ȡ�Ƕ�����
            resTime = [];           % ��¼���Եķ�Ӧʱ��
            k = 0;
            % ��Ӧ��¼ѭ��
            while true
                % �ͷ����а�����������ס
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end  
                % ��¼������Ӧ
                k = k + 1;
                [keyisdown,resTime(k),keycode] = KbCheck; % �õ�һ��keycode0/1
                index = find(keycode,1);                  % �ҵ������µļ�(ֵΪ1������ֻ������λ�ǰ�ģ���ֹswitch����
                num = index-96;
                if isempty(index)
                else
                    switch(index)     % �жϷ�Ӧ����
                        % Enter����Return��------------------------------------
                        case 13       
                            if length(strRes) == 4 % ��������ķ�Ӧ��Ŀ��ȷ
                                break;
                            else
                                % ��������ķ�Ӧ��Ŀ��������
                                DrawFormattedText(w,'����������ԣ��밴����������޸�����','center','center',targetCol);
                                Screen('Flip',w);
                                % �ͷ����а�����������ס------------------------------
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
                        % Backspace����ɾ��------------------------------------
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
                        % ESCAPE���������˳������е�ѭ����Ҫ��һ��if�ж����
                        case 27
                            break
                        % ���������ּ�����¼��Ӧ
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
            % �˳�
            if index == 27
                break
            end
            
            % ��¼���Է�Ӧ------------------------------------------------
            arrowRowOriginal = targetArrowKeys(cuePosition(t),:);
            % ������ȷ��
            [numCorrect,accuracy] = getAccuracy(arrowRowOriginal,strRes);
            numCorrect = numCorrect * 3;
            % ���㱻�Եķ�Ӧʱ��
            responseTime = resTime(k)-resTime(1);
            % д���ļ�
            fprintf(fid,'%s\t%d\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s\t%d\t%6.2f\t%6.4f\t%6.4f\t%6.4f\t%6.6f\t%6.6f\t%6.6f\t%6.6f\t%d%d\t%6.6f\n',...
                    subject,ISI,maskType,'P',cueDelay(orderBlock(indexBlock)),cuePosition(t),arrowRowOriginal,targetArrowRecord,maskRecord,strRes,numCorrect,accuracy,...
                    backgroundCol(1),targetCol(1),maskCol(1),targetDura,blankDura,maskDura,cueDura,orderBlock(1),orderBlock(2),responseTime);
            % һ��������trial����------------------------------------------------------
            
            % 20��trial֮����ʾ������Ϣ---------------------------------
            if t == 20 | t == 40
                DrawFormattedText(w , '����Ϣһ��.\n\n��"Enter"����ʾ����ʾ', 'center', 'center', targetCol);
                Screen('Flip',w);
                % �ͷ����а�����������ס---------------------------
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
                % ��������������ʾ---------------------------------
                DrawFormattedText(w ,'�����������һ��' , 'center', 'center', targetCol);
                Screen('Flip',w);
                Snd('Play',beep1);
                WaitSecs(1.5);
                DrawFormattedText(w ,'����������ڶ���' , 'center', 'center', targetCol);
                Screen('Flip',w);
                Snd('Play',beep2);
                WaitSecs(1.5);
                DrawFormattedText(w ,'���������������' , 'center', 'center', targetCol);
                Screen('Flip',w);
                Snd('Play',beep3);
                WaitSecs(1.5);
                DrawFormattedText(w,'��ʾ�ѽ������밴"Enter"��ʼ��ʽʵ�顣','center','center',targetCol);
                Screen('Flip',w);
                % �ͷ����а�����������ס---------------------------
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            end
        end
        % �˳�
        if index == 27
            break
        end
        
        % �ж�block��������������ʵ�������������Ӧָ����-------------------
        if indexBlock == 2
            % ����ʵ�����ָ����---------------------------------------
            DrawFormattedText(w , '����ʵ���ѽ�����лл���롣\n\n���������', 'center', 'center', targetCol);
            Screen('Flip',w);
            % �ͷ����а�����������ס------------------------------------
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prenvent CUP hogging
            end
            KbWait;
        else
            % ����block����ָ����--------------------------------------
            DrawFormattedText(w , '����ʵ���������������Ϣ��\n\n������"Enter"����', 'center', 'center', targetCol);
            Screen('Flip',w);
            % �ͷ����а�����������ס------------------------------------
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prenvent CUP hogging
            end
            KbWait;
        end
    end

%�ر���Ļ--------------------------------------
Screen('Close',w);
Screen('Closeall');
%�ر���Ƶͨ��-----------------------------------
Snd('Close');
%�ر������ļ�-----------------------------------
fclose(fid);
%��ʾ���--------------------------------------
ShowCursor;
    
catch
    Screen('Closeall')
    rethrow(lasterror)
end    