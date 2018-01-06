## Tutorials for R

Author : Daniel VAULOT, UMR 7144 CNRS-UPMC, Station Biologique, Place G. Tessier, 29680 Roscoff FRANCE
email: vaulot@sb-roscoff.fr / vaulot@gmail.com

I will post here a few tutorials for different types of analysis of microbial communities.  For each of these of these tutorials there will be a detailed explanation as a pdf file created with Rmd.

* [phyloseq](https://github.com/vaulot/R_tutorials/tree/master/phyloseq) - Manual is [here](https://github.com/vaulot/R_tutorials/blob/master/phyloseq/Phyloseq_tutorial.pdf)

Please post any question or issues [here](https://github.com/vaulot/R_tutorials/issues)

The whole set of tutorials can be downloaded [here](https://github.com/vaulot/R_tutorials/releases)

#### Prerequisites to be installed : 
* R : https://pbil.univ-lyon1.fr/CRAN/
* R studio : https://www.rstudio.com/products/rstudio/download/#download
* Download and install the following libraries by running under R studio the following lines
```R

install.packages("dplyr")  # To manipulate dataframes
install.packages("tidyr")  # To manipulate dataframes
install.packages("readxl")  # To read Excel files into R

install.packages("ggplot2")

source("https://bioconductor.org/biocLite.R")
biocLite('phyloseq')
```

