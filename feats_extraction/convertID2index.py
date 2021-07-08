import argparse

# create multi-labels for model training 
def convert_combined(scp_file, systemID_file, out_file):
    
    with open(scp_file) as f:
        temp = f.readlines()
    key_list = [x.strip().split()[0] for x in temp]

    with open(out_file, 'w') as f:
        for key in key_list:
            f.write('%s\n' % (key))

def convert(scp_file, out_file,label_file):
    ''' binary-class classification 
    '''
    with open(scp_file) as f:
        temp = f.readlines()
    key_list = [x.strip().split()[0] for x in temp]

    dict={}
    with open(label_file) as f:
        temp = f.readlines()
        for x in temp:
            a,b=x.strip().split(' ')
            if b=='-':
                b='-1'
            dict[int(a)]=str(b)
    print(dict)

    with open(out_file, 'w') as f:
        for i in range(len(key_list)):
            a,_=key_list[i].split('-')
            print(a)
            f.write('%s %s\n' % (key_list[i],dict[int(a)]))

if __name__ == '__main__':
    option = argparse.ArgumentParser()
    option.add_argument('--scp-file', type=str, default='data/spec/PA_train/feats_slicing.scp')
    option.add_argument('--out-file', type=str, default='data/spec/PA_train/utt2index')
    option.add_argument('--label-file', type=str, default='data/spec/PA_train/utt2spk')
    opt = option.parse_args()

    convert(opt.scp_file, opt.out_file,opt.label_file)
