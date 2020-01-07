if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GO.db")

greatResultsCompilation <- function(){
  
  greatSamples <- list.files("./results/GREAT")
  greatSamples <- substr(greatSamples,1,nchar(greatSamples)-4)
  
## Pulling results to a list from the local directory.  
  
  greatInResults <- list()
  
  for (i in 1:length(ChIPSeqSamples))
  {
    for(j in 1:length(greatSamples))
    {
      if(greatSamples[j] %in% ChIPSeqSamples[i])
      {
        greatInResults[[j]] <-read.table(paste0("./results/GREAT/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".tsv")), sep = "\t", header = TRUE)
      }
    }
  }
  
  
  ## Converting GO Terms to GO ids
  ## Creating a GO.db library to parse
  # load the GO library
  library(GO.db)
  
  # extract a named vector of all terms
  goTerms <- Term(GOTERM)
  
  # work with it in R, or export it to a file
  write.table(goTerms, sep="\t", file="goTerms.txt")
  
  ## Create a data frame from the GO database that holds terms and respective ids.  
  GOTermDb <- data.frame(matrix(0, ncol = 2, nrow = length(goTerms)))
  for (i in 1:length(names(goTerms)))
  {
    GOTermDb$ID[i] <- names(goTerms[i])
    GOTermDb$Term[i] <- goTerms[[i]]
  }
  
  GOTermDb <- GOTermDb[,c(3,4)]
  
  
  ## Condensed GREAT Results
  
  greatResults <- list()
  for (i in 1:length(greatInResults))
  {
    greatResults[[i]] <- greatInResults[[i]][,c(1,3)]
  }
  
  names(greatResults) <- as.character(greatSamples)
  
  
  ## Assigning IDs to the Terms as a new column in the results
  
  for (j in 1:length(greatResults))
  {
    tryCatch({for(k in 1:nrow(greatResults[[j]]))
    {
      for(i in 1:nrow(GOTermDb))
      {
        if(as.character(greatResults[[j]]$Term.Name[k]) == GOTermDb$Term[i])
        {
          greatResults[[j]]$Term.ID[k] <- GOTermDb$ID[i]
        }
      }
    }
  }
    , error=function(e){cat("The sample with index", j,"has error.\n")}
    , finally={next;})
  }  
  ## Reordering columns for consistency with results from other tools.
  ## Bypassing the erroneous sample results.
  greatResultsShredded <- list()
  for(i in 1:length(greatResults))
   {
     if(length(greatResults[[i]])!=3)
      {
        next;
      }
     else
     {
       greatResultsShredded[[i]] <- greatResults[[i]][,c(3,2)]
       
       ## Sorting the results in the ascending values of statistical significance.
       greatResultsShredded[[i]] <- greatResultsShredded[[i]][order(greatResultsShredded[[i]][[2]]), ]
     }
  }
  ## Assigning sample names to the final result compilation. This way the results can be accessed via plugging in the
  ## sample id.
  names(greatResultsShredded) <- as.character(greatSamples)
  saveRDS(greatResultsShredded, file = "./results/GREAT/greatResultsShredded")
  rm(greatResultsShredded, greatInResults)
  
}


