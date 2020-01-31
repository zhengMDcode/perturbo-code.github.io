---
title: Relaxation time from the 'imsigma' calculation
sidebar: mydoc_sidebar
last_updated: January 12, 2020
permalink: mydoc_relaxation_time.html
folder: mydoc
toc: false
---

Having computed the  $$\operatorname{Im}\Sigma$$ values from the `'imsigma'` PERTURBO calculation (described [here](mydoc_perturbo.html#calc_mode_imsigma)), one can find the relaxation time $$\tau$$ in the following way:

$$ 
\tau = \frac{\hbar}{2} \frac{1}{\operatorname{Im}\Sigma}.
$$

The scattering rate can be then found as the inverse of the relaxation time, $$\tau^{-1}$$.

In order to calculate the relaxation times and the scattering rates from the `'imsigma'` calculation, we provide the `relaxation_time.py` Python script.
To use it, you should have a _'preifx'_.imsigma file obtained as an output from the `'imsigma'` calculation.

Run the script in the directory where the _'preifx'.imsigma_ file is located:

```bash
$ [perturbo_path]/utils/relaxation_time.py
```
If you have more than one _.imsigma_ file in the directory, specify the file name with `--imsigma_file [file.imsigma]` (or `-i [file.imsigma]`) option.

The script generates the file called _relaxation_time.dat_, which has the following format:

```python
 # it   ik  ibnd      E(ibnd)(eV)   Relaxation time(in fs)   Scattering rate (in THz)
   1       1     1      6.955370    2.6511488462206518e+01  3.7719496641071323e+01
  ......
  ......
 #------------------------------------------------------------
```

The first four columns are the same as in the [_'prefix'.imsigma_ file](mydoc_perturbo.html#imsigma_file), which are: 1) the dummy variable for the temperature, 2) the number of $$\mathbf{k}$$ point, 3) the band number, 4) the energy. The 5<sup>th</sup> and 6<sup>th</sup> columns are the relaxation time (in fs) and the scattering rate (in THz).
