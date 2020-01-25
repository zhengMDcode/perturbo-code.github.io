---
title: Graphene (2D material) 
sidebar: mydoc_sidebar
last_updated: January 10, 2020
permalink: mydoc_tutorial_graphene.html
folder: mydoc
toc: false
---
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example05-graphene-2d/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/2ael37t601nzhnmdxbvbgr3dt1ax7aff"
target="_blank">link</a>
</span>
</div>

Run the preliminary calculations (scf, phonon, nscf, and Wannier90) in the directory _"pw-ph-wann"_. The input file for a 2D material for `qe2pert.x` requires to an extra variable, [system_2d](mydoc_param_qe2pert#system_2d) `= .true`. Here is the input file: 

```fortran
&qe2pert
  prefix='graphene'
  outdir='./tmp'
  phdir='../pw-ph-wann/phonon/References/save'
  nk1=36, nk2=36, nk3=1
  dft_band_min = 1
  dft_band_max = 11
  num_wann = 2
  lwannier = .true.
  system_2d = .true.
/
```

In the input files for `perturbo.x`, the user does not need to specify any variable related to 2D systems, since `perturbo.x` will know from the _'prefix"\_epwan.h5_. When running the calculation modes `'setup'` or `'trans'`, the carrier concentration units are cm<sup>-2</sup> instead of  cm<sup>-3</sup>. In this example, we focus only on the two bands that cross the Dirac cone of graphene. The band index is 1 for the valence and 2 for the conduction band. In the  electron mobility calculation, we set accordingly both [band_min](mydoc_param_perturbo#band_min) and [band_max](mydoc_param_perturbo#band_max) to 2. In the hole mobility calculation, both [band_min](mydoc_param_perturbo#band_min) and [band_max](mydoc_param_perturbo#band_max) are set to 1.



