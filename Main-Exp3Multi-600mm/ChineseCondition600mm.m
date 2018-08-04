function ChineseCondition600mm(subject,block)
% �ڱδ̼�Ϊ��д��������
try
    
    Screen('Preference', 'SkipSyncTests', 1);
    % ����ȫ�ֱ���
    global screenNumber w wRect a b
    
    
    %����̼���ɫ-----------------------------------------
    backgroundCol = [255*0.2,255*0.2,255*0.2];
    targetCol = [255*0.3,255*0.3,255*0.3];
    maskCol = [255*0.4,255*0.4,255*0.4];
    %����̼���С-----------------------------------------
    textSize = 24;  % Ŀ��̼������������֣����ֺŴ�С,��6.42mm
    textSize2 = 23; % �ڱδ̼����������֣����ֺŴ�С
    textPixel = [16,23]; % �ı��̼������ش�С
    strokeSize = 3; % �ı��̼��ıʻ���ϸ
    spaceV = 21;    % �������ּ��
    spaceH = 21;    % �����ּ��
    
    
    %����Ļ-------------------------------------
    screenNumber=max(Screen('Screens'));
    Screen('Resolution', screenNumber, [1280], [960], [85]);
    [w, wRect]=Screen('OpenWindow',screenNumber,backgroundCol,[],32,2);
    Screen('TextSize',w,textSize);
    Screen('TextFont',w,'Arial');
    [a,b]=WindowCenter(w);
    HideCursor;
    
    %��ǰϵͳ�ļ��̰�������������ͳһת��ΪMacOX-Xϵͳ
    KbName('UnifyKeyNames');
    %���ư�����Χ
    RestrictKeysForKbCheck([96,97,98,99,100,101,102,103,104,105,8,13,27]);
    
    %����������Ļ-----------------------------------
    [w1,w1Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w1 ���ں�̨����Ŀ��̼�
    Screen('TextSize',w1,textSize);
    Screen('TextFont',w1,'Arial');
    [a1,b1]=WindowCenter(w1);
    [w2,w2Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2); % offScreen w2 ���ں�̨�����ڱδ̼�
    Screen('TextSize',w2,textSize2);
    Screen('TextFont',w2,'����');
    [a2,b2]=WindowCenter(w2);
    [w3,w3Rect]=Screen('OpenOffscreenwindow',w,backgroundCol,[],32,2);  % offScreen w3 ʼ�տ��������ڲ���w2�����ϵ�ͼ��
    %�򿪽�������ļ�
    fid = fopen(['Results\','Chinese600mm-',subject,'.txt'],'w');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Sub','ISI',...
        'MaskType','ReportType','CueDelay','RowCued','RowOriginal','DigitWhole','Mask','Response','NumCorrect','Accuracy',...
        'BackgroundCol','TargetCol','MaskCol','TargetDura','ISIDura','MaskDura','CueDura','BlockOrder','ResponseTime');
    
    %����ʱ�����
    frameRate = Screen('FrameRate',w);
    frameDura = 1000/frameRate;
    %�趨����֡�����������ʱ��
    fixFrames = 127; %ע�ӵ����120֡
    fixDura = fixFrames * frameDura; %ע�ӵ����1500ms - ԼΪ1400ms
    targetFrames = 2;%Ŀ��̼�����2֡
    targetDura = targetFrames * frameDura; %Ŀ��̼�����25ms - 23.5ms
    blankFrames = 9; %ISI���Ռγ���9֡
    blankDura = blankFrames * frameDura; %ISI,����ʱ��Ϊ100ms - 105.9ms
    maskFrames = 2;  %�ڱδ̼�����2֡
    maskDura = maskFrames * frameDura;   %�ڱδ̼�����50ms - 23.5ms
    cueDelayFrames = {'',1,38}; %�����ӳ�ʱ���ֵ�֡��
    cueDelay = {'',0,cueDelayFrames{3}*frameDura};%��������Cue���ӳ�ʱ�� - 447ms
    %�������λ��
    desFix = [a-1/2*textPixel(1),b-1/2*textPixel(2)];  % ע�ӵ�λ��
    %��������Cue
    beep1 = MakeBeep(2500,0.5);  % ��ʾ�����һ��
    beep2 = MakeBeep(850,0.5);   % ��ʾ����ڶ���
    beep3 = MakeBeep(200,0.5);   % ��ʾ���������
    Snd('Open');  % ����Ƶͨ��
    %����Condition�ȵĲ���
    ISI = blankDura; % target-to-mask,100ms
    maskType = 'Chinese'; % Condition�����ͣ������ڱ�
    trialsPart = 60;  % ÿ�����ֱ��淨block�ڣ��ظ�60��trial����ÿ��cue delay�ظ�60�Σ�
    trialsWhole = 20; % ȫ�����淨�ظ�20��trial
    
    %������ָ����
    generalIns_img = imread('Instructions\general.jpg'); %��ȡ��ָ����
    generalIns = Screen('MakeTexture',w,generalIns_img); %��ͼƬת��ΪTexture
    Screen('DrawTexture',w,generalIns);
    Screen('Flip',w); %������ָ����
    KbWait;
    %�ͷ����а�����������ס
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prenvent CUP hogging
    end
    KbWait;
    
    
    for blockIndex = 1:3
        %Block1 ȫ�����淨
        if block(blockIndex) == 1
            %����ȫ�����淨ָ����
            wholeIns_img = imread('Instructions\startW.jpg'); %��ȡȫ�����淨ָ�����ͼƬ
            wholeIns = Screen('MakeTexture',w,wholeIns_img);  %��ͼƬת��ΪTexture
            Screen('DrawTexture',w,wholeIns); %����ȫ�����淨��ָ����
            Screen('Flip',w);
            %�ͷ����а�����������ס
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prenvent CUP hogging
            end
            KbWait;
            
            %��ʽʵ�� -- ȫ�����淨
            for t = 1:trialsWhole
                %��ȡĿ����ڱδ̼���Matrix
                [targetMatrix,targetSequence]=getNumMatrix(3,4);  % Target, 3*4����
                [maskCh,maskMatrix,maskSequence] = getChiMatrix(3,4); % Mask��3*4��������
                %���offscreens
                Screen('CopyWindow',w3,w1);
                Screen('CopyWindow',w3,w2);
                %��ǰ���ƴ̼�
                %��offscreen w1�ϻ���Ŀ��̼���3*4����-----------------------------------
                for i = 1:3
                    for j = 1:4
                        Screen('DrawText',w1,targetMatrix(i,j),a1-3/2*spaceV-2*textPixel(1)+(j-1)*(spaceV+textPixel(1)),b1-spaceH-3/2*textPixel(2)+(i-1)*(spaceH+textPixel(2)),targetCol);
                    end
                end
                targetImg = Screen('GetImage',w1);                   % ��ȡ����w1�ϻ��õ�Ŀ��̼�ͼƬ
                targetTexture = Screen('MakeTexture',w,targetImg);   % ��õ�Ŀ��̼�ͼƬת��Ϊw�Ͽɳ��ֵ�Texture
                %��offscreen w2�ϻ����ڱδ̼�-3*4����-----------------------------------------
                for i = 1:3
                    for j = 1:4
                        Screen('DrawText',w2,maskCh(i,j),a2-7-3/2*spaceV-2*textPixel(1)+(j-1)*(spaceV+textPixel(1)),b2+2-spaceH-3/2*textPixel(2)+(i-1)*(spaceH+textPixel(2)),maskCol);
                    end
                end
                maskImg = Screen('GetImage',w2);                    % ��ȡ����w2�ϻ��õ��ڱδ̼�ͼƬ
                maskTexture = Screen('MakeTexture',w,maskImg);      % ��õ��ڱδ̼�ͼƬת��Ϊw�Ͽɳ��ֵ�Texture
                
                %�̼�����
                %����"+"ע�ӵ�-----------------------------------------
                for r = 1:fixFrames
                    Screen('DrawText',w,'+',desFix(1),desFix(2),targetCol);
                    Screen('Flip',w);
                end
                %����Ŀ��̼� 3*4����
                startTarget = GetSecs;
                for r = 1:targetFrames
                    Screen('DrawTexture',w,targetTexture);
                    Screen('Flip',w);
                end
                targetDura = GetSecs - startTarget;
                %���ֿ��� ISI=100ms
                startBlank = GetSecs;
                for r = 1:blankFrames
                    Screen('Flip',w);
                end
                blankDura = GetSecs - startBlank;
                %�����ڱδ̼���������
                startMask = GetSecs;
                for r = 1:maskFrames
                    Screen('DrawTexture',w,maskTexture);
                    Screen('Flip',w);
                end
                maskDura = GetSecs - startMask;
                %trial���������ֿ���
                Screen('Flip',w);
                
                %��Ӧ��ȡ
                %ListenChar(2);
                strRes = '';     % ���Է�Ӧ������
                resTime = [];
                k = 0;
                while true
                    %�ͷ����а�����������ס
                    keyisdown = 1;
                    while(keyisdown) % first wait until all keys are released
                        [keyisdown,secs,keycode] = KbCheck;
                        WaitSecs(0.001); % delay to prenvent CUP hogging
                    end           
                    %FlushEvents('keyDown');  % ��ռ����¼�����
                    %��¼������Ӧ
                    k=k+1;
                    [keyisdown,resTime(k),keycode] = KbCheck;  % ��KbCheck��ȡ��Ӧ�ַ���������������getchar��û�õĶ�����������
                    index = find(keycode);
                    num = num2str(index-96);
                    if isempty(index)
                    else
                    switch(index)
                        case 13   % Enter����Returen��
                            if length(strRes) < 12   % ���Է�Ӧ����ȫ
                                DrawFormattedText(w ,'���벻�������밴"Enter"��������' , 'center', 'center', targetCol);
                                Screen('Flip',w);
                                %�ͷ����а�����������ס
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
                        case 8     % Backspace��
                            if ~isempty(strRes)
                                strRes = strRes(1:length(strRes)-1);
                                DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                                Screen('Flip',w);
                            end
                        case 27   % escape���������˳�
                            break
                        otherwise  % ��¼��Ӧ
                            strRes = [strRes num];
                            DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                            Screen('Flip',w);
                    end
                    end
                end
                if index==27
                    break
                end
                %ListenChar(0);
                
                %��Ӧ��¼
                [numCorrect,accuracy] = getAccuracy(targetSequence,strRes); % ������ȷ��
                responseTime = resTime(k)-resTime(1);
                %д���ļ�
                fprintf(fid,'%s\t%d\t%s\t%s\t%s\t%d\t%s\t%s\t%s\t%s\t%d\t%6.2f\t%6.4f\t%6.4f\t%6.4f\t%6.6f\t%6.6f\t%6.6f\t%6.6f\t%d%d%d\t%6.6f\n',...
                    subject,ISI,maskType,'W','','','',targetSequence,maskSequence,strRes,numCorrect,accuracy,backgroundCol(1),targetCol(1),maskCol(1),...
                    targetDura,blankDura,maskDura,'',block(1),block(2),block(3),responseTime);
                %10��trial֮����ʾ������Ϣ
                if t == 10
                    DrawFormattedText(w , '����Ϣһ�ᣬ��"Enter"����', 'center', 'center', targetCol);
                    Screen('Flip',w);
                    %�ͷ����а�����������ס
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
            %�ж�block��������������ʵ�����������ָ����
            if blockIndex == 3
                %����ʵ�����ָ����
                DrawFormattedText(w , '����ʵ���ѽ�����лл���롣\n\n���������', 'center', 'center', targetCol);
                Screen('Flip',w);
                %�ͷ����а�����������ס
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            else
                %����block����ָ����
                DrawFormattedText(w , '����ʵ���ѽ�������������Ϣ��\n\n������"Enter"����', 'center', 'center', targetCol);
                Screen('Flip',w);
                %�ͷ����а�����������ס
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            end
        end
        
        %Block2&3 ���ֱ��淨��cue-delay=0ms��450ms
        if block(blockIndex) == 2 | block(blockIndex) == 3
            %�����������������60��trial��ÿ�б���20��
            cuePosition = repmat([1,2,3],[1,20]);
            cuePosition = cuePosition(:,randperm(size(cuePosition,2)));
            %���ֲ��ֱ��淨ָ����
            partIns_img = imread('Instructions\startP.jpg'); %��ȡȫ�����淨ָ�����ͼƬ
            partIns = Screen('MakeTexture',w,partIns_img);  %��ͼƬת��ΪTexture
            Screen('DrawTexture',w,partIns); %����ȫ�����淨��ָ����
            Screen('Flip',w);
            %�ͷ����а�����������ס
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prenvent CUP hogging
            end
            KbWait;
            %��������������ʾ
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
            %�ͷ����а�����������ס
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prenvent CUP hogging
            end
            KbWait;

            %��ʽʵ�� -- ���ֱ��淨
            for t = 1:trialsPart
                %��ȡĿ����ڱδ̼���Matrix
                [targetMatrix,targetSequence]=getNumMatrix(3,4);  % Target, 3*4����
                [maskCh,maskMatrix,maskSequence] = getChiMatrix(3,4); % Mask��3*4��������
                %���offscreens
                Screen('CopyWindow',w3,w1);
                Screen('CopyWindow',w3,w2);
                %��ǰ���ƴ̼�
                %��offscreen w1�ϻ���Ŀ��̼���3*4����-----------------------------------
                for i = 1:3
                    for j = 1:4
                        Screen('DrawText',w1,targetMatrix(i,j),a1-3/2*spaceV-2*textPixel(1)+(j-1)*(spaceV+textPixel(1)),b1-spaceH-3/2*textPixel(2)+(i-1)*(spaceH+textPixel(2)),targetCol);
                    end
                end
                targetImg = Screen('GetImage',w1);                   % ��ȡ����w1�ϻ��õ�Ŀ��̼�ͼƬ
                targetTexture = Screen('MakeTexture',w,targetImg);   % ��õ�Ŀ��̼�ͼƬת��Ϊw�Ͽɳ��ֵ�Texture
                %��offscreen w2�ϻ����ڱδ̼�-3*4����-----------------------------------------
                for i = 1:3
                    for j = 1:4
                        Screen('DrawText',w2,maskCh(i,j),a2-7-3/2*spaceV-2*textPixel(1)+(j-1)*(spaceV+textPixel(1)),b2+2-spaceH-3/2*textPixel(2)+(i-1)*(spaceH+textPixel(2)),maskCol);
                    end
                end
                maskImg = Screen('GetImage',w2);                    % ��ȡ����w2�ϻ��õ��ڱδ̼�ͼƬ
                maskTexture = Screen('MakeTexture',w,maskImg);      % ��õ��ڱδ̼�ͼƬת��Ϊw�Ͽɳ��ֵ�Texture
               
                %�̼�����
                %����"+"ע�ӵ�-----------------------------------------
                for r = 1:fixFrames
                    Screen('DrawText',w,'+',desFix(1),desFix(2),targetCol);
                    Screen('Flip',w);
                end
                %����Ŀ��̼� 3*4����
                startTarget = GetSecs;
                for r = 1:targetFrames
                    Screen('DrawTexture',w,targetTexture);
                    Screen('Flip',w);
                end
                targetDura = GetSecs - startTarget;
                %���ֿ��� ISI=100ms
                startBlank = GetSecs;
                for r = 1:blankFrames
                    Screen('Flip',w);
                end
                blankDura = GetSecs - startBlank;
                %�����ڱδ̼���������
                startMask = GetSecs;
                for r = 1:maskFrames
                    Screen('DrawTexture',w,maskTexture);
                    Screen('Flip',w);
                end
                maskDura = GetSecs - startMask;
                
                cueStart = GetSecs;
                %һ��trial���������ֿ���������Cue-Delay�ĳ���֡����ͬ��0ms��1֡��450ms�����ݼ�����
                for r = 1:cueDelayFrames{block(blockIndex)}
                    Screen('Flip',w);
                end
                cueDura = GetSecs - cueStart;
                
                %���������̼���50ms����ʾ�豨�������
                switch cuePosition(t)
                    case 1   % 2.5k Hz �����һ��
                        Snd('Play',beep1);
                    case 2   % 850 Hz ����ڶ���
                        Snd('Play',beep2);
                    case 3   % 200 Hz ���������
                        Snd('Play',beep3);
                end
                
                 %��Ӧ��ȡ
                %ListenChar(2);
                strRes = '';     % ���Է�Ӧ������
                resTime = [];
                k = 0;
                while true
                    %�ͷ����а�����������ס
                    keyisdown = 1;
                    while(keyisdown) % first wait until all keys are released
                        [keyisdown,secs,keycode] = KbCheck;
                        WaitSecs(0.001); % delay to prenvent CUP hogging
                    end
                    %��ȡ������Ӧ
                    k = k+1;
                    [keyisdown,resTime(k),keycode] = KbCheck;  % ��KbCheck��ȡ��Ӧ�ַ���������������getchar��û�õĶ�����������
                    index = find(keycode);
                    num = num2str(index-96);
                    if isempty(index)
                    else
                    switch(index)
                        case 13   % Enter����Returen��
                            if length(strRes) < 4   % ���Է�Ӧ����ȫ
                                DrawFormattedText(w ,'���벻�������밴"Enter"��������' , 'center', 'center', targetCol);
                                Screen('Flip',w);
                                %�ͷ����а�����������ס
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
                        case 8     % Backspace��
                            if ~isempty(strRes)
                                strRes = strRes(1:length(strRes)-1);
                                DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                                Screen('Flip',w);
                            end
                        case 27   % escape���������˳�
                            break
                        otherwise  % ��¼��Ӧ
                            strRes = [strRes num];
                            DrawFormattedText(w , strRes, 'center', 'center', targetCol);
                            Screen('Flip',w);
                    end
                    end
                end
                if index==27
                    break
                end
                %ListenChar(0);
                
                %��Ӧ��¼
                rowOriginal = targetMatrix(cuePosition(t),:);
                [numCorrect,accuracy] = getAccuracy(rowOriginal,strRes); % ������ȷ��
                numCorrect = numCorrect*3;
                responseTime = resTime(k)-resTime(1);  % ��¼���Է�Ӧʱ��
                %д���ļ�
                fprintf(fid,'%s\t%d\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s\t%d\t%6.2f\t%6.4f\t%6.4f\t%6.4f\t%6.6f\t%6.6f\t%6.6f\t%6.6f\t%d%d%d\t%6.6f\n',...
                    subject,ISI,maskType,'P',cueDelay{block(blockIndex)},cuePosition(t),rowOriginal,targetSequence,maskSequence,strRes,numCorrect,accuracy,...
                    backgroundCol(1),targetCol(1),maskCol(1),targetDura,blankDura,maskDura,cueDura,block(1),block(2),block(3),responseTime);
                %20��trial֮����ʾ������Ϣ
                if t == 20 | t == 40
                    DrawFormattedText(w , '����Ϣһ��.\n\n��"Enter"����ʾ����ʾ', 'center', 'center', targetCol);
                    Screen('Flip',w);
                    %�ͷ����а�����������ס
                    keyisdown = 1;
                    while(keyisdown) % first wait until all keys are released
                        [keyisdown,secs,keycode] = KbCheck;
                        WaitSecs(0.001); % delay to prenvent CUP hogging
                    end
                    KbWait;
                    %��������������ʾ
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
                    %�ͷ����а�����������ס
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
            %�ж�block��������������ʵ�����������ָ����
            if blockIndex == 3
                %����ʵ�����ָ����
                DrawFormattedText(w , '����ʵ���ѽ�����лл���롣\n\n���������', 'center', 'center', targetCol);
                Screen('Flip',w);
                %�ͷ����а�����������ס
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            else
                %����block����ָ����
                DrawFormattedText(w , '����ʵ���������������Ϣ��\n\n������"Enter"����', 'center', 'center', targetCol);
                Screen('Flip',w);
                %�ͷ����а�����������ס
                keyisdown = 1;
                while(keyisdown) % first wait until all keys are released
                    [keyisdown,secs,keycode] = KbCheck;
                    WaitSecs(0.001); % delay to prenvent CUP hogging
                end
                KbWait;
            end
        end
    end
    
    
    %�ر���Ļ--------------------------------------
    Screen('Close',w);
    %�ر���Ƶͨ��------------------------------------
    Snd('Close');
    %�ر������ļ�
    fclose(fid);
    %��ʾ���
    ShowCursor;
    
catch
    Screen('Closeall')
    rethrow(lasterror)
end