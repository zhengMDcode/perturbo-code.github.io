---
title: Silicon (with spin-orbit coupling)
sidebar: mydoc_sidebar
last_updated: January 10, 2020
permalink: mydoc_tutorial_si.html
folder: mydoc
toc: false
---

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b> <i>examples/example03-silicon-soc</i>  </div>

Run qe2pert.x and perturbo.x on silicon with spin-orbit coupling

The input files can be found in the directory _"pw-ph-wann"_. Remember to run scf, nscf and Wannier90 calculations that include spinor-related variables. Once the DFT and DFPT calculations are completed, we run `qe2pert.x` to generate _'prefix'\_epwan.h5_. In the input file for `qe2pert.x` (_"qe2pert/pert.in"_) the user does not need to specify any spinor-related variables since `qe2pert.x` is able to detect that spin-orbit coupling (SOC) was used in DFT. Here is the input file (_pert.in_):

```fortran
&qe2pert
 prefix='si'
 outdir='./tmp'
 phdir='../pw-ph-wann/phonon/References/save'
 nk1=8, nk2=8, nk3=8
 dft_band_min = 1
 dft_band_max = 32
 num_wann = 16
 lwannier=.true.
/
```

The input file is similar to the one for silicon without SOC (_"examples/example02-silicon-qe2pert"_). We only need to double the number of Wannier functions ([num_wann](mydoc_param_qe2pert#num_wann) variable) and DFT bands ([dft_band_min](mydoc_param_qe2pert#dft_band_min) and [dft_band_max](mydoc_param_qe2pert#dft_band_max)) in the input file. 

The input files for `perturbo.x` are also similar to the silicon calculations without SOC, except for the band range given by [dft_band_min](mydoc_param_qe2pert#dft_band_min) and [dft_band_max](mydoc_param_qe2pert#dft_band_max). Each calculation is the same as in the silicon example without SOC.

