# Session 3 - Genomic Alignment and Variant Discovery Workshop
by: Daniel Paiva Agustinho, PhD

## Workshop Overview
This 2-2.5 hour hands-on workshop covers the fundamentals of genomic alignment and variant discovery using bacterial genome data (*Klebsiella pneumoniae*). We'll work with both short-read (Illumina) and long-read (Oxford Nanopore) sequencing data.

**Prerequisites:**
- (Very) Basic command line knowledge
- Familiarity with basic genomic concepts

**Data preparation:**
For this analysis, we are working with a single sample, sequenced in two different platforms: Illumina and ONT.
```bash
# Copying the reads that we need to our folder.
mkdir -p reads
cp /storage/hpc/work/k2i/data/ILLUMINA/ARLG-10777_SRR13320501_?.fastq.gz reads/
cp /storage/hpc/work/k2i/data/OXFORD_NANOPORE/ARLG-10777_SRR13289912.fastq.gz reads/

# Changing the file names
mv reads/ARLG-10777_SRR13320501_1.fastq.gz reads/illumina_R1.fastq.gz
mv reads/ARLG-10777_SRR13320501_2.fastq.gz reads/illumina_R2.fastq.gz
mv reads/ARLG-10777_SRR13289912.fastq.gz reads/ONT.fastq.gz

# Downloading the reference genome
## Create and change to the reference directory.
mkdir reference
cd reference

## Download the fasta and decompress it.
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/009/885/GCF_000009885.1_ASM988v1/GCF_000009885.1_ASM988v1_genomic.fna.gz
gunzip GCF_000009885.1_ASM988v1_genomic.fna.gz

## Download the genome annotation (gff file) and decompress it
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/009/885/GCF_000009885.1_ASM988v1/GCF_000009885.1_ASM988v1_genomic.gff.gz
gunzip GCF_000009885.1_ASM988v1_genomic.gff.gz

```

**Environment preparation**
```bash
# Requesting an interactive session
srun --partition=commons --reservation=workshop --mem=16G --ntasks=1 --cpus-per-task=8 --export=ALL --time=04:00:00 --pty bash -i

# Loading the mamba module
module load Mamba/23.11.0-0

# Activating our first work environment
mamba activate /home/hpc9/.conda/envs/session3_clair

#If you get an error, you might have to run this first:
## mamba init
## source ~/.bashrc
```


---

## 1. Introduction to Genomic Alignment and Variant Discovery

### What is Genomic Alignment?

Genomic alignment is the process of mapping sequenced DNA fragments (reads) to a reference genome. Think of it like solving a jigsaw puzzle where the reference genome is the picture on the box, and your sequencing reads are the pieces.

The alignment process addresses questions like:
- Where in the genome did this DNA fragment come from?
- How similar is my sample to the reference?
- Which regions differ from the reference?

### Types of Genomic Variants

When comparing a sample to a reference genome, we look for several types of differences:

**Single Nucleotide Variants (SNVs)**
- Single base changes (A→G, C→T, etc.)
- Most common type of variant
- Can cause amino acid changes or affect regulatory regions
- Example: A mutation changing ATG to ACG in a gene

**Small Insertions/Deletions (Indels)**
- Small segments added or removed (typically <50bp)
- Can cause frameshift mutations in coding regions
- More challenging to detect than SNVs
- Example: A 4bp deletion removing GATC from a sequence

**Structural Variants (SVs)**
- Large genomic alterations (typically >50bp)
- Types include:
  - Copy Number Variations (CNVs): Duplications or deletions of segments
  - Inversions: Segments flipped in orientation
  - Translocations: Segments moved to different locations
  - Large insertions/deletions: Substantial sequence changes
- Often associated with disease and bacterial evolution
- Example: A 10kb segment duplicated, potentially containing resistance genes

### The Critical Role of Reference Genomes

Reference genomes serve as the foundation for alignment and variant discovery:

**What is a reference genome?**
- A representative genome assembly for a species or strain
- Provides coordinates for genomic features
- Serves as the baseline for comparison

**Reference considerations for bacteria:**
- Strain-specific references are crucial due to the enormous genomic diversity
- For *K. pneumoniae*, different strains can vary by >5% of their genome
- The choice of reference affects what variants you can detect
- The reference strain NTUH-K2044 (common *K. pneumoniae* reference) has ~5.2Mb genome

**Reference quality impacts:**
- Completeness: Missing regions in the reference = missing potential variants
- Accuracy: Errors in reference = false variant calls
- Annotation: Good annotation helps interpret variant impact

**Key concept**: The reference you choose introduces biases in your analysis. For bacteria, choosing a closely related reference strain is often better than using a distant type strain.

