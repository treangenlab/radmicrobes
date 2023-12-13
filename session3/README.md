# Session 3 - Genomic Epidemiology, Strain-Level Analyses, and Phylogenomics
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
     * [Maximum Parsimony vs. Maximum Likelihood](#maximum-parsimony-vs.-maximum-likelihood)
  * [Inferring Phylogenies Using Maximum-Likelihood](#inferring-phylogenies-using-maximum-likelihood)
     * [IQTREE 2](#iqtree-2)  
  * [Bayesian Analysis to Infer Time-Dated Phylogenies](#bayesian-analysis-to-infer-time-dated-phylogenies)
  * [Phylogeny Visualization Tools](#phylogeny-visualization-tools) 
* [Tips](#tips)
* [License](#license)




## Preparation

If you have not already done so, please download:
  * R and RStudio from the following site: [RStudio](https://posit.co/download/rstudio-desktop/). 
  * Python: [Python](https://www.python.org/downloads/).

This is **NOT** a coding class, so we won't be going over in detail first principles of programming (*i.e.*, coding syntax, structure, etc.); however, background on R/Python will be helpful when we go through some basic code that we will use to execute scripts from a command line interface. 

As an aside, there are multiple data analysis software that you can choose to perform genomic analyses. Additionally, there are multiple interactive development environments you can choose to work from such as:
 - [PyCharm](https://www.jetbrains.com/pycharm/) 
- [JupyterLab](https://jupyter.org/)

If you're just getting started, I suggest testing out multiple platforms to see what feels most intuitive to you in conjunction of what serves your analytical needs the best. That being said, this section of the workshop is going to focus on high level theory in addition to some tools I find useful in my own work. 

## Genomic Epidemiology

### Traditional 'OG' Epidemiology 

John Snow (1813 - 1858), an English physician who pioneered many anesthesia practices in the 19th century, has been ascribed as the founder of traditional epidemiology due to his work studying the London cholera outbreaks that occurred in the mid 19th century. Prior to the widespread acceptance of germ theory that began to take hold in the late 19th century, the conventional wisdom of the time were that many diseases, including cholera, were due to 'foul air' or pollution (*i.e.*, miasma theory). John Snow was able to deduce through classic epidemiogical tracing of cholera death/attack frequency counts that cholera deaths were 14 times higher near the Broad street waterpump compared to other waterpumps that served as water sources throughout London. He documented these deaths using a dotmap, where stacked bars served as a visual tool to indicate higher frequency of deaths in a particular location: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/600px-Snow-cholera-map-1.jpg" width="500" height="400">
<em>(C.F. Cheffins, 1854)</em>
</p>

This led to John Snow being able to convince London authorities to remove the pump handle upon which cholera deaths declined:

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/cholera_deaths_time.jpg" width="600" height="400">
</p>

#### Exercise 1 - Using R

While John Snow was certainly ahead of his time, had he known that a microorganism called *Vibrio cholerae* was responsible for this life-threatening diarrheal illness and that one could culture it using a nutrient rich medium (*e.g.*, lysogeny broth which hadn't been created yet), he may have been able to more definitively demonstrate that 'fool-air' was not the causative agent for cholera. Furthermore, had John Snow been familiar with serotyping via agglutination of antisera to type specific O-antigens, he may have found an interesting correlation between genotype and phenotype. The first exercise is designed to become familiar with using R and RStudio using [this R Markdown file](https://github.com/treangenlab/radmicrobes/blob/main/session3/Files/3.1_Snow_cholera_example.Rmd) and [this dataset](https://github.com/treangenlab/radmicrobes/blob/main/session3/Files/cholera_fictional_data.csv). We will be using: (1) the package **HistData**, which can be used to load the historical data collected from the 1854 London cholera epidemic; (2) generate epidemiological curves using fictional cholera attack/death data from a two year timeframe.

### Precision Public Health 

The application of genomics to traditional epidemiology has revolutionized how we measure the spread of disease. As next generation sequencing (NGS) has become more affordable in the past two decades, the ability to track high-risk pathogens and respond rapidly has become more evident. NGS data allows for much higher resolution to characterize potential pathogenic causitive agents and better discern signal from noise. 

#### Case Study 1 - Salmonellosis Outbreak

The following example provided by [**Armstrong *et al.*, 2019**](https://www.nejm.org/doi/full/10.1056/nejmsr1813907) demonstrates how increased resolution of molecular subtyping can improve the capacity for public health officials to pinpoint sources of outbreaks: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/Precision_PH.jpg" width="600" height="300">
<em>(Adapted from Armstrong et al., 2019 NEJM)</em>
</p>

This figure succinctly demonstrates the added value of whole genome sequencing in the detection of a particular outbreak of the foodborne-pathogen *Salmonella enterica* serovar Enteritidis that occurred in a region of the United States in 2018. Panel A represents unsorted cases of gastroenteritis, with each dot representing a singular case, that without proper molecular typing, provides insufficient information as to the source of differential outbreaks. United States public health agencies began to apply pulsed-field gel electrophoresis (PFGE) in the 1990s, with a notable example of successful application being the CDC laboratory network 'PulseNet', which greatly increased capacity to pinpoint related cases through this revolutionary genotyping technique. PFGE involves digesting genomic DNA with restriction enzymes followed by agarose gel separation, which ultimately results in a particular gDNA fragment band pattern that can be used to compare other sample digests to determine if two or more organisms are related. Panel B shows how through PFGE, related cases as represented by red and yellow, cluster together; however, due to limited resolution given band patterns typically consist of a limited number of gDNA fragments, interlaboratory variability in protocols, as well as differential interpretations, 'sporadic', unrelated cases cluster with outbreak cases, which further complicates tracing if incorrect sources are ascertained. Panel C demonstrates how whole genome sequencing (WGS) provided much higher resolution to determine relatedness among cases and gave public health investigators much more confidence as to their outbreak definition. In this example, WGS data allowed state officials for the 'red' cases to identify the correct source, contaminated egg shells, and were able to definitively match the *Salmonella* Entertidis to the contaminated source. 

#### Case Study 2 - Cephalosporin Resistant *Escherichia coli* Surveillance

The next example comes from [**Shropshire *et al.*, 2023**](https://journals.asm.org/doi/full/10.1128/msphere.00183-23?rfr_dat=cr_pub++0pubmed&url_ver=Z39.88-2003&rfr_id=ori%3Arid%3Acrossref.org) demonstrating how retrospective sampling and whole genome sequencing data can provide additional context to infectious disease surveillance. The first figure shows an approximate 5-year study timeframe in which we measured the prevalence of first occurrence *Escherichia coli* bacteremia cases stratified by their susceptibility pattern to the class of beta-lactam antibiotics known as cephalosporins:

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/BSI_Ec_trends.jpg" width="650" height="400">
<em>(Shropshire et al., 2023 mSphere)</em>
</p>

Where ESC-S = extended-spectrum cephalosporin susceptible, ESC-R = extended spectrum cephalosporin resistant, and total represents total bloodstream infections (BSIs). Each dot represents monthly BSI prevalence estimates stratified by susceptibility profile and each line represents a loess curve representing the smoothed average of each respective prevalence estimate over time. We were able to sequence 64% (248/349) ESC-R *E. coli* isolates to gather a more complete picture of how the population structure of bacteremia isolates causing cephalosporin resistance were changing over time:

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/ST_Phylo_temporal_trends.jpg" width="600" height="550">
<em>(Shropshire et al., 2023 mSphere)</em>
</p>

Panels A and B show proportion and absolute frequency for isolates sequenced over time by phylogroup, a molecular typing based on a quadraplex PCR schema whereas panels C and D show proportion and absolute frequency for multi-locus sequence typing (MLST), which is based on a PCR schema that includes typically 7-8 housekeeping genes and provides additional resolution. Are there any patterns that you observe from both figures?

## Strain-Level Analysis

### Genotyping - Measures of Genetic Relatedness

As alluded to in the previous section, we can achieve increasing levels of genetic resolution to increase probability that we can discern if two or more isolates likely descended from a common recent ancestor: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/Genetic_Relatedness.jpg" width="750" height="450">
<em>(Shropshire et al., 2023 mSphere)</em>
</p>

Multi-locus sequence typing (MLST) is based on a PCR assay that would identify 7-8 single copy, housekeeping genes omnipresent in a particular species. Typically, these schema correlate well with phenotype/serotype of the organism, however, there is certainly less than ideal one-to-one correlations. Core genome MLST consists of identifying a set of genes found in nearly all organisms of a specific taxa whereas whole genome MLST includes accessory genome content which includes the union of all genes found within a particular group. cgMLST and wgMLST schema are very complex and only well curated for a handful of organisms such as *E. coli*. We will now be going through the databases responsible for curating bacterial typing schemes as well as some tools we can use to perform *in silico* typing of bacterial WGS data. 

### Databases

There are three primary databases for the curation of microbial typing schemes used across the microbinfie (*i.e.*, microbioinformatics) community: 
  
  - [PubMLST](https://pubmlst.org/)
  - [BIGSdb-Pasteur](https://bigsdb.pasteur.fr/)
  - [Enterobase](https://enterobase.warwick.ac.uk/)

Each of these databases curate specific genus/species combinations of taxa with a little overlap. For example, **Enterobase** is the primary repository for *Escherichia coli* typing information, however, **PubMLST** also hosts data from Enterobase. The underlying software that is used for both **PubMLST** and **BIGSdb-Pasteur** is the [Bacterial Isolate Genome Sequence database (BIGSdb)](https://pubmlst.org/software/bigsdb). Each of these databases host web interfaces for querying taxa schema, typing assembly input files, as well as performing other analyses. **PubMLST** also provides an [Application Programming Interface](https://bigsdb.readthedocs.io/en/latest/rest.html#db-isolates-search) that allows for scripting in specific queries based on the user's needs. We will use three examples to demonstrate the powerful utility of these databases using the PubMLST RESTful API tool. I also want to briefly go into each script to see if we can determine how the code works. 

#### Example 1 - Species identification

A colleague has sent you a fasta file letting you know that he believes that he has a bacterial assembly, but has no idea as to what it is. While you are curious as to why the colleague doesn't know what bacterial species it is, you say no problem, Dr. Keith Jolley has created a very simple python script that queries fasta assemblies against the ribosomal Multilocus Sequence Type (rMLST) database through the PubMLST RESTful API using the ```curl``` command.

```
cd ./session3/Scripts
python3 ./species_api_upload.py -f ./../Files/assemblies/ARLG-3180_consensus_assembly.fasta.fna
```

If we want to loop through two or more assemblies, we can use a ```for``` loop structure: 

```
for file in $(cat ./../Files/lists/assembly_subset.tsv);do echo $file; python ./species_api_upload.py -f ./../Files/assemblies/${file}_consensus_assembly.fasta;done
```

Given that said colleague is Dr. Hanson, who had told us previously that we were working on *K. pneumoniae* and he just had a momentary lapse recalling what project we were working with during this workshop 😉 (Dr. Hanson is *very* busy), we are happy to see that these isolates belong to the *K. pneumoniae* taxa. 

#### Example 2 - Multilocus sequence typing

Now that you have successfully identified these isolates as *K. pneumoniae*, you want to quickly check what sequence type these isolates belong to using their assembly files. As mentioned before, *in silico* multilocus sequence typing (MLST) is based on a simple PCR assay where you target 7-8 single copy housekeeping genes within a bacterial chromosome that is typically species specific. Many schema are available in the aforementioned databases. Fortunately, with some simple understanding of the key:value dictionary structure of the [JSON file format](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON), we can modify Dr. Keith Jolley's Python script to do ```curl``` API calls using the *K. pneumoniae* MLST schema:

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
mlst-download_pub_mlst -d /opt/homebrew/Caskroom/miniforge/base/envs/radgenomics/db/pubmlst -j 2
```

For a quick example, we are going to use ARLG-3179 and ARLG-3180 assemblies as input for the mlst command using another `for loop` structure. I'm also going to use **wildcard** notation, specifically `*` to have any matching number, string, or special character match following the assigned `for loop` variable up to **.fasta**. 

```
cd ./session3/Files
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
cd ./session3/Files
for file in $(cat ./lists/assembly_subset.tsv);do amrfinder -p ./prokka_dirs/${file}*_dir/${file}*.faa -g ./prokka_dirs/${file}*_dir/${file}*.gff -n ./prokka_dirs/${file}*_dir/${file}*.fna -a prokka --plus -O Klebsiella_pneumoniae --threads 2 -o ./results/${file}_AMRFinderPlus.tsv;done

head ./results/*_AMRFinderPlus.tsv
```

Let's go through the output to see what we can deduce from these two organisms. 

#### Kleborate

There are many *ad hoc* tools available to do analysis on your favorite organism of interest. [Kleborate](https://github.com/klebgenomics/Kleborate) has become a 'go-to' resource for *Klebsiella* genomics. Developed by the [Kat Holt lab](https://holtlab.net/), this python-based tool provides a wealth of information in addition to what AMRFinderPlus outputs, including assembly quality control (QC), MLST, AMR and virulence composite scores, and 'K' and 'O'-locus serotyping prediction using [Kaptive](https://github.com/klebgenomics/Kaptive). Let's run `kleborate-v2.3.2` with the `--all` parameter, which includes both resistance and serotyping prediction:

```
cd ./../Files
for file in $(cat ./lists/assembly_list.tsv);do kleborate --all -a ./assemblies/${file}*dir/*${file}*.fna -o ./results/${file}_kleborate.tsv;done
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

One of the last concepts I want to bring up before jumping into phylogenetics is how we measure genetic distances across populations. There are many ways we can estimate genetic distance based on a comparison of genetic relatedness inferred from an alignment or amongst two or more samples. Yesterday, we discussed variant calling against a reference. Estimating distance based on variant calls is perhaps the most powerful means to compare multiple sequences to then infer genetic distance. I want to close this section by going over some genetic distance heuristics, that are very helpful in estimating relatedness within a population in a computationally short amount of time with very low computational resources required. 

#### Mash



#### Snippy 

## Phylogenetics

### Introduction and Terminology 

#### Dissecting a Tree

#### Maximum Parsimony vs. Maximum Likelihood

### Inferring Phylogenies Using Maximum-Likelihood

#### IQ-TREE 2

### Bayesian Analysis to Infer Time-Dated Phylogenies

### Phylogeny Visualization Tools

## Tips

* [An applied genomic epidemiological handbook](https://alliblk.github.io/genepi-book/index.html) by Allison Black and Gytis Dudas formerly of the [Bedford lab](https://bedford.io/) is a fantastic overview of genomic epidemiology that heavily inspired the content of this section.
* Good review on bacterial strain typing can be found in this review by [**Simar *et al.*, 2021**](https://journals.lww.com/co-infectiousdiseases/fulltext/2021/08000/techniques_in_bacterial_strain_typing__past,.10.aspx)
* [Bactopia](https://bactopia.github.io/latest/#overview) is a convenient end-to-end Nextflow-based workflow that is very useful for standardized, reproducible results. Bactopia accepts assembly or raw fastq data and provides a whole suite of QC, assembly, and analysis tools.
* [ChatGPT 3.5](https://chat.openai.com/) has become an invaluable tool for troubleshooting code and creating simple, boilerplate code. While `ChatGPT` cannot be completely relied upon to code properly, it does provide a nice starting point for working through coding challenges.
* [Stackoverflow](https://stackoverflow.com/) is the original source for finding programming related answers to your questions.
* [Biostars](https://www.biostars.org/) is similar to Stackoverflow, a great resource for answering bioinformatic related questions. 

## License

[GNU General Public License, version 3](https://www.gnu.org/licenses/gpl-3.0.html)
