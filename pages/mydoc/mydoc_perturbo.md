---
title: PERTURBO calculation
sidebar: mydoc_sidebar
last_updated: January 10, 2020
permalink: mydoc_perturbo.html
folder: mydoc
toc: true
---

In this section, we will discuss the features (or calculation modes) of `perturbo.x`. The variable for the calculation mode is `calc_mode`. Here are the optional values for `calc_mode`, and the corresponding tasks carried out by PERTURBO:

* `'bands'`: interpolate electronic band structures using Wannier functions.
* `'phdisp'`: interpolate phonon dispersion by Fourier transforming real-space interatomic force constants.
* `'ephmat'`: interpolate e-ph matrix elements using  Wannier functions.
* `'setup'`: setup for transport calculations or carrier dynamics simulations.
* `'imsigma'`: compute the e-ph self-energy for electronic crystal momenta read from a list.
* `'meanfp'`: compute the e-ph mean free path, also output the corresponding band velocity and relaxition time.
* `'trans'`: compute electrical conductivity for metals, semiconductors, and insulators, or carrier mobility for semiconductors, using either the state-dependent RTA approach or the iterative approach of the BTE.
* `'trans-pp'`: postprocessing of the 'trans' calculation, compute the Seebeck coefficient.  
* `'dynamics-run'`: ultrafast hot carrier dynamics via the time-dependent Boltzmann transport equation.
* `'dynamics-pp'`: postprocessing of the 'dynamics-run' calculation, compute the BZ-averaged energy-dependent carrier population.

