dataImportClean <- function(){
  
    ### Importing the master table ###
    
    setwd(".")
    proj_set()
    ChIPSeqDataMaster <- read.csv (file = "GSAChIPSeqBenchmarkDatasetProfile.txt", sep = '\t', header = TRUE, quote = "")
    
    ## The following code creates a list of samples for which we need to extract the BED files for.
    
    ChIPSeqSamples<-as.character(ChIPSeqDataMaster$GSM)
    
    ## Initializing list for storing BED files and the consecutive GRanges objects.
    
    samplesInBED = list()
    
    for(i in 1:length(ChIPSeqSamples))
    {
      samplesInBED[[i]] <- read.table(paste0("./testData/",paste0(eval(parse(text="ChIPSeqSamples[i]")),".bed")), sep = "\t", header = FALSE)
      samplesInBED[[i]] <- samplesInBED[[i]][,1:3]
      colnames(samplesInBED[[i]]) <- c("chrom", "start", "end")
      samplesInBED[[i]] <- samplesInBED[[i]][order(samplesInBED[[i]]$chrom),]
      samplesInBED[[i]] <- GRanges(seqnames = samplesInBED[[i]]$chrom, ranges = IRanges(samplesInBED[[i]]$`start`, samplesInBED[[i]]$`end`))
      genome(samplesInBED[[i]]) <- "hg38"
    }
    
    ## Saving BED files as GRanges objects ##
    
    samplesInBED <- GRangesList(samplesInBED)
    names(samplesInBED) <- ChIPSeqSamples
    saveRDS(samplesInBED, "samplesInBED.rds")
    saveRDS(ChIPSeqSamples, "ChIPSeqSamples.rds")
}



