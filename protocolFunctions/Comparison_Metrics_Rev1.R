Comparison_Metrics <- function(){
  
  tools_results <- c("chipenrich_results_shredded", "broadenrich_results_shredded","seq2pathway_results_shredded","enrichr_results_shredded","great_results_shredded")
  disease_pools <- c("colorectal_cancer_id_pool", "alzheimers_disease_id_pool", "gastric_cancer_id_pool", "prostate_cancer_id_pool")
  # disease_pools <- trimws(paste0(as.character(unique(tolower(trimws(ChIPSeqDataMaster$Disease...Target..Pathway)))),"_id_pool"))
  # disease_pools <- str_replace(gsub("\\s+", "_", str_trim(disease_pools)), "D", "d")
  ## Rank calculation | Prioritization | Chipenrich
  
  for ( d in 1:length(disease_pools))
  {
    ranks <- list()
    prioritization_list <- list()
    x <- 1
    
    
    for (i in 1:length(chipenrich_results_shredded$GSM1847178$Geneset.ID))
    {
      for (j in eval(parse(text=disease_pools[d])))
      {
        if (chipenrich_results_shredded$GSM1847178$Geneset.ID[i] == j)
        {
          ranks[[x]]<- i
          x <- x+1
          
        }
      }
    }
    cat("The enrichment terms that matched are:\n")
    for (k in ranks)
    {
      print(chipenrich_results_shredded$GSM1847178$Geneset.ID[k])
    }
    
    for_prioritization <- as.double((ranks[[1]]/length(chipenrich_results_shredded$GSM1847178$Geneset.ID)*100))
    cat("\nThe metric for prioritization for",as.character(disease_pools[d]), "is",for_prioritization,"\n")
    
    ### eval(parse(text=(paste0(paste0(tools_results[1],"$"), ChIPSeqSamples[1]))))
    
    ## P-Value calculation | Surrogate Sensitivity | Chipenrich
    
    ## We are interested to highlight the first (lowest) p-value of the match between target pathway and the tool outputs. The median of all such p-values for every sample in the benchmark dataset shall be the surrogate sensitivity. Note that the surrogate sensitivity doesn't take into account the p< 0.05 threshold.
    
    p_values <- list()
    x <- 1
    
    for (i in 1:length(chipenrich_results_shredded$GSM1847178$Geneset.ID))
    {
      
      if (chipenrich_results_shredded$GSM1847178$Geneset.ID[i] == j)
      {
        p_values[[x]]<- chipenrich_results_shredded$GSM1847178$P.value[i]
        x <- x+1
        
      }
    }
    
    
    for_surrogate_sensitivity <- p_values[[1]]
    
    
    ## Classical Sensitivity, Specificity, Precision | Chipenrich
    
    true_positives <- list()
    true_negatives_ids <- list()
    false_positives1_ids <- list()
    false_positives2_ids <- list()
    false_positives <- list()
    false_negatives <- list()
    count1 <- 1
    count2 <- 1
    
    ## Iterating through the entire length of tool results and id-pool gives the same impression as usign "intersect" and "setdiff" set-operations, thereby achieving the common objective; just for flavor here.
    
    for (i in 1:length(chipenrich_results_shredded$GSM1847178$Geneset.ID))
    {
      for (j in eval(parse(text=disease_pools[d])))
      {
        if (chipenrich_results_shredded$GSM1847178$Geneset.ID[i] == j && chipenrich_results_shredded$GSM1847178$P.value[i] <= 0.05)
        {
          true_positives[[count1]]<- j
          count1 <- count1 + 1
        }
        if (chipenrich_results_shredded$GSM1847178$Geneset.ID[i] == j && chipenrich_results_shredded$GSM1847178$P.value[i] > 0.05)
        {
          false_negatives[[count2]]<- j
          count2 <- count2 + 1
        }
      }
    }
    
    
    ## Tool results' subsets on the basis of statistical significance.
    greater_than_0.05 <- chipenrich_results_shredded$GSM1847178[which(chipenrich_results_shredded$GSM1847178$P.value > 0.05),]
    less_than_0.05 <- chipenrich_results_shredded$GSM1847178[which(chipenrich_results_shredded$GSM1847178$P.value <= 0.05),]
    true_negatives_ids <- setdiff(greater_than_0.05$Geneset.ID, eval(parse(text=disease_pools[d]))) ## All ids that are there in the tool result with p > 0.05 and absent in the disease pool.
    
    false_positives1_ids <- intersect(eval(parse(text=disease_pools[d])),greater_than_0.05$Geneset.ID)
    false_positives2_ids <- setdiff(less_than_0.05$Geneset.ID,eval(parse(text=disease_pools[d])))
    
    false_positives <- c(false_positives1_ids,false_positives2_ids)
    
    ## Results
    
    cat("True positives for", as.character(disease_pools[d]), "is",length(true_positives),"\n")
    cat("\nTrue negatives for", as.character(disease_pools[d]), "is",length(true_negatives_ids),"\n")
    cat("\nFalse negatives for", as.character(disease_pools[d]), "is",length(false_negatives),"\n")
    cat("\nFalse positives for", as.character(disease_pools[d]), "is",length(false_positives),"\n")
    precision <- length(true_positives)/(length(true_positives)+length(false_positives))
    cat("\nPrecision(in percentage) for", as.character(disease_pools[d]), "is", precision*100,"\n")
    sensitivity <- length(true_positives)/(length(true_positives)+length(false_negatives))
    cat("\nSensitivity(in percentage) for", as.character(disease_pools[d]), "is", sensitivity*100,"\n")
    cat("\nSurrogate Sensitivity(in percentage) for", as.character(disease_pools[d]), "is", for_surrogate_sensitivity*100,"\n")
    specificity <- length(true_negatives_ids)/(length(true_negatives_ids)+length(false_positives))
    cat("\nSpecificity(in percentage) for", as.character(disease_pools[d]), "is", specificity*100,"\n")
    
  }
}