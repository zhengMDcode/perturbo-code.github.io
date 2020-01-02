---
title: PERTURBO calculation
sidebar: mydoc_sidebar
last_updated: Jan 1, 2020
permalink: mydoc_perturbox.html
folder: mydoc
toc: true
---

In this section, we will discuss all the features (or calculation modes) of `perturbo.x`. The variable for the calculation mode is _calc\_mode_. Here are the possible values for calc_mode, and the corresponding tasks carried out by PERTURBO:

* 'bands': interpolate electronic band structures using Wannier functions
* 'phdips': interpolate phonon dispersion by Fourier transforming real-space interatomic force constants
* 'ephmat': interpolate e-ph matrix elements using  Wannier functions 
* 'setup': set up transport calculations
* 'imsigma': compute the e-ph self-energy for electronic crystal momenta read from a list
* 'meanfp': compute the e-ph mean free path
* 'trans': compute electrical conductivity for metals, semiconductors, and insulators, or carrier mobility for semiconductors (computationally demanding for the iterative approach)
* 'trans-pp': compute the Seebeck coefficient 
* (ADD ULTRAFAST DYNAMICS )

In the following, we use silicon as an example to demonstrate the features of PERTURBO (see the directory "examples/example01-silicon-perturbo/perturbo"). **To run perturbo.x one first needs to generate the file perfix_epwan.h5** (in this case, si\_epwan.h5), which is prepared using qe2pert.x as we discuss below. The file si\_epwan.h5 is inside the directory "examples/example01-silicon-perturbo/qe2pert.x". For each calculation mode, we also provide reference results in the directory "References". In all calculations, the same prefix value as in the QE DFT calculation should be used.

### calc_mode = 'bands'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b> examples/example01-silicon-perturbo/perturbo/pert-band </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b> Interpolated electronic band structure given an electronic crystal momentum path  </div>


 Users specify three variables in the input file (pert.in)
  - _calc\_mode_: set to 'bands' 
  - _fklist_: the filename of a file containing the high-symmetry crystal momentum path or k list

Here is the input file or namelist (pert.in):

```
&perturbo
 prefix = 'si'
 calc_mode = 'bands'
 fklist = 'si_band.kpt'
/
```

In this example, fklist='si\_band.kpt', the file si\_band.kpt containing the k-point list: 

```
6
0.500   0.500   0.500   50
0.000   0.000   0.000   50
0.500   0.000   0.500   20
0.500   0.250   0.750   20
0.375   0.375   0.750   50
0.000   0.000   0.000   1
```

The first line specifies how many lines there are below the first line. Columns 1-3 give, respectively, the x, y, and z coordinates of a crystal momentum **in crystal coordinate**. The last column is the number of points from the current crystal momentum to the next crystal momentum. One can also provide an explicit k-point list, rather than specifying the path, by providing the number of k points in the first line, the coordinates of each k point, and setting the values in the last column to 1. 


Before running `perturbo.x`, remember to put si\_epwan.h5 in the current directory "pert-band" since `perturbo.x` needs to read si\_epwan.h5. You may choose to copy the HDF5 file using 

```$ cp ../../qe2pert/si_epwan.h5 .```

 But the size of the HDF5 file is usually quite large, creating a soft link that point to the original HDF5 file is strongly recommended:
 
 ```$ ln -sf ../../qe2pert/si_epwan.h5```

Run pertubo.x:

```
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out 
```

{% include note.html content="The number of pools (-npools) has to be equal to the number of MPI processes (-np or -n), otherwise the code will stop." %}

It takes just a few seconds to obtain the interpolated band structure. We obtain an output file called prefix.bands (in this case, si.bands) with the following format:

```
 0.0000000      0.50000    0.50000    0.50000     -3.4658249872
 ......
 3.7802390      0.00000    0.00000    0.00000     -5.8116812661
 
 0.0000000      0.50000    0.50000    0.50000     -0.8385755999
 ......
 3.7802390      0.00000    0.00000    0.00000      6.1762484317
 
 0.0000000      0.50000    0.50000    0.50000      4.9707614733
 ......
 3.7802390      0.00000    0.00000    0.00000      6.1762484335
 
 0.0000000      0.50000    0.50000    0.50000      4.9707614740
 ......
 3.7802390      0.00000    0.00000    0.00000      6.1762484335
 
 0.0000000      0.50000    0.50000    0.50000      7.6304859491
 ......
 3.7802390      0.00000    0.00000    0.00000      8.6898783415
 
 0.0000000      0.50000    0.50000    0.50000      9.4530710727
 ......
 3.7802390      0.00000    0.00000    0.00000      8.6898783428
 
 0.0000000      0.50000    0.50000    0.50000      9.4530710753
 ......
 3.7802390      0.00000    0.00000    0.00000      8.6898783429
 
 0.0000000      0.50000    0.50000    0.50000     13.6984850767
 ......
 3.7802390      0.00000    0.00000    0.00000      9.4608102223
 
```

