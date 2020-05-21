# Using gradeR with Gradescope


## Introduction 

The `gradeR` package helps grade your students's assignment submissions that are `R` Scripts (`.r` or `.R` files). If you want to use `gradeR` for grading submissions **on your own laptop or desktop**, please see the vignette [here](https://cran.r-project.org/web/packages/gradeR/vignettes/gradeR.html). Instead, this vignette describes how to use the [Gradescope autograder](https://gradescope-autograders.readthedocs.io/en/latest/) with a helper function from `gradeR`. 

If you have already read the ["getting started" vignette](https://cran.r-project.org/web/packages/gradeR/vignettes/gradeR.html), and you work for an institution/university that has an appropriate subscription to this service, then this is probably useful information for you. For each assignment you make, you might consider cloning this repository, modifying the student-facing assignment provided in `example_hw_assignment`, and then modifying the files required by Gradescope provided in `autograding_code_and_data`.

## A High-Level view

Students submit their assignments to Gradescope, and afterwards, their code is run and checked on Gradescope servers. The benefit is that students get feedback much more quickly, and your computer doesn't need to stay busy all day running student code. The downside is that everything becomes a bit more complicated. That's what this repository is for--to provide a template for each assignment, and for all the code you have to give to Gradescope for each assignment. 

The autograding code for each Gradescope assignment must be comprised of several files. We have provided all of these files in the directory [autograding_code_and_data](https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder/tree/master/autograding_code_and_data).

1. `setup.sh` is a Linux Bash script that the Gradescope servers run to install `R` and any `R` packages that are required. For those of you have little to no experience with shell scripting, do not despair! This [repository](https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder) provides an example file [(see here)](https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder/blob/master/autograding_code_and_data/setup.sh) that will be easy to modify. Note that the name of this file must be `setup.sh` because that is what Gradescope expects. 

2. The file with all of the tests. This can have any name you want, and it will usually change depending on what assignment you're grading. In this example, we call it [`assignment1_grading_file.r`](https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder/blob/master/autograding_code_and_data/assignment1_tests.r). This file contains `testthat` tests, which is another `R` package that `gradeR` depends on. The example should be pretty self explanatory, but for those looking for more detail, see the original `gradeR` vignette, or the documentation for the [`testthat` package](https://testthat.r-lib.org/). 

3. The `.R` file that grades a single student submission. This can be named anything you want, too, but we call it [`grade_one_submission.r`](https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder/blob/master/autograding_code_and_data/grade_one_submission.r). Thanks to `gradeR`, this one is pretty simple--it just calls `gradeR::calcGradesForGradescope()`. This function runs a single student's `.R` file submission, checks it against the provided `testthat` tests, and nicely formats the output in a way that Gradescope expects. 

4. `run_autograder` is another Bash script that Gradescope's Linux servers run. This file must have this name, because Gradescope expects this. This small program is run every time a single student submission needs to be graded. It copies a single student submission into the directory that the Gradescope server expects, and then it runs the previously-mentioned file (which we called `grade_one_submission.R`). 

5. Extra data files need to be included too. For example, our example homework assignment asked students to read in the file called `data.csv`. This file is in our [directory with all the other autograding files](https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder/tree/master/autograding_code_and_data).

After all of these files have been written, they are then compressed into a single `.zip` file ([as described by Gradescope here](https://gradescope-autograders.readthedocs.io/en/latest/specs/)), and then uploaded to Gradescope. Gradescope takes care of the rest. 

Note that it is still possible to use Gradescope's autograder without the `gradeR` package. For an example of how to do that, please see this [Github repo](https://github.com/guerzh/r_autograde_gradescope).

## Customization Checklist

To make your own assignment, log on to Gradescope and then start a new *programming assignment*. Then, make some customizations to the files in this repository. After you have made the changes, zip those files up, and upload it to Gradescope. 

If you are unfamiliar with their website, please see the instructions that they provide [here.](https://gradescope-autograders.readthedocs.io/en/latest/getting_started/)

There are a few things to do when you customize this to your own assignment:

1. Make sure that each student's submission is named the same. In our example, we assume all submissions are named `assignment1.R`

2. Make sure `grade_one_submission.r` references the correct filenames. For us, we chose `assignment1.R` and `assignment1_tests.R`

3. Make sure your assignment instructions feature the same warnings in our example assignment [here.](https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder/blob/master/example_hw_assignment/fake_hw1.pdf) 

4. Make sure your `setup.sh` installs all packages that student code requires. 

5. Make sure `run_autograder` uses the correct filenames. The directories are what Gradescope expects, so don't change those.


