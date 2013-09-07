#!/usr/bin/env bash
for test in {1..2}
do
  for exp in {1..5}
  do
    bash rsem/ebseq-run.sh abund/test${test}/exp${exp}
  done
done

bash rsem/ebseq-run.sh abund/test3/exp1
