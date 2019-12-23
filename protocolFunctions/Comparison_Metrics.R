## Automate the pipeline. Step 1: Unify the attribute names

overall_results <- c ("chipenrich_results_shredded","broadenrich_results_shredded","seq2pathway_results_shredded","enrichr_results_shredded")

disease_pools <- c("colorectal_cancer_id_pool", "alzheimers_disease_id_pool", "gastric_cancer_id_pool", "prostate_cancer_id_pool")

# for (i in overall_results)
# {
#   for (j in 1:length(ChIPSeqSamples))
#     {
#      # assign(colnames(eval(parse(text=paste0(paste0(eval(parse(text ="i")),"$"),eval(parse(text="ChIPSeqSamples[j]")))))),c("Geneset.ID","P.value"))
#      # lapply(paste(paste0(paste0(eval(parse(text ="i")),"$")),paste0(eval(parse(text="ChIPSeqSamples[j]")))), change_col_names)
#     buffer <- eval(parse(text=paste0(paste0(eval(parse(text ="i")),"$"),eval(parse(text="ChIPSeqSamples[j]")))))
#     colnames(buffer) <- c("Geneset.ID","P.value")
#     }
# }


#change_col_names <- function(x) {names(x) <- c("Geneset.ID","P.value")}

# count=0
for (i in overall_results)
{
  for (j in 1:length(ChIPSeqSamples))
  {
    #     print(eval(parse(text=paste0(paste0(eval(parse(text ="i")),"$"),eval(parse(text="ChIPSeqSamples[j]"))))))
    colnames(eval(parse(text=paste0(paste0(eval(parse(text ="i")),"$"),eval(parse(text="ChIPSeqSamples[j]")))))) <- c("Geneset.ID","P.value")
    #     count=count+1
  }
}
# print(count)

## Rank calculation | Prioritization | Chipenrich

ranks <- list()
prioritization_list <- list()
x <- 1

for (i in 1:length(chipenrich_results_shredded$GSM2058093$Geneset.ID))
{
  for (j in eval(parse(text=disease_pools[4])))
  {
    if (chipenrich_results_shredded$GSM2058093$Geneset.ID[i] == j)
    {
      ranks[[x]]<- i
      x <- x+1
      
    }
  }
}
cat("The enrichment terms that matched are:\n")
for (k in ranks)
{
  print(chipenrich_results_shredded$GSM2058093$Geneset.ID[k])
}

for_prioritization <- as.double((ranks[[1]]/length(chipenrich_results_shredded$GSM2058093$Geneset.ID)*100))
cat("\nThe metric for prioritization is",for_prioritization)


####################
# m = number of tools | results
# n = any sample from 1:106
# o = any of the diseases, 1:4

#Refer to the above chunk for details about these indicies
###################

priorit <- function(m,n,o){
  for (i in 1:length(eval(parse(text=paste0(paste0(overall_results[m],"$"),paste0(paste0(ChIPSeqSamples[n],"$"),"Geneset.ID"))))))
  {
    for (j in eval(parse(text=disease_pools[o])))
    {
      if (eval(paste0(paste0(overall_results[1],"$"),paste0(paste0(ChIPSeqSamples[1], "$"),eval(parse(text=Geneset.ID[i]))))) == j)
      {
        ranks[[x]]<- i
        x <- x+1
      }
    }
  }
  val <- as.double((ranks[[1]]/length(eval(parse(text=paste0(paste0(overall_results[m],"$"),paste0(paste0(ChIPSeqSamples[n],"$"),"Geneset.ID")))))*100))
  return(val)
}


## Rounding off the value.
#print(round(prioritization))
## We may recall that the results from the GSA tools are already sorted in terms of statistical significance (p-values). However, the KEGG and GO terms for a disease are just representations and do not follow any particular order. Thus, on comparing the matches in the two categories, the hits that occur in the results from the GSA tools will be the ranks. Our aim is to find if any term in the disease pool lies in the results. The lowest amongst all ranks is the effective rank for that tool.

