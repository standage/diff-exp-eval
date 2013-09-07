#!/usr/bin/env bash
for test in {1..2}
do
  for exp in {1..5}
  do
    bash bin/run-rsem-calc.sh test${test} exp${exp} seqs abund/test${test}/exp${exp}
  done
done
