enrichrResultsCompilation <- function(){

## Pulling Enrichr Results from a local directory.

tryCatch( {enrichrGOBPSamples <- list.files("./results/Enrichr/GO_Biological_Process_2018/")}
          ,error = function(e){ print("File not found"); break;}
          ,finally = function (f){next;})

enrichrGOBPSamples <- substr(enrichrGOBPSamples,1,nchar(enrichrGOBPSamples)-4)

## Similarly for other databases

tryCatch( {enrichrGOCCSamples <- list.files("./results/Enrichr/GO_Cellular_Component_2018/")}
          ,error = function(e){ print("File not found"); break;}
          ,finally = function (f){next;})

enrichrGOCCSamples <- substr(enrichrGOCCSamples,1,nchar(enrichrGOCCSamples)-4)

tryCatch( {enrichrGOMFSamples <- list.files("./results/Enrichr/GO_Molecular_Function_2018/")}
          ,error = function(e){ print("File not found"); break;}
          ,finally = function (f){next;})

enrichrGOMFSamples <- substr(enrichrGOMFSamples,1,nchar(enrichrGOMFSamples)-4)

## There could be another way here to remove the ".txt" extension from the list of samples.
#enrichrGOBPSamples[1] <- gsub('.{4}$', '', enrichrGOBPSamples[1])

## Let us load the results for the samples from the assorted databases of Enrichr, into respective lists. 

enrichrGOBPResults <- list()

for (i in 1:length(ChIPSeqSamples))
{
  for(j in 1:length(enrichrGOBPSamples))
  {
    if(enrichrGOBPSamples[j] == ChIPSeqSamples[i])
    {
      enrichrGOBPResults[[j]] <-read.table(paste0("./results/Enrichr/GO_Biological_Process_2018/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".txt")), sep = '\t', header = TRUE, quote = "", fill = TRUE)
    }
  }
}

enrichrGOMFResults <- list()

for (i in 1:length(ChIPSeqSamples))
{
  for(j in 1:length(enrichrGOMFSamples))
  {
    if(enrichrGOMFSamples[j] == ChIPSeqSamples[i])
    {
      enrichrGOMFResults[[j]] <-read.table(paste0("./results/Enrichr/GO_Molecular_Function_2018/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".txt")), sep = '\t', header = TRUE, quote = "", fill = TRUE)
    }
  }
}

enrichrGOCCResults <- list()

for (i in 1:length(ChIPSeqSamples))
{
  for(j in 1:length(enrichrGOCCSamples))
  {
    if(enrichrGOCCSamples[j] == ChIPSeqSamples[i])
    {
      enrichrGOCCResults[[j]] <-read.table(paste0("./results/Enrichr/GO_Cellular_Component_2018/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".txt")), sep = '\t', header = TRUE, quote = "", fill = TRUE)
    }
  }
}



## Same protocol for ENRICHR KEGG results too. 

tryCatch( {enrichrKEGGSamples <- list.files("./results/Enrichr/KEGG_2019_Human/")}
          ,error = function(e){ print("File not found"); break;}
          ,finally = function (f){next;})

enrichrKEGGSamples <- substr(enrichrKEGGSamples,1,nchar(enrichrKEGGSamples)-4)


enrichrKEGGResults <- list()

for (i in 1: length(ChIPSeqSamples))
{
  for(j in 1:length(enrichrKEGGSamples))
  {
    if(enrichrKEGGSamples[j] == ChIPSeqSamples[i])
    {
      enrichrKEGGResults[[j]] <-read.table(paste0("./results/Enrichr/KEGG_2019_Human/",paste0(eval(parse(text='ChIPSeqSamples[i]')),".txt")), sep = '\t', header = TRUE, quote = "", fill = TRUE)
    }
  }
}


## Condensed Results
## BP
enrichrGOBPResultsShredded <- list()
for (i in 1:length(enrichrGOBPResults))
{
  enrichrGOBPResultsShredded[[i]] <- enrichrGOBPResults[[i]][,c(1,3)]
}

names(enrichrGOBPResultsShredded) <- as.character(enrichrGOBPSamples)
saveRDS(enrichrGOBPResultsShredded, file = "./results/Enrichr/enrichrGOBPResultsShredded")


##CC
enrichrGOCCResultsShredded <- list()
for (i in 1:length(enrichrGOCCResults))
{
  enrichrGOCCResultsShredded[[i]] <- enrichrGOCCResults[[i]][,c(1,3)]
}

names(enrichrGOCCResultsShredded) <- as.character(enrichrGOCCSamples)
saveRDS(enrichrGOCCResultsShredded, file = "./results/Enrichr/enrichrGOCCResultsShredded")


##MF
enrichrGOMFResultsShredded <- list()
for (i in 1:length(enrichrGOMFResults))
{
  enrichrGOMFResultsShredded[[i]] <- enrichrGOMFResults[[i]][,c(1,3)]
}

names(enrichrGOMFResultsShredded) <- as.character(enrichrGOMFSamples)
saveRDS(enrichrGOMFResultsShredded, file = "./results/Enrichr/enrichrGOMFResultsShredded")


##KEGG
enrichrKEGGResultsShredded <- list()
for (i in 1:length(enrichrKEGGResults))
{
  enrichrKEGGResultsShredded[[i]] <- enrichrKEGGResults[[i]][,c(1,3)]
}

names(enrichrKEGGResultsShredded) <- as.character(enrichrKEGGSamples)
saveRDS(enrichrKEGGResultsShredded, file = "./results/Enrichr/enrichrKEGGResultsShredded")


## Removing data from cache.

rm(enrichrGOBPResultsShredded)
rm(enrichrGOCCResultsShredded)
rm(enrichrGOMFResultsShredded)
rm(enrichrKEGGResultsShredded)

}
