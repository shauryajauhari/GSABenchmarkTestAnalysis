installPackagesBenchmark <- function(){
  
  ## Installing packages for GSA tools
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  BiocManager::install('seq2pathway')
  BiocManager::install('chipenrich')
  
  ## Loading Packages
  
  library(seq2pathway)
  library(chipenrich)
  
  ## For making maximum memory available to R session (for MS Windows only).
  memory.size(max = TRUE)
}