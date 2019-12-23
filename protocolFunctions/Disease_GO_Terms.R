## Import the manually downloaded GO terms (as a text file) from geneontology.org associated with each of the four
## diseases as depicted in the benchmark dataset.

gastric_cancer_go_terms <- read.table("./Gastric_Cancer_GO_Terms.txt", sep = "\t", header = FALSE)
prostate_cancer_go_terms <- read.table("./Prostate_Cancer_GO_Terms.txt", sep = "\t", header = FALSE)
alzheimers_disease_go_terms <- read.table("./Alzheimers_Disease_GO_Terms.txt", sep = "\t", header = FALSE)
colorectal_cancer_go_terms <- read.table("./Colorectal_Cancer_GO_Terms.txt", sep = "\t", header = FALSE)

## Convert data frame column as character expressions instead of factors.

gastric_cancer_go_terms <- data.frame(lapply(gastric_cancer_go_terms, as.character), stringsAsFactors=FALSE) 
prostate_cancer_go_terms <- data.frame(lapply(prostate_cancer_go_terms, as.character), stringsAsFactors=FALSE) 
alzheimers_disease_go_terms <- data.frame(lapply(alzheimers_disease_go_terms, as.character), stringsAsFactors=FALSE) 
colorectal_cancer_go_terms <- data.frame(lapply(colorectal_cancer_go_terms, as.character), stringsAsFactors=FALSE) 

## Extract the GO id from the full length string including the id as well as description.

for (i in 1: length(gastric_cancer_go_terms$V1))
{
  gastric_cancer_go_terms$V1[i] <- substr(gastric_cancer_go_terms$V1[i],1,10)
}

for (i in 1: length(colorectal_cancer_go_terms$V1))
{
  colorectal_cancer_go_terms$V1[i] <- substr(colorectal_cancer_go_terms$V1[i],1,10)
}

for (i in 1: length(prostate_cancer_go_terms$V1))
{
  prostate_cancer_go_terms$V1[i] <- substr(prostate_cancer_go_terms$V1[i],1,10)
}

for (i in 1: length(alzheimers_disease_go_terms$V1))
{
  alzheimers_disease_go_terms$V1[i] <- substr(alzheimers_disease_go_terms$V1[i],1,10)
}
