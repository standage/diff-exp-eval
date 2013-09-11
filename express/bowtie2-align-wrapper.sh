#!/usr/bin/env bash
for test in {1..2}
do
  for exp in {1..5}
  do
    bash express/bowtie2-align-run.sh test${test}/exp${exp} seqs abund/express/test${test}/exp${exp}
  done
done

bash express/bowtie2-align-run.sh test3/exp1 seqs abund/express/test3/exp1
