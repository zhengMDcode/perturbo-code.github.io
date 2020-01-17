---
title: Quantum Espresso to PERTURBO
sidebar: mydoc_sidebar
last_updated: January 10, 2020
permalink: mydoc_qe2pert.html
folder: mydoc
toc: true
---

Before running electron dynamics calculations using `pertubo.x`, the user needs to carry out electronic and phonon calculations, with DFT and DFPT respectively. At present, Perturbo can read the output of DFT and DFPT calculations done with <a href="https://www.quantum-espresso.org" target="_blank">Quantum Espresso (QE)</a>. Once the relevant output files have been obtained from QE and Wannier90 (W90), the first step is to use `qe2pert.x` to compute the e-ph matrix elements on a coarse $$\mathbf{k}$$ and $$\mathbf{q}$$ point Brillouin zone grid, to obtain e-ph matrix elements in Wannier function basis, and to store the data into the <a href="https://portal.hdfgroup.org/display/HDF5/Introduction+to+HDF5" target="_blank">HDF5</a> format for `perturbo.x` to read. The generation of this HDF5 file, called '_prefix'\_epwan.h5_, is discussed in this section of the manual.

The preparation stage consists of five steps:

1. Run a self-consistent (scf) DFT calculation
2. Run a phonon calculation using DFPT
3. Run a non-scf (nscf) DFT calculation
4. Run Wannier90 to obtain Wannier functions
5. Run `qe2pert.x`

In the following, we use silicon as an example. The input files for QE and W90 are in the directory _"examples-perturbo/example02-silicon-qe2pert/pw-ph-wann"_. As a reference, we also provide the results in a directory called _"References"_. 

### Step 1: scf calculation

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder"></i> <b>Directory:</b> _examples/example02-silicon-qe2pert/pw-ph-wan/scf_ </div>

Run an SCF calculation and obtain the QE _'prefix'.save_ directory. In this case, we obtain _./tmp/si.save_, which is needed for phonon and nscf calculations.

### Step 2: phonon calculation

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder"></i> <b>Directory:</b> _examples/example02-silicon-qe2pert/pw-ph-wan/phonon_ </div>

We provide an example input file  _ph-ref.in_ for phonon calculations in QE, and two shell scripts (`ph-submit.sh` and `ph-collect.sh`) to set up and run a separate phonon calculation for each $$\mathbf{q}$$ point and collect the results. The user can modify the reference input file and the two shell scripts to use them for their material of choice and on their computing system. In this step, make sure that the number of $$\mathbf{q}$$ points is commensurate with the number of $$\mathbf{k}$$ points used in the nscf and Wannierization calculations. For example, a $$\mathbf{q}$$ grid of 8x8x8 can be used with a wannierization $$\mathbf{k}$$ grid of 8x8x8 or 16x16x16, but not with a 10x10x10 or 12x12x12 grid.  

Remember to copy the QE _'prefix'.save_ directory from the scf run to the current directory:

```bash
$ cp -r ../scf/tmp ./
```

To obtain the number of irreducible $$\mathbf{q}$$ points in the phonon calculation, edit the _ph-submit_ file and set `mode='gamma'` to run a Gamma-point phonon calculation.

```bash
$ vim ph-submit.sh
......
set mode='gamma'
......
$ ./ph-submit
```

The shell script creates a directory called _ph-1_. Change into that directory and open the file _ph.out_ to read the number of irreducible $$\mathbf{q}$$ points in the phonon calculation.

```bash
$ cd ph-1
$ vi ph.out
```

In our silicon example, the total number of $$\mathbf{q}$$ points is 29. It is fine to forgo the previous step and obtain the number of $$\mathbf{q}$$ points some other way. Once this information is available, open again the shell script _ph-submit_. Change the starting number from 1 to 2 and the final number to the total number of irreducible $$\mathbf{q}$$ points. 

```bash
$ vi ph-submit.sh
......
change (NQ=1; NQ<=8; NQ++) to (NQ=2; NQ<=29; NQ++)
......
$ ./ph-submit
```

