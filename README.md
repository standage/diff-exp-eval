The code and data stored in this repository are being used to evaluate the performance of differential expression analysis tools.
A description of the analysis is provided below.

Daniel S. Standage  
Ali J. Berens

## Design

In this analysis, we are looking at expression at a single locus.
Three tests are used to investigate the performance of the differential expression analysis tools in various situations.
Each test is composed of experiments in which four samples of paired-end reads (two replicates for queens and two for workers) are simulated at various expression levels.
After the reads are simulated, the differential expression analysis tools will be run on each experiment and the results will be assessed.

In test1, the reads are sampled from a single mRNA molecule containing three exons.
In test2, the reads are sampled from two alternatively spliced mRNA molecules: isoform 1 (the same as used in test1), and isoform 2 (simply isoform 1 with the internal exon removed).
In test3, the reads are sampled from the same two mRNA molecules, but with sample-specific isoform preference.

The following schematic gives a breakdown of the three tests.
The numbers represent relative expression abundances, and each column represents an experiment within the test.

                 Test 1                                  Test 2                              Test 3
                 mRNA 1                                 mRNA 1/2                              exp1
         exp1 exp2 exp3 exp4 exp5                exp1 exp2 exp3 exp4 exp5                 mRNA1  mRNA2
    Q1    1    2    5    7    5             Q1    1    2    5    7    5              Q1     1      5
    Q2    1    2    5    3    1             Q2    1    2    5    3    1              Q2     1      5
    W1    1    1    1    1    5             W1    1    1    1    1    5              W1     5      1
    W2    1    1    1    1    1             W2    1    1    1    1    1              W2     5      1


## Selecting the mRNA

The `select.c` program (in the `seqs` directory) was written to identify all mRNAs in a genome annotation that meet the following criteria.

* composed of 3 exons
* internal exon has length > 150bp
* combined length of terminal exons is > 500bp

This program was applied to the *P. dominula* annotation r1.0, and an mRNA was selected randomly from this set--this is isoform 1.
Isoform 2 was created by removing the internal exon from isoform 2.


## Simulating read sequencing

The `simreads.pl` script (in the `simulate` directory) utilizes the `wgsim` program (https://github.com/lh3/wgsim) to simulate paired-end short read data.
The `config.yml` file contains a machine-readable representation of the schematic above and was used as input to generate the simulated reads.

    perl simulate/simreads.pl --in=seqs simulate/config.yml

The simulated reads are organized by test and experiment in directory `test1`, `test2`, and `test3`.

## Differential expression analysis

### Bowtie, RSEM, and EBSeq

One of the differential expression analysis tools we are evaluating is RSEM/EBSeq.
The `rsem` directory contains some shell scripts to automate the execution of this tool on each experiment.

    rsem/rsem-prep-run.sh
    rsem/rsem-calc-wrapper.sh
    rsem/ebseq-wrapper.sh

Unfortunately, there seems to be an error in the final step, such that no DE results are reported for any of the experiments.
I am investigating this now.

### Bowtie2, eXpress, and DESeq/edgeR

DESeq and edgeR are two other tools we are evaluating.
We are using the same mapping and expression estimation procedure (bowtie2 + eXpress) for both of these tools.
The `express` directory contains some shell and R scripts to automate the execution of these tools on each experiment.
Note that as of yet, only the DESeq differential expression analysis is included.

    express/bowtie2-build-run.sh
    express/bowtie2-align-wrapper.sh
    express/express-wrapper.sh
    express/deseq-wrapper.sh

As luck would have it, there are errors in the final step of this pipeline as well.
I'm investigating.
