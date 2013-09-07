#!/usr/bin/env bash

# Usage: bash ebseq-run.sh abund/testX/expY
datadir=$1
cd $datadir
export PATH=/usr/local/src/RSEM:$PATH

for moltype in ilocus mrna
do
  rsem-generate-data-matrix rsem-q1-${moltype}.genes.results \
                            rsem-q2-${moltype}.genes.results \
                            rsem-w1-${moltype}.genes.results \
                            rsem-w2-${moltype}.genes.results \
                            > rsem-all-${moltype}.genes.results
  rsem-find-DE rsem-all-${moltype}.genes.results 2 0.05 rsem-${moltype}-diffexp \
               > rsem-${moltype}-diffexp.log 2>&1
done
