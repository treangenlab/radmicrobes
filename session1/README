# Session 1 - Sampling, Sequencing, Quality Assessment and Control, and Assembly
*by Blake Hanson, MS, PhD*

<details>
 <summary>
  
  ## Session Summary</summary>
 <p></p>

 * Introduction to the Unix Shell 
 	* Unix shell learning resources
 	* Accessing the workshop computational environment
 	* Enough commands to make you dangerous
 	* Zsh as compared to bash
 	* Cheat sheets are your friend
    
 * Sampling and study design
 	* Determine your goals
 	* Sampling
 		* Working with reference isolates
 		* Clinical sampling
 	* 
 
 * Sequencing
 	* A brief history
 	* Currently available technologies
 		* Short read sequencing technologies
 			* Illumina
 			* Ion Torrent
 			* Sanger
 		* Long read sequencing technologies
 			* Oxford Nanopore
 			* PacBio  
 	* How do I pick which one to use? 
 
 * Sequencing quality assessment and control
 	* Short read QC/QA 
 		* FastQC
 		* FastQC Alternatives
 			* Raspberry 
 		* MultiQC 
 	* Long read QC/QA
 		* NanoPlot and associated scripts
 		* pycoQC	
 
 * Assembly 
 	* Short read assembly
 		* Spades
 	* Long read assembly
 		* Flye

 * Assembly QC/QA
 		* Quast
 		* Bandage
 		* Busco and CheckM
 		* 

</details>

## Introduction to the Unix Shell

### Unix shell learning resources

