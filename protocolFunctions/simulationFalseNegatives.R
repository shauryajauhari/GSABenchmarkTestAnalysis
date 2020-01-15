# Generating 5 tracks from each parent/sample track from the benchmark dataset by deleting certain percentages of the total strength.}
# reading sample data from a local folder | BED file and storing as a list

simulationFalseNegatives <- function(){

allSamples <- vector("list", length(ChIPSeqSamples))
names(allSamples) <- ChIPSeqSamples
for (i in 1:length(ChIPSeqSamples))
{
  allSamples[[i]] <- as.data.frame(samplesInBED[[i]])
  allSamples[[i]] <- allSamples[[i]][,1:3] # extracting just the chromosomal number , start index , and end index.
  names(allSamples[[i]]) <- c("chrom","start","end")
}

# Function to break down lengths of child tracks as distinct percentages of the parent track. 
# We have assumed percentages less than 50 because higher order deletions could significantly hamper the outputs. 
# So, proportions of 10%, 20%, 30%, 40%, 50% are best suited.

lengthBreakups <- list()
trackLengths <- function(x){
  listingLengths <- list()
  for(i in 1:5)
  {
    listingLengths[[i]]<- round(((10*i)*nrow(x))/100)
  }
  return(listingLengths)
}

lengthBreakups <- lapply(allSamples, trackLengths) # a list of lists.

# Block to create random tracks of distinct orders.
## Creating 2 dimensional lists (list of lists)
childTracks <- lapply(1:length(lengthBreakups), function(y) list())
simulatedAllSamples <- lapply(1:length(lengthBreakups), function(y) list())
for(i in 1:length(lengthBreakups)) # 10
  {
    for(j in 1:5)
      {
        childTracks[[i]][[j]] <- allSamples[[i]][sample(nrow(allSamples[[i]]),lengthBreakups[[i]][[j]]),]
        # In the above expression, the attribute replace is set to FALSE by default. 
        # If TRUE, it shall add back rows to the main dataframe thereby carrying a chance to be chosen again and hence resulting in redundancy. 
        # The following expression will create 5 entries against each entry of all_samples, i.e. 5 different tracks from every dataset track 
        # abiding 10%, 20%, 30%, 40%, and 50% reductions in the number of rows. The function "anti_join" comes from package "dplyr" 
        # (that has already been called; if not we can do it here) and engenders the remaining rows in first-argument-dataframe that are exclusive to it, 
        # subtracting the rows from second-argument-dataframe. Any of the following does the trick.
        library(dplyr)
        simulatedAllSamples[[i]][[j]] <- anti_join(allSamples[[i]],childTracks[[i]][[j]])
      }
}
names(simulatedAllSamples) <- ChIPSeqSamples
return(simulatedAllSamples)
}


