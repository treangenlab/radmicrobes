# Session 3 - Genomic Epidemiology, Strain-Level Analyses, and Phylogenomics
*by William Shropshire, PhD*

## Table of contents

  * [Preparation](#preparation)
  * [Genomic Epidemiology](#genomic-epidemiology)
     * [Traditional 'OG' Epidemiology](#traditional-og-epidemiology)
     * [Precision Public Health](#precision-public-health)
      * [Case Study 1 - Salmonellosis Outbreak](#case-study-1-salmonellosis-outbreak)
      * [Case Study 2 - Cephalosporin Resistant Escherichia coli Surveillance](case-study-2-cephalosporin-resistant-escherichia-coli-surveillance)
  * [Strain Level Analysis](#strain-level-analysis)
  * [Phylogenetics](#phylogenetics)
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
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/600px-Snow-cholera-map-1.jpg" width="400" height="300">
<em>(C.F. Cheffins, 1854)</em>
</p>

This led to John Snow being able to convince London authorities to remove the pump handle upon which cholera deaths declined:

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/cholera_deaths_time.jpg" width="400" height="300">
</p>

While John Snow was certainly ahead of his time, had he known that a microorganism called *Vibrio cholerae* was responsible for this life-threatening diarrheal illness and that one could culture it using a nutrient rich medium (*e.g.*, lysogeny broth which hadn't been created yet), he may have been able to more definitively demonstrate that 'fool-air' was not the causative agent for cholera. Furthermore, had John Snow been familiar with serotyping via agglutination of antisera to type specific O-antigens, he may have found an interesting correlation between genotype and phenotype. The first exercise is designed to become familiar with using R and RStudio using [this R Markdown file](https://github.com/treangenlab/radmicrobes/blob/main/session3/Files/3.1_Snow_cholera_example.Rmd) and [this dataset](https://github.com/treangenlab/radmicrobes/blob/main/session3/Files/cholera_fictional_data.csv). We will be using: (1) the package **HistData**, which can be used to load the historical data collected from the 1854 London cholera epidemic; (2) generate epidemiological curves using fictional cholera attack/death data from a two year timeframe.

### Precision Public Health 

The application of genomics to traditional epidemiology has revolutionized how we measure the spread of disease. As next generation sequencing (NGS) has become more affordable in the past two decades, the ability to track high-risk pathogens and respond rapidly has become more evident. NGS data allows for much higher resolution to characterize potential pathogenic causitive agents and better discern signal from noise. 

#### Case Study 1 - Salmonellosis Outbreak

The following example provided by [**Armstrong *et al.***](https://www.nejm.org/doi/full/10.1056/nejmsr1813907) demonstrates how increased resolution of molecular subtyping can improve the capacity for public health officials to pinpoint sources of outbreaks: 

<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/Precision_PH.jpeg" width="600" height="300">
<em>(Armstrong et al., 2019)</em>
</p>

This figure succinctly demonstrates the added value of whole genome sequencing in the detection of a particular outbreak of the foodborne-pathogen *Salmonella enterica* serovar Enteritidis that occurred in a region of the United States in 2018. Panel A represents unsorted cases of gastroenteritis, with each dot representing a singular case, that without proper molecular typing, provides insufficient information as to the source of differential outbreaks. United States public health agencies began to apply pulsed-field gel electrophoresis (PFGE) in the 1990s, with a notable example of successful application being the CDC laboratory network 'PulseNet', which greatly increased capacity to pinpoint related cases through this revolutionary genotyping technique. PFGE involves digesting genomic DNA with restriction enzymes followed by agarose gel separation, which ultimately results in a particular gDNA fragment band pattern that can be used to compare other sample digests to determine if two or more organisms are related. Panel B shows how through PFGE, related cases as represented by red and yellow, cluster together; however, due to limited resolution given band patterns typically consist of a limited number of gDNA fragments, interlaboratory variability in protocols, as well as differential interpretations, 'sporadic', unrelated cases cluster with outbreak cases, which further complicates tracing if incorrect sources are ascertained. Panel C demonstrates how whole genome sequencing (WGS) provided much higher resolution to determine relatedness among cases and gave public health investigators much more confidence as to their outbreak definition. In this example, WGS data allowed state officials for the 'red' cases to identify the correct source, contaminated egg shells, and were able to definitively match the *Salmonella* Entertidis to the contaminated source. 

#### Case Study 2 - Cephalosporin Resistant *Escherichia coli* Surveillance


## License

[GNU General Public License, version 3](https://www.gnu.org/licenses/gpl-3.0.html)
