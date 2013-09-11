#!/usr/bin/env bash
for test in {1..2}
do
  for exp in {1..5}
  do
    bash express/express-run.sh seqs abund/express/test${test}/exp${exp}
  done
done

bash express/express-run.sh seqs abund/express/test3/exp1
