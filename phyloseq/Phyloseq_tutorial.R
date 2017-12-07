library("phyloseq")
library("ggplot2")
library("readxl") # necessary to import the data from Excel file
library("dplyr")  # Necessary to reformat dataframe

# Read the data and create phyloseq objects -------------------------------

  otu_mat<- read_excel("CARBOM data.xlsx", sheet = "OTU matrix")
  tax_mat<- read_excel("CARBOM data.xlsx", sheet = "Taxonomy table")
  samples_df <- read_excel("CARBOM data.xlsx", sheet = "Samples")

# Fill up row names for the three matrixes -------------------------------------------------
  
  # define the row names from the otu column
    row.names(otu_mat) <- otu_mat$otu
  # remove the column otu since it is now used as a row name     
    otu_mat <- otu_mat %>% select (-otu) 

  row.names(tax_mat) <- tax_mat$otu
  tax_mat <- tax_mat %>% select (-otu) 

  row.names(samples_df) <- samples_df$sample
  samples_df <- samples_df %>% select (-sample)   

# Transform into matrixes -------------------------------------------------
  
  tax_mat <- as.matrix(tax_mat)
  otu_mat <- as.matrix(otu_mat)
  

# Transform to phyloseq objects -------------------------------------------
  OTU = otu_table(otu_mat, taxa_are_rows = TRUE)
  TAX = tax_table(tax_mat)
  samples = sample_data(samples_df)
  
  carbom <- phyloseq(OTU, TAX, samples)
  carbom
  
# Visualize data ------------------------------------------------------------
  sample_names(carbom)
  rank_names(carbom)
  sample_variables(carbom)


# Remove unwanted samples -------------------------------------------------
  carbom <- subset_samples(carbom, Select_18S_nifH =="Yes")
  carbom

# Keep only photosynthetic taxa ----------------------------------------------------
  carbom <- subset_taxa(carbom, Division %in% c("Chlorophyta", "Dinophyta", "Cryptophyta", "Haptophyta", "Ochrophyta", "Cercozoa"))
  carbom <- subset_taxa(carbom, !(Class %in% c("Syndiniales", "Sarcomonadea")))
  carbom

# Normalize abundance using median sequencing depth -----------------------------------------------
  total = median(sample_sums(carbom))
  total
  standf = function(x, t=total) round(t * (x / sum(x)))
  carbom = transform_sample_counts(carbom, standf)


# Bar graphs ---------------------------------------------------------------
  p <- plot_bar(carbom, fill = "Division")
  p
  # Make it nicer by removing OTUs boundaries
  p <- p + geom_bar(aes(color=Division, fill=Division), stat="identity", position="stack")
  p
  
  # Bar graphs Pico vs Nano 
  carbom_fraction <- merge_samples(carbom, "fraction")
  p <- plot_bar(carbom_fraction, fill = "Division")
  # Make it nicer by removing OTUs boundaries
  p <- p + geom_bar(aes(color=Division, fill=Division), stat="identity", position="stack")
  p

  # Keep only Chlorophyta and pico and do genus analysis differentiating Pico vs Nano and Surface vs Depth  --------------------
  carbom_chloro <- subset_taxa(carbom, Division %in% c("Chlorophyta"))
  # Bar graphs
  p <- plot_bar(carbom_chloro, x="Genus", fill = "Genus", facet_grid = level~fraction)
  p + geom_bar(aes(color=Genus, fill=Genus), stat="identity", position="stack")


# Heatmaps ----------------------------------------------------------------
  # Default
  plot_heatmap(carbom, method = "NMDS", distance = "bray")
  
  # Only take OTUs that represent at least 20% of reads in given sample
  carbom_abund <- filter_taxa(carbom, function(x) sum(x > total*0.20) > 0, TRUE)
  carbom_abund
  otu_table(carbom_abund)[1:8, 1:5]
  plot_heatmap(carbom_abund, method = "NMDS", distance = "bray")
  
  # Use Jaccard distance and MDS and label OTUs with Class,  order by Class and change Palette
  plot_heatmap(carbom_abund, method = "MDS", distance = "jaccard", taxa.label = "Class", taxa.order = "Class", 
               trans=NULL, low="beige", high="red", na.value="beige")

  # Plot heatmap for Chloro using Genus
  plot_heatmap(carbom_chloro, method = "NMDS", distance = "bray", taxa.label = "Genus", taxa.order = "Genus", 
               low="beige", high="red", na.value="beige")
  
  
  
# Alpha diversity --------------------------------------------------------
  plot_richness(carbom, measures=c("Chao1", "Shannon"))
  
  # Based on fraction
  plot_richness(carbom, measures=c("Chao1", "Shannon"), x="level", color="fraction")
  

# Ordination --------------------------------------------------------------

  carbom.ord <- ordinate(carbom, "NMDS", "bray")
  
  # OTUs
  plot_ordination(carbom, carbom.ord, type="taxa", color="Class", shape= "Division", title="OTUs")
  
  # Making it more easy to visualize
  plot_ordination(carbom, carbom.ord, type="taxa", color="Class", title="OTUs", label="Class") + facet_wrap(~Division, 3)
  
  # Samples
  plot_ordination(carbom, carbom.ord, type="samples", color="fraction", shape="level", title="Samples") + geom_point(size=3)
  
  # Both 
  plot_ordination(carbom, carbom.ord, type="split", color="Class", shape="level", title="biplot", label = "station") + geom_point(size=3)
  
  
  
# Network -----------------------------------------------------------------

  plot_net(carbom, distance = "bray", type = "taxa", maxdist = 0.7, color="Class", shape="Division", point_label="Genus")
  
  # Let us make it more simple by using only major OTUs 
  plot_net(carbom_abund, distance = "bray", type = "taxa", maxdist = 0.8, color="Class", shape="Division", point_label="Genus")  
  