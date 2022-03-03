#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("tcltk2")
library(tidyverse)
library(dplyr)
library(tcltk2)

#load data from biomart - Ensembl
biomart_db <- read.delim2(file = "mart_export.txt", header = TRUE, sep = ",", dec = ",")

#read list with all the genes (still with duplicates)
#this list is a collection of all the genes we are interested in to analyse with adaptive seq
complete_gene_list<-read.delim2(file = "complete_gene_list.txt", header = TRUE)

#remove duplicates from the list
complete_gene_list<-distinct(complete_gene_list)

#save list as csv
write.csv(x=complete_gene_list, file="complete_gene_list_no_duplicates")

#filter rows with genes of interest
for (gene in complete_gene_list){
  filtered_genes <-filter(biomart_db, Gene.name %in% gene)}

#filter columns of interest
colnames(filtered_genes)
filtered_genes<-filtered_genes %>% select(Gene.name, Gene.description, Chromosome.scaffold.name, Gene.stable.ID,Gene.start..bp., Gene.end..bp.)

# arrange genes from smalles to largest start position and arrange per chromosome
filtered_genes<- filtered_genes %>% arrange(Chromosome.scaffold.name,Gene.start..bp.)

#remove duplicates that come from biomart
filtered_genes = filtered_genes[!duplicated(filtered_genes$Gene.name),]

#remove genes from chromosome variants
filtered_genes<-filtered_genes[!grepl("CHR",filtered_genes$Chromosome.scaffold.name),]

#calculate gene length
filtered_genes$gene_length <- (filtered_genes$Gene.end..bp. - filtered_genes$Gene.start..bp.)

#write df to txt
write.csv(x=filtered_genes, file="gene lengths")

#select columns of interest
filtered_genes<-filtered_genes %>% select(Chromosome.scaffold.name,Gene.start..bp., Gene.end..bp.)

#add CHR before chromosome number
filtered_genes$Chromosome.scaffold.name <- sub("^", "chr", filtered_genes$Chromosome.scaffold.name )

#add +/- 15kb to start and end, this is needed for adaptive seq
filtered_genes <- mutate(filtered_genes, Gene.start..bp. = Gene.start..bp. - 15000)
filtered_genes <- mutate(filtered_genes, Gene.end..bp. = Gene.end..bp. + 15000)

#write to text file and separate columns with tabs
write.table(filtered_genes, file = "genes_to_merge.txt", append = FALSE, sep = "\t", dec = ",",
            row.names = FALSE, col.names = FALSE, quote = FALSE)




