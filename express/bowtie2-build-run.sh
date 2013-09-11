#!/usr/bin/env bash

export PATH=/home/tothlab/bowtie2-2.1.0:$PATH
bowtie2-build seqs/mrna-both-isoforms.fa seqs/mrna.bowtie2idx > seqs/mrna.bowtie2idx.log 2>&1
bowtie2-build seqs/ilocus.fa seqs/ilocus.bowtie2idx > seqs/ilocus.bowtie2idx.log 2>&1
