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
  finalFrame$Samples <- ChIPSeqSamples # add key attribute of sample names. this may be helpful for the purpose of joining dataframes.
  
  ## loading data from master table
  
  summaryTable <- read.table("./GSAChIPSeqBenchmarkDatasetProfile.txt", sep = "\t", header = TRUE, quote = "")
  summaryTable <- summaryTable[, c("GSM", "Disease...Target..Pathway")]
  
  
  ## pre-process for making comparisons
  
  library(stringr)
  summaryTable$Disease...Target..Pathway <- tolower(str_replace_all(string=summaryTable$Disease...Target..Pathway, pattern=" ", repl=""))
  
  
  ## define column for matched terms that are lists for disease terms
  summaryTable$AffiliateDiseasePool <- vector(mode = "list", length = nrow(summaryTable))
  for (i in 1:nrow(summaryTable))
  {
    try(summaryTable$AffiliateDiseasePool[i] <- diseasePools[agrep(summaryTable$Disease...Target..Pathway[i], diseasePools)])
  }
  
  ## define a dictionary to hold sample-target pathway association
  
  library(hash)
  sampleDiseaseDictionary <- hash(keys = summaryTable$GSM, values = summaryTable$AffiliateDiseasePool)
  
  ## return a column with the noted values for a particular sample against it's target pathway
  
  for (i in 1:length(ChIPSeqSamples))
  {
    finalFrame$Value[i]<- finalFrame[ChIPSeqSamples== ChIPSeqSamples[i], values(sampleDiseaseDictionary)[i]]
  }
  
   finalFrame[is.na(finalFrame)] <- 0 ## replacing NAs with zero for lists shorther than the maximum length.
  return(finalFrame)
}
