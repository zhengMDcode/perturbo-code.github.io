# Note that .sh scripts work only on Mac. If you're on Windows, install Git Bash and use that as your client.

echo 'Kill all Jekyll instances'
kill -9 $(ps aux | grep '[j]ekyll' | awk '{print $2}')
clear

echo "Building PDF-friendly HTML site for Mydoc ...";
bundle exec jekyll serve --detach --config _config.yml,pdfconfigs/config_mydoc_pdf.yml;
echo "done";

# change the links to the input parameters from mydoc_param_qe2pert/mydoc_param_perturbo to mydoc_table_input_parameters_qe2pert.html/mydoc_table_input_parameters_perturbo.html
cd _site
for file in `find . -name "*.html" -type f -maxdepth 1 -exec basename {} \;`; do 
   sed -i.backup1 's/mydoc_param_qe2pert#/mydoc_table_input_parameters_qe2pert.html#/g' $file
   sed -i.backup2 's/mydoc_param_perturbo#/mydoc_table_input_parameters_perturbo.html#/g' $file
done
cd ../

echo "Building the PDF ...";
prince --javascript --input-list=_site/pdfconfigs/prince-list.txt -o pdf/perturbo_manual.pdf;

echo "Done. Look in the pdf directory to see if it printed successfully."
