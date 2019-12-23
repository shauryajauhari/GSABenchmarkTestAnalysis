Extracting_Valued_Results <- function(){
  
broadenrich_results_shredded <- list()
chipenrich_results_shredded <- list()

## Broadenrich

broadenrich_results <- readRDS("./Results/broadenrich/broadenrich_results")
for( i in 1:length(broadenrich_results))
{
  broadenrich_results_shredded[[i]] <- broadenrich_results[[i]]$results[,c(2,4)]
  
}
names(broadenrich_results_shredded) <- as.character(ChIPSeqSamples)
rm(broadenrich_results)

## Chipenrich

chipenrich_results <- readRDS("./Results/chipenrich/chipenrich_results")
for( i in 1:length(chipenrich_results))
{
  chipenrich_results_shredded[[i]] <- chipenrich_results[[i]]$results[,c(2,4)]
  
}
names(chipenrich_results_shredded) <- as.character(ChIPSeqSamples)
rm(chipenrich_results)


## Pruning the irrelevant results from seq2pathway

seq2pathway_results <- readRDS("./Results/seq2pathway/seq2pathway_results")
seq2pathway_results_shredded <- list()
for (i in 1:length(seq2pathway_results))
{
  seq2pathway_results_shredded[[i]] <- seq2pathway_results[[i]]$gene2pathway_result.FET$GO_BP[,c(1,3)]  
}
names(seq2pathway_results_shredded)<- as.character(ChIPSeqSamples)
rm(seq2pathway_results)
}