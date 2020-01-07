diseaseGOTerms <- function(){

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

## Saving objects

saveRDS(gastricCancerGOTerms, file = "gastricCancerGOTerms")
saveRDS(colorectalCancerGOTerms, file = "colorectalCancerGOTerms")
saveRDS(prostateCancerGOTerms, file = "prostateCancerGOTerms")
saveRDS(alzheimersDiseaseGOTerms, file = "alzheimersDiseaseGOTerms")


}
