#!/usr/bin/env bash

# Usage: bash bowtie2-align-run.sh testX/expY seqs abund/express/testX/expY
readsdir=$(cd $(dirname $1); pwd)/$(basename $1) # Gets full path
seqdir=$(cd $(dirname $2); pwd)/$(basename $2) # Gets full path
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
      echo "Processing sample $sample -> ${moltype} ($1)"
      bowtie2 -x $seqdir/${moltype}.bowtie2idx \
                 -1 $readsdir/${sample}.1.fq \
                 -2 $readsdir/${sample}.2.fq \
                 --threads 4 \
                 --very-sensitive \
                 -S ${sample}.${moltype}.bowtie2.sam \
                 > ${sample}.${moltype}.bowtie2.log 2>&1
                 # -D 20 -R 3 -N 1 -L 20 -i S,1,0.50
    done
  done
done
