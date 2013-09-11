#!/usr/bin/env bash

# Usage: bash bowtie2-align-run.sh testX/expY seqs abund/express/testX/expY
readsdir=$(cd $(dirname $1); pwd)/$(basename $1) # Gets full path
seqdir=$(cd $(dirname $2); pwd)/$(basename $2) # Gets full path
outdir=$3
mkdir -p $outdir
cd $outdir
export PATH=/home/tothlab/bowtie2-2.1.0:$PATH

for moltype in ilocus mrna
do
  for caste in q w
  do
    for rep in {1..2}
    do
      sample=${caste}${rep}
      echo "Processing sample $sample"
      bowtie2 -x $seqdir/${moltype}.bowtie2idx \
                 -1 $readsdir/${sample}.1.fq \
                 -2 $readsdir/${sample}.2.fq \
                 --threads 4 \
                 --very-sensitive \
                 -S ${sample}.${moltype}.bowtie2.sam \
                 > ${sample}.${moltype}.bowtie2.log 2>&1
    done
  done
done
