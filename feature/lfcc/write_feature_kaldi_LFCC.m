clear; close all; clc;

% add required libraries to the path
addpath(genpath('LFCC'));
addpath(genpath('CQCC_v1.0'));
addpath(genpath('bosaris_toolkit'));
addpath(genpath('kaldi-to-matlab'));

% set here the experiment to run (access and feature type)
feature_type = 'LFCC'; % LFCC or CQCC
data_type = 'test'; % train or test

mkdir('data\lfcc');
writefile = strcat('data\lfcc\', feature_type, '_', data_type, '.txt');

if strcmp(data_type, 'train') % train 
    pathToDatabase = 'F:\\Work\\2021_FMFCC\\FMFCC_Audio_train\\train_audio\\Train';
    jsonFile = 'F:\\Work\\2021_FMFCC\\FMFCC_Audio_train\\train_list.txt';
elseif strcmp(data_type, 'test') % dev
    pathToDatabase = 'F:\\Work\\2021_FMFCC\\FMFCC_Audio_test\\test_audio\\Dev';
    jsonFile = 'F:\\Work\\2021_FMFCC\\FMFCC_Audio_test\\test_list.txt';
end

% read json
filelist=load(jsonFile);

disp(writefile);
fid = fopen(writefile, 'w');

%% Feature extraction for data
disp('Extracting features for all data...');
% allFeatureCell = cell(size(filelist));
% allUttCell = cell(size(filelist));
for i=1:length(filelist)
    filePath = fullfile(pathToDatabase,strcat(num2str(filelist(i)),'.wav'));
    [x,fs] = audioread(filePath);
    if strcmp(feature_type,'LFCC')
        [stat,delta,double_delta] = extract_lfcc(x,fs,20,512,20);
	    Feature = [stat,delta,double_delta]';
    elseif strcmp(feature_type,'CQCC')
        Feature = cqcc(x, fs, 96, fs/2, fs/2^10, 16, 29, 'ZsdD');
    end
    Uttid = filelist(i);
    fprintf(fid, '%s  [\n ', Uttid);
    nfram = size(Feature, 2);
    for t = 1:nfram
        fprintf(fid, ' %.7g', Feature(:,t));
        fprintf(fid, ' \n ');
    end
    fprintf(fid, ' ]\n');
    if rem(i, 100) == 0
        disp(['Done ', num2str(i), ' utts.']);
    end
end
fclose(fid);
disp('Done!');
