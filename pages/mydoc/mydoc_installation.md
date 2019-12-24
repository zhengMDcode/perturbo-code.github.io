---
title: Installation and compilation
sidebar: mydoc_sidebar
last_updated: Decemer 19, 2019
permalink: mydoc_installation.html
folder: mydoc
toc: true
---


{% include note.html content="PERTURBO uses a small number of subroutines from the PWSCF and Phonon packages of QE. Therefore, it needs to be compiled on top of QE. We assume that the users know how to compile QE successfully" %}


## Download
Change into the QE directory – and download PERTURBO from Github: (TO BE MODIFIED)

```
$ cd <Quantum Espresso directory>
$ git clone https://github.com/jinjianzhou/perturbo.git
```

Once PERTURBO has been downloaded, change into the directory "perturbo". (UNTAR?)

```
$ cd perturbo
```

There are four subdirectories inside the directory "perturbo":

* "configure" contains the system-dependent makefiles _make.sys.XXX_
* "pert-src" contains the source code to compute electron dynamics 
* "qe2pert-src" contains the source to convert the output from QE to the format read by PERTURBO.
* (MORE ABOUT QE2PERT)
* "examples" has input files for examples and tutorials on perturbo.x and qe2pert.x

## Compilation
Two files in the "perturbo" directory, _Makefile_ and _make.sys_ modify _make.sys_ to make it suitable for your system or copy an existing _make.sys.XXX_ file from the directory "configure".

```
$ vim make.sys
or 
$ cp ./config/make.sys.XXX ./make.sys
```

Once the file _make.sys_ has been modified, you are ready to compile PERTURBO.

```
$ make
```

After the compiling, a directory called "bin" is generated, which contains two executables, perturbo.x and qe2pert.x.