Note that there are 8 blocks in this example, one for each of the 8 bands, because we use 8 Wannier functions in the Wannierization procedure in this example. The 1st column is an irrelevant coordinate used to plot the band structure. The 2nd to 4th columns are the x, y, and z coordinates of the crystal momenta **in crystal units**. The 5th column is the energy, in eV units, of each electronic state.



### calc_mode = 'phdisp'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b> examples/example01-silicon-perturbo/perturbo/pert-phdisp  </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  Interpolated phonon dispersions along a given crystal momentum path   </div>


 Users specify three variables in the input file (pert.in):
  - _prefix_: the same prefix used in 'prefix'_epwan.h5
  - _calc\_mode_: set to 'phdisp' 
  - _fqlist_: the filename of a file containing the high-symmetry crystal momentum path or q list

Here is the input file (pert.in):

```
&perturbo
 prefix = 'si'
 calc_mode = 'phdisp'
 fqlist = 'si_phdisp.qpt'
/
```

In this example, fqlist='si\_phdisp.qpt', and the file "si\_phdisp.qpt" contains a crystal momentum path or list with the same format as the file _fklist_ (see the section on calc\_mode='bands').

Remember to link (or copy) si\_epwan.h5 in the current directory using ```ln -sf ...```. 

Run pertubo.x:

```
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out 
```

It takes a few seconds to obtain the phonon dispersion. We obtain an output file called prefix.phdisp (in this case, si.phdisp) with the following format:

```
0.0000000      0.50000    0.50000    0.50000     12.9198400723
......
3.7802390      0.00000    0.00000    0.00000     -0.0000024786

0.0000000      0.50000    0.50000    0.50000     12.9198400723
......
3.7802390      0.00000    0.00000    0.00000     -0.0000022344

0.0000000      0.50000    0.50000    0.50000     45.6922098051
......
3.7802390      0.00000    0.00000    0.00000      0.0000014170

0.0000000      0.50000    0.50000    0.50000     50.7258504163
......
3.7802390      0.00000    0.00000    0.00000     63.1558948005

0.0000000      0.50000    0.50000    0.50000     60.2661349902
......
3.7802390      0.00000    0.00000    0.00000     63.1558948005

```

Note that there are 6 blocks, one for each of the to 6 phonon modes in silicon. The 1st column an irrelevant coordinate used to plot the phonon dispersion. The 2nd to 4th columns are the x, y, and z coordinates of the crystal momenta, in crystal units. The 5th column is the phonon energy in meV units.



### calc_mode = 'ephmat'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b>  examples/example01-silicon-perturbo/perturbo/pert-ephmat  </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  The absolute values of the e-ph matrix elements, summed over the number of electronic bands, given two lists of k and q points. In a typical scenario, one computes the e-ph matrix elements for a chosen k-point as a function of q point  </div>

 Requires to specify at least 7 variables:
  - _prefix_: the same prefix as in 'prefix'\_epwan.h5
  - _calc\_mode_: set to 'ephmat'
  - _fklist_: the file containing a list of k points (see the section on calc\_mode='bands')
  - _fqlist_: the file containing a list of q points (see the section on calc\_mode='bands')
  - _band\_min_, _band\_max_: bands used for the band summation in computing e-ph matrix elements
  - _phfreq\_cutoff_: phonon energy (meV) smaller than the cutoff will be ignored

- In a typical scenario, the user wants to check if the interpolated e-ph matrix elements match with the density functional perturbation theory (DFPT) result. **Here we assume that users know how to obtain the DFPT e-ph matrix elements from the PHONON package in QE. --NOT TRUE, NEED PATCHING**

Here is the input file (pert.in):

```
&perturbo
 prefix = 'si'
 calc_mode = 'ephmat'
 fklist = 'eph.kpt'
 fqlist = 'eph.qpt'

 band_min = 2
 band_max = 4

 phfreq_cutoff = 1   !meV
/
```

In this example, we compute the e-ph matrix elements summed over the bands 2 to 4. The band index here refers to the band index of the Wannier functions, and it may not be the same as the band index in the DFT output from QE because sometimes bands are excluded in the Wannierization procedure. Make sure you know band range appropriate for your calculation, and provide accordingly *band\_min* and _band\_max_. 

The variable _phfreq\_cutoff_ is used to avoid numerical stabilities in the phonon calculations, and we recommend using a value between 0.5 to 2 meV (unless you know that phonons in that energy range play a critical role). Do not set phfreq_cutoff to a large value, otherwise too many phonon modes will be excluded in the calculations. 

For the format of fklist or fqlist, please refer to the section on calc_mode='bands'. 

Before running perturbo.x, ensure that three files exist in the current directory "pert-ephmat":

* _prefix\_epwan.h5_: here si\_epwan.h5
* _fklist_: here eph.kpt
* _fqlist_: here eph.qpt

Run pertubo.x:

```
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out 
```

The calculation typically takes a few minutes. The output file, called _prefix.ephmat_, contains the absolute values of the e-ph matrix elements summed over bands from _band\_min_ to _band\_max_. In our example, we obtain the output file have si.ephmat, which is shown next:

