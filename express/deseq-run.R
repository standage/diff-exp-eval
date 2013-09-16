#!/usr/bin/env Rscript

# Usage: Rscript deseq-run.R abund/rsem/testX/expY
args <- commandArgs(trailingOnly = TRUE)
datadir <- args[1]

# source("http://www.bioconductor.org/biocLite.R")
# biocLite("DESeq")
library("DESeq")

setwd(datadir)
moltypes <- c("ilocus", "mrna")
for(moltype in moltypes)
{
  infile <- sprintf("%s.total.counts.txt", moltype)
  total.counts <- read.table(infile, head=TRUE, row.names=1)
  exp.design <- data.frame(row.names = colnames(total.counts), condition = c("Q", "Q", "W", "W"))
  conditions <- exp.design$condition

  # Estimate size factors - difference in coverage between replicates
  data <- newCountDataSet(total.counts, conditions)
  data <- estimateSizeFactors(data)
  sizeFactors(data)

  # Estimate dispersion which is computed per-condition
  # data <- estimateDispersions(data, method="per-condition")
  data <- estimateDispersions(data, method="pooled")
  dispTable(data)

  # Results for comparison between castes
  outfile.all <- sprintf("%s.diffexp.all.txt", moltype)
  outfile.sig <- sprintf("%s.diffexp.sig.txt", moltype)
  qw <- nbinomTest(data, "Q", "W")
  write.table(qw, file=outfile.all ,sep="\t", row.names=rownames(qw), col.names=colnames(qw), quote=F)
  qwSig <- qw[ qw$padj < .05, ]
  qwSig <- qwSig[complete.cases(qwSig),]
  write.table(qwSig, file=outfile.sig, sep="\t", row.names=rownames(qwSig), col.names=colnames(qwSig), quote=F)
}

