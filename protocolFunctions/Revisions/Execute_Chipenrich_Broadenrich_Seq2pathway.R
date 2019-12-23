Execute_Chipenrich_Broadenrich_Seq2pathway <- function(){
## Testing individual data in benchmark dataset with each GSA tool package
## Also, since several of the tools don't acknowledge the mitochondrial DNA ("chrMT") entries have to be removed from the BED files.
library(chipenrich)
regenerated_samples <- list()
seq2pathway_results <- list()

for (i in 1:length(ChIPSeqSamples))
{
  regenerated_samples[[i]] <- read_bed(paste0("./regen/",paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
  seq2pathway_results[[i]] <- seq2pathway_run(regenerated_samples[[i]])
}
saveRDS(seq2pathway_results, file = "./Results/seq2pathway/seq2pathway_results")
rm(seq2pathway_results)


chipenrich_results <- list()
for (i in 1:length(ChIPSeqSamples))
{
  chipenrich_results[[i]] <- chipenrich_run(paste0("./regen/",paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
}
saveRDS(chipenrich_results, file = "./Results/chipenrich/chipenrich_results")
rm(chipenrich_results)


broadenrich_results <- list()
for (i in 1:length(ChIPSeqSamples))
{
  broadenrich_results[[i]] <- broadenrich_run(paste0("./regen/",paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")))
}
saveRDS(broadenrich_results, file = "./Results/broadenrich/broadenrich_results")
rm(broadenrich_results)
}