## For prioritization, we need to calculate the rank in terms of percentage. i.e. (rank/total) *100
## Lower, the better!


## P-Value calculation | Surrogate Sensitivity | Chipenrich

## We are interested to highlight the first (lowest) p-value of the match between target pathway and the tool outputs. The median of all such p-values for every sample in the benchmark dataset shall be the surrogate sensitivity. Note that the surrogate sensitivity doesn't take into account the p< 0.05 threshold.

p_values <- list()
x <- 1

for (i in 1:length(broadenrich_results_shredded$GSM2058093$Geneset.ID))
{
  for (j in 1:length(prostate_cancer_id_pool))
  {
    if (broadenrich_results_shredded$GSM2058093$Geneset.ID[i] == prostate_cancer_id_pool[j])
    {
      p_values[[x]]<- broadenrich_results_shredded$GSM2058093$P.value[i]
      x <- x+1
      
    }
  }
}

for_surrogate_sensitivity <- p_values[[1]]
print(for_surrogate_sensitivity)

## Classical Sensitivity, Specificity, Precision | Chipenrich

true_positives <- list()
true_negatives_ids <- list()
false_positives1_ids <- list()
false_positives2_ids <- list()
false_positives <- list()
false_negatives <- list()
count1 <- 1
count2 <- 1

## Iterating through the entire length of tool results and id-pool gives the same impression as usign "intersect" and "setdiff" set-operations, thereby achieving the common objective; just for flavor here.

for (i in 1:length(broadenrich_results_shredded$GSM2058093$Geneset.ID))
{
  for (j in 1:length(prostate_cancer_id_pool))
  {
    if (broadenrich_results_shredded$GSM2058093$Geneset.ID[i] == prostate_cancer_id_pool[j] && broadenrich_results_shredded$GSM2058093$P.value[i] <= 0.05)
    {
      true_positives[[count1]]<- prostate_cancer_id_pool[j]
      count1 <- count1 + 1
    }
    if (broadenrich_results_shredded$GSM2058093$Geneset.ID[i] == prostate_cancer_id_pool[j] && broadenrich_results_shredded$GSM2058093$P.value[i] > 0.05)
    {
      false_negatives[[count2]]<- prostate_cancer_id_pool[j]
      count2 <- count2 + 1
    }
  }
}


## Tool results' subsets on the basis of statistical significance.
greater_than_0.05 <- broadenrich_results_shredded$GSM2058093[which(broadenrich_results_shredded$GSM2058093$P.value > 0.05),]
less_than_0.05 <- broadenrich_results_shredded$GSM2058093[which(broadenrich_results_shredded$GSM2058093$P.value <= 0.05),]
true_negatives_ids <- setdiff(greater_than_0.05$Geneset.ID, prostate_cancer_id_pool) ## All ids that are there in the tool result with p > 0.05 and absent in the disease pool.

false_positives1_ids <- intersect(prostate_cancer_id_pool,greater_than_0.05$Geneset.ID)   
false_positives2_ids <- setdiff(less_than_0.05$Geneset.ID,prostate_cancer_id_pool)

false_positives <- c(false_positives1_ids,false_positives2_ids)        

## Results

cat("True positives:",length(true_positives))
cat("\nTrue negatives:",length(true_negatives_ids))
cat("\nFalse negatives:",length(false_negatives))
cat("\nFalse positives:",length(false_positives))
precision <- length(true_positives)/(length(true_positives)+length(false_positives))
cat("\nPrecision(in percentage):", precision*100)
sensitivity <- length(true_positives)/(length(true_positives)+length(false_negatives))
cat("\nSensitivity(in percentage):", sensitivity*100)
specificity <- length(true_negatives_ids)/(length(true_negatives_ids)+length(false_positives))
cat("\nSpecificity(in percentage):", specificity*100)
