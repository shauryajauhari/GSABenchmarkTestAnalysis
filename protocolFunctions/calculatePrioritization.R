## This function takes a number (tool index) as input and returns the prioritization data against each given disease.

calculatePrioritization <- function(tool){
  
  forPrioritization <- vector("list", length(ChIPSeqSamples)) # output values to be filled in this list
  
  for (sam in 1:length(ChIPSeqSamples))
  {
    for (dis in 1:length(diseasePools))
    {
      tryCatch({
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
      }, error = function(e){}
      , finally = {dis=dis+1}) ## The exception handling moves the pointer to the next index if 'ranks' is empty.
    }
  }
  ## Owing to the discrepnacies in the calculation of prioritization for different samples (intersections may vary), the resultant list of
  ## lists(results) may have different length components. To ensure fullness of the dataframe we shall calculate the maximum length amongst
  ## all (that should technically be the number of diseases), and structure the shorter lists to fit the dimensions of the dataframe by 
  ## explicit zeros. 

return(listToFrame(forPrioritization))
}

## (For GREAT) Note that in the resultant table, the zero entries reflect that there are no matches between the disease terms and the tool 
## output. While the empty cells mean that the output for the particular sample was not available.