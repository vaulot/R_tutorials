## Tutorials for R

Author : Daniel VAULOT  
UMR 7144 CNRS-UPMC, Station Biologique, Place G. Tessier, 29680 Roscoff FRANCE  
email: vaulot@sb-roscoff.fr / vaulot@gmail.com

I will post here a few tutorials for different types of analysis of microbial communities.  For each of these of these tutorials there will be a detailed explanation as a pdf file created with Rmd.

* [Introduction to R](https://vaulot.github.io/tutorials/R_introduction_tutorial.html)
* [Plot data from culture experiments (cell abundance vs. time)](https://github.com/vaulot/R_tutorials/tree/master/cultures)
* [Visualization and analysis of metabarcode data with phyloseq](https://github.com/vaulot/R_tutorials/tree/master/phyloseq)


Please post any question or issues here : https://github.com/vaulot/R_tutorials/issues

#### Prerequisites to be installed to run these tutorials

* Download from [GitHub](https://github.com/vaulot/R_tutorials/archive/master.zip) the whole set of tutorial 

* Unzip the files to a folder on your computer

* Install [R](https://pbil.univ-lyon1.fr/CRAN/)

* Install [R studio](https://www.rstudio.com/products/rstudio/download/#download)

* Download and install the following libraries by running under R studio the following lines

```R

install.packages("dplyr")     # To manipulate dataframes
install.packages("tidyr")     # To manipulate dataframes
install.packages("readxl")    # To read Excel files into R
install.packages("ggplot2")   # for high quality graphics
install.packages("maps")      # to make maps
install.packages("gridExtra") # for grids
install.packages("treemap")   # for treemaps
install.packages("FactoMineR") # multivariate analysis
install.packages("plotrix" )  # needed for standard error

source("https://bioconductor.org/biocLite.R")
biocLite('phyloseq')          # metabarcode data analysis
biocLite("Biostrings")        # manipulate sequences
```

#### Step by step instructions

* [Introduction to R](https://vaulot.github.io/tutorials/R_introduction_tutorial.html)
* [Plot and process culture data](https://github.com/vaulot/R_tutorials/blob/master/cultures/R_tutorial_cultures.pdf)
* [Phyloseq analysis of metabarcode data](https://github.com/vaulot/R_tutorials/blob/master/phyloseq/Phyloseq_tutorial.pdf)



