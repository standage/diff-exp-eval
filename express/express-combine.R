#!/usr/bin/env Rscript

# Usage: Rscript express-combine.R abund/express/testX/expY
args <- commandArgs(trailingOnly = TRUE)
datadir <- args[1]
setwd(datadir)

moltypes <- c("ilocus", "mrna")
for(moltype in moltypes)
{
  q1file <- sprintf("q1.%s.express/results.xprs", moltype)
  q2file <- sprintf("q2.%s.express/results.xprs", moltype)
  w1file <- sprintf("w1.%s.express/results.xprs", moltype)
  w2file <- sprintf("w2.%s.express/results.xprs", moltype)

  q1.data <- read.table(q1file, head=TRUE)
  q2.data <- read.table(q2file, head=TRUE)
  w1.data <- read.table(w1file, head=TRUE)
  w2.data <- read.table(w2file, head=TRUE)

  q1.abund <- cbind(as.data.frame(q1.data$target_id), q1.data$tot_counts)
  q2.abund <- cbind(as.data.frame(q2.data$target_id), q2.data$tot_counts)
  w1.abund <- cbind(as.data.frame(w1.data$target_id), w1.data$tot_counts)
  w2.abund <- cbind(as.data.frame(w2.data$target_id), w2.data$tot_counts)

  q1.abund <- q1.abund[order(as.data.frame(q1.abund[,1])),]
  q2.abund <- q2.abund[order(as.data.frame(q2.abund[,1])),]
  w1.abund <- w1.abund[order(as.data.frame(w1.abund[,1])),]
  w2.abund <- w2.abund[order(as.data.frame(w2.abund[,1])),]

  total.counts <- cbind(as.data.frame(q1.abund[,1]), q1.abund[,2], q2.abund[,2], w1.abund[,2], w2.abund[,2])
  colnames(total.counts) <- c("MolID", "Q1", "Q2", "W1", "W2")
  outfile <- sprintf("%s.total.counts.txt", moltype)
  write.table(total.counts, file=outfile, row.names=FALSE, sep="\t", quote=FALSE)
}

