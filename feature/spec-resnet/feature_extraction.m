%原始特征提取代码（结果中可能会出现inf值）
%input path
sampleFile1 = 'F:\Work\2021_FMFCC\FMFCC_Audio_train\train_audio\Train\';
sampleFile2 = 'F:\Work\2021_FMFCC\FMFCC_Audio_test\test_audio\Dev\';
% output path
featureFile1 = 'F:\Work\2021_FMFCC\spec-resnet\feature\train\';
featureFile2 = 'F:\Work\2021_FMFCC\spec-resnet\feature\test\';

for cnt = 1:2
    if cnt == 1
        sampleFile = sampleFile1;
        featureFileName = featureFile1;
    elseif cnt == 2
        sampleFile = sampleFile2;
        featureFileName = featureFile2;
    end
    
    Files = dir(fullfile(sampleFile,'*.wav'));
    LengthFiles = length(Files);
    for i = 1:4000
		featureFile = [featureFileName, num2str(i) ,'.txt'];
        [sample,~]=audioread(strcat(sampleFile,Files(i).name));%read audio file
        sample=sample(:,1);%choose one channel
        len=length(sample);
        %%%%%%%%%%%%%%%%%%%%%windows size N = 512%%%%%%%%%%%%%%%%%%%%
        win=1152;
        lframe=win;% length of each frame
        overlap=fix(0.5*win); % 50% overlap and rounded
        lslip=win-overlap;
        win=hamming(lframe)';%Hamming window is chosen here
        cnt=1;
        ncols=1+fix((len-lframe)/lslip);%the number of frames（如果出现(len-lframe)/lslip恰好整除的情况，特征最后一列将为全inf）
        fea=zeros((1+lframe/2),ncols);
        for b=0:lslip:(len-lframe)
            u=win.*sample((b+1):(b+lframe))'; % 如果u为全0，对应列的特征也将为全inf
            coef=fft(u);
            fea(:,cnt)=coef(1:(1+lframe/2))';
            cnt=cnt+1;
        end
        feature = 20*log10(abs(fea));
        spectrogram = feature(1:lframe/2,:);%spectrogram matrix
        [row, col] = size(spectrogram);
        
        fid = fopen(featureFile,'w');%write into *.txt
        for r = 1:row
            for c = 1:col
                fprintf(fid, '%.2f\t', spectrogram(r, c));
            end
            fprintf(fid, '\n');
        end
        fclose(fid);
    end
%end