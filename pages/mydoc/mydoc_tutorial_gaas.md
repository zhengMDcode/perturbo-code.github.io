---
title: GaAs (polar material)
sidebar: mydoc_sidebar
last_updated: January 10, 2020
permalink: mydoc_tutorial_gaas.html
folder: mydoc
toc: false
---

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b> <a href="https://github.com/perturbo-code/perturbo-examples/tree/master/example04-gaas-polar" target="_blank"><i>perturbo-examples/example04-gaas-polar</i></a>  </div>

Example calculation in a polar material with long-range e-ph interactions.

Run the calculations in the directory _"pw-ph-wann"_ to obtain the data needed to run `qe2pert.x`. Run `qe2pert.x` to get _'prefix'\_epwan.h5_, which is required for all calculations using `perturbo.x`.

The input file for each calculation using `perturbo.x` is similiar to the silicon case (_"examples/example01-silicon-perturbo"_). The main difference is the `'imsigma'` calculation, where users can use a variable called [polar_split](mydoc_param_perturbo#polar_split) to specify whether they want to compute the full matrix element (polar plus non-polar part), or just the polar or nonpolar part. 

- For the long-range (polar) part, we set `polar_split='polar'` in the input file. In this example, we use `'cauchy'` for $$\mathbf{q}$$ point importance [sampling](mydoc_param_perturbo#sampling) and set the variable [cauchy_scale](mydoc_param_perturbo#cauchy_scale) for the Cauchy distribution. 

- For the short-range (nonpolar) part, we use `rmpolar` for the variable [polar_split](mydoc_param_perturbo#polar_split) and `'uniform'` for [sampling](mydoc_param_perturbo#sampling). 

Remember to converge both the long- and short-range parts of the e-ph matrix elements with respect to the number of $$\mathbf{q}$$ points (the variable [nsamples](mydoc_param_perturbo#nsamples)). If [polar_split](mydoc_param_perturbo#polar_split) is not specified, `perturbo.x` will compute e-ph matrix elements including both the short- and long-range interactions, which typically has a slow convergence with respect to number of $$\mathbf{q}$$ points.




