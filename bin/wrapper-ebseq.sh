for test in {1..2}
do
  for exp in {1..5}
  do
    bash bin/run-ebseq.sh abund/test${test}/exp${exp}
  done
done
