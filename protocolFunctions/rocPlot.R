## The following function takes the sensitivity and specificity values for the respective tools and draws out an ROC.

rocPlot <- function()
{
  plot(sort(1-plotSpecificity$chipenrichResultsShredded), sort(plotSensitivity$chipenrichResultsShredded), type="b", col=c("red"), 
       xlab="1-Specificity",
       ylab="Sensitivity", main = "Tools for Enrichment of Genomic Regions")
  
  lines(sort(1-plotSpecificity$broadenrichResultsShredded), sort(plotSensitivity$broadenrichResultsShredded), type="b", col=c("green"))
  lines(1-plotSpecificity[order(plotSpecificity$enrichrResultsShredded),][,4], plotSensitivity[order(plotSensitivity$enrichrResultsShredded),][,4], type="b", col=c("blue"))
  lines(1-plotSpecificity[order(plotSpecificity$seq2pathwayResultsShredded),][,3], plotSensitivity[order(plotSensitivity$seq2pathwayResultsShredded),][,3], type="b", col=c("magenta"))
  lines(1-plotSpecificity[order(plotSpecificity$greatResultsShredded),][,5], plotSensitivity[order(plotSensitivity$greatResultsShredded),][,5], type="b", col=c("lightpink"))
  
  legend(0.06, 0.65, legend=c("CHIPENRICH", "BROADENRICH", "ENRICHR", "SEQ2PATHWAY", "GREAT"),
         col=c("red", "green", "blue", "magenta", "lightpink"), lty=1, cex=0.8, box.lty=0)
}

