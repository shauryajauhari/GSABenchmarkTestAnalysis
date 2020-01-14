# When the original dataset is pruned by certain proportions, the enrichment results are likely to show some discrepancy in results, 
# i.e. some genes must not be present as the regions have been omitted. If the genes are still present, in comparison to the original
# dataset enrichment results, this will highlight the case for False Negative genes. 
# Simulation for finding false postives. This shall require adding some random tracks to the original tracks. 
# The test is designed to highlight the robustness of the tool against the False Positives.}

# The idea to create a consolidated genomic track (data frame) by adding together all the regions from the datasets in the benchmark. 
#The following is a master track that holds all the unique tracks from the combinatorial version of the benchmark dataset.

Simulation_For_False_Positives <- function()
    {

      consolidated_track <- data.frame()
        for (i in 1:length(all_samples))
        {
          consolidated_track <- unique(rbind.data.frame(consolidated_track, all_samples[[i]], stringsAsFactors = FALSE))
        }
        consolidated_track_breakups <- list()
        consolidated_track_breakups <- track_lengths(consolidated_track)
      
      ## Next is to break it up into the relevant proportions and add to the original tracks.
      
        children_tracks <- list()
        all_samples_sim_add <- lapply(1:length(all_samples), function(y) list())
        for(i in 1:length(consolidated_track_breakups))
        {
          children_tracks[[i]] <-consolidated_track[sample(nrow(consolidated_track),consolidated_track_breakups[[i]]),]
        }
      
      for (i in 1:length(all_samples))
      {
        for (j in 1:length(children_tracks))
          {
            all_samples_sim_add[[i]][[j]] <- rbind(all_samples[[i]],as.data.frame(children_tracks[[j]]))
          }
      }
}