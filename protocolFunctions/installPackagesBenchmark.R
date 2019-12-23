installPackagesBenchmark <- function(){
  
  ## Installing packages for GSA tools
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  BiocManager::install('seq2pathway')
  BiocManager::install('broadenrich')
  BiocManager::install('chipenrich')
  
  ## Loading Packages
  
  library(GSAChIPSeqGold)
  library(seq2pathway)
  library(chipenrich)
  
  ## For making maximum memory available to R session (for MS Windows only).
  memory.size(max = TRUE)
}