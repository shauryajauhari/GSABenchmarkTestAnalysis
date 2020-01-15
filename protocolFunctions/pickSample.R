## This function asks user input to select a sample to work upon for simulation. If the sample name is accurate, the sample data is picked from
## the master simulation data (simulation data for all samples), and then returned back as a list. 

pickSample <- function ()
{
  s <- as.character(readline("Enter the sample name:")) ## user chooses the sample
  
  if(file.exists(paste0("./testData/",paste0(as.character(s),".bed")))) ## checking file integrity.
  {
    sampleFalsePositives <- eval(parse(text=paste0("forFalsePositives$", eval(parse(text="s")))))
    sampleFalseNegatives <- eval(parse(text=paste0("forFalseNegatives$", eval(parse(text="s")))))
  }
  else
  {
    print("Invalid sample.")
  }
  
  ## Naming list indexes
  names(sampleFalseNegatives) <- paste0(eval(parse(text="s")), paste0("_",1:5))
  names(sampleFalsePositives) <- paste0(eval(parse(text="s")), paste0("_",1:5))
  
  resultantSimulatedData <- list(sampleFalseNegatives, sampleFalsePositives)
  names(resultantSimulatedData) <- c("forFalseNegatives", "forFalsePositives")
  return(resultantSimulatedData)
}