Here we will use the reference genome NTUH-K2044 for *Klebsiella pneumoniae*. For more information, you can check their specific RefSeq page:
`https://www.ncbi.nlm.nih.gov/nuccore/NC_012731.1`

For the reference, we want to obtain 2 different files. A fasta file with the genomic reference, and an annotation file (gff3, in this case).


### Understanding GFF3 Files in Genome Annotation

GFF3 (General Feature Format version 3) is a standard file format used for describing genomic features. Looking at your sample from the *Klebsiella pneumoniae* genome (strain NTUH-K2044), here's what the different components mean:

#### GFF3 File Structure

- **Header lines** start with `##` and contain metadata about the file and genome
- **Feature lines** contain tab-delimited fields describing genomic elements

#### Key Header Information
- File format version: `##gff-version 3`
- Genome build: `ASM988v1`
- Annotation date: June 16, 2024
- Source: NCBI RefSeq
- Genome sequence: NC_012731.1 (5,248,520 bp circular chromosome)
- Organism: *Klebsiella pneumoniae* (taxon ID: 484021)

#### Feature Line Format
Each feature line has 9 columns:
1. **Sequence ID** - The chromosome/contig (NC_012731.1)
2. **Source** - Annotation source (RefSeq or Protein Homology)
3. **Feature type** - Feature category (region, gene, CDS)
4. **Start position** - 1-based coordinate
5. **End position** - Inclusive end coordinate
6. **Score** - Often not used (.)
7. **Strand** - '+' (forward) or '-' (reverse)
8. **Phase** - Reading frame for CDS features (0, 1, 2, or .)
9. **Attributes** - Semi-colon separated tag=value pairs with feature metadata

#### Example Features
- **Chromosome region**: The entire chromosome (positions 1-5,248,520)
- **Genes**: Like *mioC* and *asnC* with their coordinates and orientation
- **CDS (Coding Sequences)**: Protein-coding regions with product descriptions and database cross-references
  
The file contains hierarchical relationships where genes are parents of CDS features, indicated by the Parent attribute.

---

## 2. Sequencing Technologies and Data Types

### Short-Read Sequencing (Illumina)

**Technology basics:**
- Sequencing-by-synthesis approach
- Reads DNA in short fragments (typically 150-300bp)
- Paired-end sequencing reads both ends of a DNA fragment

**Key characteristics:**
- High accuracy: >99.9% per base (Q30 or higher)
- High throughput: Billions of reads per run
- Cost-effective for many applications
- Limited ability to resolve repetitive regions

**Data format:**
- FASTQ files (.fastq or .fq, often compressed as .gz)
- Each read has 4 lines:
  1. Header with ID and instrument info
  2. Sequence (ATGC)
  3. "+" (separator)
  4. Quality scores (encoded as ASCII characters)

```
@SRR10971381.1 1 length=151
CGTACGATCGATCGATCGATCGAT
+
FFFFFFFFFFFFFFFFFFFFFIII
```

### Long-Read Sequencing (Oxford Nanopore)

**Technology basics:**
- Passes DNA through protein nanopores
- Measures changes in electrical current to determine bases
- Reads entire DNA fragments without breaking them

**Key characteristics:**
- Much longer reads: 10kb-2Mb typical (average ~20kb)
- Lower base accuracy: ~95-98% for latest chemistry
- Real-time sequencing capability
- Better for structural variants and repeat regions

**Data format:**
- FASTQ files for basecalled data
- FAST5 files contain raw signal data (also enables methylation detection)

### Comparing Sequencing Technologies for K. pneumoniae

| Feature | Illumina | Oxford Nanopore |
|---------|----------|-----------------|
| Read length | 150-300bp | 10kb-2Mb |
| Accuracy | >99.9% | ~95-99% |
| Cost per Gb | Lower | Higher |
| Sample prep (lab prep) | More complex | Simpler |
| Best for | SNVs, small indels | Structural variants, complete assembly |
| Runtime | Hours-days | Minutes-hours |
| *K. pneumoniae* genome coverage | ~30-50x recommended | ~20-30x recommended |

**Key concept**: These technologies are complementary. Illumina excels at cost-effective and accurate SNV detection, while Nanopore better captures structural variants and mobile genetic elements common in bacteria. The choice of which technology to use varies with the aims of the experiment.

---

## 3. Short-Read Alignment and Variant Calling

### Aligning Short Reads with BWA-MEM

BWA-MEM (Burrows-Wheeler Aligner with Maximal Exact Matches) is the gold standard for aligning short reads to a reference genome.

**How BWA-MEM works:**
1. Creates an FM-index of the reference genome
2. Finds maximal exact matches between reads and reference
3. Extends these matches with a Smith-Waterman algorithm
4. Selects the best alignment location(s)

