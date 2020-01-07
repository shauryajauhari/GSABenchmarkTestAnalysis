diseaseTerms <- function(){
## GO Terms
  
## Import the manually downloaded GO terms (as a text file) from geneontology.org associated with each of the four
## diseases as depicted in the benchmark dataset.

  
gastricCancerGOTerms <- read.table("gastricCancerGOTerms.txt", sep = "\t", header = FALSE)
prostateCancerGOTerms <- read.table("prostateCancerGOTerms.txt", sep = "\t", header = FALSE)
alzheimersDiseaseGOTerms <- read.table("alzheimersDiseaseGOTerms.txt", sep = "\t", header = FALSE)
colorectalCancerGOTerms <- read.table("colorectalCancerGOTerms.txt", sep = "\t", header = FALSE)

## Convert data frame column as character expressions instead of factors.

gastricCancerGOTerms <- data.frame(lapply(gastricCancerGOTerms, as.character), stringsAsFactors=FALSE) 
prostateCancerGOTerms <- data.frame(lapply(prostateCancerGOTerms, as.character), stringsAsFactors=FALSE) 
alzheimersDiseaseGOTerms <- data.frame(lapply(alzheimersDiseaseGOTerms, as.character), stringsAsFactors=FALSE) 
colorectalCancerGOTerms <- data.frame(lapply(colorectalCancerGOTerms, as.character), stringsAsFactors=FALSE) 

## Extract the GO id from the full length string including the id as well as description.

for (i in 1: length(gastricCancerGOTerms$V1))
{
  gastricCancerGOTerms$V1[i] <- substr(gastricCancerGOTerms$V1[i],1,10)
}

for (i in 1: length(colorectalCancerGOTerms$V1))
{
  colorectalCancerGOTerms$V1[i] <- substr(colorectalCancerGOTerms$V1[i],1,10)
}

for (i in 1: length(prostateCancerGOTerms$V1))
{
  prostateCancerGOTerms$V1[i] <- substr(prostateCancerGOTerms$V1[i],1,10)
}

for (i in 1: length(alzheimersDiseaseGOTerms$V1))
{
  alzheimersDiseaseGOTerms$V1[i] <- substr(alzheimersDiseaseGOTerms$V1[i],1,10)
}

## KEGG Terms

## We define a list for KEGG terms for each disease here. 
## The foremost ID is the KEGG term for the disease (self-explanatory variable) and the trailing ids represent it's
## subpathways.

alzheimersDiseaseKEGGTerms <- c("hsa05010", "hsa00190", "hsa04210", "hsa04020")
gastricCancerKEGGTerms <- c("hsa05226", "hsa05120", "hsa04115", "hsa04110", "hsa04310", "hsa04151", "hsa04350", "hsa04520", "hsa04010")
prostateCancerKEGGTerms <- c("hsa05215", "hsa04110", "hsa04210", "hsa04151", "hsa05202", "hsa04115", "hsa04010", "hsa04060", "hsa00140")
colorectalCancerKEGGTerms <- c("hsa05210", "hsa04310", "hsa04110", "hsa04210", "hsa04115", "hsa04151", "hsa04010", "hsa04350", "hsa04012", "hsa04150")


## Merging KEGG and GO terms.
gastricCancerPool <- c(gastricCancerGOTerms[[1]], gastricCancerKEGGTerms)
colorectalCancerPool <- c(colorectalCancerGOTerms[[1]], colorectalCancerKEGGTerms)
alzheimersDiseasePool <- c(alzheimersDiseaseGOTerms[[1]], alzheimersDiseaseKEGGTerms)
prostateCancerPool <- c(prostateCancerGOTerms[[1]], prostateCancerKEGGTerms)


# Saving these objects
saveRDS(alzheimersDiseasePool,"alzheimersDiseasePool")
saveRDS(prostateCancerPool, "prostateCancerPool")
saveRDS(colorectalCancerPool, "colorectalCancerPool")
saveRDS(gastricCancerPool, "gastricCancerPool")

}
