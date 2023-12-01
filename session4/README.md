# Session 4 - Functional Annotation and Pan Genomes
*by Rodrigo de Paula Baptista*

<details>
 <summary>
  
  ## Session Summary</summary>
 <p></p>

 * Genome Annotation
 
   * Prokaryotic annotation
  
     * Running Prokka
  
   * Eukaryotic Annotation
  
     * Training your prediction dataset

     * Running AUGUSTUS

     * Glimpse on BRAKER
  
   * Understanding the output:

     * prokka output files

     * the gff file

   * Gene Ontology and InterproScan (adding functions)
     
   * Visualization
  
   * Using your annotation in Variant Call Format files (VCF)

* Pan-Genomes
   * Core Genomes

   * Accessory Genomes

   * Running Roary the Pan-Genome pipeline
      
      * preparing dataset
      
      * Running Roary
      
      * Output files
      
      * Running Raxml to make a phylogenetic tree  
 
   * Visualization using ITOL
</details>

## Genome Annotation
Genome annotation involves the identification of functional elements along the sequence of a genome, assigning meaning to it. This process is essential because DNA sequencing often yields sequences of unknown function. Over the past three decades, genome annotation has transformed from computationally annotating long protein-coding genes in single genomes (one per species) and experimentally annotating short regulatory elements on a limited number of them, to the population-wide annotation of individual nucleotides across thousands of genomes (many per species). This enhanced resolution and inclusivity in genome annotations, spanning from genotypes to phenotypes, are providing precise insights into the biology of species, populations, and individuals.
A key distinction between prokaryotic and eukaryotic genes lies in their structural composition. Prokaryotes possess only exons, whereas eukaryotes have both exons and introns. 
<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/assets/28576450/bf4a90cb-64f7-4f0b-b791-a623fc8fd3eb" width="400" height="300">
<em>(Castellana & Bafna, 2010)</em>
</p>

The focus here is to demonstrate the methodology for gene prediction (annotation) in both prokaryotic and eukaryotic genomes.

### PROKARYOTIC Gene Annotation

There are several options of instances available:
- [PROKKA](https://github.com/tseemann/prokka) (Which will be used in this boot camp)
- [RAST](https://rast.nmpdr.org/) (Webserver application)
- [PGAP](https://github.com/ncbi/pgap) (Usually the best option, but runs slow)

<details>
<summary>
 
 #### RUNNING PROKKA</summary>
<p></p>
 Prokka is a software tool designed for the rapid annotation of bacterial, archaeal, and viral genomes, generating output files that adhere to standard specifications.

 [Prokka documentation](https://github.com/tseemann/prokka)

##### Files to be used in this hands-on
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

</details>

### Eukaryotic Annotation using AUGUSTUS

There are several options of instances available:
- [WEBAUGUSTUS](https://bioinf.uni-greifswald.de/webaugustus/) (Web application used in this boot-camp)
- [Original AUGUSTUS](https://github.com/Gaius-Augustus/Augustus) (Can be installed on your server or local machine)
- [COMPANION](https://companion.gla.ac.uk/) (automated pipeline for eukaryotic pathogens)

<details>
<summary>
 
#### RUNNING WEBAUGUSTUS</summary>
<p></p>

#### Files to be used in this hands-on
File name  | Description | Location in the cluster
------------- | ------------- | ------------- 
Reference.fasta  | Close related reference genome used for training | /pathway/Session4
Euk_genome.gff  | Genome to be annotated | /pathway/Session4
Protein_ref.fasta  | Reference protein evidence for training | /pathway/Session4
Euk_genome.gff  | Pre-generated gff output | /pathway/Session4

##### Training dataset for prediction

##### Running the prediction using your trained dataset

##### Brief look at differences between Prokaryotic and Eukaryotic gff Features

</details>

<details>
<summary>

#### Glimpse on BRAKER</summary>
<p></p>
</details>
<details>
<summary>
 
#### Understanding the output:</summary>
<p></p>

##### Prokka output files

##### The gff file
</details>
<details>
<summary>

 #### Gene Ontology and InterproScan (adding functions)
</summary> 
</details>
<details>
<summary>
  
 #### Visualization</summary>
</details>
<details>
 <summary>
  
#### Using your annotation in Variant Call Format files (VCF)</summary>
</details>

## Pan-Genomes

In molecular biology and genetics, a pan-genome refers to the complete collection of genes found across all strains within a clade. Broadly speaking, it represents the integration of all genomes within a clade. The pan-genome can be dissected into a 'core pangenome,' comprising genes present in all individuals, and an 'accessory genome', which encompasses genes found in only a subset of the strains, including strain-specific genes.

### Core Genome

### Accessory Genome

The accessory genome is frequently divided into the shell genome, which comprises genes shared by more than 15% of the strains but less than 95% of the strains, and the cloud genome, encompassing genes shared by less than 15% of the strains but present in more than one strain.
These genes have the potential to confer distinctive characteristics to a strain and/or offer a niche-specific advantage to the host strains. Acquisition of these genes may occur through horizontal gene transfer (HGT), and they are sustained by a subset of all the strains within a species.

<details>
<summary>RUNNING ROARY</summary>
<p></p>
 
#### [Roary Documentation](https://sanger-pathogens.github.io/Roary/)

##### Preparing dataset

###### Files to be used in this hands-on
File name  | Description | Location in the cluster
------------- | ------------- | ------------- 
*.gff  | all pre made annotations using prokka for our analysis | /pathway/Session4/roary_files/
my_genome_ST.tsv | Strain type from the assembled genome from sessions 1 and 3 | /pathway/Session4/roary_files

```
mkdir roary_analysis
cp /path/session4/roary_files/* roary_analysis
cd roary_analysis
```
##### Running Roary
```
roary -p 5 -n -e -v *.gff
```
##### Output files

##### Running Raxml to make a phylogenetic tree

```
raxml-ng --msa core_gene_alignment.aln --model GTR+G --all --bs-trees 10
```

</details>

<details>
<summary>Visualization using ITOL</summary>
<p></p>
 
#### [ITOL Website](https://itol.embl.de/)

</details>
