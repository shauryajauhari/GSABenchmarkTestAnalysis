tools_results <- c("chipenrich_results_shredded", "broadenrich_results_shredded","seq2pathway_results_shredded","enrichr_results_shredded","great_results_shredded")
disease_pools <- c("colorectal_cancer_id_pool", "alzheimers_disease_id_pool", "gastric_cancer_id_pool", "prostate_cancer_id_pool")

priorit <- function(){

tool <- as.integer(readline("Enter the tool index (1: Chipenrich, 2: Broadenrich, 3: Seq2Pathway, 4: Enrichr, 5: GREAT):"))
sam <- as.integer(readline("Enter the sample index (Refer ChIPSeqMaster):"))

for (d in 1:length(disease_pools))
{
  ranks <- list()
  prioritization_list <- list()
  x <- 1

  for (i in 1:length(eval(parse(text=(paste0(paste0(tools_results[tool],"$"), ChIPSeqSamples[sam]))))[[1]]))
  {
    for (j in (eval(parse(text=disease_pools[[d]]))))
    {
      if((eval(parse(text=(paste0(paste0(tools_results[tool],"$"), ChIPSeqSamples[sam]))))[[1]])[[i]] == j)
        {
          ranks[[x]]<- i
          x <- x+1
        }
    }
  }
  cat("The enrichment terms that matched are:\n")
  for (k in ranks)
  {
    print(eval(parse(text=(paste0(paste0(tools_results[tool],"$"), ChIPSeqSamples[sam]))))[[1]][[k]])
  }

  for_prioritization <- as.double((ranks[[1]]/nrow((eval(parse(text=(paste0(paste0(tools_results[tool],"$"), ChIPSeqSamples[sam]))))[1]))*100))
  cat("\nThe metric for prioritization for",as.character(disease_pools[d]), "is",for_prioritization,"\n")

}
}