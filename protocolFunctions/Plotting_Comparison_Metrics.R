Plotting_Comparison_Metrics <- function(){
  tryCatch({
    Pr <- as.character(readline("Enter the path of the prioritization file:"))
    SSn <- as.character(readline("Enter the path of the surrogate sensitivity file:"))
    Sn <- as.character(readline("Enter the path of the sensitivity file:"))
    Sp <- as.character(readline("Enter the path of the specificity file:"))
    Pn <- as.character(readline("Enter the path of the precision file:"))
  }, 
  
  # warning = function(w) {
  #   warning-handler-code
  # }, 
  
  error = function(e) {
    print("The file doesn't exist.")
  }, 
  
  finally = {
    
    ## Prioritization Plot | Import the score table from file.
    
    prioritization_score_table <- read.table(Pr, sep = "\t", header = TRUE, quote = "")
    #jpeg(file="Prioritization.jpeg")
    prioritization_score_table <- prioritization_score_table[,c(5,10,15,20,25)]
    colnames(prioritization_score_table) <- c("Chipenrich", "Broadenrich", "Seq2pathway", "Enrichr", "GREAT")
    prioritization_score_table$Samples <- ChIPSeqSamples
    
    ## For ggplot2 boxplot
    library(ggplot2)
    prioritization_score_table_gather <- gather(prioritization_score_table, Tool, Prioritization_Median_Value, -Samples)
    ggplot(data = prioritization_score_table_gather,
           mapping = aes(Tool, Prioritization_Median_Value, fill=Tool, na.rm = FALSE)) +
      geom_boxplot(varwidth = TRUE) +
      labs(x= "Tool", y= "Prioritization")
      
    
    # boxplot(prioritization_score_table, 
    #         ylab = "Prioritization", 
    #         xlab = "Enrichment Method",
    #         col = c("salmon","tan","khaki","lavender","darkolivegreen1"), 
    #         boxwex = 0.1, ylim = c(0,100), 
    #         names = c("Chipenrich", "Broadenrich","Seq2pathway", "Enrichr", "GREAT"))
    # abline(prioritization_score_table , h=50, col="red")
    #dev.off()
    
    
    ## (Surrogate) Sensitivity Plot | Import the score table from file.
    
    surrogate_sensitivity_table <- read.table(SSn, sep = "\t", header = TRUE, quote = "")
    #jpeg(file="Surrogate_Sensitivity.jpeg")
    surrogate_sensitivity_table <- surrogate_sensitivity_table[,c(5,10,15,20,25)]
    colnames(surrogate_sensitivity_table) <- c("Chipenrich", "Broadenrich", "Seq2pathway", "Enrichr", "GREAT")
    surrogate_sensitivity_table$Samples <- ChIPSeqSamples
    
    ## For ggplot2 boxplot
   
    surrogate_sensitivity_table_gather <- gather(surrogate_sensitivity_table, Tool, Prioritization_Median_Value, -Samples)
    ggplot(data = prioritization_score_table_gather,
           mapping = aes(Tool, Prioritization_Median_Value, fill=Tool, na.rm = FALSE)) +
      geom_boxplot(varwidth = TRUE) +
      labs(x= "Tool", y= "Prioritization")
    
    
    ## Sensitivity Plot | Import the score table from file.
    
    sensitivity_table <- read.table(Sn, sep = "\t", header = TRUE, quote = "")
    #jpeg(file="Sensitivity.jpeg")
    sensitivity_table <- sensitivity_table[,c(5,10,15,20,25)]
    colnames(sensitivity_table) <- c("Chipenrich", "Broadenrich", "Seq2pathway", "Enrichr", "GREAT")
    sensitivity_table$Samples <- ChIPSeqSamples
   
     ## For ggplot2 boxplot
    
    sensitivity_table_gather <- gather(sensitivity_table, Tool, Sensitivity_Median_Value, -Samples)
    ggplot(data = sensitivity_table_gather,
           mapping = aes(Tool, Sensitivity_Median_Value, fill=Tool, na.rm = FALSE)) +
      geom_boxplot(varwidth = TRUE) +
      labs(x= "Tool", y= "Sensitivity")
    
    
    ## Specificity Plot | Import the score table from file.
    
    specificity_table <- read.table(Sp, sep = "\t", header = TRUE, quote = "")
    #jpeg(file="Specificity.jpeg")
    specificity_table <- specificity_table[,c(5,10,15,20,25)]
    colnames(specificity_table) <- c("Chipenrich", "Broadenrich", "Seq2pathway", "Enrichr", "GREAT")
    specificity_table$Samples <- ChIPSeqSamples
    
    ## For ggplot2 boxplot
    
    specificity_table_gather <- gather(specificity_table, Tool, Specificity_Median_Value, -Samples)
    ggplot(data = specificity_table_gather,
           mapping = aes(Tool, Specificity_Median_Value, fill=Tool, na.rm = FALSE)) +
      geom_boxplot(varwidth = TRUE) +
      labs(x= "Tool", y= "Specificity")
    
    
    
    ## Precision Plot | Import the score table from file.
    
    precision_table <- read.table(Pn, sep = "\t", header = TRUE, quote = "")
    #jpeg(file="Precision.jpeg")
    precision_table <- precision_table[,c(5,10,15,20,25)]
    colnames(precision_table) <- c("Chipenrich", "Broadenrich", "Seq2pathway", "Enrichr", "GREAT")
    precision_table$Samples <- ChIPSeqSamples
    
    ## For ggplot2 boxplot
    
    precision_table_gather <- gather(precision_table, Tool, Precision_Median_Value, -Samples)
    ggplot(data = precision_table_gather,
           mapping = aes(Tool, Precision_Median_Value, fill=Tool, na.rm = FALSE)) +
      geom_boxplot(varwidth = TRUE) +
      labs(x= "Tool", y= "Precision")
    
  })}