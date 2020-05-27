enrichrPostprocessing <- function () {

## Loading data

enrichrGOBPResultsShredded <- readRDS("./results/Enrichr/enrichrGOBPResultsShredded")
enrichrGOMFResultsShredded <- readRDS("./results/Enrichr/enrichrGOMFResultsShredded")
enrichrGOCCResultsShredded <- readRDS("./results/Enrichr/enrichrGOCCResultsShredded")
enrichrKEGGResultsShredded <- readRDS("./results/Enrichr/enrichrKEGGResultsShredded")

  
## Refining Enrichr KEGG and GO results | Extracting "hsa*****" and "GO:*****" terms.
library(stringr)

for (i in 1:length(enrichrGOBPResultsShredded))
{
  enrichrGOBPResultsShredded[[i]]$Term <- str_extract(string = eval(parse(text=paste0("enrichrGOBPResultsShredded$",paste0(eval(parse(text="names(enrichrGOBPResultsShredded)[i]")),"$Term")))), pattern = "GO:[0-9]+")
}

for (i in 1:length(enrichrGOCCResultsShredded))
{
  enrichrGOCCResultsShredded[[i]]$Term <- str_extract(string = eval(parse(text=paste0("enrichrGOCCResultsShredded$",paste0(eval(parse(text="names(enrichrGOCCResultsShredded)[i]")),"$Term")))), pattern = "GO:[0-9]+")
}

for (i in 1:length(enrichrGOMFResultsShredded))
{
  enrichrGOMFResultsShredded[[i]]$Term <- str_extract(string = eval(parse(text=paste0("enrichrGOMFResultsShredded$",paste0(eval(parse(text="names(enrichrGOMFResultsShredded)[i]")),"$Term")))), pattern = "GO:[0-9]+")
}

for (i in 1:length(enrichrKEGGResultsShredded))
{
  enrichrKEGGResultsShredded[[i]]$Term <- str_extract(string = eval(parse(text=paste0("enrichrKEGGResultsShredded$",paste0(eval(parse(text="names(enrichrKEGGResultsShredded)[i]")),"$Term")))), pattern = "hsa[0-9]+")
}



## Combining Enrichr KEGG and GO results

enrichrResultsShredded <- list()
length(enrichrResultsShredded) <- length(ChIPSeqSamples)
names(enrichrResultsShredded) <- names(samplesInBED)

for (i in 1:length(enrichrResultsShredded))
{
  
  enrichrResultsShredded[[i]] <- rbind(enrichrGOBPResultsShredded[[i]], enrichrGOCCResultsShredded[[i]], enrichrGOMFResultsShredded[[i]], enrichrKEGGResultsShredded[[i]], stringsAsFactors = FALSE)
  
}

## Sorting on the basis of "P.value"

for (i in 1:length(enrichrResultsShredded[[i]]))
{
  enrichrResultsShredded[[i]] <- enrichrResultsShredded[[i]][with(enrichrResultsShredded[[i]], order(enrichrResultsShredded[[i]]$P.value)), ] 
}

## Saving data

saveRDS(enrichrResultsShredded, file = "./results/Enrichr/enrichrResultsShredded")
rm(enrichrResultsShredded, enrichrGOBPResultsShredded, enrichrGOCCResultsShredded, enrichrGOMFResultsShredded, enrichrKEGGResultsShredded )

}