The shell script creates one directory (_ph-#_) for each $$\mathbf{q}$$ point. Once the calculations are done, we collect all the phonon data into a directory called _save_, created by running the shell script _ph-collect.sh_.

```bash
$ ./ph-collect.sh
```

The _save_ directory contains all the information needed for PETURBO to interface with QE. These include the dynamical matrix files, phonon perturbation potentials, and the patterns.

The reference input file and scripts can be modified to run calculations for different materials. We recommend the user to become familiar with phonon calculations in QE to perform this step. 

Since phonon calculations using DFPT can be  computationally expensive, it is often useful to estimate the number of irreducible $$\mathbf{q}$$ points before running the phonon calculation. Note however that this step is optional.

### Step 3: nscf calculation

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder"></i> <b>Directory:</b> _examples/example02-silicon-qe2pert/pw-ph-wan/nscf_</div>

We now run the nscf calculations needed to generate the wavefunctions on the full $$\mathbf{k}$$ point grid, which we'll need both for generating Wannier functions with Wannier90 and for forming the coarse-grid e-ph matrix elements in Perturbo. Make sure that the number of k points is commensurate with the number of $$\mathbf{q}$$ points used for phonons, otherwise, qe2pert.x will stop. Remember to copy the QE _'prefix'.save_ directory from the scf calculation the current directory:

```
$ cp -r ../scf/tmp ./
```

Then run the nscf calculation with QE. 


### Step 4: Wannier90 calculation

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder"></i> <b>Directory:</b> _examples/example02-silicon-qe2pert/pw-ph-wan/wann_</div>

{% include note.html content="Requires Wannier90 v3.0.0 and higher." %}


The directory contains two input files, one for `wannier.x` and the other for `pw2wannier90.x`. In the input file _si.win_, we instruct Wannier90 to write two important quantities for `qe2pert.x`, the $$U(\mathbf{k})$$, $$U^{\text{dis}}(\mathbf{k})$$ matrices and the position of the Wannier function centers, using: `write_u_matrices=true` and `write_xyz=true`.

We create tmp directory:

```bash
$ mkdir tmp
```

and change into it. We soft link to the QE _'prefix'.save_ directory obtained in the nscf calculation:

```bash
$ cd tmp
$ ln -sf ../../nscf/tmp/si.save 
```

We then run Wannier90. The important output files for `qe2pert.x` are _si\_u.mat_, _si\_u\_dis.mat_, and _si\_centres.xyz_. For disentangled bands, there would be no '_prefix'\_u\_dis.mat_. We encourage the user to become familiar with Wannier90 to run this step for different materials. 

The user has to run Wannier90 3.0 or higher, since otherwise the $$U$$ matrices cannot be printed out. 

### Step 5: Running qe2pert.x 

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder"></i> <b>Directory:</b> _examples/example02-silicon-qe2pert/qe2pert_</div>

We are ready to compute the e-ph matrix elements on the coarse $$\mathbf{k}$$ point (determined by the nscf step) and $$\mathbf{q}$$ point (determined by the phonon step) Brillouin zone grids. First, copy or link the electronic and phonon calculation results to the current directory.

```bash
$ cd qe2pert
$ mkdir tmp
$ cd tmp 

$ #link to the nscf .save directory
$ ln -sf ../../pw-ph-wann/nscf/tmp/si.save
$ cd ../

$ #link to the wannier information
$ ln -sf ../wann/si_u.mat
$ ln -sf ../wann/si_u_dis.mat
$ ln -sf ../wann/si_centres.xyz
```

Here we show the input file (_qe2pert.in_) for the executable `qe2pert.x`:

```fortran
&qe2pert
 prefix='si'
 outdir='./tmp'
 phdir='../pw-ph-wann/phonon/save'
 nk1=8, nk2=8, nk3=8
 dft_band_min = 1
 dft_band_max = 16
 num_wann = 8
 lwannier=.true.
 load_ephmat = .false.
 system_2d = .false.
/ 
```

The description of the input parameters:

* [prefix](mydoc_param_qe2pert#prefix): needs to be the same as the prefix used in the input files for QE. 
* [outdir](mydoc_param_qe2pert#outdir): contains the save directroy obtained from the nscf calculations. The calculated e-ph matrix elements will be stored in this directory. 
* [phdir](mydoc_param_qe2pert#phdir): is the save directory inside which we collected all the phonon information.
* [nk1](mydoc_param_qe2pert#nk1), [nk2](mydoc_param_qe2pert#nk2), [nk3](mydoc_param_qe2pert#nk3): are the number of $$\mathbf{k}$$ points along each direction used in the nscf and Wannier90 calculations.
* [dft_band_min](mydoc_param_qe2pert#dft_band_min) and [dft_band_max](mydoc_param_qe2pert#dft_band_max): determine the range of bands we are interested in, and should be the same as the values used in the Wannierization process. For example, if we used 40 bands in the nscf calculation and we excluded bands 1-4 and 31-40 in the Wannierization, then `dft_band_min=5` and  `dft_band_max=30`.  
* [num_wann](mydoc_param_qe2pert#num_wann): the number of Wannier functions.
* [lwannier](mydoc_param_qe2pert#lwannier): a logical flag. When it is `.true.`, the e-ph matrix elements are computed using the Bloch wave functions rotated with the Wannier unitary matrix; if `.false.`, the e-ph matrix elements are computed using  the Bloch wave functions, and the e-ph matrix elements are then rotated using the Wannier unitary matrix. By default, it is `.true.` to reduce computational cost.
* [load_ephmat](mydoc_param_qe2pert#load_ephmat): a logical flag. If `.true.`, reuse e-ph matrix elements in Bloch function basis computed previously. This is useful if you want to test different Wannier bases. For example, you could first run `qe2pert.x` with `lwannier=.false.`, and then rerun  `qe2pert.x` with `lwannier=.false.` and `load_ephmat=.true.` with different Wannier unitary matrix. 
* [system_2d](mydoc_param_qe2pert#system_2d): if the materials is two-dimensional, so that in one direction only one $$\mathbf{k}$$ point is used, set it to `.true.`; the default is `.false.`.

Now we are ready to run the e-ph matrix elements: 

```bash
export OMP_NUM_THREADS=4
$ mpirun -n 2 qe2pert.x -npools 2 -i qe2pert.in > qe2pert.out
```

This task is usually time-consuming on a single core, but it can be made much faster (minutes) on multiple cores.
The executables `qe2pert.x` employ hybrid parallelization (MPI plus OpenMP), e.g. 2 MPI processes and each process span 4 OpenMP threads in this example. 


{% include note.html content="The number of pools (-npools) has to be equal to the number of MPI processes (-np or -n), otherwise the code will stop." %}


To speed up the calculations, the users could increase the number of OpenMP threads and MPI processes. 
Threads with OpenMP are particularly useful when the RAM (memory) of computing nodes is limited. The memory comsuption reduces to minimum when using 1 MPI process per node and setting `OMP_NUM_THREADS` to the number of cores per node. 

Once the calcalculation has completed, we obtain the output file _si\_epwan.h5_, which is an HDF5 database with all the information needed to run `perturbo.x` (which is described [here](mydoc_perturbo)).
