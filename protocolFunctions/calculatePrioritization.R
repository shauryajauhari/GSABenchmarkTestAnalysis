toolsResults <- c("chipenrichResultsShredded", "broadenrichResultsShredded","seq2pathwayResultsShredded","enrichrResultsShredded","greatResultsShredded")
diseasePools <- c("colorectalCancerPool", "alzheimersDiseasePool", "gastricCancerPool", "prostateCancerPool")

calculatePrioritization <- function(){
  
  forPrioritization <- vector("list", length(disease_pools)) # output values to be filled in this list
  
  for (d in 1:length(disease_pools))
  {
    for (sam in 1:length(ChIPSeqSamples))
    {
      ranks <- list()
      x <- 1
      
      for (i in 1:length(eval(parse(text=(paste0(paste0(tools_results[1],"$"), ChIPSeqSamples[sam]))))[[1]]))
      {
        for (j in (eval(parse(text=disease_pools[[d]]))))
        {
          if((eval(parse(text=(paste0(paste0(tools_results[1],"$"), ChIPSeqSamples[sam]))))[[1]])[[i]] == j)
          {
            ranks[[x]]<- i
            x <- x+1
          }
        }
      }
      
      for_prioritization <- as.double((ranks[[1]]/nrow((eval(parse(text=(paste0(paste0(tools_results[1],"$"), ChIPSeqSamples[sam]))))[1]))*100))
      forPrioritization[[d]][[sam]] <- for_prioritization
    }
  }
  
  forPrioritization <- as.data.frame(forPrioritization)
  
  # Save object
  saveRDS(forPrioritization,"forPrioritization")
}

## (For GREAT) Note that in the resultant table, the zero entries reflect that there are no matches between the 
## disease terms and the tool output. While the empty cells mean that the output for the particular sample was not
## available.