---
title: Tutorials
sidebar: mydoc_sidebar
last_updated: January 10, 2020
permalink: mydoc_tutorial_intro.html
folder: mydoc
summary: In addition to the silicon example discussed above, we provide several tutorial examples to explore the various capabilities of Perturbo. Before starting this tutorial, please read the sections on qe2pert.x and perturbo.x of this manual.
---

For each example in the tutorial, we use three directories to organize the results of the calculations: 

* _"pw-ph-wann"_ for the scf, nscf, phonon, and Wannier90 calculations
* _"qe2pert"_ to generate _prefix\_epwan.h5_
* _"perturbo"_ for `perturbo.x` calculations

As a reminder, here are the steps needed to compute _prefix\_epwan.h5_:

* Step 1: scf calculation
* Step 2: phonon calculation
  * collect all the data into a directory called _"save"_ 
* Step 3: nscf calculation
* Step 4: Wannierization with Wannier90 
* Step 5: run `qe2pert.x`
  - soft link _'prefix'\_centres.xyz_, _'prefix'\_u.mat_ (and, when present, _'prefix'\_u\_dis.mat_) in the directory _"pw-ph-wann/wann"_
  - create a directory called _"tmp"_, and inside it soft link the QE nscf output directory _'prefix'.save_ in the  _"pw-ph-wann/nscf/tmp"_

{% include note.html content="For each `perturbo.x` calculation, it is essential to always link or copy _prefix\_epwan.h5_." %}
