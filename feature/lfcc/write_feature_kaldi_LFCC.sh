#!/bin/bash

# convert .txt file into kaldi formats (.ark and .scp)
for name in train test; do
        copy-feats ark,t:data/lfcc/${name}.txt ark,scp:`pwd`/data/lfcc/${name}/feats.ark,`pwd`/data/lfcc/${name}/feats.scp
done

