## Since Seq2Pathway execution on the entire Benchmark dataset resulted in memory exhaustion (500 Gb: Hard disk problem)
## (Samples GSM2283767 and GSM2283771, serial nos. 6 and 11 respectively), the process was chosen
## to be modularised into 5 parts. Seq2pathway was run on sample sets 1-5, 7-10, 12-20,21-30,31-106.
## The results were assembled as a consolidated list for each sample set and stored as an RDS object
## to take care of the memory issue (32 GB, RAM this time). For further processing, a combined resultant list
## is constituted from the individual seq2pathway result lists.

seq2pathway15 <- readRDS("./Results/seq2pathway/seq2pathway_results_1_5")
seq2pathway710 <- readRDS("./Results/seq2pathway/seq2pathway_results_7_10")
seq2pathway1220 <- readRDS("./Results/seq2pathway/seq2pathway_results_12_20")
seq2pathway2130 <- readRDS("./Results/seq2pathway/seq2pathway_results_21_30")
seq2pathway31106 <- readRDS("./Results/seq2pathway/seq2pathway_results_31_106")


## Seq2pathway 31106 is the super list of results. It has NULL entries in the indices before [31]. To include
## results in the NULL indices the values from other resultant lists is overwritten. This calls for appropriately
## replacing parameters( a. range, b. list name) in the inside (second) 'for loop' with counter variable 'j'.  

for (i in 1:length(seq2pathway31106))
{
  for (j in 21:30)
  {
    if(i==j)
    {
      seq2pathway31106[[i]] <- seq2pathway2130[[j]]  
    }
  }
}

## final list renaming

seq2pathway_results <- list()
for (i in 1:length(seq2pathway31106))
    {
      seq2pathway_results[[i]] <- seq2pathway31106[[i]]  
    }
names(seq2pathway_results)<- as.character(ChIPSeqSamples)
saveRDS(seq2pathway_results, file = "./Results/seq2pathway/seq2pathway_results")

## Removing all data objects from the memory. 

rm(seq2pathway_results)
rm(seq2pathway15)
rm(seq2pathway710) 
rm(seq2pathway1220) 
rm(seq2pathway2130) 
rm(seq2pathway31106) 

## Pruning the relevant results from seq2pathway
seq2pathway_results <- readRDS("./Results/seq2pathway/seq2pathway_results")
seq2pathway_results_shredded <- list()
for (i in 1:length(seq2pathway_results))
{
  seq2pathway_results_shredded[[i]] <- seq2pathway_results[[i]]$gene2pathway_result.FET$GO_BP[,c(1,3)]  
}
names(seq2pathway_results_shredded)<- as.character(ChIPSeqSamples)
rm(seq2pathway_results)

