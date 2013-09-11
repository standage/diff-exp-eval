#!/usr/bin/env bash
for test in {1..2}
do
  for exp in {1..5}
  do
    express/express-run.sh seqs abund/express/test${test}/exp${exp}
    express/express-combine.R abund/express/test${test}/exp${exp}
  done
done

express/express-run.sh seqs abund/express/test3/exp1
express/express-combine.R abund/express/test3/exp1
