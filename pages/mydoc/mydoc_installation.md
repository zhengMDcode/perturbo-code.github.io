---
title: Installation and compilation
sidebar: mydoc_sidebar
last_updated: Jan 1, 2020
permalink: mydoc_installation.html
folder: mydoc
toc: true
---


{% include note.html content="PERTURBO uses a small number of subroutines from the PWSCF and Phonon packages of QE. Therefore, it needs to be compiled on top of QE. We assume that the users have already compiled QE successfully" %}


## Download
Perturbo is distributed as a gzipped tar file, e.g. perturbo-x.x.tar.gz (x.x is the version number). 
Download perturbo-x.x.tar.gz and move it into the QE directory. 
Change into the QE directory and unpack it


```
$ cd <Quantum Espresso directory>
$ tar -xvzf perturbo-x.x.tar.gz
```

which create a directory containing the source files, utitlities, documentation, and examples. 
Change into the directory "perturbo-x.x".

```
$ cd perturbo-x.x
```

There are four subdirectories inside the directory "perturbo":

* "config" contains the system-dependent makefiles _make.sys.XXX_
* "pert-src" contains the source code of `qe2pert.x` to compute electron dynamics 
* "qe2pert-src" contains the source code of the interface program `qe2pert.x`
* "examples" has input files for examples and tutorials on `perturbo.x` and `qe2pert.x`

## Compilation
Two files in the "perturbo" directory, _Makefile_ and _make.sys_ modify _make.sys_ to make it suitable for your system or copy an existing _make.sys.XXX_ file from the directory "config".

```
$ vim make.sys
or 
$ cp ./config/make.sys.XXX ./make.sys
```

Once the file _make.sys_ has been modified, you are ready to compile PERTURBO.

```
$ make
```

After the compiling, a directory called "bin" is generated, which contains two executables, `perturbo.x` and `qe2pert.x`.