```
#  ik      xk     iq      xq   imod    omega(meV)      deform. pot.(eV/A)           |g|(meV)
    1   0.00000    1   0.00000  001    12.919840     0.219927308382E+00   0.118026594146E+02
    1   0.00000    1   0.00000  002    12.919840     0.219927308382E+00   0.118026594146E+02
    1   0.00000    1   0.00000  003    45.692210     0.621221217159E+01   0.177277853210E+03
    1   0.00000    1   0.00000  004    50.725850     0.472050460536E+01   0.127850679974E+03
    1   0.00000    1   0.00000  005    60.266135     0.588886380766E+01   0.146326884271E+03
    1   0.00000    1   0.00000  006    60.266135     0.588886380766E+01   0.146326884271E+03
    1   0.00000    2   0.01698  001    12.919176     0.222183631468E+00   0.119240540866E+02
    1   0.00000    2   0.01698  002    12.919176     0.222183631468E+00   0.119240540866E+02
    1   0.00000    2   0.01698  003    45.618607     0.618085532274E+01   0.176525258121E+03
    1   0.00000    2   0.01698  004    50.785889     0.475470902657E+01   0.128700934013E+03
    1   0.00000    2   0.01698  005    60.266760     0.589432282022E+01   0.146461770958E+03
    1   0.00000    2   0.01698  006    60.266760     0.589432282022E+01   0.146461770958E+03
......
```

The 1st column is a dummy index for the k-point. The 2nd column is the k-point coordinate used for plotting. The 3rd and 4th columns are the dummy index and the q-point coordinate used for plotting, respectively. The 5th column is the phonon mode index. The 6th column is the phonon energy (in meV). The 7th column is the deformation potential (in eV/Å units), namely the expectation value of the phonon perturbation potential with respect to the initial and final electronic states. The 8th column is the absolute values of the e-ph matrix elements (meV units) summed over the number of bands specified by the user. 

### calc_mode = 'setup'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b>  examples/example01-silicon-perturbo/perturbo/pert-setup-electron (pert-setup-hole)  </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  Set up transport property calculations (i.e., electrical conductivity, carrier mobility and Seebeck) by providing k-points, k-point tetrahedra and (if needed) finding chemical potentials for given carrier concentrations  </div>

Requires to specify up to 14 variables in the input file (pert.in)
  - _prefix_: same prefix as in 'prefix'\_epwan.h5
  - _calc\_mode_: set to 'setup'
  - _hole_: By default _hole_ is set to .false.. Set it to .true. only when computing hole mobility of a semiconductor (the code compute hole concentration, instead of electron concentration, if _hole_ is .ture.). 
  - _boltz\_kdim(1)_, _boltz\_kdim(2)_, _boltz\_kdim(3)_: number of k points along each dimension of a k-point grid for the electrons momentum. This k-point grid is employed to compute the mobility or conductivity.
  - _boltz\_qdim(1)_, _boltz\_qdim(2)_, _boltz\_qdim(3)_: number of q points along each dimension of a uniform grid for the phonon momentum; the default is that _boltz\_qdim(i)=boltz\_kdim(i)_. If users need the size as same as the k grid, no need to specify these variables.
  - _boltz\_emin_, _boltz\_emax_: energy window (in eV units) used to compute transport properties. The suggested values are from 6 k_BT below E_F (boltz_emin) to 6k_BT above E_F (boltz_emax), where E<sub>F</sub> is the Fermi energy, k<sub>B</sub> the Boltzmann constant, and T is temperature in K units.
  - _band\_min_, _band\_max_: bands used for transport property calculations
  - _ftemper_: the filename of a file containing the temperature(s), chemical potential(s), and corresponding carrier concentration(s) for transport property calculations.

Here is the input file (pert.in):

```
&perturbo
 prefix      = 'si'
 calc_mode   = 'setup'

 boltz_kdim(1) = 80
 boltz_kdim(2) = 80
 boltz_kdim(3) = 80

 boltz_emin = 6.4
 boltz_emax = 6.9
 band_min = 5
 band_max = 6

 ftemper  = 'si.temper'
/
```

In the input file pert.in, we use a k-grid of 80 x 80 x 80 for electrons, which corresponds to boltz_kdim(i)=80, and use a q-grid for phonons of the same dimension as the k-grid. When a phonon q-grid different from the electron k-grid is desired, the user need to provide the q-grid variables  _boltz\_qdim(1)_,  _boltz\_qdim(2)_, and _boltz\_qdim(3)_ in the input file.

In this example, we want to compute the electron mobility, so we choose an energy window that includes the conduction band minimum. Here the energy window is between 6.4 (_boltz\_emin_) and 6.9 eV (_boltz\_emax_), and the conduction band minimum is at 6.63 eV in this case. We include the two lowest conduction bands, with band indices 5 and 6 (_band\_min_ and _band\_max_).


In this case, the ftemper file si.temper has the following format:

```
1 T
300.00   6.52   1.0E+18
```

