# Session 5 hands on

## Request an interactive session
```
srun --partition=commons --pty --export=ALL --ntasks=1 --reservation=workshop --cpus-per-task=8 --mem=15GB --time=04:00:00 /bin/bash
```
## Load mamba
```
module load Mamba/23.11.0-0
```

### coping files for the hands-on
```
mkdir /scratch/hpc<your user number>
cd /scratch/hpc<##>
cp -r /projects/k2i/data/session5/ .
```

#### This is what you will see inside the session5:
* two folders (dataset and Results)
    
    * **dataset:** Contains data for your runs

    * **Results:** pre-compiled results from your runs 


### Running Prokka
```
mamba activate /projects/k2i/session_conda_environments/S5_prokka_roary

prokka --outdir /scratch/hpc<##>/hand_son_prokka --prefix my_genome --rfam /scratch/hpc<##>/session5/dataset/ARLG-10777_022435095.1_assembly.genomic.fna

cd /scratch/hpc<##>/hands_on_prokka
ls 
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

### Understanding the Annotation output:

<p></p>

#### Prokka output files 

Many files are generated in prokka:
 
##### Output details

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


### Running Bakta (light db)
```
mamba activate /projects/k2i/session_conda_environments/S5_extra/

bakta /scratch/hpc##/session5/dataset/ARLG-10777_022435095.1_assembly.genomic.fna --prefix ARLG-10777 -o /scratch/hpc##/ARLG-10777_bakta --db /projects/k2i/databases/db-light/
```

#### Compare gffs from prokka and bakta 

##### Checking number of features

```
more <prokka.gff> | cut -s -f 3| sort| uniq -c
```
### Running Minimap2 with ONT direct RNA data

```
mamba activate /projects/k2i/session_conda_environments/S5_toolset/
minimap2 -ax splice -uf -k14 /projects/k2i/data/session5/dataset/ARLG-10777_022435095.1_assembly.genomic.fna /projects/k2i/data/session5/dataset/SRR9733835.fastq.gz > ./aln.sam
samtools sort -o aln.s.bam aln.sam 
samtools index aln.s.bam 
```

you can download the fna, gff, bam and ba.bai to your computer and open IGV in your web browser

```
# From your lcomputer run something like this to copy e.g. all the alignment files.
mkdir -p IGV
scp -o ProxyJump=hpcXX@radmicrobes.rice.edu "hpcXX@nots:/scratch/hpcXX/session5/Results/dRNA/*" ./IGV
```

Open IGV https://igv.org/app/

### Running Roary

```
roary -p 5 -n -e -v /scratch/hpc##/session5/dataset/gffs/*.gff
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

### Running Panaroo

**Basic usage**
```
panaroo -i /scratch/hpc##/session5/dataset/gffs/*.gff -o ./panaroo_results/ --clean-mode strict -a core --aligner mafft
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

### Running RaxML-NG

**Basic usage:**
```
source /projects/k2i/radmicrobes-s4/bin/activate
raxml-ng --msa <path to roary or panaroo>/core_gene_alignment.aln --model GTR+G --all --bs-trees 1000
```
**Flag explanation**

**--msa file.aln**  Alignment file generated by Roary

**--model GTR+G**   model of evolution for DNA and protein alignments for tree reconstruction (best model can be predicted using tools such as [Modeltest-NG](https://github.com/ddarriba/modeltest))

**--all**           all-in-one (ML search + bootstrapping)

**--bs-trees 1000   number of bootstraps replicates 

### Open your tree on ITOL (https://itol.embl.de/upload.cgi)


### Extra work if time permits

#### Run tMHG-Finder

```
tmhgf find -g /scratch/hpc##/session5/dataset/tmhgf_genomes/
```

#### Run eggNOG 

```
#testing with annotated proteins
emapper.py -i <prokka.faa> -o /scratch/hpc##/eggnog_p_test

#testing with a genome
emapper.py -m diamond --itype genome --genepred prodigal -i <genome.fasta> -o test --output_dir /scratch/hpc##/eggnog_g_test
```