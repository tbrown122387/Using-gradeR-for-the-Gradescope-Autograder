#!/usr/bin/env bash

# these lines install R on the Gradescope virtual machine
apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev
apt-get install -y r-base

# these lines install the packages that is needed both
# 1. the student code 
# 2. the autograding code

# Note that 
# a. devtools is for install_github This is temporary and will be changed once the updates to gradeR have made it to CRAN.
Rscript -e "install.packages('devtools')" 
Rscript -e "library(devtools); install_github('tbrown122387/gradeR')"

# These are packages that many students in the class will use
Rscript -e "install.packages('tidyverse')" 
Rscript -e "install.packages('stringr')" 