The integer in the first line is the number of settings at which we want to compute the mobility. The logical variable in the first line can be set to 'T' (for true), as is the case here, or 'F' (for false). perturbo.x to will determine the chemical potential using the carrier concentration and temperature provided as input in each of the rows below the first. If the logical variable is false ('F'), perturbo.x will use the chemical potential provided in each of the rows below the first. Each of the following lines contains three values, the temperature (K), Fermi level (eV), and carrier concentration (cm<sup>-3</sup> in 3D materials or cm<sup>-2</sup> in 2D materials). There are two possible scenarios. If the user wants perturbo.x to determine the chemical potential corresponding to a given carrier concentration and temperature, the logical variable in the first line is 'T' and upon running perturbo.x ftemper file will be overwritten. In the ftemper file generated by perturbo.x, the logical variable will become 'F', and the chemical potentials in each line below the first will be replaced by the values found by perturbo.x, which can solve for the chemical potential in the energy window between boltz_emin and boltz_emax (so make sure this window is large enough to include the chemical potential). In a second scenario, the logical variable is 'F', and ftemper will not be overwritten and will be used as is. In short, if the users want to find the chemical potentials for each combination of carrier concentration and a temperature provided as input, they need to first set the logical variable as 'T' and run the code to generate the ftemper with the desired chemical potential to be used in the transport calculation. 

Run perturbo.x with the following command (remember to link or copy prefix\_epwan.h5 in the current directory):

```
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out 
```

The calculation will take a few minutes or longer, depending the number of k- and q- points and the size of the energy window. We obtain 4 output files (_prefix.doping_, _prefix\_tet.h5_, _prefix\_tet.kpt_, and _prefix.dos_): 

* _prefix.doping_ contains chemical potentials and carrier concentrations for each tempearture of interest. The format is easy to understand so we do not show it here. Please take a look at the file by yourself. 
* _prefix\_tet.h5_ contains information on the k-points (in the irreducible wedge) used to compute transport properties. Users familiar with HDF5 can read and manipulate this file with the standard HDF5 commands. The other users can just ignore the data stored in the file. 
* _prefix\_tet.kpt_ contains the coordinates (in crystal units) of the irreducible k-points, and the associated k-point tetrahedra, in the energy window of interest. The format is different from that of _fklist_ discussed above in the calculation mode 'bands'.
* _prefix.dos_ contains the density of states (number of states per eV per unit cell volume) as a function of energy (eV). The format is easy to understand so we do not show it here. The density of states sets the phase space for several electron scattering processes, so it is convenient to compute it and print it out.

In our example, since we used 'T' in the first line of ftemper, a new ftemper file is generated as output: that the ftemper file 'si.temper' has now become:

```
1 F
300.00   6.5504824219   0.9945847E+18
```

Note how perturbo.x has computed the chemical potential (second entry in the second row) for the given temperature and carrier concentration (first and third entries of the second row). The logical variable in the first line is now 'F', and si.temper can now be used as is in subsequent calculations.

The above explanation focuses on electrons. For holes carriers, please refer to "examples/example01-silicon-perturbo/perturbo/pert-setup/pert-setup-hole". In the input file for holes, remember to use hole=.true. (default: hole=.false.), and choose an appropriate energy window and the band indices for holes. 



### calc_mode = 'imsigma'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b>  examples/example01-silicon-perturbo/perturbo/pert-imsigma-electron (pert-imsigma-hole)  </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  The imaginary part of the lowest-order (so-called 'Fan') e-ph self-energy for states in a range of bands and with crystal momenta k read from a list. The scattering rates can also be obtained using 2/hbar * ImSigma  </div>

Specify up to 12 variables in the input file (pert.in)
  - _prefix_: the same prefix as the file 'prefix'\_epwan.h5
  - _calc\_mode_: set to 'imsigma'
  - _band\_min_, _band\_max_: bands used for transport property calculations
  - _ftemper_: the filename of a file containing temperature, chemical potential, and carrier concentration values (for the format, see the section above on the calculation mode 'setup')
  - _fklist_: the filename of a file containing the coordinates of a given electron k-point list (for the format, see the section on the calculation mode 'bands')
  - _phfreq\_cutoff_: the cutoff energy for the phonons. Phonon with their energy smaller than the cutoff (in meV) is ignored; 0.5-2 meV is recommended. 
  - _delta\_smear_: the broadening (in meV) used for the Gaussian function used to model the Dirac delta function
  - _sampling_: sampling type, 'uniform' or 'cauchy'; the former is a uniform random Brillouin zone grid, and is the default, while the 'Cauchy' is a useful option for polar materials
  - _cauchy\_scale_: the width of the Cauchy function; used only when _sampling_ is 'cauchy' for polar materials
  - _nsamples_: number of q-points used to compute the imaginary part of the e-ph self-energy for each k-point 
  - _polar\_split_: describes how to compute the e-ph matrix elements for in the presence of a polar e-ph interaction (here, the ab initio Frohlich interaction). Three options: ''(none), 'polar', or 'rmpol'. Leave it blank if users want to describes how to compute the entire e-ph matrix elements (including the polar contribution). Set it to 'polar' when computing only for elements (including the polar contribution); set if to 'rmpol' when computing only the nonpolar part of the matrix elements (the total minus the polar part). This variable is relevant only for polar materials. 

