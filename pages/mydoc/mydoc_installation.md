---
title: Download and Installation
sidebar: mydoc_sidebar
last_updated: March 13, 2020
permalink: mydoc_installation.html
folder: mydoc
toc: true
---

<head>
<link rel="stylesheet" href="css/my_style.css">
</head>

{% include note.html content="PERTURBO uses a small number of subroutines from the PWSCF and Phonon packages of QE. Therefore, it needs to be compiled on top of QE. We assume that the users have already compiled QE successfully. The supported version of QE is 6.4.1. Compatibility with the version 6.5 will be provided soon." %}


## Download

In order to download the source code, contact us
(<a class="email" title="{{site.download_title}}" href="#" onclick="javascript:window.location='mailto:{{site.feedback_email}}?subject={{site.feedback_subject_line}} &body={{site.feedback_body}}' ">click here{{feedback_text}}</a>) and we will:

- [Recommended] add you as a collaborator in our GitHub project
- [If you do not have a GitHub account] send you a _.tar.gz_ file.

<p style="color:gray">If the <a class="email" title="{{site.download_title}}" href="#" onclick="javascript:window.location='mailto:{{site.feedback_email}}?subject={{site.feedback_subject_line}} &body={{site.feedback_body}}' ">contact link{{feedback_text}}</a> does not work, <a href="#contact_box">see here the intructions</a>.</p>

<!--
Perturbo is distributed as a gzipped tar file, e.g. _perturbo-x.x.tar.gz_ (x.x is the version number). 
Download _perturbo-x.x.tar.gz_ and move it into the QE directory. 
Change into the QE directory and unpack it


```bash
$ cd <Quantum Espresso directory>
$ tar -xvzf perturbo-x.x.tar.gz
```

which creates a directory containing the source files, utitlities, documentation, and examples. 
Change into the directory _"perturbo-x.x"_.

```bash
$ cd perturbo-x.x
```
-->

Clone from GitHub (or extract _.tar.gz_) into the QE directory.
There are three subdirectories inside the directory _"perturbo"_:

* _"config"_ contains the system-dependent makefiles _make.sys.XXX_
* _"pert-src"_ contains the source code of `perturbo.x` to compute electron dynamics 
* _"qe2pert-src"_ contains the source code of the interface program `qe2pert.x`

<!--
* _"examples"_ has input files for examples and tutorials on `perturbo.x` and `qe2pert.x`
-->

The source code is supplemented by the tutorial examples input and output files. More details about the examples can be found in the [Organization](mydoc_org.html) section.

## Installation
There are two files in the _"perturbo"_ directory, _Makefile_ and _make.sys_. PERTURBO uses the config file _make.inc_ of QE for most of the compiler options. The config file _make.sys_ inside the directory _“perturbo”_ specifies additional options required by PERTURBO.
Modify _make.sys_ to make it suitable for your system, such as the OpenMP options and path to the HDF5 library (not needed if HDF5 library is already specified in make.inc of QE).

```bash
$ vim make.sys
```

Once the file _make.sys_ has been modified, you are ready to compile PERTURBO.

```bash
$ make
```

After the compiling, a directory called _"bin"_ is generated, which contains two executables, `perturbo.x` and `qe2pert.x`.

<br>
<hr>

<a name="contact_box">
<div class="my_code_box">
<b>If the contact link does not work</b>, in order to get access to the code, please write us an email to <link rel="stylesheet" href="css/my_style.css"><link rel="stylesheet" href="css/my_style.css">[perturbo AT caltech.edu] and provide the following information about you:
<br><br>
Name: 
<br>
Organization: 
<br>
Country:
<br>
I am going to use PERTURBO for: 
<br>
GitHub username:
<br>
</div>
