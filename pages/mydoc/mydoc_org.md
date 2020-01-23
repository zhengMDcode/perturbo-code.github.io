---
title: Organization of the tutorials
sidebar: mydoc_sidebar
last_updated: January 10, 2020
permalink: mydoc_org.html
folder: mydoc
toc: false
---

In this section, we will go through two tutorial examples:
[TO BE MODIFIED]
* _example01-silicon-qe2pert_: to learn how to use `qe2pert.x` to generate a '_prefix'\_epwan.h5_ file

* _example02-silicon-perturbo_: to learn how to use `perturbo.x` to run perturbo calculations


The two tutorial examples and other examples can be downloaded from the GitHub repository <a href="https://github.com/perturbo-code/perturbo-examples" target="_blank">perturbo-examples</a>. Each example, except _example01_ and _example02_,  has three main directories:

* _pw-ph-wan_, which contains files for the scf, nscf, phonon, and Wannier90 calculations when running <a href="https://www.quantum-espresso.org" target="_blank">Quantum Espresso (QE)</a> 

* _qe2pert_, which contains files for running `qe2pert.x` to generate an essentail file '_prefix'\_epwan.h5_ for perturbo calculations

* _perturbo_, which contains files for running `perturbo.x`

In the <a href="https://github.com/perturbo-code/perturbo-examples" target="_blank">example repository</a>, we provide all the input files but some output files for comparison. We also provide all the input and output files in a <a href="https://caltech.app.box.com/v/perturbo-tutorial/folder/100016056569" target='_blank'>Caltech Box website</a>. Note that some of the output files have the memory size of 1-10 GB. 

For users who want to build up the essential file '_prefix'\_epwan.h5_ from scratch, we recommend to download the files from the example repository and to follow the instructions in the sections of `qe2pert.x` and `peturbo.x`. 

For users who want to play around perturbo features without building up the file '_prefix'\_epwan.h5_, please download the file _si\_epwan.h5_ in the _example02-silicon-pertubo/qe2pert/si\_epwan.h5_ from <a href="https://caltech.app.box.com/v/perturbo-tutorial/folder/100016056569" target='_blank'> this website </a> where we provide all the output files for each example. Afterwards, please follow the instructions in the `perturbo.x` section. 
