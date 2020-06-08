frameMe <- function(x)
{
  library(dplyr)
  y <- lapply(x, function(z) z %>% select(Value))
  y <- as.data.frame(y)
  colnames(y) <- toolsResults
  y$Samples <- ChIPSeqSamples
  return(y)
}