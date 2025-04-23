# Session 4 - Genomic Epidemiology, Strain-Level Analyses, and Phylogenomics
*by William Shropshire, PhD*

## Table of contents

* [Preparation](#preparation)
* [Genomic Epidemiology](#genomic-epidemiology)
  * [Traditional 'OG' Epidemiology](#traditional-og-epidemiology)
     * [Exercise 1 - Using R](#exercise-1---using-r)
  * [Precision Public Health](#precision-public-health)
     * [Case Study 1 - Salmonellosis Outbreak](#case-study-1---salmonellosis-outbreak)
     * [Case Study 2 - Cephalosporin Resistant *Escherichia coli* Surveillance](#case-study-2---cephalosporin-resistant-escherichia-coli-surveillance)
* [Strain-Level Analysis](#strain-level-analysis)
  * [Genotyping - Measures of Genetic Relatedness](#genotyping---measures-of-genetic-relatedness)
  * [Working with Databases](#databases)
     * [Example 1 - Species Identification](#example-1---species-identification)
     * [Example 2 - Multilocus sequence typing](#example-2---multilocus-sequence-typing)
     * [Example 3 - Downloading schemes](#example-3---downloading-schemes)
  * [Strain-level Analysis Tools](#strain-level-analysis-tools)
     * [MLST](#mlst)
     * [AMRFinderPlus](#amrfinderplus)
     * [Kleborate](#kleborate)
     * [Center for Genomic Epidemiology](#center-for-genomic-epidemiology)
  * [Measuring Genomic Distance](#measuring-genomic-distance)
     *  [Mash](#mash)
     *  [Snippy](#snippy)
* [Phylogenetics](#phylogenetics)
  * [Introduction and Terminology](#introduction-and-terminology)
     * [Dissecting a Tree](#dissecting-a-tree)
     * [Maximum Parsimony vs. Maximum Likelihood](#maximum-parsimony-vs-maximum-likelihood)
  * [Inferring Phylogenies Using Maximum-Likelihood Parameterization](#inferring-phylogenies-using-maximum-likelihood-parameterization)
     * [More complexities to address mutational heterogeneity](#more-complexities-to-address-mutational-heterogeneity)
  * [Why so many models and which to choose?](#why-so-many-models-and-which-to-choose)
  * [Additional model variations and approaches](#additional-model-variations-and-approaches)
  * [Summary of Key Points](#summary-of-key-points)
     * [Example 1 - Distance based phylogeny](#example-1---distance-based-phylogeny)
     * [Example 2 - Maximum-likelihood Inferred Phylogeny](#example-2---maximum-likelihood-inferred-phylogeny)
  * [Bayesian Analysis to Infer Time-Dated Phylogenies](#bayesian-analysis-to-infer-time-dated-phylogenies)
  * [Phylogeny Visualization Tools](#phylogeny-visualization-tools)
* [Tips](#tips)
* [License](#license)




## Preparation

* **Download R/RStudio**

If you have not already done so, please download:
  * R and RStudio from the following site: [RStudio](https://posit.co/download/rstudio-desktop/)

* **Set up conda environment on NOTS**
By this point everyone should be able to `ssh` into the NOTS server:
```
# First ssh into the jumpstation
ssh <your_username_here>@radmicrobes.rice.edu

# Should be in the SSH gateway
ssh <your_username_here>@nots

# Now you have accessed in the NOTS cluster

# Clone this git repository into your home directory so that you have all the files and scripts necessary for the latter parts of this session
git clone https://github.com/treangenlab/radmicrobes.git
```

* **Enter 'interactive' compute node so that we don't crash the server using limited compute resources in the compute node:
When working in Simple Linux Utility for Resource Management, or simply Slurm, cluster, you typically will send job queues to perform large computational tasks. We are going to access an 'interactive' compute node so that we can run commands within the command line interface (CLI):
```
srun --partition=commons --pty --export=ALL --ntasks=1 --reservation=workshop --cpus-per-task=8 --mem=15GB --time=04:00:00 /bin/bash
```

* **Set up conda environment on NOTS**
Most of the bioinformatic tools we use today will be used through the creation of a conda environment I already have packaged that just needs to be uncompressed within a `~/miniconda3/envs/radmicrobes-s3` directory that you'll create after successfully setting up Conda:
```
# Copy Conda install bash script into home directory
cp /projects/k2i/Miniconda3.sh ~

# Run through the interactive conda setup guide.
bash ~/Miniconda3.sh
# Enter 'yes' when the prompt asks "Do you wish to update your shell profile to automatically initialize conda?" 

# Once you have successfully downloaded Conda, we are going to add and set channels
conda config --add channels conda-forge
conda config --add channels bioconda

# Create radmicrobes-s3 environment
conda create -n radmicrobes-s3

# Activate the environment
conda activate radmicrobes-s3

# Copy the tarball radmicrobes-s3.tar.gz file into the conda environment directory
cp /projects/k2i/radmicrobes-s3.tar.gz ~/miniconda3/envs/radmicrobes-s3

# Uncompress environment in conda environment directory
cd ~/miniconda3/envs/radmicrobes-s3
tar -xvzf radmicrobes-s3.tar.gz

# Test and see if mlst is in pathway
mlst -h
```

This is **NOT** a coding class, so we won't be going over in detail first principles of programming (*i.e.*, coding syntax, structure, etc.); however, background on R/Python will be helpful when we go through some basic code that we will use to execute scripts from a command line interface. 

As an aside, there are multiple data analysis software that you can choose to perform genomic analyses. Additionally, there are multiple interactive development environments you can choose to work from such as:
 - [PyCharm](https://www.jetbrains.com/pycharm/) 
 - [JupyterLab](https://jupyter.org/)

If you're just getting started, I suggest testing out multiple platforms to see what feels most intuitive to you in conjunction of what serves your analytical needs the best. That being said, this section of the workshop is going to focus on high level theory in addition to some tools I find useful in my own work. 

## Genomic Epidemiology

### Traditional 'OG' Epidemiology 

John Snow (1813 - 1858), an English physician who pioneered many anesthesia practices in the 19th century, has been ascribed as the founder of traditional epidemiology due to his work studying the London cholera outbreaks that occurred in the mid 19th century. Prior to the widespread acceptance of germ theory that began to take hold in the late 19th century, the conventional wisdom of the time were that many diseases, including cholera, were due to 'foul air' or pollution (*i.e.*, miasma theory). John Snow was able to deduce through classic epidemiogical tracing of cholera death/attack frequency counts that cholera deaths were 14 times higher near the Broad street waterpump compared to other waterpumps that served as water sources throughout London. He documented these deaths using a dotmap, where stacked bars served as a visual tool to indicate higher frequency of deaths in a particular location: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/600px-Snow-cholera-map-1.jpg" width="500" height="400">
<em>(C.F. Cheffins, 1854)</em>
</p>

This led to John Snow being able to convince London authorities to remove the pump handle upon which cholera deaths declined:

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/cholera_deaths_time.jpg" width="600" height="400">
</p>

#### Exercise 1 - Using R

While John Snow was certainly ahead of his time, had he known that a microorganism called *Vibrio cholerae* was responsible for this life-threatening diarrheal illness and that one could culture it using a nutrient rich medium (*e.g.*, lysogeny broth which hadn't been created yet), he may have been able to more definitively demonstrate that 'fool-air' was not the causative agent for cholera. Furthermore, had John Snow been familiar with serotyping via agglutination of antisera to type specific O-antigens, he may have found an interesting correlation between genotype and phenotype. The first exercise is designed to become familiar with using R and RStudio using [this R Markdown file](https://github.com/treangenlab/radmicrobes/blob/main/session4/RScripts/3.1_Snow_cholera_example.Rmd). We will be using: (1) the package **HistData**, which can be used to load the historical data collected from the 1854 London cholera epidemic; (2) generate epidemiological curves using fictional cholera attack/death data from a two year timeframe.

### Precision Public Health 

The application of genomics to traditional epidemiology has revolutionized how we measure the spread of disease. As whole genome sequencing (WGS) has become more affordable in the past two decades, the ability to track high-risk pathogens and respond rapidly has become more evident. NGS data allows for much higher resolution to characterize potential pathogenic causitive agents and better discern signal from noise. 

#### Case Study 1 - Salmonellosis Outbreak

The following example provided by [**Armstrong *et al.*, 2019**](https://www.nejm.org/doi/full/10.1056/nejmsr1813907) demonstrates how increased resolution of molecular subtyping can improve the capacity for public health officials to pinpoint sources of outbreaks: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/Precision_PH.jpg" width="600" height="300">
<em>(Adapted from Armstrong et al., 2019 NEJM)</em>
</p>

This figure succinctly demonstrates the added value of WGS in the detection of a particular outbreak of the foodborne-pathogen *Salmonella enterica* serovar Enteritidis that occurred in a region of the United States in 2018. Panel A represents unsorted cases of gastroenteritis, with each dot representing a singular case, that without proper molecular typing, provides insufficient information as to the source of differential outbreaks. United States public health agencies began to apply pulsed-field gel electrophoresis (PFGE) in the 1990s, with a notable example of successful application being the CDC laboratory network 'PulseNet', which greatly increased capacity to pinpoint related cases through this revolutionary genotyping technique. PFGE involves digesting genomic DNA with restriction enzymes followed by agarose gel separation, which ultimately results in a particular gDNA fragment band pattern that can be used to compare other sample digests to determine if two or more organisms are related. Panel B shows how through PFGE, related cases as represented by red and yellow, cluster together; however, due to limited resolution given band patterns typically consist of a limited number of gDNA fragments, interlaboratory variability in protocols, as well as differential interpretations, 'sporadic', unrelated cases cluster with outbreak cases, which further complicates tracing if incorrect sources are ascertained. Panel C demonstrates how WGSprovided much higher resolution to determine relatedness among cases and gave public health investigators much more confidence as to their outbreak definition. In this example, WGS data allowed state officials for the 'red' cases to identify the correct source, contaminated egg shells, and were able to definitively match the *Salmonella* Entertidis to the contaminated source. 

#### Case Study 2 - Cephalosporin Resistant *Escherichia coli* Surveillance

The next example comes from [**Shropshire *et al.*, 2023**](https://journals.asm.org/doi/full/10.1128/msphere.00183-23?rfr_dat=cr_pub++0pubmed&url_ver=Z39.88-2003&rfr_id=ori%3Arid%3Acrossref.org) demonstrating how retrospective sampling and whole genome sequencing data can provide additional context to infectious disease surveillance. The first figure shows an approximate 5-year study timeframe in which we measured the prevalence of first occurrence *Escherichia coli* bacteremia cases stratified by their susceptibility pattern to the class of beta-lactam antibiotics known as cephalosporins:

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/BSI_Ec_trends.jpg" width="650" height="400">
<em>(Shropshire et al., 2023 mSphere)</em>
</p>

Where ESC-S = extended-spectrum cephalosporin susceptible, ESC-R = extended spectrum cephalosporin resistant, and total represents total bloodstream infections (BSIs). Each dot represents monthly BSI prevalence estimates stratified by susceptibility profile and each line represents a loess curve representing the smoothed average of each respective prevalence estimate over time. We were able to sequence 64% (248/349) ESC-R *E. coli* isolates to gather a more complete picture of how the population structure of bacteremia isolates causing cephalosporin resistance were changing over time:

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/ST_Phylo_temporal_trends.jpg" width="600" height="550">
<em>(Shropshire et al., 2023 mSphere)</em>
</p>

Panels A and B show proportion and absolute frequency for isolates sequenced over time by phylogroup, a molecular typing based on a quadraplex PCR schema whereas panels C and D show proportion and absolute frequency for multi-locus sequence typing (MLST), which is based on a PCR schema that includes typically 7-8 housekeeping genes and provides additional resolution. Are there any patterns that you observe from both figures?

### SARS-Cov-2 Outbreak Surveillance

I would be amiss to not mention how NGS completely reshaped how we approach genomic epidemiology following the COVID-19 outbreak. Within days of the first reported case of COVID-19 that occurred in January of 2020, we had sequenced the novel coronavirus. This not only shaped how we would trace the spread and evolution of this virus, but it also provided critical information regarding pathogenecity, immunogenicity, and gave researchers the necessasry information to develop mRNA vaccine targets for SARS-CoV-2, a completely game changing technology developed by Drs. Katalin Karikó and Drew Weissman.

Let's briefly navigate to [Nextstrain](https://nextstrain.org/ncov/gisaid/global/all-time) to look at how SARS-Cov-2 changed over time. To learn more about this awesome data visualization dashboard, I recommend checking out [Hadfield et al. 2018, *Bioinformatics* ](https://academic.oup.com/bioinformatics/article/34/23/4121/500138).

## Strain-Level Analysis

### Genotyping - Measures of Genetic Relatedness

As alluded to in the previous section, we can achieve increasing levels of genetic resolution to increase probability that we can discern if two or more isolates likely descended from a common recent ancestor: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/Genetic_Relatedness.jpg" width="750" height="450">
<em>(Shropshire et al., 2023 mSphere)</em>
</p>

Multi-locus sequence typing (MLST) is based on a PCR assay that would identify 7-8 single copy, housekeeping genes omnipresent in a particular species. Typically, these schema correlate well with phenotype/serotype of the organism, however, there is certainly less than ideal one-to-one correlations. Core genome MLST consists of identifying a set of genes found in nearly all organisms of a specific taxa whereas whole genome MLST includes accessory genome content which includes the union of all genes found within a particular group. cgMLST and wgMLST schema are very complex and only well curated for a handful of organisms such as *E. coli*. We will now be going through the databases responsible for curating bacterial typing schemes as well as some tools we can use to perform *in silico* typing of bacterial WGS data. 

### Databases

There are a few well curated databases for microbial typing schemes used across the microbinfie (*i.e.*, microbioinformatics) community. Here are some of the most commonly utilized: 
  
  - [PubMLST](https://pubmlst.org/)
  - [BIGSdb-Pasteur](https://bigsdb.pasteur.fr/)
  - [Enterobase](https://enterobase.warwick.ac.uk/)
  - [chewie-ns](https://chewie-ns.readthedocs.io/en/latest/#)

Each of these databases curate specific genus/species combinations of taxa with a little overlap. For example, **Enterobase** is the primary repository for *Escherichia coli* typing information, however, **PubMLST** also hosts data from Enterobase. The underlying software that is used for both **PubMLST** and **BIGSdb-Pasteur** is the [Bacterial Isolate Genome Sequence database (BIGSdb)](https://pubmlst.org/software/bigsdb). Each of these databases host web interfaces for querying taxa schema, typing assembly input files, as well as performing other analyses. **PubMLST** also provides an [Application Programming Interface](https://bigsdb.readthedocs.io/en/latest/rest.html#db-isolates-search) that allows for scripting in specific queries based on the user's needs. We will use three examples to demonstrate the powerful utility of these databases using the PubMLST RESTful API tool. I also want to briefly go into each script to see if we can determine how the code works.

#### Example 1 - Species identification

A colleague has sent you bacterial genome assemblies in fasta file format and wants you to determine what bacterial species it is. We are now going to leverage the PubMLST API tool with a very simple python script that Dr. Keith Jolley, [one of the primary developers of BIGSdb](https://doi.org/10.1186/1471-2105-11-595), wrote that queries fasta assemblies against the ribosomal Multilocus Sequence Type (rMLST) database through the PubMLST RESTful API using the ```curl``` command.

```
cd ~/radmicrobes/session4/Scripts
python3 ./api_species_download.py -f ./../Files/assemblies/ARLG-3180_consensus_assembly.fasta
```

If we want to loop through two or more assemblies, we can use a ```for``` loop structure: 

```
for file in $(cat ./../Files/lists/assembly_subset.tsv);do echo $file; python ./api_species_download.py -f ./../Files/assemblies/${file}_consensus_assembly.fasta;done
```

This prelininary check of our draft assemblies suggests we have *K. pneumoniae* taxa. 

#### Example 2 - Multilocus sequence typing

Now that you have successfully identified these isolates as *K. pneumoniae*, you want to quickly check what sequence type these isolates belong to using their assembly files. As mentioned before, *in silico* multilocus sequence typing (MLST) is based on a simple PCR assay where you target 7-8 single copy housekeeping genes within a bacterial chromosome that is typically species specific. Many schema are available in the aforementioned databases. Fortunately, we can modify the key:value dictionary structure of the [JSON file format](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON), and use Dr. Keith Jolley's Python script to do ```curl``` API calls using the *K. pneumoniae* MLST schema:

```
for file in $(cat ./../Files/lists/assembly_subset.tsv);do echo $file; python ./kpneumoniae_mlst_api_upload.py -f ./../Files/assemblies/${file}_consensus_assembly.fasta;done
```

We can see based on the stdout that we have exact matches for ARLG-3180 (ST307) and ARLG-3181 (ST258), which corresponds to the two most commonly detected *K. pneumoniae* sequence types that were circulating in Houston, TX from 2016 to 2017. This is a great example of how you can modify pre-existing code to perform use-case functions necessary for your own work!

For those scared of the commandline (**which you shouldn't be!!!**), I will now demonstrate how you could upload a fasta file using the website interface of [BIGSdb-Pasteur](https://bigsdb.pasteur.fr/) to determine the sequence type of the organism. 

#### Example 3 - Downloading schemes

Another useful API utility is you can download files to create your own local databases you may want to utilize for screening. For example, you can use a simple ```curl``` command to first download (1) a tab delimited list of *K. pneumoniae* MLST schemes and (2) multi-sequence fasta files for each respective housekeeping gene, where each sequence represents a unique allele:

```
sh download_kpneumoniae_mlst.sh
```
Now you have a directory (`./../db/pubmlst/klebsiella`) that has all the up-to-date *K. pneumoniae* MLST information! I hope these three examples demonstrate the power and flexibility of interfacing with these databases and how one can potentially incorporate these API commands into bespoke scripts that serve your needs! Remember, these databases host a wealth of additional information beyond simple taxa typing (*e.g.,* **PubMLST** also has antimicrobial resistance genes, plasmid replicon types, etc.) so I strongly encourage everyone to look through these sources. 

### Strain-level analysis tools

#### MLST

While using APIs for typing is certainly handy, there are tools available that make this task even simpler. One of the most simple and user-friendly tools for MLST typing is Torsten Seemann's [mlst tool](https://github.com/tseemann/mlst). The command line parameterization is very simple: 

```
% mlst contigs.fa
contigs.fa  neisseria  11149  abcZ(672) adk(3) aroE(4) fumC(3) gdh(8) pdhC(4) pgm(6)

% mlst genome.gbk.gz
genome.gbk.gz  sepidermidis  184  arcC(16) aroE(1) gtr(2) mutS(1) pyrR(2) tpiA(1) yqiL(1)

% mlst --label Anthrax GCF_001941925.1_ASM194192v1_genomic.fna.bz2
Anthrax  bcereus  -  glp(24) gmk(1) ilv(~83) pta(1) pur(~71) pyc(37) tpi(41)

% mlst --nopath /opt/data/refseq/S_pyogenes/*.fna
NC_018936.fna  spyogenes  28   gki(4)   gtr(3)   murI(4)   mutS(4)  recP(4)    xpt(2)   yqiL(4)
NC_017596.fna  spyogenes  11   gki(2)   gtr(6)   murI(1)   mutS(2)  recP(2)    xpt(2)   yqiL(2)
NC_008022.fna  spyogenes  55   gki(11)  gtr(9)   murI(1)   mutS(9)  recP(2)    xpt(3)   yqiL(4)
NC_006086.fna  spyogenes  382  gki(5)   gtr(52)  murI(5)   mutS(5)  recP(5)    xpt(4)   yqiL(3)
NC_008024.fna  spyogenes  -    gki(5)   gtr(11)  murI(8)   mutS(5)  recP(15?)  xpt(2)   yqiL(1)
NC_017040.fna  spyogenes  172  gki(56)  gtr(24)  murI(39)  mutS(7)  recP(30)   xpt(2)   yqiL(33)
```

The only required argument is a FASTA/GenBank/E formatted assembly or assemblies. There are 144 schemas preloaded with the current version of mlst as of 2023-12-12, `mlst-v2.23.0`. Given that this release was over two years ago, it would be prudent to upbdate the pubmlst databases with the following companion script available in the mlst package. This takes awhile, so I would suggest executing this command at a later time. Also note that your database pathway will be different from mine. 

```
mlst-download_pub_mlst -d  -j 2
```

For a quick example, we are going to use ARLG-3179 and ARLG-3180 assemblies as input for the mlst command using another `for loop` structure. I'm also going to use **wildcard** notation, specifically `*` to have any matching number, string, or special character match following the assigned `for loop` variable up to **.fasta**. 

```
cd ~/radmicrobes/session4/Files
mkdir -p results
for file in $(cat ./lists/assembly_subset.tsv);do mlst assemblies/${file}_*.fasta >> ./results/kpneumoniae_mlst.tsv;done
head ./results/kpneumoniae_mlst.tsv
```

As you can see, this output provides a simple, tab delimited file with filename, species, ST, and allele IDs. Importantly, we can see that using both the PubMLST API as well as the MLST tool, that we get consistent results! 

#### AMRFinderPlus

When it comes to strain-level analysis, we are typically interested in genomic features of that specific organism. In the case of our current analysis, we know that our organisms of interest are multi-drug resistant, clinical *K. pneumoniae* isolates. Thus, we may be specifically interested in understanding (1) what the antimicrobial resistant (AMR) genomic determinants are and (2) are there any other genomic factors such as virulence genes that may be cause for concern. There are many database reference tools that can be used to detect AMR genes such as: 

  - [ABRicate](https://github.com/tseemann/abricate)
  - [ResFinder](https://cge.food.dtu.dk/services/ResFinder/)

[AMRFinderPlus](https://github.com/ncbi/amr) has become one of my favorite tools for the identification of AMR genes using bacterial genome assemblies. Hosted through the National Center for Biotechnology Information (NCBI), AMRFinderPlus provides additional context to AMR that many previous AMR detection tools lacked. For example, in addition to detecting AMR genes that may be acquired through horizontal gene transfer (HGT), AMRFinderPlus allows for the detection of species specific point mutations conferring resistance as well as the option of detecting stress response and virulence genes associated with particular organisms. Importantly, this program and corresponding databases are updated consistently through NCBI. 

We are again going to use ARLG-3179 and ARLG-3180 assemblies as examples with `prokka-v1.14.5` annotated files as input (*N.B.*, Dr. Baptista will go through annotation and output files in the following section in more detail. One of the first good practice steps after setting up AMRFinderPlus is to update the database as NCBI regularly provides updates in between AMRFinderPlus releases:

```
amrfinder --update
```

To see if your organism of interest is available to characterize species specific AMR point mutations, stress response, and virulence factors, you can list out organisms as such: 

```
amrfinder --list_organisms
```

From the standard output, one can see that *Klebsiella_pneumoniae* is included as an available organism. In order to properly run AMRFinderPlus with the plus functions, you need to include a nucleotide file (.fna), a protein file (.faa), a gff file (.gff), and specify the organism, `-O`. Additionally set the `--plus` flag as well as the annotation format `-a` which is `prokka` for this case. Here is an example of code you can run with each parameter looping through our two assemblies in their respective prokka directories:

```
cd ~/radmicrobes/session4/Files
for file in $(cat ./lists/assembly_subset.tsv);do amrfinder -p ./prokka_dirs/${file}*_dir/${file}*.faa -g ./prokka_dirs/${file}*_dir/${file}*.gff -n ./prokka_dirs/${file}*_dir/${file}*.fna -a prokka --plus -O Klebsiella_pneumoniae --threads 2 -o ./results/${file}_AMRFinderPlus.tsv;done

head ./results/*_AMRFinderPlus.tsv
```

Let's go through the output to see what we can deduce from these two organisms. 

#### Kleborate

There are many *ad hoc* tools available to do analysis on your favorite organism of interest. [Kleborate](https://github.com/klebgenomics/Kleborate) has become a 'go-to' resource for *Klebsiella* genomics. Developed by the [Kat Holt lab](https://holtlab.net/), this python-based tool provides a wealth of information in addition to what AMRFinderPlus outputs, including assembly quality control (QC), MLST, AMR and virulence composite scores, and 'K' and 'O'-locus serotyping prediction using [Kaptive](https://github.com/klebgenomics/Kaptive). Let's run `kleborate-v2.3.2` with the `--all` parameter, which includes both resistance and serotyping prediction:

```
# Make sure you're in the Files directory 
for file in $(cat ./lists/assembly_subset.tsv);do kleborate --all -a ./assemblies/${file}*.fasta -o ./results/${file}_kleborate.tsv;done
head ./results/*_kleborate.tsv

```

Let's explore through some of the output and compare to the AMRFinderPlus output. 

#### Center for Genomic Epidemiology

As mentioned, this is not an exhaustive list of strain-level analysis tools by any means. One great repository of tools is hosted through the Technical University of Denmark called [Center for Genomic Epidemiology](https://www.genomicepidemiology.org). We do not have time to go over all tools available, but they do have some great tools from simple typing schemes such as plasmid typing [*e.g.*, PlasmidFinder](https://cge.food.dtu.dk/services/PlasmidFinder/) or full blown workflows such as phylogenetic analysis using [MinTyper](https://cge.food.dtu.dk/services/MINTyper/). One tool I have found invaluable is [KmerResistance](https://cge.food.dtu.dk/services/KmerResistance/). KmerResistance uses **k-mer alignment (KMA)** of short- or long-reads against redundant databases. Using a 'ConClave' sorting algorithm for non-unique matches, `kmerresistance` can identify with good sensitivity/specificity orthologous genes that may not elsewise be resolved in short-read assemblies where similar genes often get collapsed into a consensus. I like this tool so much, that I've incorporated it into my own tool that estimates copy number variants called [convict](https://github.com/wshropshire/convict). Instructions for installation are [here](https://bitbucket.org/genomicepidemiology/kma/src/master/), but I've set up `kmerresistance` to work in this conda environment. Let's quickly run through kmerresistance, using the ARLG-4673 short-read fastq files we used from session one. Note that you'll have to change the absolute pathways for each respective database based on where your radgenomics environment is located. 

`
kmerresistance -i ARLG-4673_R1.fastq.gz ARLG-4673_R2.fastq.gz -o ARLG-4673_kmerresistance -s_db /opt/homebrew/Caskroom/miniforge/base/envs/radgenomics/db/kma_databases/bacteria.ATG -t_db /opt/homebrew/Caskroom/miniforge/base/envs/radgenomics/db/kma_databases/resfinder_db
`

With short reads alone, this output indicates the likely organism (*i.e.*, *K. pneumoniae*) in addition to the AMR profile. Importantly, like many database tools that use some form of an alignment-based detection algorithm, you can use this tool with your own bespoke database to search for any genomic signature of your interest. 

While non-exhaustive, I hope that these strain-level analysis tools serve as a good starting point for those of you who are getting started in genomic epidemiology analyses. 

### Measuring Genomic Distance

One of the last concepts I want to bring up before jumping into phylogenetics is how we measure genetic distances across populations. There are many ways we can estimate genetic distance based on a comparison of genetic relatedness inferred from an alignment of amongst two or more samples. Yesterday, we discussed variant calling against a reference. Estimating distance based on variant calls is perhaps the most powerful means to compare multiple sequences to then infer genetic distance. I want to close this section by going over (1) some genetic distance heuristics, that are very helpful in estimating relatedness within a population in a computationally short amount of time with very low computational resources required and (2) a popular variant calling pipeline that can be used for generating an alignment that can subsequently used as input for phylogenetic analyses. 

#### Mash

[Mash](https://github.com/marbl/Mash) is a MinHash-based tool designed for genomics applications, offering a powerful approach to sequence comparison with minimal computational requirements. Mash leverages MinHash for constructing, manipulating, and comparing genomic data sketches, with applications ranging from genome assembly and 16S rDNA gene clustering to metagenomic sequence clustering. By introducing a novel significance test and the Mash distance metric, it distinguishes chance matches during database searches and estimates mutation rates between sequences directly from MinHash sketches. This distance metric allows for rapid computation from size-reduced sketches, offering accurate comparisons between large genomes and metagenomes. The tool supports various inputs, including whole genomes, metagenomes, nucleotide and amino acid sequences, or raw sequencing reads, making it versatile for diverse genomics applications. 

There are a total of 11 *K. pneumoniae* assemblies that are available in the `./Files/assemblies` directory. I'm going to demonstrate how simple it is to create an all-to-all Mash estimated distance matrix: 

```
cd ~/radmicrobes/session4/Files/assemblies

# Create a reduced sketch file of all 11 assemblies that will be used to estimate distance
mash sketch -o ./reference -s 100000 *.fasta

# Do an all-vs-all estimate of distance across each of the 11 assemblies to create a distance matrix that correlates well with a Jaccard distance estimate using reference-based alignments
mash dist ./reference.msh ./reference.msh -t > distances.tab
head distances.tab

# Borrowing a quick code snip-it from Ryan Wick's bacsort to format distance.tab into a PHYLIP formatted file
tail -n +2 distances.tab > distances.tab.temp  # remove first line
wc -l distances.tab.temp | awk '"[0-9]+ errors" {sum += $1}; END {print sum}' > distances.ndist  # get number for sample/line count
cat distances.ndist distances.tab.temp > kpneumo.mash.phylip
rm distances.ndist distances.tab.temp

mv kpneumo.mash.phylip ./../phylogenetics/
```

[FastANI](https://github.com/ParBLiSS/FastANI) is another great heuristic for estimating Average Nucleotide Identity (ANI) in a population, for future reference. We will use the `kpneumo.mash.phylip` PHYLIP file in the following [Phylogenetics](#phylogenetics) section. 

#### Snippy 

During session two, Dr. Treangen went over variant calling in great detail. There are a plethora of variant calling pipelines available that have advantages and disadvantages based on a multitude of factors, many of which were described yesterday. For a full review of how different variant calling pipelines perform, I suggest reading this [Bush et al. *GigaScience*](https://academic.oup.com/gigascience/article/9/2/giaa007/5728470) study where the authors systematically tested over 200 variant calling pipelines. One of the highest performing pipelines is again from the ***Torstyverse*** called [Snippy](https://github.com/tseemann/snippy). Underneath the hood, it simply is a pipeline that utilizes a short-read alignment using `bwa mem` followed by variant calling using `FreeBayes`. It works incredibly well for multiple tasks, but in particular, it's a great, reproducible tool to create a clonal frame input to use for inferring evolutionary relationships with a phylogenetic tree. I have created a simple text file that goes through the steps to create the proper input for running the `snippy-multi` pipeline in the `./Files/phylogenetics` folder named `snippy-core-instructions.txt` in addition to a pre-generated `kpneumo.clean.full.aln`, which will be used for our phylogenetics analysis. 

## Phylogenetics

### Introduction and Terminology 

Phylogenetics is simply put a catch-all term to infer evolutionary relationships using some form of distance measurement to infer the evolutionary history within a population. The field of bacterial phylogenetics employs molecular data, often derived from nucleic acids or proteins, to construct evolutionary trees that depict the genetic relatedness and divergence patterns among bacterial species or strains. 

#### Dissecting a Tree

A phylogenetic tree is a hierarchical representation of your modelled data to represent taxa within a population. Trees are composed of:

+ **tips** (*i.e.*, 'leaves' which represent your observed data),
+ **internal nodes** (*i.e.*, divergence points)
+ **branches** (*i.e.*, connections),
+ and sometimes a **root**.  
  
<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/SimpleTree1.png" width="500" height="300">
</p>

One note: there is a lot of synonymous nomenclature describing parts of trees, as anybody from biologists to mathematicians to arborists may work with trees regularly.  For instance, branches can also be called **edges** in graph vernacular.  Leaves can also be thought of as an external node.  Branches can also be be classified as internal if both ends are connected to either internal nodes or the root, or external if it terminates at a leaf.

There are a few important points to always keep in mind when interpreting trees:

+ The observed (sequenced) samples are on branch tips.

+ Time runs from root to tip

+ The order of the leaves don’t really mean anything
  + The spacing between branches also doesn't mean anything
  + Order and spacing of leaves are always arbitrary; Branches can always be swapped (or rotated about an internal node)

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/SimpleTree1_rotated.png" width="500" height="300">
</p>

<p align="center">This tree is the same as the previous one</p>

The internal nodes will represent the Most Recent Common Ancestor (MRCA), or Last Common Ancestor (LCA).  It is important to realize that since the actual observed samples are on the tips, the LCA is hypothetical.  Another common misinterpretation is that proximal leaves are closely related.  This may not be the case, depending on how the tree is drawn.  Always trace the leaves back down the branches and look to the MRCA.

#### Constructing a Phylogenetic Tree

Generally, can be divided into two methods:

+ Distance-matrix based - algorithmic
+ Directly from sequences - constructs phylogenetic inferences

Distance-matrix based methods include the Unweighted-Pair Group Method with Arithmetic Mean (UPGMA), the Fitch-Margoliash (FM) algorithm, or Neighbor-Joining (NJ) methods.  They rely heavily on pairwise distances between sample sequences - this is problematic *(why?)* - and so are rarely used on their own.  Instead, these methods are useful in building heuristic initial starting trees for the methods discussed below.

Phylogenetic inference methods can be broadly classed into maximum parsimony and maximum likelihood methods, and will be expanded on in the next subsection.

### Maximum Parsimony vs. Maximum Likelihood

#### Maximum parsimony

Generally, parsimony describes when a minimum of change is required.  

Thus in the phylogenetic context, out of all possible trees, the tree which meets the maximum parsimony criteria will group the samples in such a way that the least amount of evolutionary change is required.  That is, as every divergence point represents at least a single nucleotide change, the maximum parsimony tree will have the least total number of substitution events as one traces the topology of the tree from root to tips.  

*Claim: this necessarily means that a maximum parsimony tree will always be an underestimation of the true amount of evolutionary change.  Why might this be true?*

Maximum parsimony methods assume the concepts of homologous similarity - that identical alleles had to come from a common ancestor, and homoplasy (such as convergent evolution, parallel evolution, or reversal) are rare.

#### Maximum likelihood

Given:

1.) A sample set of sequences, and

2.) A nucleotide substitution (evolutionary) model,

Maximum Likelhood (ML) phylogenetic inference methods will build a multitude of trees, recursively computing the probabilities for the tree topology and branch lengths.  The ML method will generally start with a small (n=4) tree, analyzed, then samples are iteratively added one at a time to the tree.  With each addition, alternative topologies are explored and assessed for likelihood using local rearrangement methods such as:

+ Nearest-neighbor interchange (NNI)
+ Subtree prune and regraft (SPR)
+ Tree bisection and reconnection (TBR)

In order to compute the likelihood, the branch lengths are computed for *each* topological variant by summing the log-likelihood for *each* nucleotide at *each* site (position).

This is computationally expensive!

**ML with Bootstrapping (Felsenstein 1985)**

Generally, bootstrapping as a statistical method that involves random subsampling with replacement.  It is useful for estimating the statistical error when sampling distribution is unknown.

In the phylogenetic context, bootstrapping estimates the reliability (consistency) of the resultant (majority-rule) consensus tree.  

With each subsampling, an ML tree is constructed.  This processs is repeated 100, sometimes 1000 times.  Then all of the tree topologies are compared in a frequentist manner - these values are sometimes included on phylogenetic tree figures as 'branch support'.

One thing to note: the final resultant tree might not be the overall maximum-likelihood tree.

### Inferring Phylogenies Using Maximum-Likelihood Parameterization

As stated before, given a sample set of sequences, ML methods will also require an evolutionary model.  What is meant by this?  Let's look at the simplest (most constrained) substitution model as illustration.

**Jukes-Cantor (1969)**

The Jukes-Cantor (JC69) model assumes that the rate of nucleotide substitution is the same for all pairs, and that the base nucleotide frequency is equal in the population.  

(insert image here)

See also: Felsenstein (1981).  This is like the JC69 model, in that the substitution rates are equal, but with unequal base frequency.

**Kimura (1980)**

The Kimura (K80) model recognizes that the rate of transitions are not equal to tranversion rate.  Transitions are intragroup changes, such as A <-> G (purines), or C <-> T (pyrimidines).  Transversions would be either of the purines changing into either of the pyrimidines.  Consistent with biochemical intution, we do observe that transitions are more frequent than transversions.

(insert image here)

See also: Hasegawa-Kishino-Yano (1985).  This is like the K80 model (unequal transition vs. transversion rates), but includes unequal base frequency.

**The above two models might be thought of as "historical" by some.  We will skip ahead to more contemporary, more complex, and less constrained models below.**

**General Time-Reversible (GTR) substitution model (Tavare 1986)**

The GTR model is like the HKY model, but each possible nucleotide substitution has it's own exchangibility rate, along with unequal base frequencies.

"The Generalised time reversible (GTR) is the most general neutral, independent, finite-sites, time-reversible model possible.”

(Of course it is, it has the most parameters).

This model is probably the most popular at the moment.  

**+Gamma (Yang 1994)**

This is more of a modification that may be applied to any model, though you may commonly see this model along with the aforementioned GTR model as GTR+gamma.

In short, the gamma modification removes the assumption of per-site independence for mutations.  That is, a +gamma model:
+ allows for a model of rate heterogeneity in mutations across sites (ie: not all sites have equivalent nor independent mutational rates)
+ applies standard gamma distribution with a shape parameter (alpha), itself usually estimated from the sample data

In practice, usually a *discrete* (categorized) gamma distribution is used

#### More complexities to address mutational heterogeneity

*Why only use just one model?*

Partitioning (categorization) - apply specific models for a site or regions along a sequenced

Mixture models - assign a model (out of a user-specified selection) on a per-site basis

**!! Some caution may need to be exercised to avoid potential over-parameterization !!**

### Why so many models and which to choose?

Tractibility. The ML criterion is a NP-hard problem (as Mike Nute stated yesterday during Session 2).

We need to balance between robustness and efficiency.  There are always practical limitations such as computational resources, memory consumption, time, which are increasingly evident in the area of "big data" (larger datasets, deeper sequencing, etc.)

But, software packages can help!  Credit to the mountain of work underlying their development, testing, optimization and validation that enables analytic accessibility on large-scale genomic sequencing projects.

#### Common file formats for Trees

Newick

Nexus

PHYLIP

### Additional model variations and approaches

**Heuristics and Approximations**

+Gamma -> +CAT (rate categorization)
etc

**Hybrids and Combinatorial approaches**

 * [FastTree](http://www.microbesonline.org/fasttree/)

### Summary of Key Points

  * Inferential methods (ML, Bayesian) are statistically consistent.
  * GTR is probably the most popular model
  * At least some form of rate heterogeneity modelling should be employed
  * A number of software suites for phylogenetic estimation include features and tools designed to help with "optimal" model selection for your dataset.

#### Example 1 - Distance based phylogeny 

We can use the [BioNJ algorithm](https://academic.oup.com/mbe/article/14/7/685/1119804?login=true) to create a midpoint rooted, neighbor-joining tree inferred from the Mash distance matrix using a simple Rscript from [bacsort](https://github.com/rrwick/Bacsort). 

```
cd ~/radmicrobes/session4/Files/phylogenetics
Rscript ~/radmicrobes/session4/RScripts/bionj_tree.R kpneumo.mash.phylip kpneumo.mash.tre
```

You can now view `kpneumo.mash.tre` in [Gingr](https://github.com/marbl/gingr), which you should have already downloaded yesterday. 

Use scp from your local terminal to transfer:
```
scp -r -J hpc4@radmicrobes.rice.edu hpc4@nots.rice.edu:/home/hpc4/radmicrobes/session4/Files/phylogenetics/kpneumo.mash.tre .
```

#### Example 2 - Maximum-likelihood Inferred Phylogeny

I'm now going to show how we can use a core genome alignment as input to a maximum likelihood inferred phylogeny. One of my favorite tools is [Gubbins](https://github.com/nickjcroucher/gubbins), which includes multiple ML software tools such as **IQ-TREE 2** and **RAxML-NG**. It uses a sliding window variant detection to look for high snp density regions that are signals of potential high recombination. However, given our small sample size and high divergence, I would not use in this particular case. I would also note that you **cannot use Gubbins for core gene alignments generated from pan-genome tools**. Therefore, going to show an example using IQ-TREE 2 and go over some of the options. Dr. Baptista will go over RAxML-ng in the follow section: 

```
iqtree2 -B 1000 --alrt 1000 -s kpneumo.clean.full.aln
```
Let's go through the output and transfer the `kpneumo.clean.full.aln.contree` to your local computer so we can look through it. 

### Bayesian Analysis to Infer Time-Dated Phylogenies

Bayesian dating, a powerful analytical approach, is employed to estimate the timing of evolutionary events within these phylogenies, providing a temporal dimension to the relationships among bacterial lineages. The process typically involves incorporating molecular clock models, which assume that genetic mutations accumulate at a relatively constant rate over time. By combining sequence data from bacterial genomes with calibration points derived from known time points such as collection dates, Bayesian dating methods use statistical inference to estimate divergence times between species or lineages.

In addition to inferring a phylogeny like we did previously, we introduce a couple additional steps:

 * Molecular Clock Calibration: Introduce calibration points based on external information, such as historical events or fossil records, to anchor the molecular clock and estimate mutation rates.
 * Bayesian Dating Analysis: Employ Bayesian dating methods, such as BEAST (Bayesian Evolutionary Analysis by Sampling Trees), to simultaneously estimate phylogenetic relationships and divergence times while considering uncertainties in the data.
 * Posterior Inference: Obtain a posterior distribution of divergence times, providing a range of likely dates for key evolutionary events.

Tools that are useful for molecular clock analysis are:

  * [BEAST](https://beast.community/)
  * [BactDating](https://github.com/xavierdidelot/BactDating)

We recently performed a BactDating analysis of ST307 *K. pneumoniae* ([Selvaraj Anand *et. al.* Microbial Genomics](https://doi.org/10.1099/mgen.0.001201) to determine how a potential new cluster of ST307 isolates were expanding in Houston, TX. Here is output of root-to-tip distance to measure the correlation between sampling dates and phylogenetic signal:

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/Root-to-tip_test.jpg" width="600" height="450">
<em>(Selvaraj Anand et al., 2024 Microbial Genomics)</em>
</p>

Here is the molecular dated tree of 224 CG307 isolates from different geographic locales with 37 isolates included from our recent study: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session4/Images/BactDating_CG307.png" width="700" height="600">
<em>(Selvaraj Anand et al., 2024 Microbial Genomics)</em>
</p>

### Phylogeny Visualization Tools

There are multiple tools employed for visualizing phylogenies not limited to: 
  - [Gingr](https://github.com/marbl/gingr)
  - [iTOL](https://itol.embl.de/login.cgi)
  - [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)
  - [ggtree](https://bioconductor.org/packages/release/bioc/html/ggtree.html#:~:text='ggtree'%20is%20designed%20for%20visualization,%5Bctb%5D%2C%20Watal%20M.)

Each has advantages and disadvantages, but for our final exercise, I'm going to use `ggtree` to create a simple visual aid of our tree. 

## Tips

* [An applied genomic epidemiological handbook](https://alliblk.github.io/genepi-book/index.html) by Allison Black and Gytis Dudas formerly of the [Bedford lab](https://bedford.io/) is a fantastic overview of genomic epidemiology that heavily inspired the content of this section.
* Good review on bacterial strain typing can be found in this review by [**Simar *et al.*, 2021**](https://journals.lww.com/co-infectiousdiseases/fulltext/2021/08000/techniques_in_bacterial_strain_typing__past,.10.aspx)
* [Bactopia](https://bactopia.github.io/latest/#overview) is a convenient end-to-end Nextflow-based workflow that is very useful for standardized, reproducible results. Bactopia accepts assembly or raw fastq data and provides a whole suite of QC, assembly, and analysis tools.
* [ChatGPT 4o](https://chat.openai.com/) has become an invaluable tool for troubleshooting code and creating simple, boilerplate code. While `ChatGPT` cannot be completely relied upon to code properly, it does provide a nice starting point for working through coding challenges.
* [Stackoverflow](https://stackoverflow.com/) is the original source for finding programming related answers to your questions.
* [Biostars](https://www.biostars.org/) is similar to Stackoverflow, a great resource for answering bioinformatic related questions. 

## License

[GNU General Public License, version 3](https://www.gnu.org/licenses/gpl-3.0.html)