**Step 1: Index the reference**
```bash
# First, we need to index our reference genome
cd reference # (if not still in this directory)
bwa index GCF_000009885.1_ASM988v1_genomic.fna

# This creates several index files (.amb, .ann, .bwt, .pac, .sa)

cd ..
```

**What is this command doing?**
- The Burrows-Wheeler Transform compresses the reference
- Indexing allows rapid searching of the reference
- This is a one-time operation per reference; once the files are created, you don't need to run this again to analyse other samples.

**Step 2: Remove adaptors (optional)**
#### Adapter Trimming in Sequencing Data
Adapter trimming is the process of removing adapter sequences that were added during library preparation from sequencing reads. These artificial sequences are necessary for the sequencing process but must be removed before analysis to avoid interference with downstream applications.
```bash
# Adapter trimming (if needed)
## Download adaptors file:
wget https://raw.githubusercontent.com/timflutre/trimmomatic/master/adapters/TruSeq3-PE.fa -O adapters.fa

## Adaptor trimming
trimmomatic PE reads/illumina_R1.fastq.gz reads/illumina_R2.fastq.gz \
    reads/illumina_R1_trimmed.fastq.gz reads/illumina_R1_unpaired.fastq.gz \
    reads/illumina_R2_trimmed.fastq.gz reads/illumina_R2_unpaired.fastq.gz \
    ILLUMINACLIP:adapters.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

```
**What is this command doing?**
**Command Structure:**

`PE`: Indicates paired-end mode
`Input files`: reads/illumina_R1.fastq.gz and reads/illumina_R2.fastq.gz
`Output files`:
reads/illumina_R1_trimmed.fastq.gz: Forward reads that still have pairs
reads/illumina_R1_unpaired.fastq.gz: Forward reads that lost their pairs
reads/illumina_R2_trimmed.fastq.gz: Reverse reads that still have pairs
reads/illumina_R2_unpaired.fastq.gz: Reverse reads that lost their pairs

**Trimming Operations:**

`ILLUMINACLIP:adapters.fa:2:30:10`: Removes Illumina adapters specified in adapters.fa file

`2`: Seed mismatches allowed
`30`: Palindrome clip threshold. This refers to the minimum alignment score required to detect and remove adapter read-through events in paired-end data, where the sequencer has read through a short DNA fragment and into the adapter on the opposite end.
`10`: Simple clip threshold. This refers to the minimum alignment score required when directly matching adapter sequences against the reads, allowing for identification and removal of standard adapter contamination.


`LEADING:3`: Cuts bases from start of read if quality below 3
`TRAILING:3`: Cuts bases from end of read if quality below 3
`SLIDINGWINDOW:4:15`: Scans in 4-base windows, cutting when average quality falls below 15
`MINLEN:36`: Discards reads shorter than 36 bases after trimming

**Step 3: Align the reads**
```bash
# Now let's align our paired-end Illumina reads
mkdir alignment
bwa mem -t 4 reference/GCF_000009885.1_ASM988v1_genomic.fna reads/illumina_R1.fastq.gz reads/illumina_R2.fastq.gz | \
    samtools sort -o alignment/illumina_sorted.bam -
samtools index alignment/illumina_sorted.bam
```

**What is this command doing?**
- Paired-end information improves alignment accuracy
- The `-t 4` flag uses 4 CPU threads to speed up alignment
- The output is piped to samtools to create a sorted BAM file
- BAM files are binary versions of SAM (Sequence Alignment/Map) format.
- They can be still read using `samtools view alignment/illumina_sorted.bam`.

The `samtools index` command creates an index file for a sorted BAM or CRAM file. This index is essential for efficient random access to the alignment data.

**What Samtools Index Does:**
- Creates a companion `.bai` (BAM index) or `.csi `(CSI index) file alongside your BAM file
- Enables rapid access to specific genomic regions without scanning the entire file
- Similar to how a book index lets you find specific topics without reading the whole book

**Why indexing is necessary:**

- Random Access: Allows tools to quickly jump to specific chromosomal locations
- Visualization: Required by genome browsers and visualization tools
- Region Queries: Essential for commands like `samtools view -r chr1:1000-2000`
- Performance: Makes operations like samtools depth and variant calling much faster



**Understanding alignment output:**
```bash
# Let's look at alignment statistics
samtools flagstat alignment/illumina_sorted.bam

# View the first few alignments
samtools view alignment/illumina_sorted.bam | head

# Check mapping quality distribution
samtools view alignment/illumina_sorted.bam | cut -f5 | sort -n | uniq -c
```