In the following, we use silicon as an example to demonstrate the features of PERTURBO (see the directory _"example02-silicon-perturbo/perturbo"_, <a href="https://caltech.box.com/s/u1o6zyrdx88ftdvmtt77cduhbrwo9jpv" target="_blank">link</a>). **To run** `perturbo.x` **one first needs to generate the file _'perfix'\_epwan.h5_** (in this case, _si\_epwan.h5_), which is prepared using `qe2pert.x` as we discuss in section [qe2pert.x](mydoc_qe2pert.html#qe2pert.x). The file _si\_epwan.h5_ is inside the directory _"example02-silicon-perturbo/qe2pert.x"_, <a href="https://caltech.box.com/s/fyswa1mp0vgfvq4fllsrq44gu26zufgd" target="_blank">link</a>. For each calculation mode, we also provide reference results in the directory _"References"_. In all calculations, the same prefix value as in the QE DFT calculation should be used.


<a name="calc_mode_bands"></a>
### calc_mode = 'bands'
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-bands/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/p4qk1gs5snudd8blk3dh18kwn5m2bdsm"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b> Interpolated electronic band structure given an electronic crystal momentum path  </div>


 Users specify three variables in the input file (_pert.in_)
  - [prefix](mydoc_param_perturbo.html#prefix): the same prefix used in __'prefix'\_epwan.h5__
  - [calc\_mode](mydoc_param_perturbo.html#calc_mode): set to `'bands'` 
  - [fklist](mydoc_param_perturbo.html#fklist): the filename of a file containing the high-symmetry crystal momentum path or k list

Here is the input file or namelist (_pert.in_):

```fortran
&perturbo
 prefix = 'si'
 calc_mode = 'bands'
 fklist = 'si_band.kpt'
/
```

In this example, `fklist='si_band.kpt'`, the file _si\_band.kpt_ containing the $$\mathbf{k}$$ point list: 

<a name="fklist_file"></a>
```python
6
0.500   0.500   0.500   50
0.000   0.000   0.000   50
0.500   0.000   0.500   20
0.500   0.250   0.750   20
0.375   0.375   0.750   50
0.000   0.000   0.000   1
```

The first line specifies how many lines there are below the first line. Columns 1-3 give, respectively, the $$x$$, $$y$$, and $$z$$ coordinates of a crystal momentum **in crystal coordinates**. The last column is the number of points from the current crystal momentum to the next crystal momentum. One can also provide an explicit $$\mathbf{k}$$ point list, rather than specifying the path, by providing the number of $$\mathbf{k}$$ points in the first line, the coordinates of each $$\mathbf{k}$$ point, and setting the values in the last column to 1. 


Before running `perturbo.x`, remember to put _si\_epwan.h5_ in the current directory "pert-band" since `perturbo.x` needs to read _si\_epwan.h5_. You may choose to copy the HDF5 file using 

```$ cp ../../qe2pert/si_epwan.h5 .```

 But the size of the HDF5 file is usually quite large, creating a soft link that point to the original HDF5 file is strongly recommended:
 
 ```$ ln -sf ../../qe2pert/si_epwan.h5```

Run `perturbo.x`:

```bash
$ mpirun -n 1 perturbo.x -npools 1 -i pert.in > pert.out 
```

{% include note.html content="The number of pools (-npools) has to be equal to the number of MPI processes (-np or -n), otherwise the code will stop." %}

It takes just a few seconds to obtain the interpolated band structure. We obtain an output file called _'prefix'.bands_ (in this case, _si.bands_) with the following format:

```python
 0.0000000      0.50000    0.50000    0.50000     -3.4658249872
 ......
 3.7802390      0.00000    0.00000    0.00000     -5.8116812661
 
 ......
 ......
 
 0.0000000      0.50000    0.50000    0.50000     13.6984850767
 ......
 3.7802390      0.00000    0.00000    0.00000      9.4608102223
```

Note that there are 8 blocks in this example, one for each of the 8 bands, because we use 8 Wannier functions in the Wannierization procedure in this example. The 1<sup>st</sup> column is an irrelevant coordinate used to plot the band structure. The 2<sup>nd</sup> to 4<sup>th</sup> columns are the $$x$$, $$y$$, and $$z$$ coordinates of the crystal momenta **in crystal coordinates**. The 5<sup>th</sup> column is the energy, in eV units, of each electronic state.



<a name="calc_mode_phdisp"></a>
### calc_mode = 'phdisp'
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-phdisp/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/jqkiyhb5j096sfwcinrlp956w4d3fu5i"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  Interpolated phonon dispersions along a given crystal momentum path   </div>


 Users specify three variables in the input file (_pert.in_):
  - [prefix](mydoc_param_perturbo#prefix): the same prefix used in __'prefix'\_epwan.h5__
  - [calc_mode](mydoc_param_perturbo#calc_mode): set to 'phdisp' 
  - [fqlist](mydoc_param_perturbo#fqlist): the filename of a file containing the high-symmetry crystal momentum path or q list

Here is the input file (_pert.in_):

```fortran
&perturbo
 prefix = 'si'
 calc_mode = 'phdisp'
 fqlist = 'si_phdisp.qpt'
/
```

In this example, `fqlist='si_phdisp.qpt'`, and the file _si\_phdisp.qpt_ contains a crystal momentum path or list with the same format as the [file](#fklist_file) specified in `fklist` (in the [previous section](#calc_mode_bands)).

Remember to link (or copy) _si\_epwan.h5_ in the current directory using 

```ln -sf ../../qe2pert/si_epwan.h5```. 

<br/>
Run `perturbo.x`:

```bash
$ mpirun -n 1 perturbo.x -npools 1 -i pert.in > pert.out 
```

It takes a few seconds to obtain the phonon dispersion. We obtain an output file called _'prefix'.phdisp_ (in this case, _si.phdisp_) with the following format:

```python
0.0000000      0.50000    0.50000    0.50000     12.9198400723
......
3.7802390      0.00000    0.00000    0.00000     -0.0000024786

......
......

0.0000000      0.50000    0.50000    0.50000     45.6922098051
......
3.7802390      0.00000    0.00000    0.00000      0.0000014170
```

Note that there are 6 blocks, one for each of the to 6 phonon modes in silicon. The 1<sup>st</sup> column an irrelevant coordinate used to plot the phonon dispersion. The 2<sup>nd</sup> to 4<sup>th</sup> columns are the $$x$$, $$y$$, and $$z$$ coordinates of the crystal momenta, in crystal coordinate. The 5<sup>th</sup> column is the phonon energy in meV units.



<a name="calc_mode_ephmat"></a>
### calc_mode = 'ephmat'
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-ephmat/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/xqd47qx2kbu6sx6phvaa2n618x9ygaqn"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  The absolute values of the e-ph matrix elements, summed over the number of electronic bands, given two lists of $$\mathbf{k}$$ and $$\mathbf{q}$$ points. In a typical scenario, one computes the e-ph matrix elements for a chosen $$\mathbf{k}$$ point as a function of $$\mathbf{q}$$ point  </div>

 Requires to specify at least 7 variables:
  - [prefix](mydoc_param_perturbo#prefix): the same prefix as in _'prefix'\_epwan.h5_
  - [calc_mode](mydoc_param_perturbo#calc_mode): set to 'ephmat'
  - [fklist](mydoc_param_perturbo#fklist): the file containing a list of $$\mathbf{k}$$ points ([see the section](#calc_mode_bands) on `calc_mode='bands'`)
  - [fqlist](mydoc_param_perturbo#fqlist): the file containing a list of $$\mathbf{q}$$ points ([see the section](#calc_mode_bands) on `calc\_mode='bands'`)
  - [band_min](mydoc_param_perturbo#band_min), [band_max](mydoc_param_perturbo#band_max): bands used for the band summation in computing e-ph matrix elements
  - [phfreq_cutoff](mydoc_param_perturbo#phfreq_cutoff): phonon energy (meV) smaller than the cutoff will be ignored

In a typical scenario, the user wants to check if the interpolated e-ph matrix elements match with the density functional perturbation theory (DFPT) result. **Here we assume that users know how to obtain the DFPT e-ph matrix elements from the PHONON package in QE. --NOT TRUE, NEED PATCHING**

Here is the input file (_pert.in_):

```fortran
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

In this example, we compute the e-ph matrix elements summed over the bands from 2 to 4. The band index here refers to the band index of the Wannier functions, and it may not be the same as the band index in the DFT output from QE because sometimes bands are excluded in the Wannierization procedure. Make sure you know band range appropriate for your calculation, and provide accordingly [band_min](mydoc_param_perturbo#band_min) and [band_max](mydoc_param_perturbo#band_max). 

The variable [phfreq_cutoff](mydoc_param_perturbo#phfreq_cutoff) is used to avoid numerical instabilities in the phonon calculations, and we recommend using a value between 0.5 and 2 meV (unless you know that phonons in that energy range play a critical role). Do not set [phfreq_cutoff](mydoc_param_perturbo#phfreq_cutoff) to a large value, otherwise too many phonon modes will be excluded from the calculations. 

For the format of [fklist](mydoc_param_perturbo#fklist) or [fqlist](mydoc_param_perturbo#fqlist) files, please refer to the [section](#calc_mode_bands) on calc_mode='bands'. 

Before running `perturbo.x`, ensure that three files exist in the current directory _"pert-ephmat"_:

* _'prefix'\_epwan.h5_: here _si\_epwan.h5_
* _fklist_: here _eph.kpt_
* _fqlist_: here _eph.qpt_

Run `perturbo.x`:

```bash
$ mpirun -n 1 perturbo.x -npools 1 -i pert.in > pert.out 
```

The calculation typically takes a few minutes. The output file, called _'prefix'.ephmat_, contains the absolute values of the e-ph matrix elements summed over bands from [band_min](mydoc_param_perturbo#band_min) to [band_max](mydoc_param_perturbo#band_max). In our example, we obtain the output file _si.ephmat_, which is shown next:

```python
# ik    xk     iq     xq     imod   omega(meV)    deform. pot.(eV/A)     |g|(meV)
  1   0.00000   1   0.00000  001    12.919840     0.219927308382E+00   0.118026594146E+02
  ......
  ......
```

The 1<sup>st</sup> column is a dummy index for the $$\mathbf{k}$$ point. The 2<sup>nd</sup> column is the $$\mathbf{k}$$ point coordinate used for plotting. The 3<sup>rd</sup> and 4<sup>th</sup> columns are the dummy index and the $$\mathbf{q}$$ point coordinate used for plotting, respectively. The 5th column is the phonon mode index. The 6<sup>th</sup> column is the phonon energy (in meV). The 7<sup>th</sup> column is the deformation potential (in eV/Å units), namely the expectation value of the phonon perturbation potential with respect to the initial and final electronic states. The 8<sup>th</sup> column is the absolute values of the e-ph matrix elements (meV units) summed over the number of bands specified by the user. 

<a name="calc_mode_setup"></a>
### calc_mode = 'setup'
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-setup-electron/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/xdpr3f7on337rbdcpspuundxgbk8gzsw"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  Set up transport property calculations (i.e., electrical conductivity, carrier mobility and Seebeck) by providing $$\mathbf{k}$$ points, $$\mathbf{k}$$ point tetrahedra and (if needed) finding chemical potentials for given carrier concentrations  </div>

Requires to specify up to 14 variables in the input file (_pert.in_)
  - [prefix](mydoc_param_perturbo#prefix): same prefix as in _'prefix'\_epwan.h5_
  - [calc_mode](mydoc_param_perturbo#calc_mode): set to 'setup'
  - [hole](mydoc_param_perturbo#hole): By default, `hole` is set to `.false.`. Set it to .true. **only** when computing hole mobility of a semiconductor. if _hole_ is .true., `perturbo.x` computes hole concentration, instead of electron concentration. 
  - [boltz_kdim](mydoc_param_perturbo#boltz_kdim): number of $$\mathbf{k}$$ points along each dimension of a $$\mathbf{k}$$ point grid for the electrons momentum. This Gamma-centered Monkhorst-Pack $$\mathbf{k}$$ point grid is employed to compute the mobility or conductivity.
  - [boltz_qdim](mydoc_param_perturbo#boltz_qdim): number of $$\mathbf{q}$$ points along each dimension of a uniform grid for the phonon momentum; the default is that `boltz_qdim(i)=boltz_kdim(i)`. If users need the size as same as the $$\mathbf{k}$$ grid, no need to specify these variables. Only phonons with mmentum on the $$\mathbf{q}$$ grid are considered in the calculations of e-ph scattering. 
  - [boltz_emin](mydoc_param_perturbo#boltz_emin), [boltz_emax](mydoc_param_perturbo#boltz_emax): energy window (in eV units) used to compute transport properties. The suggested values are from 6 k_BT below E_F ([boltz_emin](mydoc_param_perturbo#boltz_emin)) to 6k_BT above E_F ([boltz_emax](mydoc_param_perturbo#boltz_emax)), where E<sub>F</sub> is the Fermi energy, k<sub>B</sub> the Boltzmann constant, and T is temperature in K units.
  - [band_min](mydoc_param_perturbo#band_min), [band_max](mydoc_param_perturbo#band_max): band window for transport property calculations
  - [ftemper](mydoc_param_perturbo#ftemper): the filename of a file containing the temperature(s), chemical potential(s), and corresponding carrier concentration(s) for transport property calculations. Either chemical potentials or carrier concentrations is required dependending on the calculation setting. 

Here is the input file (_pert.in_):

```fortran
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

In the input file _pert.in_, we use a $$\mathbf{k}$$ grid of 80 x 80 x 80 for electrons, which corresponds to boltz_kdim(i)=80, and use a $$\mathbf{q}$$ grid for phonons of the same dimension as the $$\mathbf{k}$$ grid. When a phonon $$\mathbf{q}$$ grid different from the electron $$\mathbf{k}$$ grid is desired, the user need to provide the $$\mathbf{q}$$ grid variables  _boltz\_qdim(1)_,  _boltz\_qdim(2)_, and _boltz\_qdim(3)_ in the input file.

In this example, we want to compute the mobility of the electron carrier, so we choose an energy window that includes the conduction band minimum. Here the energy window is between 6.4 (_boltz\_emin_) and 6.9 eV (_boltz\_emax_), and the conduction band minimum is at 6.63 eV in this case. We include the two lowest conduction bands, with band indices 5 and 6 (_band\_min_ and _band\_max_).

The 'setup' calculation find all the relevant $$\mathbf{k}$$ points (both irreducible and reducible $$\mathbf{k}$$ points) and the tetrahedron needed for BZ integration for the given energy window and band windowm compute the DOS at the given energy window. It also compute carrier concentrations at given chemical potentials or determine the chemical potentials that corresponding to the given carrier concentrations, depending on the setting in the ftemper file.  

In this case, the ftemper file `si.temper` has the following format:

<a name="ftemper_file"></a>
```python
1 T
300.00   6.52   1.0E+18
```

The integer in the first line is the number of (temperature, chemical potential) settings at which we want to perform the transport calculations. 
Each of the following lines contains three values, the temperature (K), Fermi level (eV), and carrier concentration (cm<sup>-3</sup> in 3D materials or cm<sup>-2</sup> in 2D materials). 

The logical variable in the first line indicates whether to compute the carrier concentration for the input chemical potential (if `F`)  or determine the chemical potential corresponding to the input carrier concentration (if `T`), thus only one of the chemical potential column and carrier concentration column in the _ftemper_ file is meaningful.

The logical variable is only used in the `'setup'` calculation. In all the other [calc_mode](mydoc_param_perturbo#calc_mode) options, `perturbo.x` reads the chemical potential column and ignores the carrier concentration column (and the logical variable). If one wants to perform transport calculations at given carrier concentrations, then set the logical variable to `T` in `'setup'` calculations. `perturbo.x` will find the corresponding chemical potentials and update the _ftemper_ file accordingly (overwrite the chemical potential and carrier concentration columns and set the logical variable to `F`). 

{% include note.html content="`perturbo.x` only search for chemical potentials within the given energy window, try extending the energy window if the updated _ftemper_ file does not show reasonable carrier concentrations." %}

Run `perturbo.x` with the following command (remember to link or copy _'prefix'\_epwan.h5_ in the current directory):

```bash
$ mpirun -n 1 perturbo.x -npools 1 -i pert.in > pert.out 
```

The calculation will take a few minutes or longer, depending the number of $$\mathbf{k}$$ and $$\mathbf{q}$$ points and the size of the energy window. We obtain 4 output files (_'prefix'.doping_, _'prefix'\_tet.h5_, _'prefix'\_tet.kpt_, and _'prefix'.dos_): 

* _'prefix'.doping_ contains chemical potentials and carrier concentrations for each tempearture of interest. The format is easy to understand so we do not show it here. Please take a look at the file by yourself. 
* _'prefix'\_tet.h5_ contains information on the $$\mathbf{k}$$ points (both in the irreducible wedge and full grid) and the associated $$\mathbf{k}$$ point tetrahedra in the energy window of interest. This file will be used to compute transport properties. Users familiar with HDF5 can read and manipulate this file with the standard HDF5 commands. The other users can just ignore the data stored in the file. 
* _'prefix'\_tet.kpt_ contains the coordinates (in crystal units) of the irreducible $$\mathbf{k}$$ points in the energy window of interest. Note that the irreducible $$\mathbf{k}$$ points coordinates is already included in _'prefix'\_tet.h5_, we output to this file in a format compatiable with that of _fklist_ discussed in the calculation mode `'bands'` ([above](#calc_mode_bands)) or `'imsigma'` ([below](#calc_mode_imsigma)).
* _'prefix'.dos_ contains the density of states (number of states per eV per unit cell) as a function of energy (eV). The format is easy to understand so we do not show it here. The density of states sets the phase space for several electron scattering processes, so it is convenient to compute it and print it out.

In our example, since we used `'T'` in the first line of ftemper, a new _ftemper_ file is generated as output: that the _ftemper_ file _'si.temper'_ has now become:

```python
1 F
300.00   6.5504824219   0.9945847E+18
```

Note how `perturbo.x` has computed the chemical potential (second entry in the second row) for the given temperature and carrier concentration (first and third entries of the second row). The logical variable in the first line is now `'F'`, and _si.temper_ can now be used as is in subsequent calculations.

The above explanation focuses on electrons. For holes carriers, please refer to _"example02-silicon-perturbo/perturbo/pert-setup-hole"_, <a href="https://caltech.box.com/s/zgucbdo77i88tcfod8zkinlxng79u441" target="_blank">link</a>. In the input file for holes, remember to use `hole=.true.` (default: `hole=.false.`), and choose an appropriate energy window and the band indices for holes. 


<a name="calc_mode_imsigma"></a>
### calc_mode = 'imsigma'
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-imsigma-electron/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/se41r5a9uhymhz1k0tsx7exrj2y2vj7d"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  The imaginary part of the lowest-order (so-called 'Fan') e-ph self-energy for states in a range of bands and with crystal momenta $$\mathbf{k}$$ read from a list. The scattering rates can also be obtained using $${2}/{\hbar} \operatorname{Im}\Sigma$$  </div>

Variables in the input file (_pert.in_)
  - [prefix](mydoc_param_perturbo#prefix): the same prefix as the file _'prefix'\_epwan.h5_
  - [calc_mode](mydoc_param_perturbo#calc_mode): set to `'imsigma'`
  - [band_min](mydoc_param_perturbo#band_min), [band_max](mydoc_param_perturbo#band_max): bands used for transport property calculations
  - [ftemper](mydoc_param_perturbo#ftemper): the filename of a file containing temperature, chemical potential, and carrier concentration values ([see the format](#ftemper_file))
  - [fklist](mydoc_param_perturbo#fklist): the filename of a file containing the coordinates of a given electron $$\mathbf{k}$$ point list ([see the format](#fklist_file))
  - [phfreq_cutoff](mydoc_param_perturbo#phfreq_cutoff): the cutoff energy for the phonons. Phonon with their energy smaller than the cutoff (in meV) is ignored; 0.5-2 meV is recommended. 
  - [delta_smear](mydoc_param_perturbo#delta_smear): the broadening (in meV) used for the Gaussian function used to model the Dirac delta function
  - [fqlist](mydoc_param_perturbo#fqlist): the filename of a file containing the coordinates of a given phonon $$\mathbf{q}$$ point list will be used to compute the e-ph self-energy. For the format, see the [section](#calc_mode_bands) on the calculation mode `'bands'`. This is optional. If `fqlist` is absent or `fqlist_=''`, random $$\mathbf{q}$$ points will be generated (see below). 
  - [sampling](mydoc_param_perturbo#sampling): sampling method for random $$\mathbf{q}$$ points used in e-ph self-energy calculation. The default value is `'uniform'`, indicates sampling random $$\mathbf{q}$$ points in the first BZ following uniform distribution. Another option is `'cauchy'`, sampling random $$\mathbf{q}$$ points following Cauchy distribution, which is useful for polar materials. Note that random $$\mathbf{q}$$ points from other importance sampling methods or $$\mathbf{q}$$ points on regular MP grid is also possible, one just needs to pre-generate the $$\mathbf{q}$$ points list to a file, and pass the file to `perturbo.x` via `fqlist`.  
  - [cauchy_scale](mydoc_param_perturbo#cauchy_scale): the width of the Cauchy function; used only when [sampling](mydoc_param_perturbo#sampling) is 'cauchy'.
  - [nsamples](mydoc_param_perturbo#nsamples): number of random $$\mathbf{q}$$ points sampled to compute the imaginary part of the e-ph self-energy for each $$\mathbf{k}$$ point 

Here is the input file (_pert.in_):

```fortran
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

In the current example, we compute the imaginary part of the e-ph self-energy of $$\mathbf{k}$$ points in the _fklist_ file (in this case, we use the irreducible Monkhorst-Pack $$\mathbf{k}$$ point list in _si\_tet.kpt_ obtained from the calculation mode `'setup'`). Note that if one is only interested in a high symmetry line, one can provide $$\mathbf{k}$$ point path in the _fklist_ file instead. The temperature, chemical potential for computing the e-ph self-energy are given in the _ftemper_ file, _si.temper_, obtained from the perturbo `'setup'` process (the carrier concentration column is ignored in `'imsigma'` calculation). Note that `perturbo.x` will do calculations, at once, for as many combinations of temperature and chemical potential as are specified in the lines below the first of _ftemper_.

Here we use a uniform random sampling (`sampling='uniform'`) with 1 million random $$\mathbf{q}$$ points (`nsample=1000000`). The phonon frequency cutoff is 1 meV (`phfreq_cutoff=1`), and the smearing for the Gaussian function is 10 meV (`delta_smear=10`). 

Before running `perturbo.x`, remember to link or copy _'prefix'\_epwan.h5_ in the current directory.

```bash
export OMP_NUM_THREADS=4
$ mpirun -n 8 perturbo.x -npools 8 -i pert.in > pert.out
```
This task is usually time-comsuming time-consuming on a single core, thus we run this calculation on multiple cores (32 cores in this case) using hybrid MPI plus openMP parallelization.

We obtain two output files:

* _'prefix'.imsigma_ contains the computed imaginary part of the e-ph self-energy
* _'prefix'.imsigma\_mode_ contains the computed imaginary part of the e-ph self-energy (where phonon modes are numbered for increasing energy values).

The following is the format of _'prefix'.imsigma_ (in this case, _si.imsigma_):

<a name="imsigma_file"></a>
```python
#  Electron (Imaginary) Self-Energy in the Migdal Approx.  #
#      ( only for bands within [band_min, band_max] )      #
#----------------------------------------------------------#
# NO.k:    450   NO.bands:   2   NO.T:   1   NO.modes:   1
#
# Temperature(T)= 25.85203 meV;  Chem.Pot.(mu)= 6.55048 eV
#===========================================================
# it     ik   ibnd    E(ibnd)(eV)     Im(Sigma)(meV)
#-----------------------------------------------------------
  1       1     1      6.955370   1.2413716479777598E+01
  ......
  ......
#-----------------------------------------------------------
```

The variable _it_ is a dummy variable for enumerating the temperature values, while, _ik_ is the number of $$\mathbf{k}$$ points in the fklist, _ibnd_ the band number (in this case, band indices are 5 and 6). _Im(Sigma)_ is the imaginary part of the e-ph self-energy (in meV units) for each state of interest.

Similarly, the format for _si.imsigma\_mode_ is 

```python
#  Electron (Imaginary) Self-Energy in the Migdal Approx.  #
#      ( only for bands within [band_min, band_max] )      #
#----------------------------------------------------------#
# NO.k:    450   NO.bands:   2   NO.T:   1   NO.modes:   6
#
# Temperature(T)= 25.85203 meV;  Chem.Pot.(mu)= 6.55048 eV
#===========================================================
# it     ik   ibnd    E(ibnd)(eV)  imode    Im(Sigma)(meV)
#-----------------------------------------------------------
  1      1     1      6.955370     1   1.415350400936959E+00
  ......
  ......
#-----------------------------------------------------------
```

Here we have an extra column with the phonon mode index (_imode_). 


{% include note.html content="One should always check the convergence of the e-ph self-energy with respect to the number of $$\mathbf{q}$$ points and the smearing parameter \([delta_smear](mydoc_param_perturbo#delta_smear)\). Check <a href='https://arxiv.org/abs/1608.03514' target='_blank'>this paper</a> for more detail." %}


Using the results in the _'prefix'.imsigma_ file, one can easily obtain, with a small script, the scattering rates for each state, which are equal to $${2}/{\hbar} \operatorname{Im}\Sigma$$ (it's convenient to use $$\hbar = 0.65821195\,\mathrm{eV}\,\mathrm{fs}$$ to this end). Using additional tools provided in `perturbo.x`, we can also compute the mean free path for each electronic state, as well as a range of phonon-limited transport properties.

One way of obtaining the relaxation times (and their inverse, the scattering rates) is to run the Python script `relaxation_time.py` we provide to post-process the imsigma output (the desciption of the script is [here](mydoc_relaxation_time)). Another way is to obtain the relaxation times is to run a calculation of the mean free paths (see below), which conveniently outputs both the relaxation times and the mean free path for the desired electronic states. 

Also note that an example calculation of the e-ph self-energy for holes, is provided in the example folder _"example02-silicon-perturbo/perturbo/pert-imsigma-hole"_, <a href="https://caltech.box.com/s/uorougr1783u7d6bcjdsm4e2d62xfvta" target="_blank">link</a>, where we use different band indices (`band_min=2` and `band_max=4`), and the files, _fklist_ and _ftemper_, are also different and obtained in a different perturbo `'setup'` calculation. 


<a name="calc_mode_meanfp"></a>
### calc_mode = 'meanfp'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-meanfp-electron/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/3fhdgj9xvsi6gpqtu8po2295rdrq387x"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  The e-ph mean free paths for electronic states in a user-defined $$\mathbf{k}$$ point list and range of bands  </div>

{% include note.html content="The mean free path calculation relies on the results of the calculation mode `'imsigma'` values obtained. Therefore, the user should first run the calculation mode `'imsigma'`, and then compute the mean free paths" %}

Requires the same files as `calc_mode='imsigma'` but needs an additional file, _'prefix'.imsigma_, obtained as an output in the `'imsigma'` calculation.

Here is the input file (_pert.in_). It should be the same input as the one for the `'imsigma'` calculation mode, except for the line specifying `calc_mode='meanfp'`:

```fortran
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

Before running `perturbo.x`, make sure you have the following files in the current directory (_"pert-meanfp-electron"_): _'prefix'\_epwan.h5_, _'prefix'.imsigma_ the _fklist_ file (_si\_tet.kpt_ in this example), and the _ftemper_ file (e.g., _si.temper_ in this example). As explained above, one can reuse the input file of the calculation mode `'imsigma'` by replacing the calculation mode with `calc_mode='meanfp'`. 

```bash
$ mpirun -n 1 perturbo.x -npools 1 -i pert.in > pert.out
```

This calculation usually takes only takes a few seconds. We obtain two output files:

* _'prefix'.mfp_ contains the relaxation time and mean free path of each electronic state. Note that the MFP is the product of the state relaxation time and the absolute value of the band velocity.
* _'prefix'.vel_ contains the band velocity of each state  

The format of _'prefix'.mfp_ is as follows:

```python
#==========================================================#
#    Electron Mean Free Path (tau_nk * |v_nk|, in nm)      #
#==========================================================#
#          NO.k:    2637   NO.bands:    2   NO.T:    1
#########
# Temperature(T)= 25.85203 meV;  Chem.Pot.(mu)= 6.55048 eV
#-----------------------------------------------------------
# it ik ibnd E(ibnd)(eV) Relaxation time(in fs)  MFP (in nm)
#-----------------------------------------------------------
  1   1  1   6.955370   2.6511488462206518E+01   9.5929573542019302E+00
  ......
  ......
```

The variable _it_ is the dummy variable for temperature; in this case, we only used one temperature (300 K). _ik_ is the dummy variable for the given crystal momentum in the file fklist. _ibnd_ is the dummy variable for bands; in this case, ibnd=1 corresponds to band index 5 and ibnd=2 is the band index 6. The 4<sup>th</sup>, 5<sup>th</sup>, and 6<sup>th</sup> columns are energy (eV), relaxation time (fs), and mean free path (nm) of each state, respectively.

The format of _'prefix'.vel_ is shown below: 

```python

######################################################
#                    Band velocity                   #
######################################################
#  ik  ibnd   E(ibnd)(eV)     k.coord. (cart. alat)                vel-dir                  |vel| (m/s)
   1     1      6.955370  -0.01250  0.58750 -0.01250     -0.24926 -0.93581 -0.24926   3.6184152269976016E+05
......
......
```

The 1<sup>st</sup> to 3<sup>rd</sup> columns are the same as in _'prefix'.mfp_. The 4<sup>th</sup> to 6<sup>th</sup> columns are the $$\mathbf{k}$$ point coordinates in the crystal units. The 7<sup>th</sup> to 9<sup>th</sup> columns are the components of the unit vector specifying the direction of the velocity of each electronic states. The last column is the magnitude of the velocity (m/s) of each state. 

For an example calculation of mean free paths for holes, please see the folder _"example02-silicon-perturbo/perturbo/pert-meanfp-hole"_, <a href="https://caltech.box.com/s/ad7lknmib8wdxjsgf0e1ex3m54z211v3" target="_blank">link</a>.


<a name="calc_mode_trans"></a>
### calc_mode = 'trans'

The calculation mode `'trans'` computes the electrical conductivity and carrier mobility tensors. The code can compute these quantities using the relaxation time approximantion (RTA) of the Boltzmann transport equation (BTE) or an iterative approach (ITA) to fully solve the linearized BTE. 

#### Relaxation time approximation (RTA)
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-trans-RTA-electron/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/7x7lexe9r6ieu2wsucyomhr3c6cz0yfq"
target="_blank">link</a>
</span>
</div>

   <div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b>  The phonon-limited conductivity and carrier mobility using the RTA of the BTE</div>

{% include note.html content="The user needs to run the calculation modes `'setup'` and then `'imsigma'` since this calculation mode relies on their outputs" %}

Requires the same variables as those specified in the calculation mode `'setup'`, except for the following two variables:
  - [calc_mode](mydoc_param_perturbo#calc_mode): set to `'trans'`
  - [boltz_nstep](mydoc_param_perturbo#): set to 0, which means computing the mobility using the RTA 

Here is the input file (_pert.in_):

```fortran
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

* _'prefix'\_epwan.h5_: here _si\_epwan.h5_
* _ftemper_: here _si.temper_ obtained in the `'setup'` calculation 
* _'prefix'\_tet.h5_: here _si\_tet.h5_ obtained in the `'setup'` calculation 
* _'prefix'.imsigma_: here _si.imsigma_ obtained in the `'imsigma'` calculation     

Run `perturbo.x`:

```bash
$ mpirun -n 1 perturbo.x -npools 1 -i pert.in > pert.out
```

This calculation usually takes a few minutes. We obtain three output files:

* _'prefix'.cond_ contains the conductivity and mobility tensors as a function of temperature
* _'prefix'.tdf_ contains transport distribution function (TDF) as a function of carrier energy and temperature
* _'prefix'\_tdf.h5_ includes all the information of the TDF for each temperature in HDF5 format

In our example, the output file is _si.cond_, which is shown here:


```python
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

The second output file is _si.tdf_, whose format is shown below:

```python
#==========================================================#
# E(eV) (-df/dE) (a.u.)  TDF(E)_(xx xy yy xz yz zz) (a.u.) #

# Temperature:  300.0000  Chemical Potential: 6.550482
  
   ......
   6.636612    1.7531179753260076E+01    0.316717E-02   0.178762E-07   0.316728E-02   0.936616E-08   0.153835E-06   0.316718E-02
   ......
   ......
```

Column 1 is the carrier energy (eV), column 2 is the energy derivative of Fermi-Dirac distribution at the energy given by column 1, and column 3\-8 is the TDF for each energy (same as conductivity, TDF has six components, usually the longitudinal component is plotted), respectively. The data for each temperature and chemical potential combination is given in a separate block in the file. In this case, we look at one temperature and one concentration, so there is only one block in the file.  

In more rigorous calculations, the user will need to converge the conductivity and mobility with respect to the number of $$\mathbf{k}$$ and $$\mathbf{q}$$ points, namely the variables [boltz_kdim](mydoc_param_perturbo#boltz_kdim) and [boltz_qdim](mydoc_param_perturbo#boltz_qdim). 

An example for hole carriers is also provided, in the folder _"example02-silicon-perturbo/perturbo/pert-trans-RTA-hole"_, <a href="https://caltech.box.com/s/8jc3mxfawyy3rup295jz7o8jpe4keiaz" target="_blank">link</a>.

#### Iterative approach (ITA)
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-trans-ITA-electron/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/4v6752vkisuwt0n048bkuu2n9xtrqahs"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b> The phonon-limited conductivity and carrier mobility using ITA  </div>

{% include note.html content="The user needs to run the calculation modes `'setup'` since this calculation mode relies on their outputs. The _'prefix'.imsigma_ file is optional, use it as a starting point for the iterative process if present." %}

Requires the same input file variables as the calculation mode "setup", except for the following 6 variables:
  - [calc_mode](mydoc_param_perturbo#calc_mode): is set to `'trans'`
  - [boltz_nstep](mydoc_param_perturbo#boltz_nstep): contains the maximum number of iterations in the iterative scheme for solving Boltzmann equation, where a typical value is 10
  - [phfreq_cutoff](mydoc_param_perturbo#phfreq_cutoff): contains phonon threshold (meV). Phonons with energy smaller than the cutoff will be ignored.
  - [delta_smear](mydoc_param_perturbo#delta_smear): contains broadening (meV) for a Gaussian function to present the Dirac delta function
  - [tmp_dir](mydoc_param_perturbo#tmp_dir): contains output directory containing the e-ph matrix elements used in the calculations
  - [load_scatter_eph](mydoc_param_perturbo#load_scatter_eph): if `.true.`, it will read the e-ph matrix elements from _tmp\_dir_. The default is `.false.`

Here is the input file (_pert.in_):

```fortran
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


Before running the ITA calculation, make sure that the following files are in the current directory (_"pert-trans-ITA-electron"_):

* _'prefix'\_epwan.h5_: here _si_epwan.h5_
* _ftemper_: here _si.temper_
* _'prefix'\_tet.h5_: here _si\_tet.h5_ 

```bash
export OMP_NUM_THREADS=4
$ mpirun -n 8 perturbo.x -npools 8 -i pert.in > pert.out
```

This task is time-comsuming using one thread and one MPI process on a single core. To speed up the calculations, we run it on multiple cores using hybrid MPI plus openMP parallelization. After the calculation has completed, we obtain 3 output files, _'prefix'.cond_, _'prefix'.tdf_, and _'prefix'\_tdf.h5_, similar to the RTA calculation.

{% include note.html content="For ITA calculations, each MPI process could consume a significnat amount of RAM (memory). If RAM of computing nodes is limited, one can set `OMP_NUM_THREADS` to the total number of cores of the computing node, and set the MPI process per node to 1" %}

An example calculation for holes is also provided in the folder _"example02-silicon-perturbo/perturbo/pert-trans-ITA-hole"_, <a href="https://caltech.box.com/s/m7ajrealqbn0x2oxq1cnpmc3hv7ztmy2" target="_blank">link</a>.



<a name="calc_mode_trans-pp"></a>
### calc_mode = 'trans-pp'

<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-trans-pp-electron/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/gwbvrdbuticvu2g3vs4t2pisgpox8a2r"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b> Seebeck coefficient. Note that phonon drag effects are not included in this calculation.
  </div>

Uses the same input file as the `'trans'` calculation mode, but requires the additional file _'prefix'\_tdf.h5_ obtained in the `'trans'` calculation. The Seebeck calculation is a quick post-processing of the 'trans' calculation, which needs to be done before running `'trans-pp'`.

Change the calculation mode in the input file to `'trans-pp'`. Before running `perturbo.x`, make sure that four files exist in the current directory:

* _'prefix'_epwan.h5_: here _si\_epwan.h5_
* _ftemper_: here _si.temper_
* _'prefix'_tet.h5_: here _si\_tet.h5_
* _'prefix'_tdf.h5_: here _si\_tdf.h5_

Run `perturbo.x`:

``` bash
$ mpirun -n 1 perturbo.x -npools 1 -i pert.in > pert.out
```

It takes a few seconds. We obtain a file, _'prefix'.trans_coef_, in this case, si.trans_coef, which has the following format:

```python
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

The two blocks for the conductivity and mobility are the same as those in the `'trans'` calculation mode, but the output file of `'trans-pp'` has an additional block with the Seebeck coefficient results. 

An example calculation for holes is also provided in the folder _"example02-silicon-perturbo/perturbo/pert-trans-pp-hole"_, <br> <a href="https://caltech.box.com/s/uqh22v7hpqs5nb8ip224qh7fl0gqh6ek" target="_blank">link</a>.




<a name="calc_mode_dynamics-run"></a>
### calc_mode = 'dynamics-run' 
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-dynamics-run/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/mrzlzcl4iix17xrb7y3kanjlefscnsac"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b> Ultrafast hot carrier dynamics via the time-dependent Boltzmann transport equation: set an initial carrier distribution and calculate its evolution in time </div>

For the ultrafast dynamics, one needs first to perform the `calc_mode = 'setup'` calculation, which is described [here](#calc_mode_setup). So, we assume that the user has already performed the `'setup'` calculation. From the `'setup'` calculation, we retain the following files necessary for the dynamics calculations: _'prefix'.temper_ and _'prefix'\_tet.h5_. 
 
For the `'dynamics-run'` calculation, specify the following variables in the input file (_pert.in_):
  - [preifx](mydoc_param_perturbo#prefix): the same prefix as in _'prefix'\_epwan.h5_
  - [calc_mode](mydoc_param_perturbo#calc_mode): set to `'dynamics-run'`
  - [boltz_kdim](mydoc_param_perturbo#boltz_kdim): $$\mathbf{k}$$ grid for electrons, here we use a 80x80x80 grid
  - [boltz_qdim](mydoc_param_perturbo#boltz_qdim): $$\mathbf{q}$$ grid for phonons, specify if it is different from the $$\mathbf{k}$$ grid, here we use the same $$\mathbf{q}$$ grid as $$\mathbf{k}$$ grid
  - [boltz_emin](mydoc_param_perturbo#boltz_emin), [boltz_emax](mydoc_param_perturbo#boltz_emax): energy window (in eV units), use the same as in the `'setup'` calculation
  - [band_min](mydoc_param_perturbo#band_min), [band_max](mydoc_param_perturbo#band_max): band range
  - [ftemper](mydoc_param_perturbo#ftemper): the filename of a file containing temperature, chemical potential, and carrier concentration values ([see the format](#ftemper_file))
  - [time_step](mydoc_param_perturbo#time_step): simulation time step, set to its typical value, 1 fs
  - [boltz_nstep](mydoc_param_perturbo#boltz_nstep): total number of time steps, set to 50; here we perform a relatively short simulation of 50 fs 
  - [output_nstep](mydoc_param_perturbo#output_nstep): an optional variable to shorten the output; the output time step $$\Delta t_{out}$$ is determined in the following way: $$\Delta t_{out} = \texttt{output_nstep}\times \Delta t_{sim}  $$, where $$\Delta t_{sim} $$ is the simulation time step
  - [solver](mydoc_param_perturbo#solver): BTE solver type, set to `'euler'`, here we use the Euler first order solver of BTE 
  - [boltz_init_dist](mydoc_param_perturbo#boltz_init_dist): set to `'gaussian'`, we select the Gaussian initial distribution. To restart the simulation, specify `boltz_init_dist='restart'`, then the distribution of the last step from the previous simulation will be used.
  - [boltz_init_e0](mydoc_param_perturbo#boltz_init_e0): in this example, the Gaussian distribution is centered around 7.4 eV
  - [boltz_init_smear](mydoc_param_perturbo#boltz_init_smear): we select a 40 meV smearing
  - [phfreq_cutoff](mydoc_param_perturbo#phfreq_cutoff): we select a 1 meV phonon energy cutoff
  - [delta_smear](mydoc_param_perturbo#delta_smear): the broadening to model the Dirac delta function is chosen to 8 meV

Here is the input file (_pert.in_):
<a name="input_file_dynamics-run"></a>

```fortran
&perturbo
 prefix      = 'si'
 calc_mode   = 'dynamics-run'

 boltz_kdim(1) = 80
 boltz_kdim(2) = 80
 boltz_kdim(3) = 80

 boltz_emin = 6.4
 boltz_emax = 6.9
 band_min = 5
 band_max = 6

 ftemper  = 'si.temper'

 time_step   = 1 !fs
 boltz_nstep = 50
 output_nstep = 2
 solver = 'euler'

 boltz_init_dist = 'gaussian'
 boltz_init_e0 = 7.4 ! eV
 boltz_init_smear = 40 !meV

 tmp_dir = "./tmp"
 phfreq_cutoff = 1 ! meV
 delta_smear = 8 ! meV
/
```

In this example, we calculate the evolution of the electron distribution. In order to perform the hole dynamics, set the parameter <a href="mydoc_param_perturbo.html#hole">hole</a> to `true`.

Run `perturbo.x` (remember to link or copy _'prefix'\_epwan.h5_ in the current directory):

```bash
$ export OMP_NUM_THREADS=4
$ mpirun -n 8 <perturbo_bin>/perturbo.x -npools 8 -i pert.in > pert.out
```

We obtain the _'prefix'\_cdyna.h5_ HDF5 output file (this file can be also found in the _"References"_ directory). This file contains all the necessary output information about the performed simulation. This file is organized as follows:

- `band_structure_ryd`: electronic bandstructure in Ry; each column corresponds to the band index $$n$$ $$(~\texttt{band_min}\leq n \leq \texttt{band_max})$$
- `dynamics_run_[i]`: an HDF5 group that contains information about the _i<sup> th</sup>_ simulation.<br/>  If the simulation was restarted (`boltz_init_dist='restart'`) one or more times, one will have several dynamics_run_[i] groups, otherwise, only dynamics_run_1 will be present. A group dynamics_run_[i] is structured as follows:
  - `num_steps`: the number of _output_ time steps (taking into account [output_nstep](mydoc_param_perturbo#output_nstep)), can be different for different dynamics_run_[i]
  <br/><br/>
  - `snap_t_0`: $$f_{n\mathbf{k}}(t_0)$$
  <br/>$$\vdots$$<br/>
  - `snap_t_[j]`: the distribution function $$f_{n\mathbf{k}}$$ for time $$t_j$$: $$t_j = t_0 + j\Delta t_{out}  $$, where $$\Delta t_{out} $$ is the output time step. Each column of the array corresponds to the band index $$n$$
  <br/>$$\vdots$$<br/>
  - `snap_t_[num_steps]`: $$f_{n\mathbf{k}}(t_{\texttt{num_steps}})$$
  <br/><br/>
  - `time_step_fs`: the output time step $$\Delta t_{out}$$ (can be different for different dynamics_run_[i])
- `num_runs`: total number of performed simulations (corresponds to the number of dynamics_run_[i] groups).

<br/>
The _'prefix'\_cdyna.h5_ file structure can be schematically represented as follows:
<img src="images/diagram_hdf5_dynamics/diagram_hdf5_dynamics-run.svg" alt="diagram_hdf5_dynamics-run">

The HDF5 files can be easily processed by python pakage <a href="https://docs.h5py.org/en/stable/">python package h5py</a>. As an example, we present here a simple Python script that visualizes the distribution function for the time $$t_5$$ of the simulation and for the first band (in the selected band range):

```python
#!/usr/bin/env python3
import h5py
import matplotlib.pyplot as plt

prefix='si'
snap_number=5
band_index=0

# load the HDF5 file
h5file = h5py.File(prefix+'_cdyna.h5', 'r')

# get the data
ryd2ev = h5file['band_structure_ryd'].attrs['ryd2ev']
energy_ev = h5file['band_structure_ryd'][:,band_index] * ryd2ev
dist_func = h5file['dynamics_run_1']['snap_t_'+str(snap_number)][:,band_index]
h5file.close()

# plot the data
plt.plot(energy_ev,dist_func,marker='o',linestyle='')
plt.xlabel('Energy (eV)')
plt.ylabel('Distribution function')
plt.show()
```

In order to postprocess this file using `perturbo.x`, see the next section.

<a name="calc_mode_dynamics-pp"></a>
### calc_mode = 'dynamics-pp' 
<div markdown="span" class="alert alert-warning" role="alert"><i class="fa fa-folder fa"></i>
<b> Directory:</b>
<i>
example02-silicon-perturbo/perturbo/pert-dynamics-pp/
</i>
&nbsp;&nbsp;
<span style="float: right;">
<a href=
"https://caltech.box.com/s/kfqh3hig2knmga8kltup8a6cj68da4mc"
target="_blank">link</a>
</span>
</div>

<div markdown="span" class="alert alert-success" role="alert"><i class="fa fa-server fa"></i> <b> Computes:</b> Postprocessing of the ultrafast dynamics calculations</div>

In this section we aim to calculate the Brillouin zone-averaged _energy_-dependent carrier population $$\bar{f}(E,t) $$. Having calculated the distribution function $$f_{n\mathbf{k}}(t)$$, one can find $$\bar{f}(E,t) $$ in the following way:

$$
\bar{f}(E,t) = \sum_{n\mathbf{k}} f_{n\mathbf{k}}(t) \delta(\epsilon_{n\mathbf{k}}-E).
$$

The integral of $$\bar{f}(E,t)$$ over the energy gives the number of carriers per unit cell as a function of time.

In order to calculate the $$\bar{f}(E,t)$$ quantity, one needs to have all the files required for the `calc_mode='dynamics-run'` calculation ([previous section](#calc_mode_dynamics-run)) and the HDF5 output file _'prefix'\_cdyna.h5_ from the dynamics-run calculation. To perform the postprocessing, use a similar to the previous section [input file](#input_file_dynamics-run), but change the calculation mode to `calc_mode='dynamics-pp'`. Run `perturbo.x` (remember to link or copy _'prefix'\_epwan.h5_ in the current directory):

```bash
$ mpirun -n 1 <perturbo_bin>/perturbo.x -npools 1 -i pert.in > pert.out
```

On the output, we obtain the following files: 

- _si\_popu.h5_: an HDF5 file that contains all the necessary information for $$\bar{f}(E,t) $$
- _si_cdyna.dat_: an ASCII file containing the number of carriers per unit cell as a function of time

The _si\_popu.h5_ HDF5 file is organized as follows:

- `energy_distribution`: a group that contains the populations for all the time instants of the dynamics-run simulation
  <br/><br/>
  - `popu_t1`: $$ \bar{f}(E,t_1) $$
  <br/>$$\vdots$$<br/>
  - `popu_t[j]`: the carrier population $$\bar{f}(E,t_j)$$ at time $$t_j$$
  <br/>$$\vdots$$<br/>
  - `popu_t[num_steps+1]`: $$ \bar{f}(E,t_{\texttt{num_steps+1}}) $$
  <br/><br/>
- `energy_grid_ev`: the grid of energies in eV; the number of energy grid points is given by $$ \frac{ \texttt{emax} - \texttt{emin} }{ \texttt{boltz_de} }+\texttt{3}$$
- `times_fs`: the array of time instants in fs

<br/>
The _si\_popu.h5_ HDF5 file can be schematically represented as follows:
<img src="images/diagram_hdf5_dynamics/diagram_hdf5_dynamics-pp.svg" alt="diagram_hdf5_dynamics-pp">

Similarly to the previous section, we provide here a simplistic Python script showing an example how to manipulate this HDF5 file. For example, to plot the electron population for the time $$t_{25}$$, run:

```python
#!/usr/bin/env python3
import h5py
import matplotlib.pyplot as plt

prefix='si'
snap_number=25

# load the HDF5 file
h5file = h5py.File(prefix+'_popu.h5', 'r')

# get the data
energy_ev = h5file['energy_grid_ev'][()]
population = h5file['energy_distribution']['popu_t'+str(snap_number)][()]
h5file.close()

# plot the data
plt.plot(energy_ev,population,marker='o',linestyle='')
plt.xlabel('Energy (eV)')
plt.ylabel('Electron population')
plt.show()
```

It is also convenient to postprocess and visualize the data in HDF5 file using other high level languages, such as Julia. For example, the following Julia script does the same thing as the above Python script: 

```Julia
using HDF5, Plots

prefix = "si"
fname = prefix * "_popu.h5"
snap_number = 25

# read the data
energy_ev = h5read(fname, "energy_grid_ev")
population = h5read(fname, "energy_distribution/popu_t"*string(snap_number))

# plot
plot(energy_ev, population, xlabel="Energy (eV)", ylabel="Electron population")
```
