if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GO.db")

GREAT_Results_Compilation <- function(){
  
  ## In the command prompt, type in  *dir* (for Windows) or *ls* (for Ubuntu/MAC OS) to redirect the file listing of a directory to a seperate file, as "file_names.txt" here.
  
  great_samples <- read.table("./Results/great/file_names.txt")
  great_samples <- as.character(great_samples$V1)
  for(i in 1:length(great_samples)){great_samples[i] <- substr(great_samples[i],1,nchar(great_samples[i])-4)}
  
  
  ## Removing auxilliary file: "file_names"
  great_samples <- great_samples[great_samples!="file_names"]
  
  great_in_results <- list()
  
  for (i in 1: length(ChIPSeqSamples))
  {
    for(j in 1:length(great_samples))
    {
      if(great_samples[j] == ChIPSeqSamples[i])
      {
        great_in_results[[j]] <-read.table(paste0("./Results/great/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".tsv")), sep = "\t", header = TRUE)
      }
    }
  }
  
  ## Converting GO Terms to GO ids
  ## Creating a GO.db library to parse
  # load the GO library
  library(GO.db)
  
  # extract a named vector of all terms
  goterms <- Term(GOTERM)
  
  # work with it in R, or export it to a file
  write.table(goterms, sep="\t", file="goterms.txt")
  
  ## Create a data frame from the GO database that holds terms and respective ids.  
  GO_Term_Db <- data.frame(matrix(0, ncol = 2, nrow = 45050))
  for (i in 1:length(names(goterms)))
  {
    GO_Term_Db$ID[i] <- names(goterms[i])
    GO_Term_Db$Term[i] <-goterms[[i]]
  }
  
  GO_Term_Db <- GO_Term_Db[,c(3,4)]
  
  
  ## Condensed GREAT Results
  
  great_results <- list()
  for (i in 1:length(great_in_results))
  {
    great_results[[i]] <- great_in_results[[i]][,c(1,3)]
  }
  
  names(great_results) <- as.character(great_samples)
  
  ## Assigning IDs to the Terms as a new column in the results
  
  for (j in 1:length(great_results))
  {
    tryCatch({for(k in 1:nrow(great_results[[j]]))
    {
      for(i in 1:nrow(GO_Term_Db))
      {
        if(as.character(great_results[[j]]$Term.Name[k]) == GO_Term_Db$Term[i])
        {
          great_results[[j]]$Term.ID[k] <- GO_Term_Db$ID[i]
        }
      }
    }
  }
    , error=function(e){cat("The sample with index", j,"has error.\n")}
    , finally={next;})
  }  
  ## Reordering columns for consistency with results from other tools.
  ## Bypassing the erroneous sample results.
  great_results_shredded <- list()
  for(i in 1:length(great_results))
   {
     if(length(great_results[[i]])!=3)
      {
        next;
      }
     else
     {
       great_results_shredded[[i]] <- great_results[[i]][,c(3,2)]
       
       ## Sorting the results in the ascending values of statistical significance.
       great_results_shredded[[i]] <- great_results_shredded[[i]][order(great_results_shredded[[i]][[2]]), ]
     }
  }
  ## Assigning sample names to the final result compilation. This way the results can be accessed via plugging in the
  ## sample id.
  names(great_results_shredded) <- as.character(great_samples)
}


