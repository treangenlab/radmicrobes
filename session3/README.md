# Session 3 - Genomic Epidemiology, Strain-Level Analyses, and Phylogenomics
*by William Shropshire, PhD*

<details>
 <summary>
  
  ## Session Summary</summary>
 <p></p>
 
  * Genomic Epidemiology
   
    * History
    
      * London Cholera Epidemic of 1850s
      
        * RStudio example
  
  * Strain-level Analyses
  
  * Phylogenomics

</details>

## Preparation

If you have not already done so, please download R and RStudio from the following site: [RStudio](https://posit.co/download/rstudio-desktop/). 

As an aside, there are multiple data analysis software that you can choose to perform genomic analyses (*e.g.*, [Python](https://www.python.org/downloads/)). 
Additionally, there are multiple interactive development environments you can choose to work from such as:

 - [PyCharm](https://www.jetbrains.com/pycharm/) 
- [JupyterLab](https://jupyter.org/)

However, for consistency and time's sake, I will be focusing on useful command line interface (CLI) tools in addition to data analysis using R packages, as R typically has what I find useful for genomic epidemiology. Python is wonderful for other data science applications (*e.g.*, prediction modeling), but is beyond the scope of this workshop. 

## Genomic Epidemiology
John Snow (1813 - 1858), an English physician who pioneered many anesthesia practices in the 19th century, has been ascribed as the founder of traditional epidemiology due to his work studying the London cholera outbreaks that occurred in the mid 19th century. Prior to the widespread acceptance of germ theory that began to take hold in the late 19th century, the conventional wisdom of the time were that many diseases, including cholera, were due to 'foul air' or pollution (*i.e.*, miasma theory). John Snow was able to deduce through classic epidemiogical tracing of cholera death/attack frequency counts that cholera deaths were 14 times higher near the Broad street waterpump compared to other waterpumps that served as water sources throughout London. He documented these deaths using a dotmap, where stacked bars served as a visual tool to indicate higher frequency of deaths in a particular location: 
<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/600px-Snow-cholera-map-1.jpg" width="400" height="300">
<em>(C.F. Cheffins, 1854)</em>
</p>

This led to John Snow being able to convince London authorities to remove the pump handle upon which cholera deaths declined:
<p align="center">
<img src="https://github.com/treangenlab/radmicrobes/blob/main/session3/Images/cholera_deaths_time.jpg" width="400" height="300">
</p>

While John Snow was certainly ahead of his time, had he known that a microorganism called *Vibrio cholerae* was responsible for this life-threatening diarrheal illness and that one could culture it using a nutrient rich medium (*e.g.*, lysogeny broth which hadn't been created yet), he may have been able to more definitively demonstrate that 'fool-air' was not the causative agent for cholera. Furthermore, had John Snow been familiar with serotyping via agglutination of antisera to type specific O-antigens, he may have found an interesting correlation between genotype and phenotype. The first exercise is designed to get users familiar with using R and RStudio using: (1) the package **HistData**, which can be used to load the historical data collected from the 1854 London cholera epidemic; (2) generate epidemiological curves using fictional cholera attack/death data from a two year timeframe.

