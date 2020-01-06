executeChipenrichBroadenrichSeq2pathway <- function(loc){
## Testing individual data in benchmark dataset with each GSA tool package
## Also, since several of the tools don't acknowledge the mitochondrial DNA ("chrMT") entries have to be removed from the BED files.

regeneratedSamples <- list()


## This module holds the individual executives for the tools in question
## Seq2pathway

seq2pathwayRun <- function(x){
  results <- list()
  results [[i]] <- runseq2pathway(x, genome = "hg19")
  return(results)
}


## Chipenrich

chipenrichRun <- function(x){
  results <- list()
  results [[i]] <- chipenrich(peaks = x, out_name = NULL, genesets = c("GOBP", "GOCC", "GOMF", "kegg_pathway"), genome = "hg19", qc_plots = FALSE, n_cores = 1)
  return(results)
}


## Broadenrich

broadenrichRun <- function(x){
  results <- list()
  results [[i]] <- broadenrich(peaks = x, out_name = NULL, genesets = c("GOBP", "GOCC", "GOMF", "kegg_pathway"), genome = "hg19", qc_plots = FALSE, n_cores = 1)
  return(results)
}


## Execution

seq2pathwayResults <- list()
for (i in 1:length(ChIPSeqSamples))
{
  regeneratedSamples[[i]] <- read_bed(paste0(loc,paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
  seq2pathwayResults[[i]] <- seq2pathwayRun(regeneratedSamples[[i]])
}
system("mkdir ./results/Seq2pathway")
saveRDS(seq2pathwayResults, file = "./results/Seq2pathway/seq2pathwayResults")
rm(seq2pathwayResults)


chipenrichResults <- list()
for (i in 1:length(ChIPSeqSamples))
{
  chipenrichResults[[i]] <- chipenrichRun(paste0(loc,paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
}
system("mkdir ./results/Chipenrich")
saveRDS(chipenrichResults, file = "./results/Chipenrich/chipenrichResults")
rm(chipenrichResults)


broadenrichResults <- list()
for (i in 1:length(ChIPSeqSamples))
{
  broadenrichResults[[i]] <- broadenrichRun(paste0(loc,paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
}
system("mkdir ./results/Broadenrich")
saveRDS(broadenrichResults, file = "./results/Broadenrich/broadenrichResults")
rm(broadenrichResults)
}
