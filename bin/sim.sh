#!/usr/bin/env bash

print_usage()
{
  cat <<EOF
Usage: $0 [options] seqs.fasta
  Options:
    -b:    baseline expression level (in 100bp-length read pairs);
           default is 150
    -h:    print this help message and exit
    -o:    directory in which to place reads; default is 'reads'
    -s:    seed for random number generator; default is -1
EOF
}

baseline=150
reads="reads"
seed=-1
while getopts "b:ho:s:" OPTION
do
  case $OPTION in
    b)
      baseline=$OPTARG
      ;;
    h)
      print_usage
      exit 0
      ;;
    o)
      reads=$OPTARG
      ;;
    s)
      seed=$OPTARG
      ;;
  esac
done
shift $((OPTIND-1))

if [[ $# != 1 ]]; then
  echo -e "error: please provide sequence file\n"
  print_usage
  exit 1
fi
infile=$1
test -d $reads && echo "error: output directory '$reads' exists" && exit 1
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

  wgsim -1 100 -2 100 -d 270 -s 40    \
        -N $(( $baseline * $q1abun )) \
        -S $seed $infile              \
        $reads/$explab.q1.1.fq        \
        $reads/$explab.q1.2.fq        \
        > /dev/null 2>&1

  wgsim -1 100 -2 100 -d 270 -s 40    \
        -N $(( $baseline * $q2abun )) \
        -S $seed $infile              \
        $reads/$explab.q2.1.fq        \
        $reads/$explab.q2.2.fq        \
        > /dev/null 2>&1

  wgsim -1 100 -2 100 -d 270 -s 40    \
        -N $(( $baseline * $w1abun )) \
        -S $seed $infile              \
        $reads/$explab.w1.1.fq        \
        $reads/$explab.w1.2.fq        \
        > /dev/null 2>&1

  wgsim -1 100 -2 100 -d 270 -s 40    \
        -N $(( $baseline * $w2abun )) \
        -S $seed $infile              \
        $reads/$explab.w2.1.fq        \
        $reads/$explab.w2.2.fq        \
        > /dev/null 2>&1
done
