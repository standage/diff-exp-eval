#!/usr/bin/env bash

# Usage: bash rsem-calc-run.sh testX/expY seqs abund/rsem/testX/expY
readsdir=$(cd $(dirname $1); pwd)/$(basename $1) # Gets full path
seqdir=$(cd $(dirname $2); pwd)/$(basename $2)   # Gets full path
outdir=$3
mkdir -p $outdir
cd $outdir

for moltype in ilocus mrna
do
  for caste in q w
  do
    for rep in {1..2}
    do
      sample=${caste}${rep}
      rsem-calculate-expression --paired-end \
                                --num-threads 4 \
                                --temporary-folder temp-rsem-${sample}-${moltype} \
                                --keep-intermediate-files \
                                $readsdir/${sample}.1.fq \
                                $readsdir/${sample}.2.fq \
                                $seqdir/${moltype}.rsemref \
                                rsem-${sample}-${moltype} \
                                > log-${sample}-${moltype}.rsem 2>&1
    done
  done
done
