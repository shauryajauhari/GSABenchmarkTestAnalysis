calculateSensitivitySpecificityPrecision <- function(tool)
  
{
  forPrioritization <- vector("list", length(disease_pools))
  forSensitivity <- vector("list", length(disease_pools)) 
  forSpecificity <- vector("list", length(disease_pools)) 

  ## Classical Sensitivity, Specificity, Precision
  
  for (d in 1:length(disease_pools))
  {
    for (sam in 1:length(ChIPSeqSamples))
    {
      true_positives <- list()
      true_negatives_ids <- list()
      false_positives1_ids <- list()
      false_positives2_ids <- list()
      false_positives <- list()
      false_negatives <- list()
    
    ## Tool results' subsets on the basis of statistical significance.
    greater_than_0.05 <- eval(parse(text=(paste0(paste0(tools_results[tool],"$"), ChIPSeqSamples[sam]))))[which(eval(parse(text=(paste0(paste0(tools_results[tool],"$"), ChIPSeqSamples[sam]))))[2] > 0.05),]
    less_than_0.05 <- eval(parse(text=(paste0(paste0(tools_results[tool],"$"), ChIPSeqSamples[sam]))))[which(eval(parse(text=(paste0(paste0(tools_results[tool],"$"), ChIPSeqSamples[sam]))))[2] <= 0.05),]
    true_negatives_ids <- setdiff(greater_than_0.05[[1]], eval(parse(text=disease_pools[d]))) ## All ids that are there in the tool result with p > 0.05 and absent in the disease pool.
    
    false_positives1_ids <- intersect(eval(parse(text=disease_pools[d])),greater_than_0.05[[1]])
    false_positives2_ids <- setdiff(less_than_0.05[[1]],eval(parse(text=disease_pools[d])))
    
    false_positives <- c(false_positives1_ids,false_positives2_ids)
    true_positives <- intersect(less_than_0.05[[1]], eval(parse(text=disease_pools[d])))
    false_negatives <- intersect(greater_than_0.05[[1]], eval(parse(text=disease_pools[d])))
    
    ## Results
    library(tidyverse)
    
    precision <- length(true_positives)/(length(true_positives)+length(false_positives))
    sensitivity <- length(true_positives)/(length(true_positives)+length(false_negatives))
    specificity <- length(true_negatives_ids)/(length(true_negatives_ids)+length(false_positives))

    # Store results
    forPrecision[[d]][[sam]] <- precision
    forSensitivity[[d]][[sam]] <- sensitivity
    forSpecificity[[d]][[sam]] <- specificity

    }

  } 
  ## Precision
  forPrecision <- as.data.frame(forPrecision) 
  colnames(forPrecision) <- diseasePools
  forPrecision$Samples <- ChIPSeqSamples 

  ##Sensitivity
  forSensitivity <- as.data.frame(forSensitivity) 
  colnames(forPrecision) <- diseasePools
  forSensitivity$Samples <- ChIPSeqSamples 

  ##Specificity
  forSpecificity <- as.data.frame(forSpecificity) 
  colnames(forSpecificity) <- diseasePools
  forSpecificity$Samples <- ChIPSeqSamples

  ## Let's return a list for convenience; a list of dataframes.
  masterReturn <- list(forSensitivity, forSpecificity, forPrecision)
  return(masterReturn)

}