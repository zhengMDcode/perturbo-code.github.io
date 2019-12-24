---
title: GaAs (polar material)
sidebar: mydoc_sidebar
last_updated: Decemer 19, 2019
permalink: mydoc_tutorial_gaas.html
folder: mydoc
toc: false
---

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b> examples/example04-gaas-polar  </div>

Example calculation in a polar material with long-range e-ph interactions

Run the calculations in the directory "pw-ph-wann" to obtain the data needed to run qe2pert.x. Run qe2pert.x to get _prefix\_epwan.h5_, which is required for all calculations using perturbo.x.

The input file for each calculation using perturbo.x is similiar to the silicon case ("examples/example01-silicon-perturbo"). The main difference is the 'imsigma' calculation, where users can use a variable called _polar\_split_ to specify whether they want to compute the full matrix element (polar plus non-polar part), or just the polar or nonpolar part. For the long-range (polar) part, we set _polar\_split_ 'polar' in the input file. In this example, we use 'cauchy' for q-point importance _sampling_ and set the variable _cauchy\_scale_ for the Cauchy distribution. For the short-range (nonpolar) part, we use 'rmpol' for the variable _polar\_split_ and 'uniform' for _sampling_. Remember to converge both the long- and short-range parts of the e-ph matrix elements with respect to the number of q-points (the variable _nsamples_). If _polar_split_ is not specified, perturbo.x will compute e-ph matrix elements including both the short- and long-range interactions, which typically has a slow convergence with respect to number of q-points.




