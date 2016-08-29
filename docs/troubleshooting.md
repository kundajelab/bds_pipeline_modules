---
layout: default
title: {{ site.name }}
---

### /bin/bash: module: line 1: syntax error: unexpected end of file

If see the following error when you submit jobs to Sun Grid Enginee,

```
/bin/bash: module: line 1: syntax error: unexpected end of file
```

Check if your $HOME/.bashrc has any errorneous lines.

Remove the following line in you module initialization scripts ($MODULESHOME/init/bash or /etc/profile.d/modules.sh).

```
export -f module
```

### Unable to run job: unknown resource "'mem"

Replace `$HOME/.bds/bds.config` with the one in the repo.

```
$ cp /path/to/repo/bds.config $HOME/.bds/
```

### Unable to access jarfile /picard.jar

Define a shell variable `PICARDROOT` for your environment. Add the following to your `~/.bashrc` or conda `activate`:

```
export PICARDROOT=/path/to/your/picard-tool
```

### awk: cmd. line:1: fatal: division by zero attempted

This error happens when 1) picard tool's MarkDuplicate is running out of memory, 2) fastq inputs have wrong endedness (SE or PE) or 3) input raw bam is incorrect.
For 1) balance memory usage among parallel tasks, add `-no_par` or reduce max. # threads (`-nth [SMALL_NUMBER]`).
For 2) check your fastq inputs are correct (`-fastqN_1`, `-fastqN_2`, ...) and also check their endedness (SE or PE) parameters like (`-se` or `-pe`).
For 3) check if there is an error in aligning stage (in an HTML report).


### Unsupported major.minor version (java)

When running bds (BigDataScript), you get the following error if you have lower version of java or high version of java is not selected as default.

Solution:

```
$ sudo apt-get install openjdk-8-jre # for Fedora based linux (Red Hat, ...)

$ sudo yum install java-1.8.0-openjdk # for Debian based linux (Ubuntu, ...)

$ sudo update-alternatives --config java # choose the latest java as default
```


### [main_samview] random alignment retrieval only works for indexed BAM or CRAM files.

If your pipeline starts from BAM files, make sure that bam index (.bam.bai) exists together with BAM file. If not, build index with `samtools index [YOUR_BAM_FILE]`. BAM and BAI should be in the same directory.


### Fatal error: /home/leepc12/bds_atac/modules/report_*.bds

Simply re-run the pipeline with the same command. Possible bug in BDS for locking/unlocking global variables.


### ImportError: libopenblasp-r0-39a31c03.2.18.so: cannot open shared object file: No such file or directory

Dependencies are not installed correctly. Check your Anaconda Python is correctly configured for conda environments. Run `./uninstall_dependencies.sh` and then `./install_dependencies.sh` again.


### Unable to run job: unknown resource "mem"

Copy `./bds.config` to `$HOME/.bds/`.


### Error trying to find out post-mortem info on task

For fast scheduling clusters including SGE, doing post-mortem on jobs can fail in BDS. Add `clusterPostMortemDisabled = true` to your `~/.bds/bds.config`.


### java.lang.OutOfMemoryError: unable to create new native thread

Number of threads created by BDS exceeds limit (`ulimit -a`). BDS created lots of thread per pipeline (more than 20). So if you see any thread related error, check your `ulimit -a` and increase it a bit.


### Task disappeared

Check a log of failed tasks with `qacct -j [JOB_ID]` (for SGE). You job can be killed due to resource settings. Increase your walltime or max. memory (`-wt`, `-wt_APPNAME`, `-mem` or `-mem_APPNAME`) for the task of failure.


### File exists, No file or directory (related to parallel conda activations)

This is a known bug in conda [#2837](https://github.com/conda/conda/issues/2837) and has not been fixed yet even in the latest version (4.2.1). Downgrade conda to 4.0.5 or 4.0.10. 

```
Traceback (most recent call last):
  File "/home/leepc12/miniconda3/bin/conda", line 6, in <module>
    sys.exit(main())
  File "/home/leepc12/miniconda3/lib/python3.5/site-packages/conda/cli/main.py", line 48, in main
    activate.main()
  File "/home/leepc12/miniconda3/lib/python3.5/site-packages/conda/cli/activate.py", line 135, in main
    conda.install.symlink_conda(prefix, root_dir, shell)
  File "/home/leepc12/miniconda3/lib/python3.5/site-packages/conda/install.py", line 596, in symlink_conda
    symlink_conda_hlp(prefix, root_dir, where, symlink_fn)
  File "/home/leepc12/miniconda3/lib/python3.5/site-packages/conda/install.py", line 613, in symlink_conda_hlp
    symlink_fn(root_file, prefix_file)
FileExistsError: [Errno 17] File exists: '/home/leepc12/miniconda3/bin/conda' -> '/home/leepc12/miniconda3/envs/bds_atac/bin/conda'

Traceback (most recent call last):
  File "/home/leepc12/miniconda3/bin/conda", line 6, in <module>
    sys.exit(main())
  File "/home/leepc12/miniconda3/lib/python3.5/site-packages/conda/cli/main.py", line 48, in main
    activate.main()
  File "/home/leepc12/miniconda3/lib/python3.5/site-packages/conda/cli/activate.py", line 135, in main
    conda.install.symlink_conda(prefix, root_dir, shell)
  File "/home/leepc12/miniconda3/lib/python3.5/site-packages/conda/install.py", line 596, in symlink_conda
    symlink_conda_hlp(prefix, root_dir, where, symlink_fn)
  File "/home/leepc12/miniconda3/lib/python3.5/site-packages/conda/install.py", line 610, in symlink_conda_hlp
    os.remove(prefix_file)
FileNotFoundError: [Errno 2] No such file or directory: '/home/leepc12/miniconda3/envs/bds_atac_py3/bin/conda'
```

### Exception in thread "main" java.lang.NumberFormatException: For input string: "40G"

Do not use `-mem` in your command line. Use '-memory` instead.

```
$ bds chipseq.bds -mem 40G
Picked up _JAVA_OPTIONS: -Xms256M -Xmx1024M -XX:ParallelGCThreads=1
Exception in thread "main" java.lang.NumberFormatException: For input string: "40G"
        at java.lang.NumberFormatException.forInputString(NumberFormatException.java:65)
        at java.lang.Long.parseLong(Long.java:589)
        at java.lang.Long.parseLong(Long.java:631)
        at org.bds.lang.Type.parse(Type.java:334)
        at org.bds.BdsParseArgs.parseArgs(BdsParseArgs.java:207)
        at org.bds.BdsParseArgs.initializeArgs(BdsParseArgs.java:150)
        at org.bds.BdsParseArgs.initializeArgs(BdsParseArgs.java:106)
        at org.bds.BdsParseArgs.parse(BdsParseArgs.java:172)
        at org.bds.Bds.runCompile(Bds.java:872)
        at org.bds.Bds.run(Bds.java:815)
        at org.bds.Bds.main(Bds.java:182)
```

# Contributors

* Jin wook Lee - PhD Student, Mechanical Engineering Dept., Stanford University
* Anshul Kundaje - Assistant Professor, Dept. of Genetics, Stanford University
