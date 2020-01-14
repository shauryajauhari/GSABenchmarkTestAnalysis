plotMetrics <- function(x)
{
  library(tidyr) ## 'gather' function
  library(ggplot2)
  
  y <- gather(x, Tool, medianValue, -Samples)
  y$Tool <- toupper(y$Tool)
  y$Tool <- substr(y$Tool,1,nchar(y$Tool)-15)
  ggplot(data = y,
         mapping = aes(Tool, medianValue, fill=Tool, na.rm = FALSE)) +
    geom_boxplot(varwidth = TRUE) +
    labs(x= "Tool", y= "Metric")
}