**Key alignment concepts to discuss:**
- Mapping quality (MAPQ): Higher = more confident alignment
- For *K. pneumoniae*, expect >95% mapping rate with a good reference
- Properly paired reads: Both ends mapped at the expected distance/orientation
- Soft-clipping: Parts of reads that don't align well
- Coverage and depth: More is generally better, but diminishing returns

**Let's investigate these alignment files:**

BAM File Analysis Commands Explained
1) Count Mapped and Unmapped Reads
```bash
# Count mapped reads
samtools view -F 4 -c alignment/illumina_sorted.bam

# Count reads with minimum mapping quality of 20 phreds
samtools view -F 4 -q 20 -c alignment/illumina_sorted.bam

# Count ALL reads
samtools view -c alignment/illumina_sorted.bam
```
`samtools view`: Tool to view/convert SAM/BAM
`-F 4`: Filter out flag 4 (unmapped reads), keeping only mapped reads
`-c`: Count only, don't output records

```bash
# Count unmapped reads
samtools view -f 4 -c alignment/illumina_sorted.bam
```
`-f 4`: Keep only reads with flag 4 (unmapped reads)

**2) Get Coverage at Each Position**
```bash
# Coverage at each position
samtools depth -q 20 alignment/illumina_sorted.bam > coverage_per_base.txt
```
`samtools depth`: Reports depth at each position
`-q 20`: Only count reads with mapping quality ≥20
`>`: Redirect output to file

```bash
# Coverage in windows
## Create a genome file from your FASTA (sometimes called a "chromosome sizes" file)
samtools faidx reference/GCF_000009885.1_ASM988v1_genomic.fna
cut -f1,2 reference/GCF_000009885.1_ASM988v1_genomic.fna.fai > reference/genome.txt

bedtools makewindows -g reference/genome.txt -w 1000 > windows.bed
```
Creates 1000bp windows across the reference genome
`-g`: Genome file specifying chromosome sizes
`-w 1000`: Window size of 1000bp

```bash
# First filter BAM file for reads with mapping quality ≥ 20
samtools view -b -q 20 alignment/illumina_sorted.bam > alignment/illumina_sorted_q20.bam

# Index the filtered BAM file
samtools index alignment/illumina_sorted_q20.bam

# Then calculate coverage using filtered BAM
bedtools coverage -a windows.bed -b alignment/illumina_sorted_q20.bam > coverage_per_window.txt

```
Calculates coverage in each window
`-a`: BED file with windows
`-b`: BAM file
`-q 20`: Minimum mapping quality

**Understanding the output:**
When you run `bedtools coverage -a windows.bed -b alignment/illumina_sorted_q20.bam > coverage_per_window.txt`, the output file contains several columns that provide coverage statistics for each genomic window:

1. `Chromosome/Sequence ID`: The name of the chromosome or sequence from your windows.bed file
2. `Start position`: The starting coordinate of the window (0-based)
3. `End position`: The ending coordinate of the window
4. `Number of features/reads overlapping`: Count of reads that overlap with this window
5. `Number of bases covered`: Total number of bases in the window that are covered by at least one read
6. `Size of window`: Total size of the window in base pairs
7. `Fraction covered`: Proportion of the window that is covered by at least one read (column 5 divided by column 6)

Additional columns depend on which options you use:

With `-d` option: Depth at each position in the window
With `-hist` option: Histogram data showing how many bases have what depth
With `-mean` option: An additional column showing the mean depth of coverage across the window

For standard coverage analysis, columns 1-7 provide the essential coverage metrics, with column 7 (fraction covered) and column 4 (number of reads) being particularly useful for assessing coverage completeness and depth.

**3) Calculate Average Coverage**
```bash
# Method 1: Using samtools depth output
awk '{ sum += $3 } END { print sum/NR }' coverage_per_base.txt
```
Sums the third column (depth) and divides by number of rows (positions)
Calculates mean depth across all positions

```bash
# Method 2: Using bedtools genomecov
bedtools genomecov -ibam alignment/illumina_sorted.bam -d | awk '{ sum += $3 } END { print sum/NR }'
```
`bedtools genomecov`: Computes coverage across genome
`-ibam`: Input BAM file
`-d`: Reports coverage at each position
`awk` part calculates the average

**Are you getting the same results between methods 1 and 2?**
The difference between your two coverage calculations (107.333 vs 99.005) is  due to how each command handles certain regions.
- By default, samtools depth only reports positions that have non-zero coverage
- This means positions with zero coverage are excluded from the calculation
- Thus, your average (107.333) is higher because it's only averaging across covered positions
- `bedtools genomecov -d` reports every single position in the genome, including those with zero coverage.
- This provides a more accurate genome-wide average.
- Your lower result (99.005) reflects the true average because it includes uncovered regions

