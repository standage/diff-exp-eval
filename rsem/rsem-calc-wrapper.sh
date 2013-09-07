#!/usr/bin/env bash
for test in {1..2}
do
  for exp in {1..5}
  do
    bash rsem/rsem-calc-run.sh test${test}/exp${exp} seqs abund/test${test}/exp${exp}
  done
done

bash rsem/rsem-calc-run.sh test3/exp1 seqs abund/test3/exp1
