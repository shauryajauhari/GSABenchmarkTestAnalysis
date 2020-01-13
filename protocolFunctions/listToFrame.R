listToFrame <- function(listLists)
{
  ## The following chunk stretches the incomplete lists to the maximum length (total number of considered
  ## diseases), by filling the incomplete entries (trailing) with NA.  
  # tempList <- list()
  # for(ind in 1: length(listLists)){tempList <- append(tempList, length(listLists[[ind]]))}
  # maxNum <- max(unlist(tempList))
  healMe <-  function(x) {
    for(ind in 1: length(x))
    {
      if(length(x[[ind]]) < length(diseasePools))
      {
        x[[ind]] <- append(x[[ind]], rep(as.numeric(NA), times = (length(diseasePools)-length(x[[ind]]))))
      }
    }
    return(x)}
  
  listLists <- healMe(listLists)
  
  ## The below lines: (i) convert the list of lists to list a dataframe representing results from a tool,
  ## (ii) annotate the columns, (iii) add columns for median and sample names, and (iv) returns the 
  ## "glorified" dataframe.
  
  finalFrame <- as.data.frame(listLists) # transform to a dataframe
  finalFrame <- as.data.frame(t(finalFrame)) # transpose the data frame as the output from the function is a list
  row.names(finalFrame) <- NULL
  colnames(finalFrame) <- diseasePools
  finalFrame$Median <- apply(finalFrame, 1, median) # median value shall be the basis of plotting the results.
  finalFrame$Samples <- ChIPSeqSamples # add key attribute of sample names. this may be helpful for the purpose of joining dataframes.
  finalFrame[is.na(finalFrame)] <- 0 ## replacing NAs with zero for lists shorther than the maximum length.
  return(finalFrame)
}
