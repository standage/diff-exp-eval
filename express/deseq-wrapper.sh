#!/usr/bin/env bash
for test in {1..2}
do
  for exp in {1..5}
  do
    express/deseq-run.R abund/express/test${test}/exp${exp} > abund/express/test${test}/exp${exp}/deseq-run.log 2>&1
  done
done

express/deseq-run.R abund/express/test3/exp1 > abund/express/test3/exp1/deseq-run.log 2>&1
