## This function takes a number (tool index) as input and returns the prioritization data against each given disease.

calculatePrioritization <- function(tool){
  
  forPrioritization <- vector("list", length(disease_pools)) # output values to be filled in this list
  
  for (d in 1:length(disease_pools))
  {
    for (sam in 1:length(ChIPSeqSamples))
    {
      ranks <- list()
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
      
      findPrioritization <- as.double((ranks[[1]]/nrow((eval(parse(text=(paste0(paste0(tools_results[tool],"$"), 
      ChIPSeqSamples[sam]))))[1]))*100))
      forPrioritization[[d]][[sam]] <- findPrioritization
    }
  }
  
  forPrioritization <- as.data.frame(forPrioritization) # transform to a dataframe
  colnames(forPrioritization) <- diseasePools
  forPrioritization$Median <- apply(forPrioritization,1,median) # median value shall be the basis of plotting the results.
  forPrioritization$Samples <- ChIPSeqSamples # add key attribute of sample names. this may be helpful for the purpose of joining dataframes.
  return(forPrioritization)
}

## (For GREAT) Note that in the resultant table, the zero entries reflect that there are no matches between the disease terms and the tool 
## output. While the empty cells mean that the output for the particular sample was not available.