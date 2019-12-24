---
sidebar: mydoc_sidebar
last_updated: Decemer 19, 2019
permalink: mydoc_tutorial_intro.html
folder: mydoc
summary: "In addition to the silicon example discussed above, we provide several tutorial examples to explore the various capabilities of Perturbo. Before starting this tutorial, please read the sections on perturbo.x and qe2pert.x of this manual."
---

For each example in the tutorial, we use three directories to organize the results of the calculations: 

* "pw-ph-wann" for the scf, nscf, phonon, and Wannier90 calculations
* "qe2pert" to generate _prefix\_epwan.h5_
* "perturbo" for perturbo.x calculations

As a reminder, here are the steps needed to compute _prefix\_epwan.h5_:

* Step 1: scf calculation
* Step 2: phonon calculation
  * collect all the data into a directory called "save" 
* Step 3: nscf calculation
* Step 4: Wannierization with Wannier90 
* Step 5: run qe2pert.x
  - soft link _prefix\_centres.xyz_, _prefix\_u.mat_ (and, when present, _prefix\_u\_dis.mat_) in the directory "pw-ph-wann/wann "
  - create a directory called "tmp", and inside it soft link the QE nscf output directory "prefix.save" in the  "pw-ph-wann/nscf/tmp"

For each perturbo.x calculation, it is essential to always link or copy _prefix\_epwan.h5_.5




