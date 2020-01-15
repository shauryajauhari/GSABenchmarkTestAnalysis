# When the original dataset is pruned by certain proportions, the enrichment results are likely to show some discrepancy in results, 
# i.e. some genes must not be present as the regions have been omitted. If the genes are still present, in comparison to the original
# dataset enrichment results, this will highlight the case for False Negative genes. 
# Simulation for finding false postives. This shall require adding some random tracks to the original tracks. 
# The test is designed to highlight the robustness of the tool against the False Positives.}

# The idea to create a consolidated genomic track (data frame) by adding together all the regions from the datasets in the benchmark. 
#The following is a master track that holds all the unique tracks from the combinatorial version of the benchmark dataset.

simulationFalsePositives <- function()
    {

      consolidatedTrack <- data.frame()
        for (i in 1:length(allSamples))
        {
          consolidatedTrack <- unique(rbind.data.frame(consolidatedTrack, allSamples[[i]], stringsAsFactors = FALSE))
        }
        consolidatedTrackBreakups <- list()
        consolidatedTrackBreakups <- trackLengths(consolidatedTrack)
      
      ## Next is to break it up into the relevant proportions and add to the original tracks.
      
        childTracks <- list()
        allSamplesSimulationAdd <- lapply(1:length(allSamples), function(y) list())
        for(i in 1:length(consolidatedTrackBreakups))
        {
          childTracks[[i]] <-consolidatedTrack[sample(nrow(consolidatedTrack),consolidatedTrackBreakups[[i]]),]
        }
      
      for (i in 1:length(allSamples))
      {
        for (j in 1:length(childTracks))
          {
            allSamplesSimulationAdd[[i]][[j]] <- rbind(allSamples[[i]],as.data.frame(childTracks[[j]]))
          }
      }
        names(allSamplesSimulationAdd) <- ChIPSeqSamples
        return(allSamplesSimulationAdd)
}