To get comparable results from samtools depth, you would need to use:
```bash
samtools depth -a alignment/illumina_sorted.bam | awk '{ sum += $3 } END { print sum/NR }'
```
The `-a` flag forces reporting of all positions, including those with zero coverage.


### Variant Calling with Freebayes

Freebayes is a Bayesian variant caller that identifies SNVs and indels.

 **How Freebayes works:**
1. Analyzes aligned reads at each position
2. Uses Bayesian statistics to calculate variant probabilities
3. Considers multiple factors: base quality, mapping quality, allele frequency

**Step 1: Call variants**
```bash
# Call variants using Freebayes
# This will take ~5-10 minutes
mkdir variants
freebayes -f reference/GCF_000009885.1_ASM988v1_genomic.fna -p 1 -m 20 alignment/illumina_sorted.bam > variants/illumina_variants.vcf
```

**What is this command doing?**
- `-p 1` specifies ploidy (bacteria are typically haploid)
- `-m 20`: ensures that only reads with a mapping quality of 20 are used
- Variant calling combines evidence across multiple reads
- *K. pneumoniae* typically has 5,000-10,000 SNVs compared to reference
- Common sources of false positives: sequencing errors, alignment artifacts

**Step 2: Filter variants**
```bash
# Basic filtering of low-quality variants
bcftools filter -i 'QUAL>20 && INFO/DP>10' variants/illumina_variants.vcf > variants/illumina_filtered.vcf

# Summarize variants
bcftools stats variants/illumina_filtered.vcf > variants/illumina_variants_stats.txt
```

**What is this command doing?**
`bcftools`: A toolkit for variant calling and manipulating VCF files
`filter`: The subcommand used to include or exclude variants based on specified criteria
`-i`: The "include" flag that specifies which variants to keep
`'QUAL>20 && INFO/DP>10'`: The filtering expression:

`QUAL>20`: Only keep variants with a quality score greater than 20
&&: Logical AND operator (both conditions must be true)
`INFO/DP>10`: Only keep variants with a depth of coverage greater than 10 reads

`variants/illumina_variants.vcf:` The input VCF file containing all variant calls
`>`: Redirect output to a file
`variants/illumina_filtered.vcf`: The output file that will contain only the filtered variants that passed the quality thresholds

**Key variant calling concepts:**
- Quality scores (PHRED scale): 10 = 90% confidence, 20 = 99%, 30 = 99.9%
- Depth (DP): More reads = more confidence (typically want >10x)
- Strand bias: Variants should appear on both forward and reverse reads
- Transition/transversion ratio: Expect ~2-3 in bacteria
- For K. pneumoniae, antimicrobial resistance often arises from specific SNVs

---

## 4. Long-Read Alignment and Variant Calling

### Aligning Long Reads with Minimap2

Minimap2 is designed for efficient alignment of long reads, which have different error profiles than short reads.

**How Minimap2 works:**
1. Finds minimizers (representative k-mers) in reads and reference
2. Creates "seed chains" of matching minimizers
3. Performs alignment around these chains
4. Optimized for the higher error rates of long reads

**Step 1: Align ONT reads**
```bash
# Align Oxford Nanopore reads
# This will take ~5-10 minutes
minimap2 -ax map-ont -t 4 reference/GCF_000009885.1_ASM988v1_genomic.fna reads/ONT.fastq.gz | \
    samtools sort -o alignment/ont_sorted.bam -

# Index the BAM file
samtools index alignment/ont_sorted.bam
```

**What is this command doing?**
- `-ax map-ont` specifies ONT-specific parameters
- Minimap2 is much faster than BWA for long reads
- Long reads often span repetitive regions that confuse short reads
- Expect lower mapping quality due to higher error rates

**Examining long-read alignments:**
```bash
# Check alignment statistics
samtools flagstat alignment/ont_sorted.bam

# Compare coverage between technologies
samtools depth -a alignment/illumina_sorted.bam | \
    awk '{sum+=$3} END {print "Average Illumina depth:", sum/NR}'
samtools depth -a alignment/ont_sorted.bam | \
    awk '{sum+=$3} END {print "Average ONT depth:", sum/NR}'
```

**Long-read alignment characteristics:**
- More uniform coverage than Illumina (fewer GC biases)
- Often spans complex and difficult regions (repeats, insertion sequences)
- May show distinctive error patterns (more indels than substitutions)
- In *K. pneumoniae*, longer reads better resolve genomic islands and phage insertions

### Optimized Variant Calling for *Klebsiella pneumoniae* (Haploid) Using Long Reads

