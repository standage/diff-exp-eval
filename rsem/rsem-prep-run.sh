#!/usr/bin/env bash

rsem-prepare-reference seqs/mrna-both-isoforms.fa seqs/mrna.rsemref > seqs/mrna.rsemref.log  2>&1
rsem-prepare-reference seqs/ilocus.fa seqs/ilocus.rsemref > seqs/ilocus.rsemref.log 2>&1