There are many fantastic resources that can help you start your journey using Unix and bash/zsh or help you take your skills to the next level.  A few are listed here:
 * [Happy Belly Bioinformatics](https://astrobiomike.github.io/unix/unix-intro) (Which will be used in this boot camp)
 * [Software Carpentry - The Unix Shell](https://swcarpentry.github.io/shell-novice/)
 * [Bioinformatics Workbook](https://bioinformaticsworkbook.org/Appendix/Unix/unix-basics-1.html#gsc.tab=0)

As a gentile introduction for the sessions during this workshop, we will loosely follow the [Happy Belly Bioinformatics](https://astrobiomike.github.io/unix/unix-intro) guide with some abbreviated sections to better fit our workshop.

#### A few notes before we start

In Unix-based systems, spaces in file names can often lead to confusion and scripting errors, as the space character is a delimiter that separates command line arguments. To avoid these issues, it's recommended to use dashes (-) or underscores (_) instead of spaces in file names.

These characters provide visual separation between words in a file name while ensuring the name is interpreted as a single entity by the shell and other command-line tools. 

For instance, instead of naming a file `My Document.txt`, you would name it `My-Document.txt` (using dashes) or `My_Document.txt` (using underscores). 

This naming convention enhances readability and makes it easier to handle files in scripts or command-line operations. When typing commands, you can simply refer to the file without needing to wrap the name in quotes or escape the spaces. Adopting this practice is especially beneficial in scripting and programming, where consistency and predictability in file names are essential.

It is equally important to adopt this practice for folder names in addition to file names. Spaces in folder names, like in file names, can lead to unexpected behavior or errors in various scripts, software programs, and command-line operations. By using dashes or underscores in folder names, you avoid potential complications that arise from spaces being misinterpreted as argument separators or requiring additional handling such as escape characters or quotes. 

### Accessing the workshop computational environment

### Enough commands to make you dangerous

#### Navigating the Filesystem:

 * `pwd` (Print Working Directory)
   - **Description:** Shows the current directory path.
   - **Example:** 
     ```
     pwd
     ```

 * `ls` (List)
   - **Description:** Lists files and directories in the current directory.
   - **Example:** 
     ```
     ls
     ```

 * `cd` (Change Directory)
   - **Description:** Changes the current directory.
   - **Example:** To change to a directory named `Documents`:
     ```
     cd Documents
     ```

 * `mkdir` (Make Directory)
   - **Description:** Creates a new directory.
   - **Example:** To create a new directory named `TestFolder`:
     ```
     mkdir TestFolder
     ```

 * `touch`
   - **Description:** Creates an empty file or updates the timestamp of an existing file.
   - **Example:** To create a new file named `example.txt`:
     ```
     touch example.txt
     ```

 * `rmdir ` (Remove Directory)
   - **Description:** Deletes an empty directory.
   - **Example:** To remove a directory named `OldFolder`:
     ```
     rmdir TestFolder
     
     #This is functionally the same as rm -r, which is discussed below
     rm -r TestFolder
     ```
     
     
     STEPS to work out and screenshot on infrastructure
     - PWD
     - ls -s vs ls -l
     - mkdir TestFolder
     - cd TestFolder
     - touch example.txt
     - nano example.txt
     	- Add text
     - close nano
     - ls
     - cat
     - head vs tail
     - cp example.txt example_copy.txt
     - rm example_copy.txt
     - cd ../
     - ls
     - cp TestFolder TestFolder_copy
     - rm -r TestFolder_copy
     - ls 
     


### Zsh as compared to bash

`zsh` (Z Shell) is an extended version of `bash` (Bourne Again SHell) with many improvements and additional features. `zsh` includes many of the features of `bash`, but it enhances them with better scriptability, spell check for command entry, extended file globbing, improved variable handling, and more. It also incorporates features from other shells such as `ksh` and `tcsh`. One of the notable features of `zsh` is its themeable and highly customizable prompt. Additionally, `zsh` has a powerful completion system that can be used to create complex command-line completions.

That said, most unix high-performance compute servers and resources come with `bash` as the default shell, and `zsh` scripts are not backwards compatible by default with `bash`. For this reason, I recommend sticking with `bash` for your scripting and if you need advanced computational scripting support, utilizing a more powerful and flexible scripting language such as `python`.

It's also important to note that as of macOS Catalina, `zsh` has replaced `bash` as the default shell, so Mac users may need to adapt to `zsh` going forward or [revert their shell to `bash`](https://www.howtogeek.com/444596/how-to-change-the-default-shell-to-bash-in-macos-catalina/#:~:text=Apple%20now%20uses%20Zsh%20as,in%20Terminal%20and%20reopen%20it.). Users should test their scripts and environment setup when switching between the shells to ensure compatibility.

<details>
<summary>
#### Users transitioning from `bash` to `zsh` should be aware of the following changes:
</summary>
- **Syntax Differences:** While `zsh` is largely compatible with `bash`, there are syntax differences that can affect scripts. For example, `zsh` handles loop syntax and conditionals slightly differently and has different expansion rules for some pattern matches.
- **Scripting:** Scripts written for `bash` might need adjustments to run on `zsh` due to the differences in shell built-ins and behavior.
- **Configuration Files:** `zsh` uses different configuration files (`.zshrc`, `.zshenv`, `.zprofile`, and `.zlogin`) compared to `bash` (`.bashrc`, `.bash_profile`, `.bash_login`, and `.profile`).
- **Startup/Interactive Shells:** `zsh` and `bash` have different rules for which configuration files they read on startup, depending on whether the shell is a login shell or an interactive shell.
- **Completion System:** `zsh`'s autocompletion is more robust and provides better context-sensitive options than `bash`.

</details>


### Cheat sheets are your friend 

There are many different cheat sheets on the internet that have similar but unique sets of reference commands and details on them. Here are a few cheat sheets I have found useful but please feel free to adopt or create your own.

[FOSSwire Unix/Linux Command Cheat Sheet](https://files.fosswire.com/2007/08/fwunixrefshot.png) 
<p align="center">
<img src="https://files.fosswire.com/2007/08/fwunixrefshot.png" width="600">

[Bash & zsh Terminal Basics Cheat Sheet](https://images.datacamp.com/image/upload/v1700048361/Bash_Cheat_Sheet_4503e68287.png)
<p align="center">
<img src="https://images.datacamp.com/image/upload/v1700048361/Bash_Cheat_Sheet_4503e68287.png" width="600">


## Sampling and study design



## Sequencing 


## Quality assessment and control


## Assembly








