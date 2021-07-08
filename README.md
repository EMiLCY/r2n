# csig-res2net
### Feature extraction

   Three features are adopted in this repo, i.e. Spec, LFCC and CQT. The top script for feature extraction is `extract_feats.sh`, where the first step (Stage 0) is required to prepare dataset before feature extraction. It also provides feature extraction for Spec (Stage 1) and CQT (Stage 2), while for LFCC extraction, you need to run the `./baseline/write_feature_kaldi_PA_LFCC.sh` and `./baseline/write_feature_kaldi_LA_LFCC.sh` scripts. All features are required to be truncated by the Stage 4 in `extract_feats.sh`.

   Given your dataset directory in `extract_feats.sh`, you can run any stage (e.g. NUM) in the `extract_feats.sh` by

   ```bash
./extract_feats.sh --stage NUM
   ```

   For LFCC extraction, you need to run

   ```bash
./baseline/write_feature_kaldi_LA_LFCC.sh
./baseline/write_feature_kaldi_PA_LFCC.sh
   ```

### System training and evaluation

   This repo supports different system architectures, as configured in the `conf/training_mdl` directory. You can specify the system architecture, acoustic features in `start.sh`, then run the codes below to train and evaluate your models.

   ```bash
./start.sh
   ```

   Remember to rename your `runid` in `start.sh` to differentiate each configuration.
   From our experiments after ICASSP 2021 submission, we observe that SERes2Net50 configured with `14w_8s` and `26w_8s` can achieve slightly better performance.

   For evaluating systems, run

   ```bash
./eval.sh
   ```
