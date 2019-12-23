GREAT_Results_Compilation <- function(){

## In the command prompt, type in  *dir* (for Windows) or *ls* (for Ubuntu/MAC OS) to redirect the file listing of a directory to a seperate file, as "file_names.txt" here.

great_samples <- read.table("./GREAT_Results/file_names.txt")
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
      great_in_results[[j]] <-read.table(paste0("./GREAT_Results/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".tsv")), sep = '\t', header = TRUE, quote = "", fill = TRUE)
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
GO_Term_Db <- data.frame(matrix(0, ncol = 2, nrow = length(goterms)))
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
count=0
for (j in 1:length(great_results))
{
  for(k in 1:nrow(great_results[[j]]))
  {
    for(i in 1:nrow(GO_Term_Db))
    {
      if(as.character(great_results[[j]]$Term.Name[k]) == GO_Term_Db$Term[i])
      {
        great_results[[j]]$Term.ID[k] <- GO_Term_Db$ID[i]
        
      }
    }
  };count=count+1
}
print(count)
}