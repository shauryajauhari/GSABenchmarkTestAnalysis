calculateSensitivitySpecificityPrecision <- function(tool)
  
{
  forPrioritization <- vector("list", length(ChIPSeqSamples))
  forSensitivity <- vector("list", length(ChIPSeqSamples)) 
  forSpecificity <- vector("list", length(ChIPSeqSamples)) 

  ## Classical Sensitivity, Specificity, Precision
  
  for (sam in 1:length(ChIPSeqSamples))
  {
    for (dis in 1:length(diseasePools))
    {
      truePositives <- list()
      trueNegativesIDs <- list()
      falsePositives1IDs <- list()
      falsePositives2IDs <- list()
      falsePositives <- list()
      falseNegatives <- list()
    
    ## Tool results' subsets on the basis of statistical significance.
    greaterThan0.05 <- eval(parse(text=(paste0(paste0(toolsResults[tool],"$"), ChIPSeqSamples[sam]))))[which(eval(parse(text=(paste0(paste0(toolsResults[tool],"$"), ChIPSeqSamples[sam]))))[2] > 0.05),]
    lessThan0.05 <- eval(parse(text=(paste0(paste0(toolsResults[tool],"$"), ChIPSeqSamples[sam]))))[which(eval(parse(text=(paste0(paste0(toolsResults[tool],"$"), ChIPSeqSamples[sam]))))[2] <= 0.05),]
    trueNegativesIDs <- setdiff(greaterThan0.05[[1]], eval(parse(text=diseasePools[dis]))) ## All ids that are there in the tool result with p > 0.05 and absent in the disease pool.
    
    falsePositives1IDs <- intersect(eval(parse(text=diseasePools[d])),greaterThan0.05[[1]])
    falsePositives2IDs <- setdiff(lessThan0.05[[1]],eval(parse(text=diseasePools[dis])))
    
    falsePositives <- c(falsePositives1IDs,falsePositives2IDs)
    truePositives <- intersect(lessThan0.05[[1]], eval(parse(text=diseasePools[dis])))
    falseNegatives <- intersect(greaterThan0.05[[1]], eval(parse(text=diseasePools[dis])))
    
    ## Results
    
    precision <- length(truePositives)/(length(truePositives)+length(falsePositives))
    sensitivity <- length(truePositives)/(length(truePositives)+length(falseNegatives))
    specificity <- length(trueNegativesIDs)/(length(trueNegativesIDs)+length(falsePositives))

    # Store results
    forPrecision[[sam]][dis] <- precision
    forSensitivity[[sam]][dis] <- sensitivity
    forSpecificity[[sam]][dis] <- specificity

    }

  } 
  ## Precision
  forPrecision <- as.data.frame(forPrecision)
  forPrecision <- as.data.frame(t(forPrecision))
  row.names(forPrecision) <- NULL
  colnames(forPrecision) <- diseasePools
  forPrecision$Median <- apply(forPrecision,1,median)
  forPrecision$Samples <- ChIPSeqSamples
  return(forPrecision)

  ##Sensitivity
  forSensitivity <- as.data.frame(forSensitivity)
  forSensitivity <- as.data.frame(t(forSensitivity))
  row.names(forSensitivity) <- NULL
  colnames(forSensitivity) <- diseasePools
  forSensitivity$Median <- apply(forSensitivity,1,median)
  forSensitivity$Samples <- ChIPSeqSamples
  return(forSensitivity)

  ##Specificity
  forSpecificity <- as.data.frame(forSpecificity)
  forSpecificity <- as.data.frame(t(forSpecificity))
  row.names(forSpecificity) <- NULL
  colnames(forSpecificity) <- diseasePools
  forSpecificity$Median <- apply(forSpecificity,1,median)
  forSpecificity$Samples <- ChIPSeqSamples
  return(forSpecificity)

  ## Let's return a list for convenience; a list of dataframes.
  masterReturn <- list(forSensitivity, forSpecificity, forPrecision)
  return(masterReturn)

}