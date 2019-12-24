---
title: "Introduction"
keywords: introduction homepage 
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: index.html
toc: false
---



PERTURBO is an open source software to compute from first principles the scattering processes between charge carriers (electrons and holes) and phonons, defects, and photons in solid state materials, including metals, semiconductors, oxides, and insulators. In the current version, PERTURBO mainly computes electron-phonon (e-ph) interactions and phonon limited transport properties in the framework of the Boltzmann transport equation (BTE). These include the carrier mobility, electrical conductivity, and Seebeck coefficient. PERTURBO can also compute the ultrafast carrier dynamics (for now, with fixed phonon occupations) by explicitly time-stepping the time-dependent BTE. We will include other additional electron interactions, transport and ultrafast dynamics calculations in future releases..

PERTURBO is written in Fortran95 with hybrid parallelization (MPI and OpenMP). The main output format is HDF5, which is easily portable from one machine to another. PERTURBO has a core software, called perturbo.x, for electron dynamics calculations and an interface software, called qe2pert.x, to read output files of Quantum Espresso (QE, version 6.4.1) and Wannier90 (W90). The qe2pert.x interface software generates and HDF5 file, which is then read from the core perturbo.x software. In principle, any other third-party density functional theory (DFT) codes (e.g., VASP) can use PERTURBO as long as the interface of the DFT codes can prepare an HDF5 output format for PERTURBO to read.

For more details on the code structure of PERTURBO, we refer the users to the manuscript accompying the source code: [XXXXXX].

When using results from PERTURBO in your publications, please cite the following paper and acknowledge the use of PERTURBO.

- Jin-Jian Zhou, Jinsoo Park, I-Te Lu, Marco Bernardi, “Title of perturbo paper” Journal.Of.Perturbo (2020)(http://perturbo.caltech.edu)


