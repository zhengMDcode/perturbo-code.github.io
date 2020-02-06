---
title: "Introduction"
keywords: introduction homepage 
sidebar: mydoc_sidebar
permalink: index_for_pdf.html
toc: false
---

PERTURBO is an open source software to compute from first principles the scattering processes between charge carriers (electrons and holes) and phonons, defects, and photons in solid state materials, including metals, semiconductors, oxides, and insulators. In the current version, PERTURBO mainly computes electron-phonon (e-ph) interactions and phonon limited transport properties in the framework of the Boltzmann transport equation (BTE). These include the carrier mobility, electrical conductivity, and Seebeck coefficient. PERTURBO can also compute the ultrafast carrier dynamics (for now, with fixed phonon occupations) by explicitly time-stepping the time-dependent BTE. We will include additional electron interactions, transport and ultrafast dynamics calculations in future releases.

PERTURBO is written in Fortran95 with hybrid parallelization <a href="https://www.open-mpi.org" target="_blank">(MPI and OpenMP)</a>. The main output format is <a href="https://portal.hdfgroup.org/display/HDF5/Introduction+to+HDF5" target="_blank">HDF5</a>, which is easily portable from one machine to another and is convenient for postprocessing using high-level languauges (e.g., Python).  PERTURBO has a core software, called `perturbo.x`, for electron dynamics calculations and an interface software, called `qe2pert.x`, to read output files of <a href="https://www.quantum-espresso.org" target="_blank">Quantum Espresso</a> (QE, version 6.4.1) and Wannier90 (W90, version 3.0.0 and higher). The `qe2pert.x` interface software generates an HDF5 file, which is then read from the core `perturbo.x` software. In principle, any other third-party density functional theory (DFT) codes (e.g., VASP) can use PERTURBO as long as the interface of the DFT codes can prepare an HDF5 output format for PERTURBO to read.

For more details on the code structure of PERTURBO, we refer the users to the manuscript accompying the source code: 

- Jin-Jian Zhou, Jinsoo Park, I-Te Lu, Ivan Maliyov, Xiao Tong, Marco Bernardi, <i>"Perturbo: a software package for ab initio electron-phonon interactions, charge transport and ultrafast dynamics"<i>.

<div markdown="span" class="alert alert-warning" role="alert">
<img src="images/newspaper-regular.svg" style="width:3.5%;margin-top:0.1%" >
&nbsp;
When using results from PERTURBO in your publications, please, cite the above paper and acknowledge the use of the code.
</div>


<div class="alert alert-success" role="alert"><i class="fa fa-download fa-lg"></i>
&nbsp;  To download the code, contact us:  <i class="fa fa-envelope-o"></i> perturbo@caltech.edu. For more information, please, visit the <a href="mydoc_installation.html">Download and installation</a> section. </div>

<hr>

<img src="images/NSF_logo.png" style="width:11%;margin-top:5%;margin-left: auto;margin-right: auto; display: block" >

<div style="text-align: center">
<b>
We gratefully acknowledge the National Science Foundation for supporting the development of PERTURBO.
</b>
</div>
