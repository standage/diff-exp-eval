#!/usr/bin/env bash

# Usage: bash ebseq-run.sh abund/rsem/testX/expY
datadir=$1
cd $datadir

for moltype in ilocus mrna
do
  rsem-generate-data-matrix rsem-q1-${moltype}.genes.results \
                            rsem-q2-${moltype}.genes.results \
                            rsem-w1-${moltype}.genes.results \
                            rsem-w2-${moltype}.genes.results \
                            > rsem-all-${moltype}.genes.results
  rsem-run-ebseq rsem-all-${moltype}.genes.results 2,2 \
                 rsem-ebseq-results-${moltype}.txt \
                 > rsem-ebseq-${moltype}.log 2>&1

  rsem-control-fdr rsem-ebseq-results-${moltype}.txt 0.05 \
                   rsem-ebseq-diffexp-${moltype}.txt \
                    > rsem-${moltype}-diffexp.log 2>&1
done