#### Key Differences for Bacterial Genomics
- **No phasing needed** (haploid genome simplifies analysis)
- **Focus on two variant types**:
  1. **Small variants (SNPs/indels)** - Single base changes or insertions/deletions <50bp  
     *Example*: Antibiotic resistance mutations in *gyrA* or *rpoB*
  2. **Structural variants (SVs)** - Larger changes (>50bp) like deletions, insertions, inversions  
     *Example*: Plasmid integration or large genomic deletions

#### Why Long Reads Outperform Short Reads
| Feature              | Long Reads (ONT/PacBio)       | Short Reads (Illumina)       |
|----------------------|-------------------------------|------------------------------|
| **SNP/Indel calling** | Better in repetitive regions  | Higher raw accuracy but fails in repeats |
| **SV detection**      | Can span entire SVs           | Limited by read length (~300bp) |


#### Clair3 vs Sniffles2 for Bacteria
| Tool       | Best For                          | Bacterial Use Case                |
|------------|-----------------------------------|-----------------------------------|
| **Clair3** | SNPs/indels (1-50bp)              | Detecting point mutations causing resistance |
| **Sniffles2** | SVs (>50bp)                      | Identifying large genomic changes or plasmid integrations |

### Variant calling with Clair3
Clair3 is specifically designed for variant calling from long reads, accounting for their unique error profiles.

**Step 1: Call variants with Clair3**
```bash
# Set up output directory
mkdir -p clair3_output

# Run Clair3 (this may take ~10-15 minutes)
run_clair3.sh \
    --bam_fn=alignment/ont_sorted.bam \
    --ref_fn=reference/GCF_000009885.1_ASM988v1_genomic.fna \
    --output=clair3_output \
    --threads=4 \
    --platform="ont" \
    --model_path="/home/hpc9/.conda/envs/session3_clair/bin/models/ont" \
    --include_all_ctgs \
    --no_phasing_for_fa \
    --haploid_precise

```

**What is this command doing:**
`--bam_fn=alignment/ont_sorted.bam`: Input BAM file containing sorted reads from Oxford Nanopore Technology (ONT) sequencing
`--ref_fn=reference/GCF_000009885.1_ASM988v1_genomic.fna`: Reference genome file in FASTA format against which variants will be called
`--output=clair3_output`: Directory where output files will be saved
`--threads=4`: Number of CPU threads to use for parallel processing
`--platform="ont"`: Specifies the sequencing platform as Oxford Nanopore Technology
`--model_path="/home/hpc9/.conda/envs/session3_clair/bin/models/ont"`: Path to the pre-trained machine learning model for ONT data
`--include_all_ctgs`: Include all contigs from the reference genome for variant calling, not just the primary ones
`--no_phasing_for_fa`: Disables phasing when generating FASTA output (phasing is the process of determining which variants are on the same chromosome)
`--haploid_precise`: Optimizes variant calling for haploid genomes, improving precision for organisms with a single set of chromosomes

**Note that:**
- Long-read variant callers must account for higher error rates
- ONT reads tend to have more indel errors than substitution errors
- Neural network models help distinguish true variants from sequencing errors
- Structural variants are more easily detected with long reads

**Step 2: Analyze the variants**
```bash
# Copy the merged VCF to our working directory
cp clair3_output/merge_output.vcf.gz variants/ont_variants.vcf.gz
gunzip -f variants/ont_variants.vcf.gz

# Basic filtering of low-quality variants
bcftools filter -i 'QUAL>20 && DP>10' variants/ont_variants.vcf > variants/ont_variants_filtered.vcf

# Basic stats on variants
bcftools stats variants/ont_variants_filtered.vcf > variants/ont_variants_stats.txt
```

**Unique aspects of long-read variant calling:**
- Better detection of structural variants
- Potential for direct methylation detection
- Higher false positive rates for SNVs compared to Illumina
- Important for detecting antimicrobial resistance gene insertions in K. pneumoniae

### SV calling with Sniffles2
Sniffles2 efficiently detects structural variants (SVs >50bp) in bacterial genomes like K. pneumoniae from long-read data, identifying deletions, insertions, and plasmid integrations with minimal false positives. It skips phasing (ideal for haploid genomes) and offers tunable filters (--minsupport, --minsvlen) for precision. Pair with Clair3 for comprehensive SNP/indel+SV analysis.

