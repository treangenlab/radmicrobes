# Session 4 - Functional Annotation, Accessory Genomes, and Pan Genomes
*by Rodrigo de Paula Baptista*

**This sesssion will be divided in three parts:**
* Genome Annotation
  * Prokaryotic annotation
    * Running Prokka
  * Eukaryotic Annotation
    * Training your prediction dataset
    * Running AUGUSTUS
    * Glimpse on BRAKER
  * Understanding the output: the gff file
  * Visualization

* Accessory Genomes

* Pan Genomes

## Genome Annotation
Genome annotation involves the identification of functional elements along the sequence of a genome, assigning meaning to it. This process is essential because DNA sequencing often yields sequences of unknown function. Over the past three decades, genome annotation has transformed from computationally annotating long protein-coding genes in single genomes (one per species) and experimentally annotating short regulatory elements on a limited number of them, to the population-wide annotation of individual nucleotides across thousands of genomes (many per species). This enhanced resolution and inclusivity in genome annotations, spanning from genotypes to phenotypes, are providing precise insights into the biology of species, populations, and individuals.
A key distinction between prokaryotic and eukaryotic genes lies in their structural composition. Prokaryotes possess only exons, whereas eukaryotes have both exons and introns. 
<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/assets/28576450/bf4a90cb-64f7-4f0b-b791-a623fc8fd3eb" width="400" height="300">
</p>
The focus here is to demonstrate the methodology for gene prediction (annotation) in both prokaryotic and eukaryotic genomes.

### PROKARYOTIC Annotation using Prokka
Prokka is a software tool designed for the rapid annotation of bacterial, archaeal, and viral genomes, generating output files that adhere to standard specifications.
Prokka documentation can be found at this [link](https://github.com/tseemann/prokka)

#### Files to be used in this hands-on
File name  | Description | Location in the cluster
------------- | ------------- | ------------- 
Genome.fasta  | Assembled genome generated on session 1 | /pathway/Session4
my_genome.gff  | Pre-generated gff output | /pathway/Session4

**Basic Usage:**
```
prokka --outdir prokka_test --prefix my_genome --rfam genome.fasta
```
**Flag explanation**
**--outdir** [name]      Output folder (in this case it will be a folder created as prokka_test in your current location)
**--prefix** [name]      Filename output prefix (in this case it will name your files with the my_genome prefix, e.g. my_genome.gff)
**--rfam**               Enable searching also for ncRNAs with Infernal+Rfam and not just protein-coding genes


### Eukaryotic Annotation using AUGUSTUS

There are several options of instances available:
- [WEBAUGUSTUS](https://bioinf.uni-greifswald.de/webaugustus/) (Web application used in this boot-camp)
- [Original AUGUSTUS](https://github.com/Gaius-Augustus/Augustus) (Can be installed on your server or local machine)
- [COMPANION](https://companion.gla.ac.uk/) (automated pipeline for eukaryotic pathogens)

#### Files to be used in this hands-on
File name  | Description | Location in the cluster
------------- | ------------- | ------------- 
Reference.fasta  | Close related reference genome used for training | /pathway/Session4
Euk_genome.gff  | Genome to be annotated | /pathway/Session4
Protein_ref.fasta  | Reference protein evidence for training | /pathway/Session4
Euk_genome.gff  | Pre-generated gff output | /pathway/Session4


#### Training dataset for prediction
