#!/usr/bin/env bash

export PATH=/usr/local/src/RSEM:$PATH
rsem-prepare-reference seqs/mrnas.fa  seqs/mrnas.rsemref  > seqs/mrnas.rsemref.log  2>&1
rsem-prepare-reference seqs/ilocus.fa seqs/ilocus.rsemref > seqs/ilocus.rsemref.log 2>&1
