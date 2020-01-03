---
title: Parameters for perturbo.x
sidebar: mydoc_sidebar
last_updated: Decemer 19, 2019
permalink: mydoc_parameters_perturbox.html
folder: mydoc
toc: false
---

<html>		
 <body>		

<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
  text-align: left;    
}
</style>


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
      <td colspan="3" >JOB CONTROL</td>
  </tr>
  <tr>
      <td>prefix</td>
      <td>string</td>
      <td>Job name prefix. It should be the same as the prefix used in QE</td>
  </tr>
  <tr>
      <td>calc_mode</td>
      <td>string</td>
      <td>Calculation mode:'setup', 'bands', 'phdisp', 'ephmat', 'imsigma', 'meanfp', 'trans', 'trans-pp', 'dynamics-run', 'dynamics-pp' the last two are beta versions</td>
  </tr>
  <tr>
      <td>fklist</td>
      <td>string</td>
      <td>Name of the file containing the k-point list (in crystal unit)</td>
  </tr>
  <tr>
      <td>fqlist</td>
      <td>string</td>
      <td>Name of the file containing the q-point list (in crystal unit)</td>
  </tr>
  <tr>
      <td>ftemper</td>
      <td>string</td>
      <td>Name of the file containing values for the temperature (K), chemical potential (eV), and carrier concentration (cm<sup>-2</sup> or cm<sup>-3</sup>)</td>
  </tr>
  <tr>
      <td>debug</td>
      <td>logical</td>
      <td>.true. turns on the debug mode; the default is .false.</td>
  </tr>
  <tr>
      <td>hole</td>
      <td>logical</td>
      <td>Set to .true. for calculations on hole carriers; the default is .false.</td>
  </tr>
  <tr>
     <td>tmp_dir</td>
     <td>string</td>
     <td>The directory where the e-ph matrix elements are stored when calc_mode='trans'</td>
  </tr>
  <tr>
    <td>load_scatter_eph</td>
    <td>logical</td>
    <td>Read the e-ph matrix elements from the files in tmp_dir; the default is .false.; used in the calculation mode 'trans'</td>	
  </tr>
  <tr>
      <td colspan="3" >BOLTZMANN TRANSPORT EQUATION</td>
  </tr>
  <tr>
      <td>boltz_kdim(1:3)</td>
      <td>integer</td>
      <td>Number of <b>k</b> points along each dimension for the Boltzmann equation; the default is 1.</td>
  </tr>
  <tr>
      <td>boltz_qdim(1:3)</td>
      <td>integer</td>
      <td>Number of <b>q</b> points along each dimension for the Boltzmann equation; the default is boltz_qdim(i)=boltz_kdim(i)</td>
  </tr>
  <tr>
      <td>band_min</td>
      <td>integer</td>
      <td>Lowest band included; the default is 1</td>
  </tr>
  <tr>
      <td>band_max</td>
      <td>integer</td>
      <td>Highest band included; the default is 9999999</td>
  </tr>
  <tr>
      <td>boltz_emin</td>
      <td>real</td>
      <td>Bottom of the energy window (in eV) for the Boltzmann equation; the default is -9999.0</td>
  </tr>
  <tr>
      <td>boltz_emax</td>
      <td>real</td>
      <td>Top of the energy window (in eV) for Boltzmann equation; the default is 9999.0 </td>
  </tr>
  <tr>
      <td>boltz_nstep</td>
      <td>integer</td>
      <td>Number of iterations for solving the Boltzmann transport equation</td>
  </tr>
  <tr>
      <td>boltz_de</td>
      <td>real</td>
      <td>Energy step (in meV) for the integrals in the Boltzmann equation; the default is 1.0 </td>
  </tr>
  <tr>
      <td>delta_smear</td>
      <td>real</td>
      <td>Smearing (in meV) for the Dirac delta function; the default is 10.0</td>
  </tr>
  <tr>
      <td>phfreq_cutoff</td>
      <td>real</td>
      <td>Phonon energy threshold (meV). Phonons with energy smaller than phfreq_cutoff will be excluded</td>
  </tr>
  <tr>
      <td>trans_thr</td>
      <td>real</td>
      <td>Threshold for the iterative procedure; the default is 0.002</td>
  </tr>
  <tr> 
       <td colspan="3" >POLAR CORRECTION (required only for calc_mode='imsigma')</td>
  </tr>
  <tr>
       <td>polar_split</td>
       <td>string</td>
       <td>Three options are: ' ' (leave blank, the default), 'polar', or 'rmpol'; if not specified, the code will compute both the polar and nonpolar parts </td>
  </tr>
  <tr>
       <td>sampling</td>
       <td>string</td>
       <td>Random q points sampling method. Options: 'uniform' (default), 'cauchy'</td>
  </tr>
  <tr>
       <td>cauchy_scale</td>
       <td>real</td>
       <td>Scale parameter gamma for the Cauchy distribution; used when sampling='cauchy'; the default is 0.05</td>
  </tr>
  <tr>
       <td>nsamples</td>
       <td>integer</td>
       <td>Number of q-points for the summation over the q-points in imsigma calculation; the default is 100,000</td>
  </tr>
  <tr>
       <td colspan="3" >DYNAMICS (via the time-dependent BTE) </td>
  </tr>
  <tr>
       <td>time_step</td>
       <td>real</td>
       <td>Time step for the carrier dynamics (in fs)</td>
  </tr>  
  <tr>
       <td>output_nstep</td>
       <td>integer</td>
       <td>Print out the results every n time steps; the default is 1</td>
  </tr>  
  <tr>
       <td>boltz_init_dist</td>
       <td>string</td>
       <td>Initial electron distribution at time zero. options: 'restart', 'lorentz', 'fermi', 'gaussian'</td> 
  </tr>
  <tr>
       <td>boltz_init_e0</td>
       <td>real</td>
       <td> Energy (in eV) parameter used to generate initial distribution. </td>
  </tr>  
  <tr>
       <td>boltz_init_smear</td>
       <td>real</td>
       <td>The broadening or width (in meV) of the initial distribution. Needed for boltz_init_dist='lorent' or 'gaussian'</td>
  </tr>
  <tr>
       <td>solver</td>
       <td>string</td>
       <td>Options: 'rk4' (default), 'euler'</td>
  </tr>  
</table>

 </body>	
</html>		
	

