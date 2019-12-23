# Generating 5 tracks from each parent/sample track from the benchmark dataset by deleting certain percentages of the total strength.}
# reading sample data from a local folder | BED file and storing as a list

Simulation_For_False_Negatives <- function(){

all_samples <- list()
for (i in 1:length(ChIPSeqSamples))
{
  all_samples[[i]] <- read.table(paste("./regen/",paste(eval(parse(text="ChIPSeqSamples[i]")),".bed", sep = ""), sep = ""))
  all_samples[[i]] <- all_samples[[i]][,1:3] # extracting just the chromosomal number , start index , and end index.
  names(all_samples[[i]]) <- c("chrom","start","end")
}

# Function to break down lengths of child tracks as distinct percentages of the parent track. 
# We have assumed percentages less than 50 because higher order deletions could significantly hamper the outputs. 
# So, proportions of 10%, 20%, 30%, 40%, 50% are best suited.

length_breakups <- list()
track_lengths <- function(x){
  listing_lengths <- list()
  for(i in 1:5)
  {
    listing_lengths[[i]]<- round(((10*i)*nrow(x))/100);
  }
  return(listing_lengths)
}

length_breakups <- lapply(all_samples,track_lengths) # a list of lists.

# Block to create random tracks of distinct orders.
## Creating 2 dimensional lists (list of lists)
child_tracks <- lapply(1:length(length_breakups), function(y) list())
simulated_all_samples <- lapply(1:length(length_breakups), function(y) list())
for(i in 1:length(length_breakups)) # 106
  {
    for(j in 1:5)
      {
        child_tracks[[i]][[j]] <-all_samples[[i]][sample(nrow(all_samples[[i]]),length_breakups[[i]][[j]]),]
        # In the above expression, the attribute replace is set to FALSE by default. 
        # If TRUE, it shall add back rows to the main dataframe thereby carrying a chance to be chosen again and hence resulting in redundancy. 
        # The following expression will create 5 entries against each entry of all_samples, i.e. 5 different tracks from every dataset track 
        # abiding 10%, 20%, 30%, 40%, and 50% reductions in the number of rows. The function "anti_join" comes from package "dplyr" 
        # (that has already been called; if not we can do it here) and engenders the remaining rows in first-argument-dataframe that are exclusive to it, 
        # subtracting the rows from second-argument-dataframe. Any of the following does the trick.
        library(dplyr)
        simulated_all_samples[[i]][[j]] <- anti_join(all_samples[[i]],child_tracks[[i]][[j]])
    
        # simulated_all_samples[[i]][[j]] <- all_samples[[i]][is.na(match(all_samples[[i]],child_tracks[[i]][[j]])),]
        # simulated_all_samples[[i]][[j]] <- all_samples[[i]][!all_samples[[i]]%in%child_tracks[[i]][[j]],]
      }
  }
}


