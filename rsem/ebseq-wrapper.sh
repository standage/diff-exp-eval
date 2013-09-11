#!/usr/bin/env bash
for test in {1..2}
do
  for exp in {1..5}
  do
    rsem/ebseq-run.sh abund/rsem/test${test}/exp${exp}
  done
done

rsem/ebseq-run.sh abund/rsem/test3/exp1
