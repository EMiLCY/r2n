. ./path.sh

randomseed=0 # 0, 1, 2, ...
config=conf/training_mdl/seresnet34.json # configuration files in conf/training_mdl
feats=cqt  # `spec`, `cqt`, `lfcc`
pretrained=model_snapshots/SEResNet34cqt1/1_99.900.pth.tar

KALDI_ROOT=/home/lcy/kaldi python3 eval.py --data-feats $feats --pretrained $pretrained --configfile $config --random-seed $randomseed|| exit 1

# KALDI_ROOT=/home/lcy/kaldi python3 eval.py --data-feats spec --pretrained model_snapshots/SEResNet34specResnet1/model_best.pth.tar --configfile conf/training_mdl/seresnet34.json --random-seed 0
