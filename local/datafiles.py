import os

spec = {
        'train_scp': 'data/spec/train/feats_slicing.scp',
        'train_utt2index': 'data/spec/train/utt2index',
        'scoring_dir': 'scoring/cm_scores/',
        'test_scp': 'data/spec/test/feats_slicing.scp',
        'test_utt2index': 'data/spec/test/utt2index',
        'val_scp': 'data/spec/val/feats_slicing.scp',
        'val_utt2index': 'data/spec/val/utt2index',
        'tiny_scp': 'data/spec/tiny/feats_slicing.scp',
        'tiny_utt2index': 'data/spec/tiny/utt2index',
        'sr_scp': 'data/spec-resnet/train/feats_slicing.scp',
        'sr_utt2index': 'data/spec-resnet/train/utt2index',
        'srt_scp': 'data/spec-resnet/test/feats_slicing.scp',
        'srt_utt2index': 'data/spec-resnet/test/utt2index',
}

lfcc = {
        'train_scp': 'data/lfcc/train/feats_slicing.scp',
        'train_utt2index': 'data/lfcc/train/utt2index',
        'scoring_dir': 'scoring/cm_scores/',
        'test_scp': 'data/lfcc/test/feats_slicing.scp',
        'test_utt2index': 'data/lfcc/test/utt2index',
        'tnv_scp': 'data_bak/lfcc/tnv/feats_slicing.scp',
        'tnv_utt2index': 'data_bak/lfcc/tnv/utt2index',
}

cqt = {
        'train_scp': 'data/cqt/train/feats_slicing.scp',
        'train_utt2index': 'data/cqt/train/utt2index',
        'scoring_dir': 'scoring/cm_scores/',
        'test_scp': 'data/cqt/test/feats_slicing.scp',
        'test_utt2index': 'data/cqt/test/utt2index',
}

spec_resnet = {
        'train_scp': 'data/spec-resnet/train/feats_slicing.scp',
        'train_utt2index': 'data/spec-resnet/train/utt2index',
        'scoring_dir': 'scoring/cm_scores/',
        'test_scp': 'data/spec-resnet/test/feats_slicing.scp',
        'test_utt2index': 'data/spec-resnet/test/utt2index',
}

debug_feats = {
        'train_scp': 'data/debug_samples/feats_slicing.scp',
        'train_utt2index': 'data/debug_samples/utt2index',
        'scoring_dir': 'scoring/cm_scores/',
        'test_scp': 'data/debug_samples/feats_slicing.scp',
        'test_utt2index': 'data/debug_samples/utt2index',
}

data_prepare = {
        'spec': spec,
        'cqt': cqt,
        'lfcc': lfcc,
        'debug_feats': debug_feats,
}

