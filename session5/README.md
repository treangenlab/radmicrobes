# Session 5 - Functional Annotation and Pan Genomes
*by Rodrigo de Paula Baptista, PhD*

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
    
   * Direct RNA sequencing for annotation
  
   * Understanding the output:

     * prokka output files

     * the gff file

   * Gene Ontology Functional annotation
     
   * Visualization
  
   

* Pan-Genomes
   * Core Genomes

   * Accessory Genomes

   * Running Roary the Pan-Genome pipeline
      
      * preparing dataset
      
      * Running Roary and panaroo
      
      * Output files
      
      * Running Raxml to make a phylogenetic tree  
 
   * Visualization using ITOL
</details>

#### **All Files from this session will be available during the bootcamp at "/projects/k2i/data/session5/"**

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
- [bakta](https://github.com/oschwengers/bakta) (besides being heavily inspired by prokka Bakta is reported to find sligthly more of everything compare to prokka.)

<details>
<summary>
 
 ### RUNNING PROKKA <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20"></summary>
<p></p>
 Prokka is a software tool designed for the rapid annotation of bacterial, archaeal, and viral genomes, generating output files that adhere to standard specifications.

 [Prokka documentation](https://github.com/tseemann/prokka)

#### <ins>Files to be used in this hands-on</ins>
File name  | Description | Location in the cluster
------------- | ------------- | ------------- 
ARLG-10777_022435095.1_assembly.genomic.fna  | Assembled genome generated on session 1 | /projects/k2i/data/session5/dataset
ARLG-10777_022435095.1_assembly.genomic.fna.gff  | Pre-generated gff output | /projects/k2i/data/session5/Results/Prokka_results

**Basic Usage:**
```
###Prepare to run in interactive node
srun --pty --export=ALL --ntasks=1 --reservation=workshop --cpus-per-task=8 --mem=15GB --time=04:00:00 /bin/bash

###Activate Prokka's enviroment
ml Mamba
mamba activate /projects/k2i/session_conda_environments/S5_prokka_roary

##Run prokka
prokka --outdir prokka_test --prefix my_genome --rfam genome.fasta
```
**Flag explanation**

**--outdir** [name]      Output folder (in this case it will be a folder created as prokka_test in your current location)

**--prefix** [name]      Filename output prefix (in this case it will name your files with the my_genome prefix, e.g. my_genome.gff)

**--rfam**               Enable searching also for ncRNAs with Infernal+Rfam and not just protein-coding genes

<ins>For more options type:</ins>

```prokka -h```

<details>
 <summary>prokka options</summary>

```
General:
  --help            This help
  --version         Print version and exit
  --citation        Print citation for referencing Prokka
  --quiet           No screen output (default OFF)
  --debug           Debug mode: keep all temporary files (default OFF)
Setup:
  --listdb          List all configured databases
  --setupdb         Index all installed databases
  --cleandb         Remove all database indices
  --depends         List all software dependencies
Outputs:
  --outdir [X]      Output folder [auto] (default '')
  --force           Force overwriting existing output folder (default OFF)
  --prefix [X]      Filename output prefix [auto] (default '')
  --addgenes        Add 'gene' features for each 'CDS' feature (default OFF)
  --locustag [X]    Locus tag prefix (default 'PROKKA')
  --increment [N]   Locus tag counter increment (default '1')
  --gffver [N]      GFF version (default '3')
  --compliant       Force Genbank/ENA/DDJB compliance: --genes --mincontiglen 200 --centre XXX (default OFF)
  --centre [X]      Sequencing centre ID. (default '')
Organism details:
  --genus [X]       Genus name (default 'Genus')
  --species [X]     Species name (default 'species')
  --strain [X]      Strain name (default 'strain')
  --plasmid [X]     Plasmid name or identifier (default '')
Annotations:
  --kingdom [X]     Annotation mode: Archaea|Bacteria|Mitochondria|Viruses (default 'Bacteria')
  --gcode [N]       Genetic code / Translation table (set if --kingdom is set) (default '0')
  --prodigaltf [X]  Prodigal training file (default '')
  --gram [X]        Gram: -/neg +/pos (default '')
  --usegenus        Use genus-specific BLAST databases (needs --genus) (default OFF)
  --proteins [X]    Fasta file of trusted proteins to first annotate from (default '')
  --hmms [X]        Trusted HMM to first annotate from (default '')
  --metagenome      Improve gene predictions for highly fragmented genomes (default OFF)
  --rawproduct      Do not clean up /product annotation (default OFF)
Computation:
  --fast            Fast mode - skip CDS /product searching (default OFF)
  --cpus [N]        Number of CPUs to use [0=all] (default '8')
  --mincontiglen [N] Minimum contig size [NCBI needs 200] (default '1')
  --evalue [n.n]    Similarity e-value cut-off (default '1e-06')
  --rfam            Enable searching for ncRNAs with Infernal+Rfam (SLOW!) (default '0')
  --norrna          Don't run rRNA search (default OFF)
  --notrna          Don't run tRNA search (default OFF)
  --rnammer         Prefer RNAmmer over Barrnap for rRNA prediction (default OFF)
```
</details>

</details>

### Eukaryotic Annotation using AUGUSTUS

There are several options of instances available:
- [WEBAUGUSTUS](https://bioinf.uni-greifswald.de/webaugustus/) (Web application used in this boot-camp)
- [Original AUGUSTUS](https://github.com/Gaius-Augustus/Augustus) (Can be installed on your server or local machine)
- [COMPANION](https://companion.gla.ac.uk/) (automated pipeline for eukaryotic pathogens)

<details>
<summary>
 
### RUNNING WEBAUGUSTUS <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20"></summary>
<p></p>

#### <ins>Files to be used in this hands-on</ins>
File name  | Description | Location in the cluster
------------- | ------------- | ------------- 
Reference.fasta  | Close related reference genome used for training | [not covered in the hands-on]
Euk_genome.fasta  | Genome to be annotated | [not covered in the hands-on]
Protein_ref.fasta  | Reference protein evidence for training | [not covered in the hands-on]
Euk_genome_augustus.gff  | Pre-generated gff output | [not covered in the hands-on]

#### <ins>Training dataset for prediction</ins>

![WEBAUGUSTUS](https://github.com/treangenlab/radmicrobes/assets/28576450/79878937-e7f5-4001-b37b-dcd95e38e515)

#### <ins>Submission Form</ins>

For the training submission you need:
* Your Reference Genome in Fasta format: Reference.fasta
* Your Reference Genome Protein file in fasta format:  Protein_ref.fasta
<img width="448" alt="image" src="https://github.com/treangenlab/radmicrobes/assets/28576450/d801936b-2037-4da8-8693-6344e0d4514a">


#### <ins>Running the prediction using your trained dataset</ins>

Very Similar to submitting the Training but now providing the training parameter file generated from your training

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/65a10cb5-7ec0-4f9a-ad7c-07244558589a)


**The parameters.tar.gz archive has a folder containing the following files is required for predicting genes in a new genome with pre-trained parameters that as observed have the probabilities for the feature prediction in your sample**

* species/species_parameters.cfg
* species/species_metapars.cfg
* species/species_metapars.utr.cfg
* species/species_exon_probs.pbl.withoutCRF
* species/species_exon_probs.pbl
* species/species_weightmatrix.txt
* species/species_intron_probs.pbl
* species/species_intron_probs.pbl.withoutCRF
* species/species_igenic_probs.pbl
* species/species_igenic_probs.pbl.withoutCRF

#### <ins>Expected differences between Prokaryotic and Eukaryotic GFF Features</ins>

* Prokaryotic Expected Features:
   * Gene, exon, CDS, short UTR length
* Eukaryotic expected Feature:
   * Gene, more than one exon per gene (single exon are also expected), intron, CDS (including splice variants), longer and more complex UTR lengths
</details>

<details>
<summary>

### Glimpse on BRAKER</summary>
<p></p>
BRAKER mainly features semi-unsupervised, extrinsic evidence data (RNA-Seq and/or protein spliced alignment information) supported by the training of GeneMark-ES/ET/EP/ETP and subsequent training of AUGUSTUS with the integration of extrinsic evidence in the final gene prediction step. It automates all the AUGUSTUS prediction process.

[BRAKER Documentation](https://github.com/Gaius-Augustus/BRAKER)
<br>
<img src="https://github.com/treangenlab/radmicrobes/assets/28576450/d554241d-b7a3-441e-95d8-32cd7d53e37f" width="350" height="300">


**Basic usage using protein data or/and RNAseq data:**
```
braker.pl --genome=genome.fa --prot_seq=orthodb.fa --bam=/path/to/SRA_ID1.bam
```
</details>
<details>
<summary>

### Long read RNA sequencing for annotation using PacBio and Oxford Nanopore sequencing (DRS)

</summary>

**PacBio Iso-Seq** method sequences the entire cDNA molecules – up to 10 kb or more – without the need for bioinformatics transcript assembly, so you can characterize novel genes and isoforms in bulk and single-cell transcriptomes.

**Nanopore direct RNA sequencing (DRS)** involves the continuous reading of native RNA strands, providing a valuable tool for validating *ab initio* annotations. 

Both techniques are particularly useful for obtaining information about gene boundaries, including untranslated regions (UTRs), and is adept at detecting alternative splicing events.

 
<img src="https://github.com/treangenlab/radmicrobes/assets/28576450/d0fc0990-fb26-4dd7-b99e-641c0d12f83c" >
<em>(Parker et al., 2020)</em>

Since the results from this assay would give you full-length transcripts, there is no need to perform a prediction or transcriptome assembly. Usually, you run [minimap2](https://github.com/lh3/minimap2) against your assembled genome and curate the annotation using tools such as [Webapollo2](https://github.com/GMOD/Apollo).

To analyze using [Isoseq3](https://github.com/ylipacbio/IsoSeq3)

```
#Consensus Calling
ccs movie.subreads.bam ccs.bam --no-polish --num-passes 1
#Primer removal and demultiplexing
lima ccs.bam barcoded_primers.fasta demux.ccs.bam --isoseq --no-pbi
#Clustering and transcript clean up
isoseq3 cluster demux.P5--P3.bam unpolished.bam --verbose
#Polishing (optional)
isoseq3 polish unpolished.bam m54020_171110_2301211.subreads.bam polished.bam
```

To run the alignment using minmap2 and DRS reads against a reference genome:

```
./minimap2 -ax splice -uf -k14 reference.fa reads.fq > aln.sam
```

</details>

<details>
<summary>

### Understanding the Annotation output:
</summary>
<p></p>

#### Prokka output files 

Many files are generated in prokka:
 
##### Output details</summary>

Extension	| Description
------------- | ------------- 
.gff	| This is the master annotation in GFF3 format, containing both sequences and annotations. It can be viewed directly in Artemis or IGV.
.gbk	| This is a standard Genbank file derived from the master .gff. If the input to prokka was a multi-FASTA, then this will be a multi-Genbank, with one record for each sequence.
.fna	| Nucleotide FASTA file of the input contig sequences.
.faa	| Protein FASTA file of the translated CDS sequences.
.ffn	| Nucleotide FASTA file of all the prediction transcripts (CDS, rRNA, tRNA, tmRNA, misc_RNA)
.sqn	| An ASN1 format "Sequin" file for submission to Genbank. It needs to be edited to set the correct taxonomy, authors, related publication etc.
.fsa	| Nucleotide FASTA file of the input contig sequences, used by "tbl2asn" to create the .sqn file. It is mostly the same as the .fna file, but with extra Sequin tags in the sequence description lines.
.tbl	| Feature Table file, used by "tbl2asn" to create the .sqn file.
.err	| Unacceptable annotations - the NCBI discrepancy report.
.log	| Contains all the output that Prokka produced during its run. This is a record of what settings you used, even if the --quiet option was enabled.
.txt	| Statistics relating to the annotated features found.
.tsv	| Tab-separated file of all features: locus_tag,ftype,len_bp,gene,EC_number,COG,product


#### The GFF File <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20"> </summary>

The GFF (General Feature Format) format consists of one line per feature, each containing 9 columns of data, plus optional track definition lines. 

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/b71471f4-e603-4d17-886c-f64733865ae6)

**Fields must be tab-separated. Also, all but the final field in each feature line must contain a value; "empty" columns should be denoted with a '.'**

**1. seqname -** name of the chromosome or scaffold; chromosome names can be given with or without the 'chr' prefix.

**2. source -** name of the program that generated this feature, or the data source (database or project name)

**3. feature -** feature type name, e.g. gene, mRNA, exon, CDS, ncRNA, UTR, etc.

**4. start -** Start position of the feature, with sequence numbering starting at 1.

**5. end -** End position of the feature, with sequence numbering starting at 1.

**6. score -** A floating point value. (not important here)

**7. strand -** defined as + (forward) or - (reverse).

**8. frame -** One of '0', '1' or '2'. '0' indicates that the first base of the feature is the first base of a codon, '1' that the second base is the first base of a codon, and so on.

**9. attribute -** A semicolon-separated list of tag-value pairs, providing additional information about each feature.

<details>
<summary>
 
##### **Lets do some exercises!**</summary>

```
###How does your GFF file looks like?
less my_genome.gff

###How many features are in your gff file?
cat my_genome.gff | cut -s -f 3| sort| uniq -c

###Do we have a "Carbapenem-hydrolyzing beta-lactamase KPC" gene annotated in this genome?
more my_genome.gff| grep "KPC"

```
</details>
</details>
<details>
<summary>

 ### Gene Ontology Functional Annotation <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20">
</summary> 

The Gene Ontology (GO) serves as a framework and set of concepts for delineating the functions of gene products across various organisms. Tailored for supporting the computational representation of biological systems, GO annotations establish associations between specific gene products and GO concepts. Together, these annotations create statements relevant to the function of the respective genes.


Practically, an ontology serves as a representation of our knowledge about a subject. In the context of biology, 'ontologies' encompass representations of detectable or directly observable entities and the relationships between them. The lack of a universal standard terminology in biology and related fields results in varied term usage specific to species, research areas, or even individual research groups, creating challenges in communication and data sharing.

To address this, the Gene Ontology project offers an ontology comprising defined terms that represent properties of gene products. This ontology spans three domains:

**1. Cellular component:** Encompassing the parts of a cell or its extracellular environment.

**2. Molecular function:** Describing the elemental activities of a gene product at the molecular level, such as binding or catalysis.

**3. Biological process:** Defining operations or sets of molecular events with a clear beginning and end, relevant to the functioning of integrated living units, including cells, tissues, organs, and organisms.


#### Blast2GO

[Blast2GO](https://www.blast2go.com/) is one of the best tools available to look for gene functions. (Besides being paid as part of OMICs Box it has a free trial and for some cases free basic versiohn for non-profit organization accounts)

* Simple usage with all analysis needed to add GO terms into your genome

* Basic worflow:

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/beb2ca28-ca3c-4dec-aa5f-ebfb528ee4de)


#### Interproscan

Using [InterproScan](https://www.ebi.ac.uk/interpro/search/sequence/) ou can also visualize for other features such as domain location transmembrane domains, and signal peptides in your proteins.

**You just need to submit your protein sequence:**

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/0ae73a5e-8eda-4a50-b8d5-3fdad1057eef)

**Exercise:** copy the first sequence on your prokka faa result and paste [here](https://www.ebi.ac.uk/interpro/search/sequence/). What do you see?


#### EggNOG

[EggNOG-mapper](https://github.com/eggnogdb/eggnog-mapper) is a tool for fast functional annotation of novel sequences. It uses precomputed orthologous groups and phylogenies from the [eggNOG database](http://eggnog5.embl.de) to transfer functional information from fine-grained orthologs only.

EggNOG-mapper is more accurate and runs ∼15× faster than BLAST and at least 2.5× faster than InterProScan. Can run on a [web-service](http://eggnog-mapper.embl.de/) or command line.  

<img width="612" alt="image" src="https://github.com/user-attachments/assets/267ba074-ba18-4273-8e82-1c0bca260bb8" />


**Basic usage (diamond blastp)**
```
emapper.py -i FASTA_FILE_PROTEINS -o test
```
*note: it needs to have eggNOG database downloaded. For this workshop we have the Bacterial database*
**Run search and annotation for a genome, using Diamond search on proteins predicted by Prodigal, changing the output directory**
```
emapper.py -m diamond --itype genome --genepred prodigal -i FASTA_FILE_NTS -o test --output_dir /home/me/mydir
```



</details>
<details>
<summary>
  
 ### Visualization <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20"> </summary>
 <p> </p>
 
Integrative Genomics Viewer ([IGV](https://igv.org/app/)) <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/dc1b3be9-9f71-4b33-b2b8-d5e55cc9c9b7" width="30" height="30">

* To visualize your genome and annotation:

  * Upload your genome:

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/37fbc409-7192-4c2c-b988-094ee9fde4fc)

  * Upload your gff track: 

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/a5d7ba21-7707-475f-8c0d-0e1428b3db75)

</details>


## Pan-Genomes

In molecular biology and genetics, a pan-genome refers to the complete collection of genes found across all strains within a clade. Broadly speaking, it represents the integration of all genomes within a clade. The pan-genome can be dissected into a 'core pangenome,' comprising genes present in all individuals, and an 'accessory genome', which encompasses genes found in only a subset of the strains, including strain-specific genes.
<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/assets/28576450/6707150a-55d8-42be-a887-6e71fa617a75" >
</p>

### Core Genome

Whole genome sequencing (WGS) is increasingly employed in epidemiological investigations of pathogens. While SNP variant calling is presently considered the most suitable method, challenges arise from the selection of a representative reference genome and the results being dependent on the isolate, limiting standardization and impacting resolution in an uncertain manner.

In the quest for a pangenome analysis, the core genome emerges as an appealing alternative. This is because the core genome comprises loci present in all isolates (>95% of the isolates), facilitating the comparison and identification of sequence differences in protein-coding genes among the analyzed isolates. This approach distinguishes itself from whole-genome sequencing by incorporating a selection of accessory loci (not present in all isolates) and intergenic regions.

### Accessory Genome

The accessory genome is frequently divided into the shell genome, which comprises genes shared by more than 15% of the strains but less than 95% of the strains, and the cloud genome, encompassing genes shared by less than 15% of the strains but present in more than one strain.
These genes have the potential to confer distinctive characteristics to a strain and/or offer a niche-specific advantage to the host strains. Acquisition of these genes may occur through horizontal gene transfer (HGT), and they are sustained by a subset of all the strains within a species.

### Pangenome tools

There are several options of instances available:

* [Roary](https://sanger-pathogens.github.io/Roary/) (Besides not having updates anymore, it is still very useful for the community and will be used for this session)

* [Panaroo](https://github.com/gtonkinhill/panaroo) (Considered the substitute for roary)

* [PIRATE](https://github.com/SionBayliss/PIRATE) (another good alternative)

* [tMHG-Finder](https://github.com/yongze-yin/tMHG-Finder) (de Novo Tree-Based Maximal Homologous Group Finder, can be used to find homologous sites for pangenome analysis)
  
<details>
<summary>
 
 ### RUNNING ROARY and PANAROO <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20"></summary>
<p></p>
 
#### [Roary Documentation](https://sanger-pathogens.github.io/Roary/)

##### Preparing dataset

###### Files to be used in this hands-on
File name  | Description | Location in the cluster
------------- | ------------- | ------------- 
*.gff  | all pre made annotations using prokka for our analysis | /projects/k2i/data/session5/dataset/gffs/*.gff
my_genome_ST.tsv | Strain type from the assembled genome from sessions 1 and 3 | /projects/k2i/data/session5/dataset/pangenome/
core_gene_alignment.aln | Core alignment pre generated from roary for phylogeny | /projects/k2i/data/session5/Results/pangenome/roary
accessory_binary_genes.fa.newick | Accessory phylogenetic tree generated by Roary | /projects/k2i/data/session5/Results/pangenome/roary

```
mkdir roary_analysis
cp /path/session5/roary_files/* roary_analysis
cd roary_analysis
```
##### Running Roary <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20">
**Basic usage**
```
roary -p 5 -n -e -v *.gff
```

**Flag explanation**

**-p 5**   number of threads (5 in this example)

**-n**     fast core gene alignment with MAFFT

**-e**     create a multiFASTA alignment of core genes using PRANK

**-v**     verbose output to STDOUT

**(*)gff** All annotated files from your samples

##### Output files
File name  | Description 
------------- | ------------- 
core_gene_alignment.aln	| Core gene aligment 
accessory_binary_genes.fa.newick | Accessory gene tree
gene_presence_absence.csv | Table with information of gene presence and absense

##### Running Panaroo <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20">

**[Panaroo documentation](https://gthlab.au/panaroo/#/gettingstarted/quickstart)**

**Basic usage**
```
panaroo -i *.gff -o ./results/ --clean-mode strict -a core --aligner mafft
```
**Flag explanation**

**-i**                     input GFF3 files (Genbank file formats are also supported with extensions '.gbk', '.gb' or '.gbff')

**--clean-mode**           The stringency mode at which to run panaroo. (strict,moderate,sensitive)

**-a**                     Output alignments of core genes or all genes. Options are 'core' and 'pan'. Default: 'None'

**--core_threshold**       frequency of a gene in the your sample required to classify it as 'core' (example: 0.95)

**--aligner**              Specify an aligner. Options:'prank', 'clustal', and default: 'mafft'

**--merge_paralogs**       Panaroo splits paralogs into separate clusters by default. Merging paralogs can be enabled.

**--remove-invalid-genes** ignore invalid annotation that do not conform to the expected Prokka format such as those including premature stop codons

* Clean-modes explained:
  * strict: Requires fairly strong evidence (present in  at least 5% of genomes) to keep likely contaminant genes. Will remove genes that are refound more often than they were called originally.
  * moderate: Requires moderate evidence (present in  at least 1% of genomes) to keep likely contaminant genes. Keeps genes that are refound more often than they were called originally.
  * sensitive: Does not delete any genes and only performes merge and refinding operations. Useful if rare plasmids are of interest as these are often hard to disguish from contamination. Results will likely include  higher number of spurious annotations.

##### Running Raxml to make a phylogenetic tree <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20">

**Basic usage:**
```
source /projects/k2i/radmicrobes-s4/bin/activate
raxml-ng --msa core_gene_alignment.aln --model GTR+G --all --bs-trees 10
```
**Flag explanation**

**--msa file.aln**  Alignment file generated by Roary

**--model GTR+G**   model of evolution for DNA and protein alignments for tree reconstruction (best model can be predicted using tools such as [Modeltest-NG](https://github.com/ddarriba/modeltest))

**--all**           all-in-one (ML search + bootstrapping)

**--bs-trees 10**   number of bootstraps replicates (10 replicates is not recommended since is too low, but we are using here to get results faster)

</details>

<details>
<summary>
 
 ### Visualization using ITOL <img src="https://github.com/treangenlab/radmicrobes/assets/28576450/b4033000-380f-416a-aeec-ab7385412a6b" width="20" height="20"></summary>
<p></p>
 
#### [ITOL Website](https://itol.embl.de/)

##### Visualizing your core tree

* **Step 1:** Upload your raxml tree [here](https://itol.embl.de/upload.cgi)

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/c693b51a-5fd1-438d-8b6f-20bb433cc9c6)

* **Step 2:** In the control panel select Advanced and then click on midpoint root

  ![image](https://github.com/treangenlab/radmicrobes/assets/28576450/9effbbd9-438b-47e5-98e6-e2162cf9f922)

##### Adding Information (Sequencing types)

* **Create a dataset:**

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/a92a7726-88fa-42a4-93ec-6907e3c7686e)

* **Add information about your samples (my_genomes_STs.tsv):**

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/8ccd2440-960c-4815-91e2-232bc0984276)

   * **Input file**

      * Contains three columns (see example below):


Sample name  | Color code | Information (ST)
------------- | ------------- | ------------- 
Sample1 | #0A11C8 | 307
Sample2 | #048B52 | 258
Sample3 | #0A11C8 | 307
sample4 | #0A11C8 | 307         

* **Core gene tree**

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/f26ffaa9-c76b-41f7-b54d-8fb8db2e1723)


##### How about the Accessory?

![image](https://github.com/treangenlab/radmicrobes/assets/28576450/ab3dc488-7a2f-438b-8b79-23982aaf201e)

##### Discussion

* What are the differences that you see between core and Accessory trees? What information you can extract from it?

</details>
