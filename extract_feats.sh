#! /bin/bash
# This script extracts Spec, CQT, LFCC features

. ./cmd.sh
. ./path.sh
set -e
specdir=`pwd`/raw_feats/spec
datadir=/home/lcy/fmfcc

stage=0

. ./parse_options.sh || exit 1

if [ $stage -le 0 ]; then
    echo "Stage 0: prepare dataset."
    # utt2spk和wav.scp手动生成，这里仅生成spk2utt

    # #awk '{print $2" "$1}' $protofile >data/train/utt2spk || exit 1
    feats_extraction/utt2spk_to_spk2utt.pl data/train/utt2spk >data/train/spk2utt || exit 1
    # #awk -v dir="${datadir}/" -v type="train" '{print $2" sox "dir"/ASVspoof2019_"type"/flac/"$2".flac -t wav - |"}' $protofile >data/train/wav.scp || exit 1
    
    # #awk '{print $2" "$1}' $protofile >data/test/utt2spk || exit 1
    feats_extraction/utt2spk_to_spk2utt.pl data/test/utt2spk >data/test/spk2utt || exit 1
    # #awk -v dir="${datadir}/" -v type="test" '{print $2" sox "dir"/"type"/flac/"$2".flac -t wav - |"}' $protofile >data/test/wav.scp || exit 

    echo "dataset finished"
    exit 0
fi

# 提取spec特征
if [ $stage -le 1 ]; then
    echo "Stage 1: extract Spec feats."
    # for name in train test; do
    for name in train test; do
        [ -d data/spec/${name} ] || cp -r data/${name} data/spec/${name} || exit 1
        feats_extraction/make_spectrogram.sh --feats-config conf/feats/spec.conf --nj 10 --cmd "$train_cmd" \
                data/spec/${name} exp/make_spec $specdir || exit 1
    done
    echo "Spec feats done"
    exit 0
fi

# 提取cqt特征
if [ $stage -le 2 ]; then
    echo "Stage 2: extract CQT feats."
    python3 feats_extraction/compute_CQT.py --out_dir data/cqt --param_json_path conf/feats/cqt_48bpo_fmin15.json --num_workers 10 || exit 1
    python3 feats_extraction/GenLPCQTFeats_kaldi.py --work_dir data/cqt || exit 1

    # uncomment below for removing numpy data to save space.
    #for name in PA_train PA_dev PA_eval LA_train LA_dev LA_eval; do
    #    rm -rf data/cqt/${name}/*.npy || exit 1
    #done
    exit 0
fi

# 所有特征最后都要经过这一步 截断并生成utt2index文件
if [ $stage -le 3 ]; then
    echo "Stage 3: truncate features and generate labels."
    for name in train test; do
        for feat_type in spec-resnet; do
            echo "Processing $name $feat_type"
            python3 feats_extraction/feat_slicing.py --in-scp data/${feat_type}/${name}/feats.scp --out-scp data/${feat_type}/${name}/feats_slicing.scp --out-ark data/${feat_type}/${name}/feats_slicing.ark || exit 1
            python3 feats_extraction/convertID2index.py --scp-file data/${feat_type}/${name}/feats_slicing.scp --out-file data/${feat_type}/${name}/utt2index --label-file data/${feat_type}/${name}/utt2spk || exit 1
        done
    done
    exit 0
fi