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
 	* Cheat sheets are your friends
    
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

### Enough commands to make you dangerous

#### Useful commands for our workshop

##### Navigating the Filesystem:

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

##### File Manipulation:

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

##### Scripting and Automation 

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

##### Networking:

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


#### Navigating the Filesystem:

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

### Cheat sheets are your friends

There are many different cheat sheets on the internet that have similar but unique sets of reference commands and details on them. Here are a few cheat sheets I have found useful but please feel free to adopt or create your own.

[FOSSwire Unix/Linux Command Cheat Sheet](https://files.fosswire.com/2007/08/fwunixrefshot.png) 
<p align="center">
<img src="https://files.fosswire.com/2007/08/fwunixrefshot.png" width="600">
</p>

[Bash & zsh Terminal Basics Cheat Sheet](https://images.datacamp.com/image/upload/v1700048361/Bash_Cheat_Sheet_4503e68287.png)
<p align="center">
<img src="https://images.datacamp.com/image/upload/v1700048361/Bash_Cheat_Sheet_4503e68287.png" width="600">
</p>


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

## Sampling and study design



## Sequencing 


## Quality assessment and control


## Assembly








