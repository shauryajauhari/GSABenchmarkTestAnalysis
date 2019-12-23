executeChipenrichBroadenrichSeq2pathway <- function(){
## Testing individual data in benchmark dataset with each GSA tool package
## Also, since several of the tools don't acknowledge the mitochondrial DNA ("chrMT") entries have to be removed from the BED files.

regenerated_samples <- list()
seq2pathway_results <- list()

for (i in 1:length(ChIPSeqSamples))
{
  regenerated_samples[[i]] <- read_bed(paste0("./testData/",paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
  seq2pathway_results[[i]] <- seq2pathway_run(regenerated_samples[[i]])
}
saveRDS(seq2pathway_results, file = "./results/Seq2pathway/seq2pathway_results")
rm(seq2pathway_results)


chipenrich_results <- list()
for (i in 1:length(ChIPSeqSamples))
{
  chipenrich_results[[i]] <- chipenrich_run(paste0("./testData/",paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
}
saveRDS(chipenrich_results, file = "./results/Chipenrich/chipenrich_results")
rm(chipenrich_results)


broadenrich_results <- list()
for (i in 1:length(ChIPSeqSamples))
{
  broadenrich_results[[i]] <- broadenrich_run(paste0("./testData/",paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
}
saveRDS(broadenrich_results, file = "./results/Broadenrich/broadenrich_results")
rm(broadenrich_results)
}
