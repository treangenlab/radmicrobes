# Session 3 - Genomic Epidemiology, Strain-Level Analyses, and Phylogenomics
*by William Shropshire, PhD*

## Table of contents

* [Preparation](#preparation)
* [Genomic Epidemiology](#genomic-epidemiology)
* [Traditional 'OG' Epidemiology](#traditional-og-epidemiology)
  * [Precision Public Health](#precision-public-health)
     * [Case Study 1 - Salmonellosis Outbreak](#case-study-1---salmonellosis-outbreak)
     * [Case Study 2 - Cephalosporin Resistant Escherichia coli Surveillance](#case-study-2---cephalosporin-resistant-escherichia-coli-surveillance)
* [Strain Level Analysis](#strain-level-analysis)
  * [Genotyping - Measures of Genetic Relatedness](#genotyping---measures-of-genetic-relatedness)
  * [Databases and Query-based Tools](#databases-and-query-based-tools)
* [Phylogenetics](#phylogenetics)
  * [Introduction and Terminology](#introduction-and-terminology)  
* [Tips](#tips)
* [License](#license)




## Preparation

If you have not already done so, please download R and RStudio from the following site: [RStudio](https://posit.co/download/rstudio-desktop/). 

As an aside, there are multiple data analysis software that you can choose to perform genomic analyses (*e.g.*, [Python](https://www.python.org/downloads/)). 
Additionally, there are multiple interactive development environments you can choose to work from such as:

 - [PyCharm](https://www.jetbrains.com/pycharm/) 
- [JupyterLab](https://jupyter.org/)

However, for consistency and time's sake, I will be focusing on useful command line interface (CLI) tools in addition to data analysis using R packages, as R typically has what I find useful for genomic epidemiology. Python is wonderful for other data science applications (*e.g.*, prediction modeling), but is beyond the scope of this workshop. 

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

## Strain Level Analysis

### Genotyping - Measures of Genetic Relatedness

This section is going to focus on how genetic relatedness is defined and the tools that we can use to measure genetic relatedness. As alluded to in the previous section, we can achieve increasing levels of resolution to increase probability that we can discern if two or more isolates likely descended from a common recent ancestor: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/Genetic_Relatedness.jpg" width="750" height="450">
<em>(Shropshire et al., 2023 mSphere)</em>
</p>

Multi-locus sequence typing (MLST) is based on a PCR assay that would identify 7-8 single copy, housekeeping genes omnipresent in a particular species. Typically, these schema correlate well with phenotype/serotype of the organism, however, there is certainly less than ideal one-to-one correlations. Core genome MLST consists of identifying a set of genes found in nearly all organisms of a specific taxa whereas whole genome MLST includes accessory genome content which includes the union of all genes found within a particular group. cgMLST and wgMLST schema are very complex and only well curated for a handful of organisms such as *E. coli*. We will now be going through the databases responsible for curating bacterial typing schemes as well as some tools we can use to perform *in silico* typing of bacterial WGS data. 

## Databases and Query-based Tools

### Databases

There are three primary databases for the curation of microbial typing schemes used across the microbinfie (*i.e.*, microbioinformatics) community: 
  
  - [PubMLST](https://pubmlst.org/)
  - [BIGSdb-Pasteur](https://bigsdb.pasteur.fr/)
  - [Enterobase](https://enterobase.warwick.ac.uk/)

Each of these databases curate specific genus/species combinations of taxa with a little overlap. For example, **Enterobase** is the primary repository for *Escherichia coli* typing information, however, **PubMLST** also hosts data from Enterobase. Each of these databases host web interfaces for querying taxa schema, typing assembly input files, as well as performing other analyses. **PubMLST** also provides an [Application Programming Interface](https://bigsdb.readthedocs.io/en/latest/rest.html#db-isolates-search) that allows for scripting in specific queries based on the user's needs. 

### Tools

One of the most simple and user-friendly tools for MLST typing is Torsten Seemann's [mlst tool](https://github.com/tseemann/mlst). The command line parameterization is very simple: 

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



## Phylogenetics

### Introduction and Terminology 

## Tips

* [An applied genomic epidemiological handbook](https://alliblk.github.io/genepi-book/index.html) by Allison Black and Gytis Dudas formerly of the [Bedford lab](https://bedford.io/) is a fantastic overview of genomic epidemiology that heavily inspired the content of this section.
* Good review on bacterial strain typing can be found in this review by [**Simar *et al.*, 2021**](https://journals.lww.com/co-infectiousdiseases/fulltext/2021/08000/techniques_in_bacterial_strain_typing__past,.10.aspx)
* [Bactopia](https://bactopia.github.io/latest/#overview) is a convenient end-to-end Nextflow-based workflow that is very useful for standardized, reproducible results. Bactopia accepts assembly or raw fastq data and provides a whole suite of QC, assembly, and analysis tools. 

## License

[GNU General Public License, version 3](https://www.gnu.org/licenses/gpl-3.0.html)
