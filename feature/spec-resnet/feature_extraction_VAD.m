% 根据res2net模型修改后代码，加入了静音去除（结果中没有inf值）
% input path 
sampleFile1 = 'F:\Work\2021_FMFCC\FMFCC_Audio_train\train_audio\Train\';
sampleFile2 = 'F:\Work\2021_FMFCC\FMFCC_Audio_test\test_audio\Dev\';
% output path
featureFile1 = 'F:\Work\2021_FMFCC\spec-resnet\feature\train\';
featureFile2 = 'F:\Work\2021_FMFCC\spec-resnet\feature\test\';

for fcnt = 1:2
    if fcnt == 1
        sampleFile = sampleFile1;
        featureFileName = featureFile1;
    elseif fcnt == 2
        sampleFile = sampleFile2;
        featureFileName = featureFile2;
    end
    
    Files = dir(fullfile(sampleFile,'*.wav'));
    LengthFiles = length(Files);
    for i = 1:LengthFiles
        name=strsplit(Files(i).name,'.');
		featureFile = strcat(featureFileName, name(1),'.txt')
        [sample,~]=audioread(strcat(sampleFile,Files(i).name)); % read audio file
        
        sample=sample(:,1); % choose one channel
        len=length(sample);
        % windows size N = 1152
        win=1152;
        lframe=win; % length of each frame
        overlap=fix(0.5*win); % 50% overlap and rounded
        lslip=win-overlap;
        win=hamming(lframe)'; % Hamming window
        cnt=1;
        % 考虑了整除情况
        if (len-lframe)/lslip==uint32((len-lframe)/lslip)
            ncols=fix((len-lframe)/lslip); % the number of frames
        else
            ncols=1+fix((len-lframe)/lslip); % the number of frames
        end
        fea=zeros((1+lframe/2),ncols);
        if (len-lframe)/lslip==uint32((len-lframe)/lslip)
            for b=0:lslip:(len-lframe)-lslip
            u=win.*sample((b+1):(b+lframe))';
            if any(u) % 不考虑全0情况
                coef=fft(u);
                fea(:,cnt)=coef(1:(1+lframe/2))';
                cnt=cnt+1;
            end
            end
        else
            for b=0:lslip:(len-lframe)
            u=win.*sample((b+1):(b+lframe))';
            if any(u)
                coef=fft(u);
                fea(:,cnt)=coef(1:(1+lframe/2))';
                cnt=cnt+1;
            end
            end
        end
        feature = 20*log10(abs(fea));
        spectrogram = feature(1:lframe/2,:);%spectrogram matrix
        [row, col] = size(spectrogram);

        fid = fopen(featureFile{1},'w');%write into *.txt
        for r = 1:row
            for c = 1:cnt-1
                fprintf(fid, '%.2f\t', spectrogram(r, c));
            end
            fprintf(fid, '\n');
        end
        fclose(fid);
    end
end