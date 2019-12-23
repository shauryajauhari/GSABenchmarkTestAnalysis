Install_Packages_Benchmark <- function(){
  
  ## Installing packages of GSA tools
  source('http://www.bioconductor.org/biocLite.R')
  BiocManager::install('seq2pathway')
  BiocManager::install('broadenrich')
  BiocManager::install('chipenrich')
  
  ## Install and load devtools to facilitate package sourcing from github.
  install.packages("devtools")
  library(devtools)
  
  ## Loading Benchmark dataset
  ## Sourcing the compiled gold standard benchmark dataset
  
  install_github("shauryajauhari/GSAChIPSeqBenchmarkData")
  
  
  ## Loading Packages
  
  library(GSAChIPSeqGold)
  library(seq2pathway)
  library(rtracklayer)
  library(chipenrich)
  
  ## For making maximum memory available to R session. 
  memory.size(max = TRUE)
}