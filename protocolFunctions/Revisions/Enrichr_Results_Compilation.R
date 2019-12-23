Enrichr_Results_Compilation <- function(){

## Pulling Enrichr Results from a local directory.

## In the command prompt, type in  dir (for WINDOWS) or ls (for Ubuntu/MAC OS) to redirect the file listing of a directory to a seperate file, as "file_names.txt" here.
tryCatch( {enrichr_go_samples <- read.table("./Results/enrichr/GO_BP_2018/file_names.txt")}
          ,error = function(e){ print("File not found"); break;}
          ,finally = function (f){next;})

enrichr_go_samples <- as.character(enrichr_go_samples$V1)
for(i in 1:length(enrichr_go_samples)){enrichr_go_samples[i] <- substr(enrichr_go_samples[i],1,nchar(enrichr_go_samples[i])-4)}

## There could be another way here to remove the ".txt" extension from the list of samples.
#enrichr_go_samples[1] <- gsub('.{4}$', '', enrichr_go_samples[1])
enrichr_go <- list()

for (i in 1: length(ChIPSeqSamples))
{
  for(j in 1:length(enrichr_go_samples))
  {
    if(enrichr_go_samples[j] == ChIPSeqSamples[i])
    {
      enrichr_go[[j]] <-read.table(paste0("./Results/enrichr/GO_BP_2018/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".txt")), sep = '\t', header = TRUE, quote = "", fill = TRUE)
    }
  }
}


## Same protocol for ENRICHR KEGG results too. 


enrichr_kegg <- list()

enrichr_kegg_samples <- read.table("./Results/enrichr/KEGG_2016/file_names.txt")
enrichr_kegg_samples <- as.character(enrichr_kegg_samples$V1)
for(i in 1:length(enrichr_kegg_samples)){enrichr_kegg_samples[i] <- substr(enrichr_kegg_samples[i],1,nchar(enrichr_kegg_samples[i])-4)}



enrichr_kegg <- list()

for (i in 1: length(ChIPSeqSamples))
{
  for(j in 1:length(enrichr_kegg_samples))
  {
    if(enrichr_kegg_samples[j] == ChIPSeqSamples[i])
    {
      enrichr_kegg[[j]] <-read.table(paste0("./Results/enrichr/KEGG_2016/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".txt")), sep = '\t', header = TRUE, quote = "", fill = TRUE)
    }
  }
}


## Condensed Results

enrichr_go_results <- list()
for (i in 1:length(enrichr_go))
{
  enrichr_go_results[[i]] <- enrichr_go[[i]][,c(1,3)]
}

names(enrichr_go_results) <- as.character(enrichr_go_samples)

enrichr_kegg_results <- list()
for (i in 1:length(enrichr_kegg))
{
  enrichr_kegg_results[[i]] <- enrichr_kegg[[i]][,c(1,3)]
}

names(enrichr_kegg_results) <- as.character(enrichr_kegg_samples)

}
