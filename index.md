---
title: "Introduction"
keywords: introduction homepage 
sidebar: mydoc_sidebar
permalink: index.html
toc: false
---


<style>
.mySlides {display:none;
margin-left: 40px
}


/* Next & previous buttons */
.prev,
.next {
  cursor: pointer;
  position: absolute;
  top: 40%;
  width: auto;
  padding: 16px;
  margin-top: -50px;
  color: white;
  font-weight: bold;
  font-size: 20px;
  border-radius: 0 3px 3px 0;
  user-select: none;
  background-color: rgba(0, 0, 0, 0.2);
  -webkit-user-select: none;
}

/* Position the "next button" to the right */
.next {
  right: 0;
  border-radius: 3px 0 0 3px;
}

/* On hover, add a black background color with a little bit see-through */
.prev:hover,
.next:hover {
  background-color: rgba(0, 0, 0, 0.8);
}

.image_box{
  height: 250px;
  display: block;
  position:relative;
  margin-left: auto;
  margin-right: auto;
  width: 95%;
}

</style>

<div class="image_box">
  <img class="mySlides" src="/images/slideshow/figure_workflow.pdf" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/figure_scaling.pdf" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/figure_naph.pdf" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/figure_trans.pdf" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/figure_cdyna.pdf" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/img1.jpg" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/img2.jpg" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/img3.jpg" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/img4.png" style="width:86%;margin-left:7%">
  <img class="mySlides" src="/images/slideshow/img5.jpg" style="width:86%;margin-left:7%">

  <button class="prev" onclick="plusDivs(-1)">&#10094;</button>
  <button class="next" onclick="plusDivs(1)">&#10095;</button>
</div>

<script>
var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName("mySlides");
  if (n > x.length) {slideIndex = 1}
  if (n < 1) {slideIndex = x.length}
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";  
  }
  x[slideIndex-1].style.display = "block";  
}
</script>

<br>

PERTURBO is an open source software to compute from first principles the scattering processes between charge carriers (electrons and holes) and phonons, defects, and photons in solid state materials, including metals, semiconductors, oxides, and insulators. In the current version, PERTURBO mainly computes electron-phonon (e-ph) interactions and phonon limited transport properties in the framework of the Boltzmann transport equation (BTE). These include the carrier mobility, electrical conductivity, and Seebeck coefficient. PERTURBO can also compute the ultrafast carrier dynamics (for now, with fixed phonon occupations) by explicitly time-stepping the time-dependent BTE. We will include additional electron interactions, transport and ultrafast dynamics calculations in future releases.

PERTURBO is written in Fortran95 with hybrid parallelization <a href="https://www.open-mpi.org" target="_blank">(MPI and OpenMP)</a>. The main output format is <a href="https://portal.hdfgroup.org/display/HDF5/Introduction+to+HDF5" target="_blank">HDF5</a>, which is easily portable from one machine to another and is convenient for postprocessing using high-level languauges (e.g., Python).  PERTURBO has a core software, called `perturbo.x`, for electron dynamics calculations and an interface software, called `qe2pert.x`, to read output files of <a href="https://www.quantum-espresso.org" target="_blank">Quantum Espresso</a> (QE, version 6.4.1) and Wannier90 (W90, version 3.0.0 and higher). The `qe2pert.x` interface software generates an HDF5 file, which is then read from the core `perturbo.x` software. In principle, any other third-party density functional theory (DFT) codes (e.g., VASP) can use PERTURBO as long as the interface of the DFT codes can prepare an HDF5 output format for PERTURBO to read.

For more details on the code structure of PERTURBO, we refer the users to the manuscript accompying the source code: 

- Jin-Jian Zhou, Jinsoo Park, I-Te Lu, Ivan Maliyov, Xiao Tong, Marco Bernardi, <i>"Perturbo: a software package for ab initio electron-phonon interactions, charge transport and ultrafast dynamics"</i>. Preprint: <a href="https://arxiv.org/abs/2002.02045" target="_blank">arxiv 2002.02045</a>

<div markdown="span" class="alert alert-warning" role="alert">
<img src="images/newspaper-regular.svg" style="width:3.5%;margin-top:0.1%" > 
&nbsp;
When using results from PERTURBO in your publications, please cite the PERTURBO paper given above and acknowledge the use of the code.
</div>



<div class="alert alert-success" role="alert"><i class="fa fa-download fa-lg"></i> 
&nbsp;  To download the code, contact us (<a class="email" title="{{site.download_title}}" href="#" onclick="javascript:window.location='mailto:{{site.feedback_email}}?subject={{site.feedback_subject_line}} &body={{site.feedback_body}}' ">click here{{feedback_text}}</a>). For more information, please visit the <a href="mydoc_installation">Download and installation</a> section. </div>

<hr>

<img src="images/NSF_logo.png" style="width:11%;margin-top:5%;margin-left: auto;margin-right: auto; display: block" > 

<div style="text-align: center">
<b>
We gratefully acknowledge the National Science Foundation for supporting the development of PERTURBO.
</b>
</div>
