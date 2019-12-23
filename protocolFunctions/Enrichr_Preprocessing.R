Enrichr_Preprocessing <- function () {
## Rank calculation | Prioritization | Enrichr | Pre-processing

## Testing if the samples names are consistent between KEGG and GO results.
count <- 0
for (i in 1:length(names(enrichr_go_results_shredded)))
{
  for(j in 1:length(names(enrichr_kegg_results_shredded)))
  {
    if(names(enrichr_go_results_shredded)[i] == names(enrichr_kegg_results_shredded)[j])
    {
      count <- count+1
    }
  }
}
print (count) ## That is equal to total samples. Cool!

## Refining Enrichr KEGG and GO results | Extracting "hsa*****" and "GO:*****" terms.

library(stringr)

enrichr_go_terms_extracted_results_shredded <- list()
enrichr_go_terms_extracted_results_shredded <- enrichr_go_results_shredded
for (i in 1:length(enrichr_go_results_shredded))
{
  enrichr_go_terms_extracted_results_shredded[[i]]$Term <- str_extract(string = print(eval(parse(text=paste0("enrichr_go_results_shredded$",paste0(eval(parse(text="names(enrichr_go_results_shredded)[i]")),"$Term"))))), pattern = "GO:[0-9]+")
}

enrichr_kegg_terms_extracted_results_shredded <- list()
enrichr_kegg_terms_extracted_results_shredded <- enrichr_kegg_results_shredded
for (i in 1:length(enrichr_kegg_results_shredded))
{
  enrichr_kegg_terms_extracted_results_shredded[[i]]$Term <- str_extract(string = print(eval(parse(text=paste0("enrichr_kegg_results_shredded$",paste0(eval(parse(text="names(enrichr_kegg_results_shredded)[i]")),"$Term"))))), pattern = "hsa[0-9]+")
}

## Combining Enrichr KEGG and GO results

enrichr_results_shredded <- list()
length(enrichr_results_shredded) <- length (enrichr_go_terms_extracted_results_shredded)
names(enrichr_results_shredded) <- names (enrichr_go_terms_extracted_results_shredded)

for (i in 1:length(enrichr_results_shredded))
{
  if(names(enrichr_results_shredded) == names(enrichr_go_terms_extracted_results_shredded) && names(enrichr_results_shredded) == names(enrichr_kegg_terms_extracted_results_shredded))
  {
    enrichr_results_shredded[[i]] <- rbind(enrichr_go_terms_extracted_results_shredded[[i]], enrichr_kegg_terms_extracted_results_shredded[[i]], stringsAsFactors = FALSE)
  }
}

## Sorting on the basis of "P.value"

for (i in 1:length(enrichr_results_shredded))
{
  enrichr_results_shredded[[i]] <- enrichr_results_shredded[[i]][with(enrichr_results_shredded[[i]], order(enrichr_results_shredded[[i]]$P.value)), ] 
}
}

