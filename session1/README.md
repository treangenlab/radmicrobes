# Session 1 - Sampling, Sequencing, Quality Assessment and Control, and Assembly
*by Blake Hanson, MS, PhD*

<details>
 <summary>
  
  # Session Summary</summary>
 <p></p>

 * [Introduction to the Unix Shell](#introduction-to-the-unix-shell)
 	* [Unix shell learning resources](#unix-shell-learning-resources)
 	* [Accessing the workshop computational environment](#accessing-the-workshop-computational-environment)
 	* [Enough commands to make you dangerous](#enough-commands-to-make-you-dangerous)
 	* [Zsh as compared to bash](#zsh-as-compared-to-bash)
 	* [Cheat sheets are your friends](#cheat-sheets-are-your-friends)
    
 * [Sampling and study design](#sampling-and-study-design)
 	* [Determine your goals](#determine-your-goals)
 	* [Sampling](#sampling-considerations-for-microbial-genomics)
 		* [Working with reference isolates](#collecting-samples)
 		* [Clinical sampling](#clinical-isolates)
 
 * [Sequencing](#sequencing)
 	* [A brief history](#a-brief-history-of-microbial-sequencing)
 	* [Currently available technologies](#currently-available-technologies)
 		* [Short read sequencing technologies](#short-read-sequencing-technologies)
 			* [Illumina](#illumina-sequencing-next-generation-sequencing---ngs)
 			* [Ion Torrent](#ion-torrent-sequencing)
 			* [Sanger](#sanger-sequencing)
 		* [Long read sequencing technologies](#long-read-sequencing-technologies)
 			* [Oxford Nanopore](#oxford-nanopore-technologies-ont)
 			* [PacBio](#pacbio-sequencing)  
 	* [How do I pick which one to use?](#how-do-i-pick-which-one-to-use)
 
 * [Sequencing quality assessment and control](#sequencing-quality-assessment-and-control)
 	* [Short read QC/QA](#short-read-qcqa)
 		* [FastQC](#fastqc)
 		* [FastQC Alternatives](#fastqc-alternatives)
 			* [Raspberry](#raspberry)
 		* [MultiQC](#multiqc)
 	* [Long read QC/QA](#long-read-qcqa)
 		* [NanoPlot and associated scripts](#nanoplot-and-associated-scripts)
 		* [pycoQC](#pycoqc)
 
 * [Assembly](#assembly)
 	* [Short read assembly](#short-read-assembly)
 		* [Spades](#spades)
 	* [Long read assembly](#long-read-assembly)
 		* [Flye](#flye)

 * [Assembly QC/QA](#assembly-qcqa)
 	* [Quast](#quast)
 	* [Bandage](#bandage)
 	* [Busco and CheckM](#busco-and-checkm)

</details>

#  Introduction to the Unix Shell

## Unix shell learning resources

There are many fantastic resources that can help you start your journey using Unix and bash/zsh or help you take your skills to the next level.  A few are listed here:
 * [Happy Belly Bioinformatics](https://astrobiomike.github.io/unix/unix-intro) (Which will be used in this boot camp)
 * [Software Carpentry - The Unix Shell](https://swcarpentry.github.io/shell-novice/)
 * [Bioinformatics Workbook](https://bioinformaticsworkbook.org/Appendix/Unix/unix-basics-1.html#gsc.tab=0)

As a gentile introduction for the sessions during this workshop, we will loosely follow the [Happy Belly Bioinformatics](https://astrobiomike.github.io/unix/unix-intro) guide with some abbreviated sections to better fit our workshop.

## A few notes before we start

In Unix-based systems, spaces in file names can often lead to confusion and scripting errors, as the space character is a delimiter that separates command line arguments. To avoid these issues, it's recommended to use dashes (-) or underscores (_) instead of spaces in file names.

These characters provide visual separation between words in a file name while ensuring the name is interpreted as a single entity by the shell and other command-line tools. 

For instance, instead of naming a file `My Document.txt`, you would name it `My-Document.txt` (using dashes) or `My_Document.txt` (using underscores). 

This naming convention enhances readability and makes it easier to handle files in scripts or command-line operations. When typing commands, you can simply refer to the file without needing to wrap the name in quotes or escape the spaces. Adopting this practice is especially beneficial in scripting and programming, where consistency and predictability in file names are essential.

It is equally important to adopt this practice for folder names in addition to file names. Spaces in folder names, like in file names, can lead to unexpected behavior or errors in various scripts, software programs, and command-line operations. By using dashes or underscores in folder names, you avoid potential complications that arise from spaces being misinterpreted as argument separators or requiring additional handling such as escape characters or quotes. 

## Accessing the workshop computational environment

To access the workshop computational resources, we will utilize the `ssh` command, which stands for secure shell. 

On MacOS, this can be accessed using Terminal, which can be found two ways: 
 * Opening spotlight and typing "terminal", then selecting the option called "Terminal"

<p align="center">
<img src="Images/macOS_terminal.gif" width="600" align="center"> 
</p>
 
 * Navigating to Applications -> Utilities -> Terminal
 
On Windows, this can be accomplished by opening PowerShell:
 * From the start menu, enter "powershell" in the search bar
 <p align="center">
 <img src="Images/powershell.png" width="600" align="center">
 </p>
 	
Once you have accessed either Terminal or PowerShell, you then need to enter the following command, making sure to swap in your user name in place of "username".

``` 
ssh username@radmicrobes.rice.edu
```

As an example, my username for our workshop is `hpc3` so my login command is:

```
ssh hpc3@username@radmicrobes.rice.edu
```

Once you hit enter, the connection between your computer and the radmicrobes.rice.edu server will be established and you will be greeted with the interactive command line. This server is called a gateway server, or a jump station, and acts as our portal to the workshop infrastructure.

<p align="center">
<img src="Images/radmicrobes_login.png" width="600" align="center"> 
</p>


Note, that the first time you log in, you may see details on the key fingerprint for the server asking you if you are sure you want to continue connecting. This is normal behavior for the first time you log into a new server using ssh, and is OK to inter "yes" to confirm your login. Once you do that, you can enter in your password and will be greeted with the interactive command line of the server. 

<p align="center">
<img src="Images/radmicrobes_login.gif" width="600" align="center">
</p>
	
	  
**Your unique credentials for the server will be distributed via the workshop slack channel.**

Once you have logged into the radmicrobes.rice.edu server, you will need to connect one step further to access our NOTS cluster where we will be running our analyses. To accomplish this, you will enter the following command:

```
ssh nots
```

<p align="center">
<img src="Images/nots_login.png" width="600" align="center">
</p>


Congratulations! You now have access to our workshop computational infrastructure. Let's get started. 

## Enough commands to make you dangerous

### Useful commands for our workshop

#### Navigating the Filesystem:

1. `pwd` (Print Working Directory)
   - **Description:** Shows the current directory path.
   - **Example:** 
     ```
     pwd
     ```

2. `ls` (List)
   - **Description:** Lists files and directories in the current directory.
   - **Examples:** 
     ```
     #If you want to list files with associated details
     ls -l
     
     #If you want to list files without associated details (often useful to see more file names in less space)
     ls -s
     ```

3. `cd` (Change Directory)
   - **Description:** Changes the current directory.
   - **Example:** To change to a directory named `Documents`:
     ```
     cd Documents
     ```

4. `mkdir` (Make Directory)
   - **Description:** Creates a new directory.
   - **Example:** To create a new directory named `NewFolder`:
     ```
     mkdir NewFolder
     ```

5. `rmdir` (Remove Directory)
   - **Description:** Deletes an empty directory.
   - **Example:** To remove a directory named `OldFolder`:
     ```
     rmdir OldFolder
     ```

6. `touch`
   - **Description:** Creates an empty file or updates the timestamp of an existing file.
   - **Example:** To create a new file named `example.txt`:
     ```
     touch example.txt
     ```

#### File Manipulation:

1. `cp` (Copy)
   - **Description:** Copies files or directories.
   - **Example:** To copy a file named `file1.txt` to `file2.txt`:
     ```
     #Create a copy in the same directory
     cp file1.txt file2.txt
     #Create a copy in a different directory (assumes different directory exists)
     cp file1.txt new_directory/file1.txt
     OR
     cp file1.txt new_directory/file2.txt
     ```

2. `mv` (Move)
   - **Description:** Moves or renames files or directories.
   - **Example:** To rename `file1.txt` to `file2.txt`:
     ```
     #Move the file within the same directory (works as renaming the file)
     mv file1.txt file2.txt
     #Move the file to a different directory (assumes different directory exists)
     mv file1.txt new_directory/file1.txt
     OR
     mv file1.txt new_directory/file2.txt
     ```

3. `rm` (Remove)
   - **Description:** Removes files or directories.
   - **Example:** To remove a file named `file.txt`:
     ```
     rm file.txt
     ```

4. `cat` (Concatenate)
   - **Description:** Displays file content, combines files.
   - **Example:** To display the contents of `file.txt`:
   - **Note:** If this is a large file, it will print the entire thing to your screen, which may be slow or unwieldy. In that situation, consider the options of `head`, `tail`, `less`, and `grep`.
     ```
     cat file.txt
     ```

5. `head`
   - **Description:** Shows the first few lines of a file.
   - **Example:** To show the first 10 lines of `file.txt`:
     ```
     head file.txt
     #If you want to show a different number of lines, use the -n command
     head -n 50 file.txt
     ```

6. `tail`
   - **Description:** Shows the last few lines of a file.
   - **Example:** To show the last 10 lines of `file.txt`:
     ```
     tail file.txt
     #If you want to show a different number of lines, use the -n command
     tail -n 50 file.txt
     ```

7. `less`
   - **Description:** Allows backward and forward navigation through the content of a file.
   - **Example:** To open `file.txt` in `less`:
     ```
     less file.txt
     ```

8. `grep`
   - **Description:** Searches for patterns within files. This supports a wide range of patterns such as regular expressions, which are beyond the scope of this workshop. 
   - **Example:** To search for the word "example" in `file.txt`:
     ```
     grep "example" file.txt
     ```

9. `find`
   - **Description:** Searches for files and directories within the file system.
   - **Example:** To find files named `file.txt` in the current directory and subdirectories:
   - **Note:** The period in this sentence tells find to search starting in the current directory. 
   	 ```
     find . -name "file.txt"
     ```

10. `wc` (Word Count)
   - **Description:** Counts lines, words, and characters in a file.
   - **Example:** To count the number of lines, words, and characters in `file.txt`:
     ```
     wc file.txt
     ```

#### Scripting and Automation 

1. `nano`, `vi`, `emacs`
   - **Description:** Text editors for writing scripts or editing files.
   - **Example:** To edit a file named `script.sh` using `nano`:
     ```
     nano script.sh
     ```

2. `bash`
   - **Description:** Executes commands read from a script file.
   - **Example:** To execute a script file named `script.sh`:
     ```
     bash script.sh
     ```

3. `ssh` (Secure Shell)
   - **Description:** Connects to a remote machine securely.
   - **Example:** To connect to a remote host at `example.com` with username `user`:
     ```
     ssh user@example.com
     ```

4. `scp` (Secure Copy)
   - **Description:** Securely transfers files between hosts.
   - **Example:** To copy a file `file.txt` to a remote host `example.com`:
     ```
     #To transfer a file from your local computer to a remote host
     scp file.txt user@example.com:/path/to/destination
     #To transfer a file from a remote host to your local computer
     scp user@example.com:/path/to/file /path/to/local/destination
     ```

5. `tar`
   - **Description:** Archives files.
   - **Example:** To create a tar archive of a directory `folder`:
     ```
     tar -cvf archive.tar folder/
     ```

6. `zip`/`unzip`
   - **Description:** Compresses files and extracts compressed files.
   - **Example:** To zip a directory `folder` into a new file called archive.zip:
     ```
     zip -r archive.zip folder/
     ```
   - **Example:** To unzip an archive `archive.zip`:
     ```
     unzip archive.zip
     ```
     
 7. `echo`
   - **Description:** Displays a line of text.
   - **Example:** To display "Hello World":
     ```
     echo "Hello World"
     ```

#### Networking:

1. `ping`
   - **Description:** Checks network connectivity to another host.
   - **Example:** To ping `google.com`:
     ```
     ping google.com
     ```

2. `curl`
   - **Description:** Transfers data from or to a server.
   - **Example:** To download a webpage from `example.com`:
     ```
     curl http://example.com
     ```

3. `wget`
   - **Description:** Non-interactive network downloader.
   - **Example:** To download a file from `example.com/file.txt`:
     ```
     wget http://example.com/file.txt
     ```


### Navigating the Filesystem:

Let's start with how to move around using unix commands. 

While you are only able to use text commands while using terminal and PowerShell, the same fundamental structure you have on your local computer also applies, and files and folders are stored hierarchically. 

As an example, consider that I am working on the desktop of my laptop, and I want to find a file using terminal that I know is in a folder called `test_folder`. To start with, I can confirm I am in the folder I think I am in using the `pwd` command:

<p align="center">
<img src="Images/pwd.gif" width="600" align="center"> 
</p>

As you can see, `pwd` tells us we are currently in the folder **Desktop/test_folder**. This is reflected in the finder window below where you can see that on my desktop is a folder called `test_folder`.

Next, we want to look and see what is within `test_folder`. For this, we will use the ls command:

<p align="center">
<img src="Images/ls.gif" width="600" align="center"> 
</p>

As you can see, I used three different versions of the ls command, each with differing information:
 * **ls** which simply lists the names of the files and directories, but does not differentiate between the different types clearly 
 * **ls -s** which provides a similar output to ls, but provides information on the size in blocks of the files and directories listed
 * **ls -l** which provides the list of the directories and files, but also provides information on the size of the files, indicates which are files (a dash as the first character in the column to the left) vs directories (the character d is the first character in the column to the left), as well as the [read and write privileges](https://www.tutorialspoint.com/unix/unix-file-permission.htm) for the objects listed. 

Due to the additional information shown, I prefer `ls -l`, but each have their utilities (and there are additional sub-commands you can use to further refine the output).

Now that we have seen within the `test_folder`, I have identified another folder nested within that directory called `test_subfolder`.  I did not find what I was looking for within the current directory, so let's use the `cd` command to change directories and look within the `test_subfolder` directory. 

<p align="center">
<img src="Images/cd.gif" width="600" align="center"> 
</p>

Now we see there is a single file within the `test_subfolder` called `test_file_2.txt`. This file is larger than the `test_file_1.txt` that we saw within the previous directory, which we can see using the file size section of the `ls -l` command. That said, while we can see the contents of the file within the finder window when I click on the file name, we cannot see that in our terminal. To see what is within this file, we have a few options:
 * `cat`
 * `head/tail`
 * `nano/vim`
 
 For this example, I am going to use `cat` as my file is not too long, but I encourage you to try the other options after consulting the command descriptions listed above. 
 
<p align="center">
<img src="Images/cat.gif" width="600" align="center"> 
</p>
 
After seeing the contents of `test_file_2.txt`, I have identified this is the file I want, but it is not in the location I thought it was in and I want to move the file. To do this, I can use the `mv` command:

<p align="center">
<img src="Images/mv.gif" width="600" align="center"> 
</p>

By using the `mv test_file_2.txt ../` command, what I am doing is using a key character `../` to tell the `mv` command that I want to move the file up one directory from where I am, which will move it from `test_subfolder` to `test_folder`. I could have also accomplished this by using the command `mv test_file_2.txt ~/Desktop/test_folder/`, which uses the `~` key character to tell the system to go to my base directory, which on my laptop is my user folder that contains my Desktop, Downloads, and Documents, among other things. 
 
Now that I have moved the file up a directory, I also want to go to that directory. I can do this by using the `cd` command again. 

<p align="center">
<img src="Images/cd_part_2.gif" width="600" align="center"> 
</p>


Note that I used the `cd ../` command here, which uses the same key character as the last set of commands. I could have also accomplished this via the command `cd ~/Desktop/test_folder`, which would accomplish the same thing using the path names and the `~` key character.

To round out my search for and move of my `test_file_2.txt`, I want to see what is inside of the `test_file_1.txt` file I found first, and if it is empty, delete it using the `rm` command. 

<p align="center">
<img src="Images/rm.gif" width="600" align="center"> 
</p>

While I do not show this step here, I may also want to remove the now empty `test_subfolder`that I am no longer using. The safest way to do this is using `rmdir test_subfolder`. I could also use the `rm -r test_subfolder` command, and it would have the same behavior as the `rmdir test_subfolder` command in this example. That said, it is much better to use `rmdir` in this situation as the directory is empty and `rmdir` will only remove empty directories by default. If there is something in the directory being deleted, `rmdir` will generate and error to make sure I don't accidentally delete something I may have wanted/needed. If you are sure you want to remove a directory and all of its contents, `rm -r` is a more powerful command that can accomplish this task, but be careful. 
   
Now you should be ready to go for our workshop and be able to navigate throughout the file structures and everything we need. Remember, if you are ever lost, `pwd`, `cd`, and `ls` are your friends. Additionally, as you continue to learn, there are plenty of cheat sheets online to help you identify and apply new commands and sub-commands. 

## Cheat sheets are your friends

There are many different cheat sheets on the internet that have similar but unique sets of reference commands and details on them. Here are a few cheat sheets I have found useful but please feel free to adopt or create your own.

[FOSSwire Unix/Linux Command Cheat Sheet](https://files.fosswire.com/2007/08/fwunixrefshot.png) 
<p align="center">
<img src="https://files.fosswire.com/2007/08/fwunixrefshot.png" width="600">
</p>

[Bash & zsh Terminal Basics Cheat Sheet](https://images.datacamp.com/image/upload/v1700048361/Bash_Cheat_Sheet_4503e68287.png)
<p align="center">
<img src="https://images.datacamp.com/image/upload/v1700048361/Bash_Cheat_Sheet_4503e68287.png" width="600">
</p>


## Zsh as compared to bash

`zsh` (Z Shell) is an extended version of `bash` (Bourne Again SHell) with many improvements and additional features. `zsh` includes many of the features of `bash`, but it enhances them with better scriptability, spell check for command entry, extended file globbing, improved variable handling, and more. It also incorporates features from other shells such as `ksh` and `tcsh`. One of the notable features of `zsh` is its themeable and highly customizable prompt. Additionally, `zsh` has a powerful completion system that can be used to create complex command-line completions.

That said, most unix high-performance compute servers and resources come with `bash` as the default shell, and `zsh` scripts are not backwards compatible by default with `bash`. For this reason, I recommend sticking with `bash` for your scripting and if you need advanced computational scripting support, utilizing a more powerful and flexible scripting language such as `python`.

It's also important to note that as of macOS Catalina, `zsh` has replaced `bash` as the default shell, so Mac users may need to adapt to `zsh` going forward or [revert their shell to `bash`](https://www.howtogeek.com/444596/how-to-change-the-default-shell-to-bash-in-macos-catalina/#:~:text=Apple%20now%20uses%20Zsh%20as,in%20Terminal%20and%20reopen%20it.). Users should test their scripts and environment setup when switching between the shells to ensure compatibility.

<details>

<summary>

### Users transitioning from `bash` to `zsh` should be aware of the following changes:

</summary>

 * **Syntax Differences:** While `zsh` is largely compatible with `bash`, there are syntax differences that can affect scripts. For example, `zsh` handles loop syntax and conditionals slightly differently and has different expansion rules for some pattern matches.

 * **Scripting:** Scripts written for `bash` might need adjustments to run on `zsh` due to the differences in shell built-ins and behavior.
 ****Configuration Files:** `zsh` uses different configuration files (`.zshrc`, `.zshenv`, `.zprofile`, and `.zlogin`) compared to `bash` (`.bashrc`, `.bash_profile`, `.bash_login`, and `.profile`).

 * **Startup/Interactive Shells:** `zsh` and `bash` have different rules for which configuration files they read on startup, depending on whether the shell is a login shell or an interactive shell.
- **Completion System:** `zsh`'s autocompletion is more robust and provides better context-sensitive options than `bash`.

</details>

# Sampling and study design

Microbial genomics is a powerful tool in understanding the genetics of microorganisms. This section outlines key considerations in the study design and sampling for various applications in microbial genomics.

## Determine your goals

Determining clear goals before embarking on microbial genomics sequencing and analyses is crucial for several reasons:
1.  Firstly, it guides the choice of sequencing technology, as different platforms offer varying read lengths, accuracies, and throughputs, which can significantly impact the resolution and quality of genomic data. For instance, short-read sequencing might suffice for single nucleotide polymorphism (SNP) analysis, but long-read sequencing is more suitable for resolving complex genomic structures. 
2. Secondly, well-defined objectives help in designing the experiment, including sample collection, preparation, and the depth of sequencing required. This is especially important in microbial genomics where variables like bacterial diversity, genome size, and the presence of plasmids or mobile genetic elements can influence experimental design. Moreover, clear goals ensure that the subsequent data analysis is focused and relevant. Different bioinformatics tools and pipelines are better suited to specific types of analysis, such as gene expression profiling, variant calling, or metagenomic analysis. 
3. Finally, and perhaps most importantly, having a clear understanding of the project's aims ensures efficient use of resources and time, and aids in the interpretation and relevance of the findings, thereby enhancing the scientific value and impact of the research. 

In summary, clear, well-defined goals are the cornerstone of a successful microbial genomics project, ensuring that the right questions are asked, and the most suitable methods are employed to answer them effectively.

Below is a non-exhaustive set of reasons you may want to generate and/or analyze microbial genomics data. 

### Generating a Reference Isolate for a Microbiology Experiment
- **Objective**: To create a well-characterized reference isolate that can be used as a standard for comparison in microbiological studies.
- **Methodology**:
	- Isolate Selection: Choose a representative isolate from a known source.
	- Whole Genome Sequencing (WGS): Perform WGS to obtain a complete genetic profile.
	- Annotation: Annotate the genome to identify genes, operons, regulatory elements, etc.
- **Considerations**:
	- Purity of Culture: Ensure the isolate is pure and not contaminated with other microorganisms.
	- Reproducibility: The isolate should be easy to culture and maintain to ensure reproducibility in experiments.
	- Level of completeness needed: Depending on the planned use of your reference, you may need to consider if short-reads, long-reads, or a combination of both are needed.

### Confirming a Mutation Following Genetic Modification
- **Objective**: To confirm the presence and correctness of introduced mutations, as well as to assess for potential off-target mutations.
- **Methodology**:
	- **PCR and Sanger Sequencing**: For specific, targeted mutations. Does not provide insights for potential off-target mutations.
	- **Whole Genome Sequencing**: For a comprehensive overview and to check for off-target effects.
- **Considerations**:
	- Target Verification: Verify that the mutation occurs at the intended site.
	- Off-target Analysis: Screen for unintended mutations elsewhere in the genome.

### Pathogen Identification and Characterization
- **Objective**: To identify unknown pathogens and characterize known ones, including studying antibiotic resistance mechanisms (AMR).
- **Methodology**:
	- 16S rRNA Sequencing: For bacterial identification.
	- Whole genome sequencing: For bacterial identification as well as genetic content identification. 
	- AMR Gene Analysis: Using WGS to identify resistance genes.
	- Virulence Gene Analysis: Using WGS to identify known virulence genes.
	- Phylogenetics: Using WGS from multiple isolates to characterize a pathogen in terms of known isolates. 
- **Considerations**:
	- Sample Source: Clinical, environmental, or other.
	- Extraction and library preparation methodology. 
	- Data Analysis Plan: Bioinformatics tools for sequence alignment, phylogenetics, and resistance gene identification.

### Outbreak Investigation
- **Objective**: To trace the source and transmission pathway of infectious disease outbreaks.
- **Methodology**:
	- **Same methods as pathogen identification**
	- **Epidemiological Linking**: Combining genomic data with epidemiological information.
	- **Phylogenetic Analysis**: To understand the relationship between isolates.
- **Considerations**
	- Timeliness: Rapid sequencing and analysis are crucial in outbreak settings.
	- Spatial and Temporal Sampling: Important for tracking the spread and evolution of the pathogen.

### Epidemiology Surveillance
- **Objective**: To monitor the population structure of pathogens and identify genomic factors associated with virulence or environmental adaptation.
- **Methodology**:
	- **Same methods as pathogen identification**
	- **Pan-genome Analysis**: To study the core and accessory genomes.
	- **Association Studies**: Correlating genomic features with clinical/environmental factors.
- **Considerations**
	- Population Sampling: Representativeness of the samples to the population.
	- Data Integration: Combining genomic data with clinical, environmental, and other relevant data.

In conclusion, microbial genomics requires careful consideration of study design and sampling, with methodologies tailored to the specific objectives of the study. The integration of genomic data with clinical, environmental, and epidemiological information is key to unlocking the full potential of microbial genomics in understanding and combating microbial diseases.


## Sampling Considerations for Microbial Genomics

Proper sampling is crucial in microbial genomics to ensure that the data obtained accurately represents the bacterial isolate being studied. This process varies depending on the source of the sample, such as clinical isolates, environmental isolates, and isolates from animal models.

### Collecting Samples

#### Clinical Isolates
- **Source**: Typically obtained from human tissues, fluids (like blood, urine), or swabs (throat, skin).
- **Considerations**:
  - Ensure sterile collection to prevent contamination.
  - Timing is crucial, especially in infection outbreaks.
  - Ethical considerations and patient consent are paramount.

#### Environmental Isolates
- **Source**: Soil, water, air, or surfaces in various environments.
- **Considerations**:
  - Diverse microbial community; hence, selective culturing might be necessary.
  - Consider environmental factors (pH, temperature, humidity) at the time of collection.
  - Potential for contamination with foreign material is high.

#### Isolates from Animal Models
- **Source**: Similar to clinical isolates but from animals used in research.
- **Considerations**:
  - Ethical considerations and adherence to animal welfare regulations.
  - Sampling should minimize stress or harm to the animal.
  - Consider the microbiome of the animal and its impact on the isolate.

### Culturing/Purifying Isolates

- **Objective**: To obtain a pure culture of the bacterial isolate.
- **Methods**:
  - Use of selective media to encourage the growth of the target organism.
  - Incubation conditions tailored to the growth requirements of the bacteria (temperature, oxygen levels).
- **Considerations**:
  - Avoid cross-contamination with other microbes.
  - Repeated streaking or single colony isolation might be necessary for purity.
  - Validation of the isolate's identity (e.g., through biochemical tests, PCR).

### Preparing for Sequencing

- **DNA Extraction**: Efficient extraction methods to obtain high-quality, high-purity genomic DNA.
- **Quality Control**: Assessing DNA quality (purity and integrity) before sequencing.
- **Quantification**: Accurate DNA quantification to ensure optimal input for sequencing library preparation.
- **Considerations**:
  - Avoidance of DNA shearing or degradation during extraction.
  - Use of appropriate library preparation kits based on the sequencing platform and the specifics of the isolate.

In conclusion, each step in the sampling process for microbial genomics is critical. Proper handling, culturing, and preparation of bacterial isolates, tailored to their source and characteristics, are essential for ensuring high-quality genomic data that accurately reflects the organism of interest.
 
# Sequencing
## A Brief History of Microbial Sequencing

Microbial sequencing has revolutionized our understanding of microorganisms and their role in health, disease, and the environment. Here's a concise timeline of key milestones in the history of microbial sequencing:

### 1977: Sanger Sequencing
- **Development of Sanger Sequencing**: Fred Sanger and colleagues developed the chain-termination method for DNA sequencing. This method was first applied to sequence the genome of the bacteriophage ΦX174.

### 1995: First Bacterial Genome Sequenced
- **Haemophilus influenzae Sequenced**: The first complete genome of a free-living organism, the bacterium *Haemophilus influenzae*, was sequenced. This milestone was achieved using Sanger sequencing and marked the beginning of genomics.

### Early 2000s: Shotgun Sequencing
- **Advent of Shotgun Sequencing**: This period saw the rise of shotgun sequencing, a method that involves breaking DNA into random fragments and then reassembling the sequences. It was used extensively in microbial genomics.

### 2005: Next-Generation Sequencing
- **Introduction of Next-Generation Sequencing (NGS)**: NGS technologies emerged, allowing massively parallel sequencing. This led to a significant increase in speed and a reduction in cost, revolutionizing microbial sequencing.

### 2010s: Third-Generation Sequencing
- **Third-Generation Sequencing Technologies**: Technologies such as single-molecule real-time sequencing (PacBio) and nanopore sequencing (Oxford Nanopore) provided longer reads and faster turnaround times, further enhancing microbial genomics research.

### Present and Future
- **Ongoing Developments**: Microbial sequencing continues to evolve, with improvements in speed, accuracy, and cost. It's now a cornerstone in research and diagnostics, offering insights into microbial diversity, evolution, and pathogenesis.

The journey of microbial sequencing reflects a broader evolution of genomic sciences, with each technological advance opening new frontiers in research and application.

## Currently available technologies

Microbial genomics has greatly benefited from various sequencing technologies, each offering unique advantages. Below are the key technologies currently in use:

### Short read sequencing technologies

#### Illumina Sequencing (Next-Generation Sequencing - NGS)
- **Overview**: Illumina platforms, known for their high-throughput sequencing, are widely used for microbial genomics. They offer short but highly accurate reads.
- **Key Features**:
  - High accuracy and throughput.
  - Suitable for whole-genome sequencing, metagenomics, and targeted sequencing.
  - Limitations include shorter read lengths, which can be challenging for genome assembly in complex regions.
- **Limitations**:
  - Short Read Length: While highly accurate, Illumina sequencing produces short reads (usually 150-300 base pairs), which can be a challenge in assembling complex genomes or in regions with high repetitive content.
  - Genomic Complexity: Short reads may not fully resolve complex genomic structures like repeats and structural variants.
  - **Library Preparation and Amplification Bias**: The process of preparing DNA for sequencing can introduce biases and errors if library preparation kits with PCR amplification are utilized.
  
#### Ion Torrent Sequencing
- **Overview**: Ion Torrent systems use semiconductor technology for sequencing. They are known for their speed and are useful in various applications.
- **Key Features**:
  - Faster turnaround times.
  - Suitable for rapid sequencing applications like pathogen identification.
  - Lower throughput compared to Illumina and longer reads than traditional NGS but shorter than PacBio or ONT.
- **Limitations**:
  - Homopolymer Errors: Ion Torrent technology is prone to errors in homopolymer regions (stretches of the same DNA base), which can affect accuracy.
  - Throughput Limitations: Lower throughput compared to Illumina, making it less suitable for large-scale genomics projects.
  - Sensitivity to Starting Material: Like other sequencing technologies, the quality and quantity of the starting DNA material can significantly impact the results.
  
#### Sanger Sequencing
There are lots of different companies that offer equipment that can generate sanger sequencing data, and not all technologies are identical. Be sure to check the specifics of the technology you are using if you choose to generate sanger sequencing data. 

- **Overview**: Sanger sequencing is based on the selective incorporation of chain-terminating dideoxynucleotides (ddNTPs) during DNA replication. It results in DNA fragments of varying lengths that can be separated and read to determine the DNA sequence.
- **Key Features**:
	- Accuracy: Sanger sequencing is known for its high accuracy in base calling, making it ideal for confirming specific mutations or modifications.
	- Read Length: It typically provides read lengths of up to 900 base pairs, sufficient for many targeted sequencing applications.
	- Cost-Effectiveness: For small-scale sequencing projects, such as confirming a single genetic modification, Sanger sequencing is cost-effective compared to high-throughput next-generation sequencing (NGS) methods.
 - **Limitations**:
	- Throughput: Not suitable for large-scale sequencing projects due to lower throughput compared to NGS technologies.
	- Fragment Size: Limited to sequencing smaller DNA fragments, which can be a constraint for some applications.

### Long read sequencing technologies 

#### Oxford Nanopore Technologies (ONT)
- **Overview**: ONT offers portable real-time sequencing with their MinION and other devices. They provide long reads and are highly flexible in terms of deployment.
- **Key Features**:
  - Real-time sequencing capability.
  - Portable and flexible, suitable for field-based microbial genomics studies.
  - Long reads are advantageous for complete genome assembly, but with a higher error rate than short-read technologies.
 - **Limitations**:
	- Error Rate: ONT sequencing has a higher error rate compared to both Illumina and PacBio, particularly in base substitution errors. This is partially due to the ability of ONT sequencing to detect methylation and base-modifications, which depending on the model used for base calling, can impact error rates if not included. 
	- Data Quality and Quantity: The quality of the data can be variable across runs and library preparation kits, and throughput may be lower than Illumina sequencing, depending on the specific platform and experiment setup.
	- Dependency on Sample Quality: Long-read technologies like ONT are more sensitive to DNA degradation and require high-quality samples.
  
#### PacBio Sequencing
- **Overview**: Pacific Biosciences (PacBio) provides long-read sequencing, capable of reading longer DNA fragments in a single run.
- **Key Features**:
  - Long reads improve genome assembly and detection of structural variants.
  - Higher error rate compared to Illumina but can be mitigated by increased coverage.
  - Useful in studying complex genomic regions and repeat sequences.
- **Limitations**:
  - Higher Error Rate: PacBio sequencing has a higher raw error rate compared to Illumina, particularly in the form of insertion-deletion errors (though these can be mitigated through consensus sequencing).
  - Cost: Generally more expensive per base than Illumina sequencing, which can be a limiting factor for large-scale projects.
  - Longer Run Times: PacBio machines typically have longer run times, which can delay results.

### How do I pick which one to use? 
Each sequencing technology has its strengths and limitations. The choice of technology depends on the specific requirements of a microbial genomics project, such as read length, accuracy, throughput, and cost.

The continuous evolution of these technologies is expanding the horizons of microbial research, enabling more detailed and comprehensive genomic studies.


 
# Sequencing quality assessment and control
## Short read QC/QA 
### FastQC
### FastQC Alternatives
#### Raspberry 
### MultiQC 
## Long read QC/QA
### NanoPlot and associated scripts
### pycoQC	
 
# Assembly 
## Short read assembly
### Spades
## Long read assembly
### Flye

# Assembly QC/QA
## Quast
## Bandage
## Busco and CheckM








