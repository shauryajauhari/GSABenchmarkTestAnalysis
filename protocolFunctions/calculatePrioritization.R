## This function takes a number (tool index) as input and returns the prioritization data against each given disease.

calculatePrioritization <- function(tool){
  
  forPrioritization <- vector("list", length(ChIPSeqSamples)) # output values to be filled in this list
  
  for (sam in 1:length(ChIPSeqSamples))
  {
    for (dis in 1:length(disease_pools))
    {
      tryCatch({
      ranks <- list()
      x <- 1
      for (i in 1:length(eval(parse(text=(paste0(paste0(tools_results[3],"$"), ChIPSeqSamples[sam]))))[[1]]))
        {
          for (j in (eval(parse(text=disease_pools[[dis]]))))
          {
            if((eval(parse(text=(paste0(paste0(tools_results[3],"$"), ChIPSeqSamples[sam]))))[[1]])[[i]] == j)
            {
              ranks[[x]]<- i
              x <- x+1
            }
          }
        }
        findPrioritization <- as.double((ranks[[1]]/nrow((eval(parse(text=(paste0(paste0(tools_results[3],"$"), 
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
tempList <- list()

for(ind in 1: length(forPrioritization)){tempList <- append(tempList, length(forPrioritization[[ind]]))}
maxNum <- max(unlist(tempList))
forPrioritization <- lapply(forPrioritization, function(x) x[1:maxNum])


forPrioritization <- as.data.frame(forPrioritization) # transform to a dataframe
forPrioritization <- as.data.frame(t(forPrioritization)) # transpose the data frame as the output from the function is a list
row.names(forPrioritization) <- NULL
colnames(forPrioritization) <- diseasePools
forPrioritization$Median <- apply(forPrioritization, 1, median) # median value shall be the basis of plotting the results.
forPrioritization$Samples <- ChIPSeqSamples # add key attribute of sample names. this may be helpful for the purpose of joining dataframes.
forPrioritization[is.na(forPrioritization)] <- 0 ## replacing NAs with zero for lists shorther than the maximum length.
return(forPrioritization)
}

## (For GREAT) Note that in the resultant table, the zero entries reflect that there are no matches between the disease terms and the tool 
## output. While the empty cells mean that the output for the particular sample was not available.