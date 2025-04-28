# RAD microbes
2025 RAD microbes boot camp

DATES: April 28th and 29th, 2025
LOCATION: Room 280, BRC (https://brc.rice.edu/) 

AGENDA: click [here](https://github.com/treangenlab/radmicrobes/blob/main/agenda.md)

SUMMARY: Computational analyses of microbial genomes through genomic sequencing hold tremendous promise yet can become riddled with various sources of potential bias. The microbial genome analysis workshop is designed for graduate students, postdoctoral fellows, and investigators from diverse backgrounds and interests for clarity on how to effectively utilize ubiquitous computational pipelines for answering specific research questions. This hands-on workshop will cover end-to-end microbial genome analysis, discussing the pros and cons of decisions made during the process (library preparation, sequencing, bioinformatic tool selection, parameter settings, and interpretation of results).

TOPICS: Short and long-read sequencing, amplicon and isolate genome sequence, genome assembly and validation, functional annotation, phylogenomic analysis, and strain typing. This workshop will be taught by scientists with expertise in bioinformatics and analysis of clinical samples, allowing participants to get individualized training on how to accurately sample, sequence, and characterize microbial genomes.

# RAD Microbes Boot Camp Cheat Sheet

| Session | Topics Covered | Key Tools/Concepts | Tips |
|:-------:|:---------------|:------------------|:----|
| **[Session 1: Sampling, Sequencing, Quality Assessment and Control, and Assembly](https://github.com/treangenlab/radmicrobes/tree/main/session1)** | - Introduction to Unix Shell<br>- Sampling and study design<br>- Sequencing technologies (short and long reads)<br>- Sequencing quality assessment and control | - Unix shell<br>- Sequencing platforms (Illumina, ONT, PacBio)<br>- QC tools: FastQC, Raspberry | - Learn basic Unix commands before venturing too far.<br>- Choose sequencing tech to match goals!<br>- Always QC your raw reads! |
| **[Session 2: Microbial Reference Genomes, Variant Calling, and Multiple Genome Alignment](https://github.com/treangenlab/radmicrobes/tree/main/session2)** | - Strain-level analyses<br>- Core and whole-genome alignment<br>- Visualization of genome variation | - Parsnp, Mauve, SibeliaZ<br>- Gingr (visualization) | - Check assembly quality first.<br>- Visualize to spot genome rearrangements.<br>- Use the right aligner for genome size/number. |
| **[Session 3: Genomic Alignment and Variant Discovery Workshop](https://github.com/treangenlab/radmicrobes/tree/main/session3)** | - Align reads to reference<br>- Bacterial variant discovery | - Short/long-read data<br>- Variant calling pipelines | - Preprocess reads (QC+trim).<br>- Pick the best reference genome.<br>- Validate variants if possible! |
| **[Session 4: Genomic Epidemiology, Strain-Level Analyses, and Phylogenomics](https://github.com/treangenlab/radmicrobes/tree/main/session4)** | - Public health genomics<br>- Genotyping and strain typing<br>- Building phylogenetic trees | - MLST, AMRFinderPlus, Kleborate<br>- Mash, Snippy<br>- RAxML, IQ-TREE | - Integrate genomic + metadata.<br>- Confirm results with multiple tools.<br>- Interpret trees carefully! |
| **[Session 5: Functional Annotation and Pan Genomes](https://github.com/treangenlab/radmicrobes/tree/main/session5)** | - Genome annotation (prokaryotes/eukaryotes)<br>- Functional analysis<br>- Pan-genome analysis | - Prokka, AUGUSTUS, BRAKER<br>- InterProScan, Roary, ITOL | - Customize annotation pipelines.<br>- Use broad databases for annotation.<br>- Visualize pan-genomes for insight! |

---

🔹 **Pro Tip**: Always record software versions and key parameters!  

# RAD Microbes Instructors and TAs

## RAD Instructors
### Session 1
#### Dr. Blake Hanson, MS, PhD

<img width="200" alt="image" src="https://github.com/treangenlab/radmicrobes/assets/28576450/0aabd7fe-8836-4422-8f4e-bc335d661f87">

I am trained as an epidemiologist and have extensive experience in applying advanced genomic technologies and big-data analytical methods to investigate infectious diseases of public health importance. I am also an Assistant Professor in the Department of Internal Medicine, Division of Infectious Diseases, within the McGovern School of Medicine, and serve as the Associate Director for Microbial Genomics in the Center for Antimicrobial Resistance and Microbial Genomics (CARMiG). My laboratory uses a combination of existing and innovative laboratory techniques, and cutting-edge sequencing and bioinformatics to study infectious disease transmission and colonization, how microbial communities impact the development of disease, and how antimicrobial resistance develops and transmits through society. Current projects include: elucidating the importance of acquired antimicrobial resistance genes and mobile genetic elements in clinical outcomes, such as patient mortality and response to treatment, in Staphylococcus aureus causing bacteremia, co-circulating strains of carbapenem resistant Enterobacteriaceae (CRE), and vancomycin resistant enterococci (VRE); and interrogating the role of the microbiome in implanted medical device-associated infections, with a specific focus on breast implants placed following mastectomy due to cancer.

### Session 2

#### Rossie Luo

Rossie: add description + photo

#### Michael Nute, PhD

<img width="200" alt="image" src="https://github.com/treangenlab/radmicrobes/assets/761469/32dbac1b-04f5-49da-97fa-c33e728b5f2f">

Mike is a Research Scientist at Rice University in Todd Treangen's lab and has been working on Microbial bioinformatics since 2015. He did his Ph.D. in Statistics at UIUC under Tandy Warnow, where he worked on algorithms for phylogenetics and multiple sequence alignment with a particular emphasis on applications to microbes. He was co-advised by Rebecca Stumpf researching the microbiome of non-human primates. After finishing in 2019, he patiently waited for a global pandemic to take hold in order to find a postdoc that could be done remotely, which he found in 2020 with the Treangen Lab. 


#### Dr. Todd Treangen, PhD

<img width="200" alt="image" src="https://github.com/treangenlab/radmicrobes/assets/28576450/892207aa-f0e5-4299-8989-e03429ce5baf">

Todd Treangen is a Associate Professor in the Computer Science department at Rice University. His primary research interests lie at the intersection of computer science and genomics, and his research group is focused on the development of novel computational methods and software tools with relevance to real-time monitoring of microbial community dynamics, infectious disease, and biothreats. Given the computational challenges presented by the metagenomic data deluge, coupled with the time-sensitive nature of problems specific to tracking pandemics and synthetic DNA screening, the Treangen lab strives to develop efficient and accurate computational solutions to emerging problems in these fields. Specifically, his research group focuses on the design, development, and implementation of novel algorithms, heuristics, and data structures to solve emerging computational research questions specific to biosecurity, infectious disease monitoring, and host-associated microbiome characterization. The Treangen lab is also dedicated to the dissemination and development of novel open-source bioinformatics methods, software, and pipelines.

### Session 3

#### Daniel Paiva Agustinho, PhD

<img width="200" alt="image" src="https://github.com/treangenlab/radmicrobes/assets/72709799/6ed66db5-0b81-4a29-984d-2ed9d39e7b4e)">

Daniel is a Assistant professor at Baylor College of Medicine with over 13 years of dedicated research focusing on human pathogens and host interactions. His journey from wet lab biology to bioinformatics commenced during his PhD, where he analyzed gene expression in host-pathogen interactions. His contributions to microbiology and immunology shed light on complex molecular relationships. As a postdoctoral researcher, Daniel deepened his exploration into host-pathogen interactions, investigating pathogen-triggered immune responses. Transitioning to Baylor College of Medicine, he leads comprehensive metagenomic analyses, specializing in viral evolution studies. His work includes a review article on metagenomics' utility in infectious diseases, and he spearheads the development of pipelines for pathogen detection in clinical samples. Daniel's interdisciplinary approach has significantly advanced our understanding of infectious diseases.

### Session 4
#### Dr. Will Shropshire, PhD

<img width="200" alt="image" src="https://github.com/treangenlab/radmicrobes/assets/28576450/62d34750-c510-4993-9220-ee3b5de6cd37">

William Shropshire is an Instructor, research faculty at the University of Texas MD Anderson Cancer Center within the Department of Infectious Diseases, Infection Control, and Employee Health. He is a previous Gulf Coast Consortia/Keck Center’s Texas Medical Center Training Program in Antimicrobial Resistance (NIAID Grant No. T32 AI141349-05) T32 Postdoctoral Fellow. During the past seven years, Dr. Shropshire has developed a strong skillset in computational biology and microbiology with the focus of his work translating genomic data into clinically impactful results. His pre- and post-doctoral work has spanned a broad spectrum of topics, ranging from the molecular mechanisms of antimicrobial resistance to the genomic epidemiology of infectious disease outbreaks. The focus of his previous T32 work was to elucidate genomic and transcriptomic factors that contribute to the progressive development of carbapenem resistance within *Escherichia coli* causing invasive infections. Over the past four years, his research has documented the significant clinical impact of extended-spectrum beta-lactamase (ESBL) positive Enterobacterales and how ESBL encoding genes can amplify via mobile genetic elements upon initial exposures to beta-lactam drugs. There is increasing evidence that these beta-lactamase gene encoding amplifications can lead to heteroresistant populations, wherein only a subset of a bacterial population remains non-susceptible to treatment. He recently submitted a K01 application in which he proposes to investigate clinical and microbiological factors contributing to recurrent, racalcitrant Enterobacterales infections, including characterizing how AMR survival srategies such as heteroresistance and tolerance contribute to recurrence. His research work can be summarized [here](https://www.researchgate.net/profile/William-Shropshire).

#### An Dinh

<img width="200" alt="image" src="https://github.com/treangenlab/radmicrobes/assets/153662215/e8e5f279-6442-4dc5-939a-9a407a6ec0fa">

An Dinh is a second year PhD student of epidemiology under Dr. Blake Hanson in the Center of Infectious Disease at the UTHealth School of Public Health.  For the past 9 years, he has worked with both short- and long- read sequencing technologies, producing data for large-scale genomic epidemiology studies of antimicrobial resistant pathogens.  His work experience includes laboratory automation, protocol development and optimization, high-throughput data processing, as well as more narrowly-focused small-scale projects. Studies have ranged from transcriptomics, metagenomics, and exploring the use of rapid sequencing of clinical samples for pathogen diagnoses and personalized medicine.  His interests include pushing new technologies and techniques to improve data resolution for AMR surveillance, optimizations of analyses pipelines for microbial genomics, and continuing to test and validate the utility of microbial sequencing in clinical spaces.

### Session 5
#### Dr. Rodrigo de Paula Baptista, PhD 

<img width="200" alt="image" src="https://github.com/treangenlab/radmicrobes/assets/28576450/5c815f66-0d01-4bab-87db-800f9b7a8ba3"> 

Rodrigo Baptista is a researcher with over a decade of expertise in eukaryotic pathogens and bioinformatics. His extensive experience includes a notable focus on parasite genomic data, particularly in the realms of Trypanosomatids and Apicomplexan parasites. Over the last few years, Baptista has cultivated specific proficiency in evolutionary genomics and the analysis of highly repetitive genomes and transcriptomes. His skill set encompasses tasks ranging from assembly and annotation to variant calling, and the identification and characterization of duplications and repetitive elements within these genomes. He has contributed significantly to the field by assembling and annotating numerous protozoan parasite genomes using various sequencing platforms, such as paired-end Illumina, Ion-Torrent short reads, PacBio, and Oxford Nanopore long-reads. These efforts have resulted in published data accessible to the scientific community. As a bioinformatician, he has established collaborations with research groups worldwide, working across diverse areas including protozoan parasites, prokaryotes, and vectors. Currently, at the Houston Methodist Research Institute, he leads the genomics enterprise within the Center for Infectious Diseases, focusing on employing genomics to characterize antibiotic resistance in clinical bacterial infections and eukaryotic pathogens. The primary goal is to mitigate the emergence and spread of resistant pathogens induced by treatment interventions.

## RAD TAs

### Ryan Doughty

<img width="200" alt="image" src="https://github.com/user-attachments/assets/74c28d0c-7a9d-4e65-a584-8a1231866c51">

Ryan Doughty is a first year PhD student at Rice University in the Department of Computer Science supervised by Dr. Todd Treangen. He is also a predoctoral fellow in the NLM Training Program in Biomedical Informatics and Data Science, with a secondary mentor Dr. Michael Tisza at Baylor College of Medicine. His research focuses on methods for the detection of viruses from metagenomic sequencing data, as well as pathogenicity prediction of viral and microbial species. Previously he obtained his BS in Computer Science from Case Western Reserve University. During his undergraduate studies, he worked with Dr. Treangen on large-scale wastewater analyses and targeted metagenomic sequencing methods. He also spent six months in Vigo, Spain, working in Dr. David Posada’s lab, focusing on gut-virome biomarkers in colorectal cancer. Additionally, he interned at Intellia Therapeutics for a summer, where he contributed to developing machine learning methods for CRISPR Cas-9 guide design.

### Eddy Huang

Fixme: Add description and photo

### Natalie Kokroko  

<img width="200" alt="image" src="https://github.com/user-attachments/assets/0bdc3db7-3bf5-4c43-b41c-115d7281df9f">

Natalie Kokroko is a second year PhD student at Rice University in the Computer Science program. Her background is in Biomedical Engineering. Natalie worked in a research Institute at the University of Ghana (West African Centre for cell Biology of Infectious Pathogens) where she mainly did research and bioinformatics data analysis for the genomics and infectious disease laboratory. As a member of the Treangen lab, her research interest is to make use of computational tools and algorithms to interpret and analyze clinical and environmental microbiome data. Generally, Natalie is interested in Computational Biology, Bioinformatics, Genomics and Metagenomic data analysis. Her future goal is to be in academia and impart the knowledge and skills gained from her PhD to the next generation of scientists. 

### Hossaena Ayele

<img width="200" alt="image" src="https://github.com/user-attachments/files/19933064/Ayele_Hossaena_headshot.pdf">

Hossaena Ayele is a Graduate Research Assistant (GRA) and a 4th year PhD candidate in Dr. Blake Hanson's lab at the School of Public Health and Center for Infectious Diseases at the University of Texas at Houston, co-mentored by Dr. Cesar Arias at Houston Methodist Research Institute. Hossaena received her Bachelor of Science in Microbiology and Master of Science in Medical Microbiology from the University of Manitoba in Winnipeg, Manitoba, Canada. Hossaena's past research experience has consisted of examining host and microbial proteomic changes with contraceptive use in a population at high risk of HIV infection. She is currently at UTHealth studying to receive her PhD in Epidemiology. As a GRA, Hossaena has had the incredible opportunity to work on multiple projects in Dr. Hanson's lab. These projects have revolved around understanding specific microbial mechanisms involved in health and disease within the context of the microbiome. She has also participated in developing methods to analyze microbial omics data to aid in the surveillance and understanding of the molecular epidemiology of anti-microbial resistant bacterial strains.