Here is the input file (pert.in):

```
&perturbo
 prefix      = 'si'
 calc_mode   = 'imsigma'

 fklist   = 'si_tet.kpt'
 ftemper  = 'si.temper'

 band_min = 5
 band_max = 6

 phfreq_cutoff = 1 ! meV
 delta_smear = 10 ! meV

 sampling = 'uniform'
 nsamples = 1000000
/
```

In the current example, we compute the imaginary part of the e-ph self-energy of a k-points in the fklist file (in this case, we use the irreducible Monkhorst-Pack k-point list in si\_tet.kpt obtained from the calculation mode 'setup'). Note that if one is only interested in a high symmetry line, one can provide k-point path in the fklist file instead. The temperature, chemical potential, and carrier concentration values for computing the e-ph self-energy are given in the ftemper file, si.temper, obtained from the perturbo 'setup' process. Note that perturbo.x will do calculations, at once, for as many combinations of temperature and chemical potential as are specified in the lines below the first of ftemper.

Here we use a uniform random sampling (sampling='uniform') with 1 million randomly sampled q-points (nsample=1000000). The phonon frequency cutoff is 1 meV (phfreq\_cutoff=1), and the smearing for the Gaussian function is 10 meV (delta\_smear=10). In the imaginary part of the e-ph self-energy (or equivalently, e-ph scattering rate) calculations, the energy difference between the initial and final states must match the energy of the involved phonon, within a range of +/- 3*_delta\_smear_ from gaussian smearing. To converge the e-ph self-energy, one must vary the input variables 'nsample' and 'delta_smear'. A small parameter η ≈ 5 meV usually a good starting point, as this value is known to sufficiently converge the scattering rates in GaAs (Reference Jinjian).

Before running perturbo.x, remember to link or copy prefix\_epwan.h5 in the current directory.

```
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out
```

We obtain two output files:

* _prefix.imsigma contains the computed imaginary part of the e-ph self-energy 
* _prefix.imsigma\_mode contains the computed imaginary part of the e-ph self-energy (one separate file for each phonon mode, where phonon modes are numbered for increasing energy values).

The following is the format of prefix.imsigma (in this case, si.imsigma):

```
 # Electron (Imaginary) Self-Energy in the Migdal Approximation #
 #      (WARNING: only output a part of the eigenstates)        #
 #==============================================================#
 #NO.k:    450   NO.bands:   2   NO.T:   1   NO.modes:   1
 # it     ik   ibnd    E(ibnd)(eV)     Im(Sigma)(meV)
 # Temperature(T)=  25.85203 meV;  Chem.Pot.(mu)=   6.55048 eV
   1       1     1      6.955370   1.2413716479777598E+01
   1       1     2      8.625216   8.0941033638003375E+01
 #------------------------------------------------------------
 ......
```

The variable _it_ is a dummy variable for enumerating the temperature values, while, _ik_ is the number of k-points in the fklist, _ibnd_ the band number (in this case, band indices are 5 and 6). _Im(Sigma)_ is the imaginary part of the e-ph self-energy (in meV units) for each state of interest.

Similiarly, the format for si.imsigma\_mode is 

```
 # Electron (Imaginary) Self-Energy in the Migdal Approximation #
 #      (WARNING: only output a part of the eigenstates)        #
 #==============================================================#
 #NO.k:    450   NO.bands:   2   NO.T:   1   NO.modes:   6
 # it     ik   ibnd    E(ibnd)(eV)  imode    Im(Sigma)(meV)
 # Temperature(T)=  25.85203 meV;  Chem.Pot.(mu)=   6.55048 eV
   1       1     1      6.955370     1   1.4153504009369593E+00
   1       1     1      6.955370     2   5.7649932505673829E-01
   1       1     1      6.955370     3   3.3560451875664166E+00
   1       1     1      6.955370     4   9.1248572526519600E-01
   1       1     1      6.955370     5   6.7828926275888612E-01
   1       1     1      6.955370     6   5.4750465781934041E+00
   1       1     2      8.625216     1   1.4251118413529920E+01
   1       1     2      8.625216     2   2.3885895867766276E+01
   1       1     2      8.625216     3   1.9149613992834450E+01
   1       1     2      8.625216     4   8.0914088438082139E+00
   1       1     2      8.625216     5   5.5520190253046220E+00
   1       1     2      8.625216     6   1.0010977494759880E+01
 #------------------------------------------------------------
 ......
```

Here we have an extra column with the phonon mode index (imode). 

**Remember to converge the Im(Sigma) results with respect to the number of samples (_nsamples_).**

(ADD EXPLANATION)

