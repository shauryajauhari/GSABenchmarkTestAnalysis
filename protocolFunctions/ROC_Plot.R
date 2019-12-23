## The following function takes the sensitivity and specificity values for the respective tools and draws out an ROC.

plot(sort(1-specificity_table$Chipenrich), sort(sensitivity_table$Chipenrich), type="b", col=c("red"), 
     xlab="1-Specificity",
     ylab="Sensitivity", main = "Tools for Enrichment of Genomic Regions")

lines(sort(1-specificity_table$Broadenrich), sort(sensitivity_table$Broadenrich), type="b", col=c("green"))
lines(1-specificity_table[order(specificity_table$Enrichr),][,4], sensitivity_table[order(sensitivity_table$Enrichr),][,4], type="b", col=c("blue"))
lines(1-specificity_table[order(specificity_table$Seq2pathway),][,3], sensitivity_table[order(sensitivity_table$Seq2pathway),][,3], type="b", col=c("magenta"))
lines(1-specificity_table[order(specificity_table$GREAT),][,5], sensitivity_table[order(sensitivity_table$GREAT),][,5], type="b", col=c("lightpink"))

legend(-95, 70, legend=c("Chipenrich", "Broadenrich", "Enrichr", "Seq2pathway", "GREAT"),
       col=c("red", "green", "blue", "magenta", "lightpink"), lty=1, cex=0.8, box.lty=0)
