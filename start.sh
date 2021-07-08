
mkdir -p logs || exit 1

randomseed=0 # 0, 1, 2, ...
config=conf/training_mdl/seresnet34.json # configuration files in conf/training_mdl
feats=cqt  # `pa_spec`, `pa_cqt`, `pa_lfcc`, `la_spec`, `la_cqt` or `la_lfcc`
runid=SEResNet34cqt1

echo "Start training."
KALDI_ROOT=/home/lcy/kaldi python3 train.py --run-id $runid --random-seed $randomseed --data-feats $feats --configfile $config >logs/$runid || exit 1

# echo "Start evaluation on all checkpoints."
# for model in model_snapshots/$runid/*_[0-9]*.pth.tar; do
#     python3 eval.py --random-seed $randomseed --data-feats $feats --configfile $config --pretrained $model || exit 1
# done

# KALDI_ROOT=/home/lcy/kaldi python3 train.py --run-id SEResNet34lfcc1 --random-seed 0 --data-feats lfcc --configfile conf/training_mdl/seresnet34.json >logs/SEResNet34lfcc1 || exit 1

KALDI_ROOT=/home/lcy/kaldi python3 finetune.py --run-id SEResNet34spec1-ft --random-seed 0 --data-feats spec --pretrained model_snapshots/SEResNet34spec1/model_best.pth.tar --configfile conf/training_mdl/seresnet34-ft.json >logs/SEResNet34spec1-ft || exit 1

KALDI_ROOT=/home/lcy/kaldi python3 train-bak.py --run-id SEResNet34spec2 --random-seed 0 --data-feats spec --configfile conf/training_mdl/seresnet34.json >logs/SEResNet34spec2 || exit 1

KALDI_ROOT=/home/lcy/kaldi python3 train-bak.py --run-id SEResNet34specResnet2 --random-seed 0 --data-feats spec --configfile conf/training_mdl/seresnet50.json >logs/SEResNet34specResnet2 || exit 1