import numpy as np
import os
import random
import shutil
import time
import warnings
import math 
from collections import defaultdict
from functools import reduce

from local import optimizer

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.nn.parallel
import torch.backends.cudnn as cudnn
import torch.distributed as dist
import torch.optim
import torch.utils.data
import torch.utils.data.distributed
import torchvision.transforms as transforms
import torchvision.datasets as datasets
import torchvision.models as models

def prediction(val_loader, model, device, output_file,utt2index):
    
    # switch to evaluate mode
    utt2scores = defaultdict(list) 
    model.eval()
    # find = False
    # samples = 0
    # print(len(val_loader))
    with torch.no_grad():
        for i, (utt_list, input, target) in enumerate(val_loader):
            #print(utt_list, input, target)
            input  = input.to(device, non_blocking=True)
            target = target.to(device, non_blocking=True).view((-1,))
            top1 = optimizer.AverageMeter()

            # compute output
            output = model(input)
            score = output[:,1] # use log-probability of the bonafide class for scoring 
            acc1, = optimizer.accuracy(output, target, topk=(1, ))
            top1.update(acc1[0], input.size(0))
           
            #print(top1.avg)

            for index, utt_id in enumerate(utt_list):
                curr_utt = ''.join(utt_id.split('-')[0])
                utt2scores[curr_utt].append(score[index].item()) 
   
        # first do averaging
        with open(utt2index, 'r') as f:
            temp = f.readlines()
        content  = [x.strip() for x in temp]
        utt_list = [x.split('-')[0] for x in content]

        with open(output_file, 'w') as f:
            f.writelines('{\n')
            for index, utt_id in enumerate(sorted(set(utt_list),key=utt_list.index)):
                score_list = utt2scores[utt_id]
                assert score_list != [], '%s' %utt_id   
                avg_score  = reduce(lambda x, y: x + y, score_list) / len(score_list)
                if utt_id.find('.wav')==-1:
                    utt_id=utt_id+'.wav'
                if utt_id=="20030000.wav":
                    f.write('  "%s":%8f\n' % (utt_id, math.exp(avg_score)))
                else:
                    f.write('  "%s":%8f,\n' % (utt_id, math.exp(avg_score)))
                #f.writelines("'  '+'"'+{}+'": ' + {.f} +',\n'".format(math.exp(avg_score)))
                #f.write('%s %f\n' % (utt_id, avg_score))
            f.writelines('}')
                #eerf.write('%f target\n' %avg_score)math.exp(avg_score)