Using the results in the _prefix.imsigma_ file, one can easily obtain, with a small script, the scattering rates for each state, which are equal to 2/hbar x ImSigma (it's convenient to use hbar = 0.65821195 eV fs to this end). Using additional tools provided in perturbo.x, we can also compute the mean free path for each electronic state, as well as a range of phonon-limited transport properties.

One way of obtaining the relaxation times (and their inverse, the scattering rates) is to run the Python script ***.py (ADD HERE) we provide to post-process the imsigma output. Another way is to obtain the relaxation times is to run a calculation of the mean free paths (see below), which conveniently outputs both the relaxation times and the mean free path for the desired electronic states. 

Also note that an example calculation of the e-ph self-energy for holes, is provided in the example folder "examples/example01-silicon-perturbo/perturbo/pert-imsigma-hole", where we use different band indices (_band\_min=2_ and _band\_max=4_), and the files, fklist and ftemper, are also different and obtained in a different perturbo 'setup' calculation. 



### calc_mode = 'meanfp'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b>  examples/example01-silicon-perturbo/perturbo/pert-meanfp-electron (pert-meanfp-hole)  </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  The e-ph mean free paths for electronic states in a user-defined k-point list and range of bands  </div>

{% include note.html content="The mean free path calculation relies on the results of the calculation mode \"imsigma\" values obtained. Therefore, the user should first run the calculation mode imsigma, and then compute the mean free paths" %}

Requires the same files as _calc\_mode='imsigma'_ but needs an additional file, _prefix.imsigma_, obtained from the as output in the 'imsigma' calculation.

Here is the input file (pert.in). It should be the same input as the one for the "imsigma" calculation mode, except for the line specifying _calc\_mode='meanfp'_:

```
&perturbo
 prefix      = 'si'
 calc_mode   = 'meanfp'

 fklist   = 'si_tet.kpt'
 ftemper  = 'si.temper'

 band_min = 5
 band_max = 6

 phfreq_cutoff = 1 ! meV
 delta_smear = 10 ! meV

 sampling = 'uniform'
 nsamples = 1000000
/
```

Before running perturbo.x, make sure you have the following files in the current directory ("pert-meanfp-electron"): _prefix\_epwan.h5_, _prefix.imsigma_ the fklist file (si_tet.kpt in this example), and the ftemper file (e.g., si.temper in this example). As explained above, one can reuse the input file of the calculation mode "imsigma" by replacing the calculation mode with _calc\_mode='meanfp'_. 

```
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out
```

This calculation usually takes only takes a few seconds. We obtain two output files:

* _prefix.mfp_ contains the relaxation time and mean free path of each electronic state. Note that the MFP is the product of the state relaxation time and band velocity.
* _prefix.vel_ contains the band velocity of each state  

The format of _prefix.mfp_ is as follows:

```
#         Electron Mean Free Path (tau_nk*v_nk, in nm)       #
###################################################################
#NO.k:     450   NO.bands:    2   NO.T:    1
# it   ik  ibnd   E(ibnd)(eV)   Relaxation time(in fs)           MFP (in nm)
# Temperature(T)=   25.85203 meV;  Chem.Pot.(mu)=    6.55048 eV
1       1     1      6.955370   2.6511488462206518E+01   9.5929573542019302E+00
1       1     2      8.625216   4.0659982512529345E+00   4.8049949684520232E+00
#-------
......
```

The variable _it_ is the dummy variable for temperature; in this case, we only used one temperature (300 K). _ik_ is the dummy variable for the given crystal momentum in the file fklist. _ibnd_ is the dummy variable for bands; in this case, ibnd=1 corresponds to band index 5 and ibnd=2 is the band index 6. The 3rd, 4th, and 5th columns are energy (eV), relaxation time (fs), and mean free path (nm) of each state, respectively.

The format of _prefix.vel_ is shown below: 

```
#                    Band velocity                   #
###################################################################
#  ik  ibnd   E(ibnd)(eV)     k.coord. (cart. alat)                vel-dir                  |vel| (m/s)
   1     1      6.955370  -0.01250  0.58750 -0.01250     -0.24926 -0.93581 -0.24926   3.6184152269976016E+05
   1     2      8.625216  -0.01250  0.58750 -0.01250     -0.04306 -0.99814 -0.04306   1.1817503775293969E+06
   2     1      6.915451   0.00000  0.60000  0.00000     -0.00000 -1.00000  0.00000   3.1811354238290834E+05
   2     2      8.510979   0.00000  0.60000  0.00000      0.00000 -1.00000 -0.00000   1.1197561247449291E+06
   3     1      6.932859  -0.02500  0.60000  0.00000     -0.49908 -0.86656  0.00000   3.6515768155811669E+05
   3     2      8.520464  -0.02500  0.60000  0.00000     -0.08888 -0.99604 -0.00000   1.1259209936791812E+06
......
```

The 1st to 3rd columns are the same as in _prefix.mfp_. The 4th to 6th columns are the k-point coordinates in the crystal units. The 7th to 9th columns are the components of the unit vector specifying the direction of the velocity of each electronic states. The last column is the magnitude of the velocity (m/s) of each state. 

For an example calculation of mean free paths for holes, please see the folder "examples/example01-silicon-perturbo/perturbo/pert-meanfp-hole".



### calc_mode = 'trans'

The calculation mode 'trans' computes the electrical conductivity and carrier mobility tensors. The code can compute these quantities using the relaxation time approximantion (RTA) of the Boltzmann transport equation (BTE) or an iterative approach (ITA) to fully solve the linearized BTE. 

#### Relaxation time approximation (RTA)

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b> examples/example01-silicon-perturbo/perturbo/pert-trans-RTA-electron (pert-trans-RTA-hole)    </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  The phonon-limited conductivity and carrier mobility using the RTA of the BTE
 </div>

{% include note.html content="The user needs to run the calculation modes \"setup\" and then \"imsigma\" since this calculation mode relies on their outputs" %}

Requires the same variables as those specified in the calculation mode "setup", except for the following two variables:
  - _calc\_mode_: set to 'trans'
  - _boltz\_nstep_: set to 0, which means computing the mobility using the RTA 

Here is the input file (pert.in):

```
&perturbo
 prefix      = 'si'
 calc_mode   = 'trans'

 boltz_kdim(1) = 80
 boltz_kdim(2) = 80
 boltz_kdim(3) = 80

 boltz_emin = 6.4
 boltz_emax = 6.9
 band_min = 5
 band_max = 6

 ftemper  = 'si.temper'
 
 boltz_nstep = 0  ! RTA
/
```

Before running perturbo.x, remember to put the following files in the current directory: 

* _prefix\_epwan.h5: here si\_epwan.h5
* _ftemper_: here 'si.temper' obtained in the 'setup' calculation 
* _prefix\_tet.h5_: here si\_tet.h5 obtained in the 'setup' calculation 
* _prefix.imsigma_: here si.imsigma obtained in the 'imsigma' calculation     

Run perturbo.x:

```
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out
```

This calculation usually takes a few minutes. We obtain three output files:

* _prefix.cond_ contains the conductivity and mobility tensors as a function of temperature
* _prefix.tdf_ contains transport distribution function (TDF) as a function of carrier energy and temperature
* _prefix\_tdf.h5_ includes all the information of the TDF for each temperature in HDF5 format

In our example, the output file is si.cond, which is shown here:

```
          #==========================================================#
          #                  Conductivity (1/Ohm/m)                  #
          #----------------------------------------------------------#

#  T (K)   E_f(eV)   n_c (cm^-3)      sigma_xx       sigma_xy       sigma_yy       sigma_xz       sigma_yz       sigma_zz
  300.00   6.55048   0.99458E+18    0.256282E+05  -0.867734E-06   0.256282E+05  -0.643904E-06  -0.266436E-04   0.256282E+05


          #==========================================================#
          #                    Mobility (cm^2/V/s)                   #
          #--------------------(for semiconductor)-------------------#

#  T (K)   E_f(eV)   n_c (cm^-3)       mu_xx          mu_xy          mu_yy          mu_xz          mu_yz          mu_zz
  300.00   6.55048   0.99458E+18    0.160830E+04  -0.544546E-07   0.160830E+04  -0.404082E-07  -0.167202E-05   0.160830E+04
```

The calculated electron mobility at 300 K is ~ 1608 cm<sup>2</sup>V<sup>-1</sup>s<sup>-1</sup>, in reasonably good agreement with the experimental value of roughly 1400 cm<sup>2</sup>V<sup>-1</sup>s<sup>-1</sup>. 

(THE VALUE DEVIATES SIGNIFICANTLY FROM WHAT I(JINSOO)'VE DONE BEFORE. WHY IS THIS? WE SHOULD RE-DO THE CALCULATIONS)

The second output file is si.tdf, whose format is shown below:

```
#  E(eV)    (-df/dE) (a.u.)    TDF(E)_(xx xy yy xz yz zz) (a.u.)   #

# Temperature:  300.0000  Fermi Level:   6.550482

   6.632612    2.0230556858340154E+01    0.000000E+00   0.000000E+00   0.000000E+00   0.000000E+00   0.000000E+00   0.000000E+00
   6.633612    1.9522224579919563E+01    0.000000E+00   0.000000E+00   0.000000E+00   0.000000E+00   0.000000E+00   0.000000E+00
   6.634612    1.8836601850198139E+01    0.122626E-03   0.507955E-13   0.122626E-03  -0.954877E-13  -0.185696E-12   0.122626E-03
   ......
```

Column 1 is the carrier energy (eV), column 2 is the energy derivative of Fermi-Dirac distribution at the energy given by column 1, and column 3 is the TDF for each energy, respectively. The data for each temperature and chemical potential combination is given in a separate block in the file. In this case, we look at one temperature and one concentration, so there is only one block in the file.  

In more rigorous calculations, the user will need to converge the conductivity and mobility with respect to the number of k and q-points, namely the variables _boltz\_kdim_ and _boltz\_qdim_. 

An example for hole carriers is also provided, in the folder "examples/example01-silicon-perturbo/perturbo/pert-trans-RTA-hole".

#### Iterative approach (ITA)

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b> examples/example01-silicon-perturbo/perturbo/pert-trans-ITA-electron (pert-trans-ITR-hole)    </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b> The phonon-limited conductivity and carrier mobility using ITA  </div>

{% include note.html content="The user needs to run the calculation modes \"setup\" and then \"imsigma\" since this calculation mode relies on their outputs" %}

Requires the same input file variables as the calculation mode "setup", except for the following 6 variables:
  - _calc\_mode is set to 'trans'
  - _boltz\_nstep contains the maximum number of iterations in the iterative scheme for solving Boltzmann equation, where a typical value is 10
  - _phfreq\_cutoff contains phonon threshold (meV). Phonons with energy smaller than the cutoff will be ignored.
  - _delta\_smear contains broadening (meV) for a Gaussian function to present the Dirac delta function
  - _tmp\_dir_ contains output directory containing the e-ph matrix elements used in the calculations
  - _load\_scatter\_eph_: if .true., it will read the e-ph matrix elements from _tmp\_dir_. The default is .false.

Here is the input file (pert.in):

```
&perturbo
 prefix      = 'si'
 calc_mode   = 'trans'

 boltz_kdim(1) = 80
 boltz_kdim(2) = 80
 boltz_kdim(3) = 80

 boltz_emin = 6.4
 boltz_emax = 6.9
 band_min = 5
 band_max = 6

 ftemper  = 'si.temper'

 tmp_dir = './tmp'
 !load_scatter_eph = .true.

 boltz_nstep = 10 !max number of iterations
 phfreq_cutoff = 1  !meV
 delta_smear = 10  !meV
/
```


Before running the ITA calculation, make sure that the following files are in the current directory ("pert-trans-ITA-electron"):

* _prefix\_epwan.h5_: here "si_epwan.h5"
* _ftemper_: here "si.temper"
* _prefix\_tet.h5_: here "si\_tet.h5" 

```
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out
```

It takes ~20 hours using one thread and one MPI process. To speed up the calculations, the user can increase the OpenMP threads and/or the MPI processes. If the number of MPI processes is increased, one has to make sure that the RAM is large enough. After the calculation has completed, we obtain 3 output files, _prefix.cond_, _prefix.tdf_, and _prefix\_tdf.h5_, similar to the RTA calculation.

An example calculation for holes is also provided in the folder "examples/example01-silicon-perturbo/perturbo/pert-trans-ITR-hole".



### calc_mode = 'trans-pp'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i> <b> Directory:</b>  examples/example01-silicon-perturbo/perturbo/pert-trans-pp-electron  </div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b> Seebeck coefficient. Note that phonon drag effects are not included in this calculation.
  </div>

Uses the same input file as the 'trans' calculation mode, but requires the additional file _prefix\_tdf.h5_ obtained in the 'trans' calculation. The Seebeck calculation is a quick post-processing of the 'trans' calculation, which needs to be done before running 'trans-pp'

Change the calculation mode in the input file to 'trans-pp'. Before running perturbo.x, make sure that four files exist in the current directory:

* _prefix_epwan.h5_: here si_epwan.h5
* _ftemper_: here si.temper
* _prefix_tet.h5_: here si_tet.h5
* _prefix_tdf.h5_: here si_tdf.h5

Run perturbo.x:

``` $ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out```

It takes a few seconds. We obtain a file, _prefix.trans_coef_, in this case, si.trans_coef, which has the following format:

```
          #==========================================================#
          #                  Conductivity (1/Ohm/m)                  #
          #----------------------------------------------------------#

#  T (K)   E_f(eV)   n_c (cm^-3)      sigma_xx       sigma_xy       sigma_yy       sigma_xz       sigma_yz       sigma_zz
  300.00   6.55048   0.99458E+18    0.251810E+05  -0.106635E+00   0.251823E+05  -0.172325E+00   0.142428E+00   0.251812E+05

          #==========================================================#
          #                    Mobility (cm^2/V/s)                   #
          #--------------------(for semiconductor)-------------------#

#  T (K)   E_f(eV)   n_c (cm^-3)       mu_xx          mu_xy          mu_yy          mu_xz          mu_yz          mu_zz
  300.00   6.55048   0.99458E+18    0.158023E+04  -0.669186E-02   0.158031E+04  -0.108143E-01   0.893806E-02   0.158025E+04

          #==========================================================#
          #                Seebeck coefficient (mV/K)                #
          #----------------------------------------------------------#

#  T (K)   E_f(eV)   n_c (cm^-3)        S_xx           S_xy           S_yy           S_xz           S_yz           S_zz
  300.00   6.55048   0.99458E+18    0.425885E+00   0.186328E-06   0.425883E+00  -0.791938E-07  -0.329487E-06   0.425885E+00
```

The two blocks for the conductivity and mobility are the same as those in the 'trans' calculation mode, but the output file of 'trans-pp' has an additional block with the Seebeck coefficient results. 

An example calculation for holes is also provided in the folder "examples/example01-silicon-perturbo/perturbo/pert-trans-pp-hole".




