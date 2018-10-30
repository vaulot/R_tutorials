
library("phyloseq")

setwd("C:/daniel.vaulot@gmail.com/Scripts/R tutorials/phyloseq/user_cases/2018_genevieve")

otu_mat<-read.table("OTUB.txt", header = TRUE, row.names="Otu", sep = "\t", na.strings="NA", dec=".", strip.white=TRUE)
tax_mat<-read.table("TaxonomyB.txt", header = TRUE, row.names="Otu", sep = "\t", na.strings="NA", dec=".", strip.white=TRUE)
samples_df<-read.csv("Samples.csv", header = TRUE, row.names="samples", sep = ",", na.strings="NA", dec=".", strip.white=TRUE, stringsAsFactors = FALSE)

otu_mat <- as.matrix(otu_mat)
tax_mat <- as.matrix(tax_mat)
OTU = otu_table(otu_mat, taxa_are_rows = TRUE)
TAX = tax_table(tax_mat)
samples = sample_data(samples_df)
physeq = phyloseq(OTU, TAX, samples)

physeq
sample_sums(physeq)
total = median(sample_sums(physeq))
total

standf = function(x, t=total) round(t * (x / sum(x)))
physeq_norm = transform_sample_counts(physeq, standf)
taxa_sums(physeq_norm)

# Errors in next line are due to the fact that you do not have enough samples...
plot_heatmap(physeq_norm, method = "NMDS", distance = "bray")

# Error in next line is due to the fact that with the 20% threshold you were removing all the OTUs. 
# So I changed from 20% to 1% and now it works fine
physeq_abund <- filter_taxa(physeq_norm, function(x) sum(x > total*0.01) > 0, TRUE)

physeq_abund

plot_heatmap(physeq_abund, method = "NMDS", distance = "bray")

plot_heatmap(physeq_abund, method = "MDS", distance = "jaccard",
             taxa.label = "Class", taxa.order = "Class",
             trans=NULL, low="beige", high="red", na.value="beige")

# Alternative that all work...
# Note in the distance, one must use physeq and physeq_abund

plot_heatmap(physeq_abund, method = "MDS", distance = phyloseq::distance(physeq, method = "jaccard", binary = TRUE),
             taxa.label = "Class", taxa.order = "Class",
             trans=NULL, low="beige", high="red", na.value="beige")

plot_heatmap(physeq_abund, method = "MDS", distance = distance(physeq, "(A+B-2*J)/(A+B-J)"),
             taxa.label = "Class", taxa.order = "Class",
             trans=NULL, low="beige", high="red", na.value="beige")


