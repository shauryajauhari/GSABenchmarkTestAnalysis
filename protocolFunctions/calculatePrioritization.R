## This function takes a number (tool index) as input and returns the prioritization data against each given disease.

calculatePrioritization <- function(tool){
  
  forPrioritization <- vector("list", length(ChIPSeqSamples)) # output values to be filled in this list
  
  for (sam in 1:length(ChIPSeqSamples))
  {
    for (dis in 1:length(diseasePools))
    {
      ranks <- list()
      x <- 1
      for (i in 1:length(eval(parse(text=(paste0(paste0(toolsResults[tool],"$"), ChIPSeqSamples[sam]))))[[1]]))
      {
        for (j in (eval(parse(text=diseasePools[[dis]]))))
        {
          if((eval(parse(text=(paste0(paste0(toolsResults[tool],"$"), ChIPSeqSamples[sam]))))[[1]])[[i]] == j)
          {
            ranks[[x]]<- i
            x <- x+1
          }
        }
      }
      
      findPrioritization <- as.double((ranks[[1]]/nrow((eval(parse(text=(paste0(paste0(toolsResults[tool],"$"), 
      ChIPSeqSamples[sam]))))[1]))*100))
      forPrioritization[[sam]][dis] <- findPrioritization
    }
  }
  
  forPrioritization <- as.data.frame(forPrioritization) # transform to a dataframe
  forPrioritization <- as.data.frame(t(forPrioritization)) # transpose the data frame as the output from the function is a list
  row.names(forPrioritization) <- NULL
  colnames(forPrioritization) <- diseasePools
  forPrioritization$Median <- apply(forPrioritization,1,median) # median value shall be the basis of plotting the results.
  forPrioritization$Samples <- ChIPSeqSamples # add key attribute of sample names. this may be helpful for the purpose of joining dataframes.
  return(forPrioritization)
}

## (For GREAT) Note that in the resultant table, the zero entries reflect that there are no matches between the disease terms and the tool 
## output. While the empty cells mean that the output for the particular sample was not available.