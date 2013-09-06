#!/usr/bin/env bash
seq=$1
test -z $seq && echo "Please provide sequence" &&  exit
reads=$2
test -z $reads && echo "Please provide outdir" &&  exit
mkdir $reads

# Experiment data: label:queen-abundances:worker-abundances
for exp in exp1:1,1:1,1 exp2:2,2:1,1 exp3:5,5:1,1 exp4:7,3:1,1 exp5:5,1:5,1
do
  explab=`echo $exp    | cut -f 1 -d ':'`
  qabuns=`echo $exp    | cut -f 2 -d ':'`
  wabuns=`echo $exp    | cut -f 3 -d ':'`
  q1abun=`echo $qabuns | cut -f 1 -d ','`
  q2abun=`echo $qabuns | cut -f 2 -d ','`
  w1abun=`echo $wabuns | cut -f 1 -d ','`
  w2abun=`echo $wabuns | cut -f 2 -d ','`

  echo "Experiment '$explab': Q1=$q1abun, Q2=$q2abun, W1=$w1abun, W2=$w2abun"
  baseline=150 # Baseline number of reads

  wgsim -1 100 -2 100 -d 270 -s 40    \
        -N $(( $baseline * $q1abun )) \
        $seq                          \
        $reads/$explab.q1.1.fq        \
        $reads/$explab.q1.2.fq        \
        > /dev/null 2>&1

  wgsim -1 100 -2 100 -d 270 -s 40    \
        -N $(( $baseline * $q2abun )) \
        $seq                          \
        $reads/$explab.q2.1.fq        \
        $reads/$explab.q2.2.fq        \
        > /dev/null 2>&1

  wgsim -1 100 -2 100 -d 270 -s 40    \
        -N $(( $baseline * $w1abun )) \
        $seq                          \
        $reads/$explab.w1.1.fq        \
        $reads/$explab.w1.2.fq        \
        > /dev/null 2>&1

  wgsim -1 100 -2 100 -d 270 -s 40    \
        -N $(( $baseline * $w2abun )) \
        $seq                          \
        $reads/$explab.w2.1.fq        \
        $reads/$explab.w2.2.fq        \
        > /dev/null 2>&1
done
