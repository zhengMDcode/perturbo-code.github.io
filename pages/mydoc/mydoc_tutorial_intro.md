---
title: Other tutorials
sidebar: mydoc_sidebar
last_updated: January 23, 2020
permalink: mydoc_tutorial_intro.html
folder: mydoc
summary: In addition to the silicon example discussed above, we provide several tutorial examples to explore the various capabilities of Perturbo. Before starting this tutorial, please read the sections on qe2pert.x and perturbo.x of this manual.
---

For each example in the tutorial, we use three directories to organize the results of the calculations: 
* _pw-ph-wan_: contains files for the scf, nscf, phonon, and Wannier90 calculations when running <a href="https://www.quantum-espresso.org" target="_blank">Quantum Espresso (QE)</a>

* _qe2pert_: contains files for running `qe2pert.x` to generate an essentail file '_prefix'\_epwan.h5_ for perturbo calculations

* _perturbo_: contains files for running `perturbo.x`

As a reminder, here are the steps needed to compute _prefix\_epwan.h5_:

* Step 1: scf calculation
* Step 2: phonon calculation
  * collect all the data into a directory called _"save"_ 
* Step 3: nscf calculation
* Step 4: Wannierization with Wannier90 
* Step 5: run `qe2pert.x`
  - soft link _'prefix'\_centres.xyz_, _'prefix'\_u.mat_ (and, when present, _'prefix'\_u\_dis.mat_) in the directory _"pw-ph-wann/wann"_
  - create a directory called _"tmp"_, and inside it soft link the QE nscf output directory _'prefix'.save_ in the  _"pw-ph-wann/nscf/tmp"_

{% include note.html content="For each `perturbo.x` calculation, it is essential to always link or copy _'prefix'\_epwan.h5_." %}
