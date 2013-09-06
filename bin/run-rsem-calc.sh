#!/usr/bin/env bash

readsdir=$(cd $(dirname $1); pwd)/$(basename $1) # Gets full path
prefix=$2
seqdir=$(cd $(dirname $3); pwd)/$(basename $3) # Gets full path
outdir=$4
mkdir -p $outdir
cd $outdir
export PATH=/usr/local/src/RSEM:$PATH

for moltype in ilocus mrnas
do
  for caste in q w
  do
    for rep in {1..2}
    do
      sample=${caste}${rep} #exp1.q1.1.fq
      rsem-calculate-expression --paired-end \
                                --num-threads 4 \
                                --temporary-folder temp-rsem-${sample}-${moltype} \
                                --keep-intermediate-files \
                                $readsdir/$prefix.${sample}.1.fq \
                                $readsdir/$prefix.${sample}.2.fq \
                                $seqdir/${moltype}.rsemref \
                                rsem-${sample}-${moltype} \
                                > log-${sample}-${moltype}.rsem 2>&1
    done
  done
done
