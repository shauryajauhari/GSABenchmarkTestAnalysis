## This function works on pruning the relevant entries from the Chipenrich, Broadenrich, and Seq2pathway tools' results. We are solely interested in
## the enrichment terms and the corresponding value of statistical significance (p).

extractingValuedResults <- function(){
    
## Broadenrich

broadenrichResultsShredded <- list()
broadenrichResults <- readRDS("./results/Broadenrich/broadenrichResults")
for( i in 1:length(broadenrichResults))
{
  broadenrichResultsShredded[[i]] <- broadenrichResults[[i]][[i]]$results[,c(2,4)]
  
}
names(broadenrichResultsShredded) <- as.character(ChIPSeqSamples)
saveRDS(broadenrichResultsShredded, file = "./results/Broadenrich/broadenrichResultsShredded")
rm(broadenrichResults)

## Chipenrich

chipenrichResultsShredded <- list()
chipenrichResults <- readRDS("./results/Chipenrich/chipenrichResults")
for( i in 1:length(chipenrichResults))
{
  chipenrichResultsShredded[[i]] <- chipenrichResults[[i]][[i]]$results[,c(2,4)]
  
}
names(chipenrichResultsShredded) <- as.character(ChIPSeqSamples)
saveRDS(chipenrichResultsShredded, file = "./results/Chipenrich/chipenrichResultsShredded")
rm(chipenrichResults)


## Pruning the irrelevant results from Seq2pathway

seq2pathwayResultsShredded <- list()
seq2pathwayResults <- readRDS("./results/Seq2pathway/seq2pathwayResults")

for (i in 1:length(seq2pathwayResults))
{
  seq2pathwayResultsShredded[[i]] <- rbind(seq2pathwayResults[[i]][[i]]$gene2pathway_result.FET$GO_BP[,c(1,3)],
                                           seq2pathwayResults[[i]][[i]]$gene2pathway_result.FET$GO_CC[,c(1,3)],
                                           seq2pathwayResults[[i]][[i]]$gene2pathway_result.FET$GO_MF[,c(1,3)])
}
names(seq2pathwayResultsShredded)<- as.character(ChIPSeqSamples)
saveRDS(seq2pathwayResultsShredded, file = "./results/Seq2pathway/seq2pathwayResultsShredded")
rm(seq2pathwayResults)
}