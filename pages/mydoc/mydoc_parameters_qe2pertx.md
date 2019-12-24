---
title: Parameters for qe2pert.x 
sidebar: mydoc_sidebar
last_updated: Decemer 19, 2019
permalink: mydoc_parameters_qe2pertx.html
folder: mydoc
toc: false
---
## Parameters for 


<html>
<body>


<table style="width=600">
<!--<table style="text-align:center" width=600>-->
  <col width="150">
  <col width="150">
  <col width="300">

<tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>

  <tr>
      <td>prefix</td>
      <td>string</td>
      <td>Job name prefix. It should be the same as the prefix used in QE</td>
  </tr>
  <tr>
      <td>outdir</td>
      <td>string</td>
      <td>Name of the directory where the QE nscf output directory prefix.save is located, and where the e-ph matrix elements prefix_elph.h5 will be stored</td>
  </tr>
  <tr>
      <td>phdir</td>
      <td>string</td>
      <td>Name of the directory where the phonon "save" directory is located</td>
  </tr>
  <tr>
      <td>qe_band_min</td>
      <td>intger</td>
      <td>Lowest band index used in Wannier90; the default is 1</td>
  </tr>
  <tr>
      <td>qe_band_max</td>
      <td>intger</td>
      <td>Highest band index used in Wannier90; the default is 10000</td>
  </tr>
  <tr>
      <td>num_wann</td>
      <td>intger</td>
      <td>Number of Wannier functions</td>
  </tr>
  <tr>
      <td>system_2d</td>
      <td>logical</td>
      <td>Set it to .true. if the system is 2D; the default is .false.</td>
  </tr>
  <tr>
      <td>nk1, nk2, nk3</td>
      <td>intger</td>
      <td>Number of k points along each dimension used in the Wannierization</td>
  </tr>
  <tr>
      <td>debug</td>
      <td>logical</td>
      <td>Set to .true. to turn on the debug mode (the default is .false.)</td>
  </tr>
  <tr>
      <td>lwannier</td>
      <td>logical</td>
      <td>Set to .true. to rotate the wavefunctions using Wannier unitary matrix before computing e-ph matrix elements (the default is .true.)</td>
  </tr>  
  <tr>
      <td>load_ephmat</td>
      <td>logical</td>
      <td>Set to .true. to load prefix_elph.h5 from the directory specified by the variable outdir (the default is .false.)</td>
  </tr>
  <tr>
      <td>eig_corr</td>
      <td>string</td>
      <td>File containing the Kohn-Sham eigenvalues (usually called prefix.eig) prefix.eig</td>
  </tr>  
  <tr>
      <td>polar_alpha</td>
      <td>real</td>
      <td>Used only in polar materials. to be consistent with rigid_bulk, enforce alpha=1.0 for lattice dynamical</td>
  </tr>  
  <tr>
      <td>asr</td>
      <td>string</td>
      <td>Acoustic sum rule; options: 'no', 'simple', 'crystal' (default)</td>
  </tr>
  <tr>
      <td>thickness_2d</td>
      <td>real</td>
      <td>Thickness of the 2d system, used in the 2D polar e-ph correction. Only needed when system_2d=.true.. The default is 6 (Å)</td>
  </tr>
</table>

</body>
</html>