```bash
# Calling SVs with Sniffles2
## Sniffles needs a different environment because Clair3 and Sniffles have different Python requirements (3.9 x 3.10)
mamba activate /home/hpc9/.conda/envs/session3_sniffles

# Calling sniffles2
sniffles --minsupport 5 --minsvlen 50 --mapq 20 --min-alignment-length 500 --threads 4 --input alignment/ont_sorted.bam -v variants/sniffles.vcf
```
**What is this command doing?**
`--minsupport 3-5`: For bacterial genomes, lower support values work well. Bacterial genomes tolerate lower support (haploidy + high coverage). Trade-off: 3 for sensitive plasmid detection; 5 for stricter chromosomal SVs.
`--minsvlen 30-50`: Detect SVs of at least 30bp (or 50bp). Captures small but meaningful SVs (e.g., antimicrobial resistance gene indels). Balance: 50bp reduces noise; 30bp increases sensitivity for plasmids.
`--mapq 20`: Minimum mapping quality threshold
`--min-alignment-length 500`: Ensures reads span SV breakpoints confidently (avoids false positives).
`--threads 4`: Use of 4 threads
`--min-af 0.1`: Detect variants with at least 10% allele frequency. Controversial for haploid bacteria: Pure clonal samples should have `AF=1.0`. Use only if expecting mixed populations.

**Investigating the Sniffles2 results:
```bash
# One-liner "quick and dirty" investigation of the Sniffles2 results
grep -v "^#" variants/sniffles.vcf | awk -F';' '{for(i=1;i<=NF;i++){if($i~/^SVTYPE=/){print $i}}}' | cut -d'=' -f2 | sort | uniq -c
```
**What is this command doing?**

