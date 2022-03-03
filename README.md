# gene_lenths
All the ferroptosis related genes are searched in the biomart database from Ensembl. The chromosomal start- and end position is extracted and 15kb margins are added. The latter is important for adaptive sequencing. The final file written to txt (genes_to_merge.txt) will be used in the bedtools environment to merge overlapping genes or genes that come closer than 20kb. 