1.` grep -v "^#" variants/sniffles.vcf`
*Purpose*: Skip header lines (lines starting with #) in the VCF file.
*Why*: VCF headers (metadata) are irrelevant for counting variants.
*Output*: Streams only variant records (data lines) to the next command.
2. `awk -F';' '{for(i=1;i<=NF;i++){if($i~/^SVTYPE=/){print $i}}}'`
*Purpose*: Extract the SVTYPE field from the INFO column (8th column in VCF).
How:
`-F';'`: Sets the field separator to ; (the INFO column uses ;-delimited key-value pairs).
Loops through all fields (`NF` = number of fields) in the INFO column.
If a field starts with SVTYPE=, print it (e.g., SVTYPE=INS, SVTYPE=DEL).
*Output*: Streams SVTYPE=INS, SVTYPE=DEL, etc., one per line.
3. `cut -d'=' -f2`
*Purpose*: Isolate the SV type (value after =).
*How*:
`-d'='`: Splits each line at =.
`-f2`: Prints the second field (e.g., INS, DEL).
*Output*: Streams raw SV types (e.g., INS, DEL).

4. `sort | uniq -c`
*Purpose*: Count occurrences of each SV type.
*How*:
`sort`: Groups identical SV types together.
`uniq -c`: Counts and prints unique entries.


---

## 5. Variant annotation with SnpEff


### Setting Up IGV
Copy the alignment and variant files to your computer
**Step 1: Load the data**
```bash
# Change back to our session3_clair enviroment
mamba activate /home/hpc9/.conda/envs/session3_clair

# Use a pre-built SnpEff database to annotate our variants of interest.
java -Xmx4g -jar /home/hpc9/.conda/envs/session3_clair/share/snpeff-5.2-1/snpEff.jar -c /home/hpc9/.conda/envs/session3_clair/share/snpeff-5.2-1/snpEff.config -v Klebsiella_pneumoniae_ASM988v1 variants/illumina_filtered.vcf > variants/illumina_variants_filtered_annotated.vcf
java -Xmx4g -jar /home/hpc9/.conda/envs/session3_clair/share/snpeff-5.2-1/snpEff.jar -c /home/hpc9/.conda/envs/session3_clair/share/snpeff-5.2-1/snpEff.config -v Klebsiella_pneumoniae_ASM988v1 variants/ont_variants_filtered.vcf > variants/ont_variants_filtered_annotated.vcf

```

## 6. Visualization with IGV

1. Copy the files of interest to your computer (alignment and variant calls)
2. Load the reference genome with annotation.
3. Load the alignment files and examine.
4. Load the variant call and compare.


### Key Regions to Explore

**1. High-confidence variants**
Look for regions where both technologies call the same variants
- Typically have high coverage
- Clear allele separation
- Example: Find a SNV with strong support in both datasets

**2. Technology-specific variants**
Identify variants called by only one technology
- ONT-specific: Often around homopolymers (AAAAA or GGGGG)
- Illumina-specific: Often in repetitive regions

**3. Antimicrobial resistance genes**
Navigate to known resistance genes in K. pneumoniae
- Examples: *blaKPC*, *blaCTX-M*, *oqxAB* genes
- Look for variants or structural changes

**4. Mobile genetic elements**
Find regions with unusual coverage or structural changes
- Insertion sequences (IS elements)
- Prophages
- Genomic islands

**Key visualization tips:**
- Use the coverage track to identify potential CNVs
- Zoom to base level to verify variant calls
- Look for soft-clipped reads that may indicate structural variants
- Toggle between read and coverage view for different perspectives

---

## 7. Comparative Analysis

Now let's compare the results from both technologies to understand their strengths and limitations.

### Comparing Variant Calls

```bash
# How many variants were called by each technology?
echo "Illumina variants: $(grep -v "#" variants/illumina_variants_filtered_annotated.vcf | wc -l)"
echo "ONT variants: $(grep -v "#" variants/ont_variants_filtered_annotated.vcf | wc -l)"

# Find variants called by both technologies
bedtools intersect -a variants/illumina_variants_filtered_annotated.vcf -b variants/ont_variants_filtered_annotated.vcf > variants/common_variants.vcf
echo "Common variants: $(grep -v "#" variants/common_variants.vcf | wc -l)"

# Find technology-specific variants
bedtools subtract -a variants/illumina_variants_filtered_annotated.vcf -b variants/ont_variants_filtered_annotated.vcf > variants/illumina_only.vcf
bedtools subtract -a variants/ont_variants_filtered_annotated.vcf -b variants/illumina_variants_filtered_annotated.vcf > variants/ont_only.vcf
echo "Illumina-only variants: $(grep -v "#" variants/illumina_only.vcf | wc -l)"
echo "ONT-only variants: $(grep -v "#" variants/ont_only.vcf | wc -l)"
```
**What are these commands doing?**
`bedtools`: A powerful toolkit for genomic arithmetic operations. Performs intersection, subtraction, and other comparisons between genomic datasets.
`intersect`: Finds overlapping features between two datasets.
`subtract`: Removes features in dataset B from dataset A.
`-a`: Specifies the first input file (primary dataset).
`-b`: Specifies the second input file (comparison dataset).
`> file.vcf`: Redirects output to a new VCF file.
These commands create: 
  - `common_variants.vcf` (intersection output)
  - `illumina_only.vcf` (first subtraction output, variants found only in the Illumina reads)
  - `ont_only.vcf` (second subtraction output, variants found only in the ONT reads)

Important Behavior Notes
1. Automatic format handling: Recognizes VCF format without explicit specification
2. Coordinate-based comparison: Matches variants by genomic position (chr:pos)
3. Strand-agnostic by default: Doesn't consider strand orientation unless specified
4. Whole-line output: Preserves complete VCF records for matching variants
### Technology Complementarity

**Illumina strengths:**
- Higher accuracy for SNV detection
- More reliable small indel detection
- Lower false-positive rate
- Cost-effective for large sample numbers

**Oxford Nanopore strengths:**
- Better structural variant detection
- Resolution of repetitive regions
- Detection of methylation patterns
- Real-time sequence analysis capability

***K. pneumoniae*-specific insights:**
- AMR genes often contain both SNVs (point mutations) and structural changes
- Mobile genetic elements, common in K. pneumoniae, are better resolved with long reads
- Plasmids, critical for understanding resistance transmission, are easier to assemble with long reads

### Real-World Applications

**Clinical microbiology:**
- Rapid identification of resistance mechanisms
- Tracking hospital outbreaks
- Guiding appropriate antibiotic therapy

**Research applications:**
- Understanding evolution of antimicrobial resistance
- Characterizing novel resistance mechanisms
- Studying bacterial population structures

**Public health:**
- Surveillance of emerging resistant strains
- Tracking transmission chains
- Informing infection control policies

---

## 7. Wrap-up and Best Practices

### Key Takeaways

**Technical considerations:**
- Choose the right reference genome for your research question
- Use appropriate depth for your technology (30-50x Illumina, 20-30x ONT)
- Validate important variants across technologies when possible
- Always visualize and manually inspect critical variants

**Biological insights:**
- *K. pneumoniae* has extensive genomic plasticity
- Resistance can emerge through multiple mechanisms
- Population structure affects interpretation
- Reference choice substantially impacts results

### Next Steps for Participants

**Further analyses to consider:**
- De novo assembly (especially with long reads)
- Phylogenetic analysis to place samples in context
- Functional annotation of variants
- Comparative genomics across multiple isolates

**Resources for continued learning:**
- Tool documentation (BWA, Minimap2, Freebayes, Clair3)



---

## Reference Materials
- BWA - https://github.com/lh3/bwa
- Samtools - https://www.htslib.org/doc/samtools.html
- bcftools - https://www.htslib.org/doc/bcftools.html
- Bedtools - https://github.com/arq5x/bedtools2
- Freebayes - https://github.com/freebayes/freebayes
- Minimap2 - https://github.com/lh3/minimap2
- Clair3 - https://github.com/HKU-BAL/Clair3
- Sniffles2 - https://github.com/fritzsedlazeck/Sniffles
- SnpEff - https://pcingola.github.io/SnpEff/snpeff/introduction/
