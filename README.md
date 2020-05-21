# Using gradeR with Gradescope


## Introducing 

The `gradeR` package helps grade your students's assignment submissions that are `R` Scripts (`.r` or `.R` files). If you want to use `gradeR` for grading submissions on your own laptop or desktop, please see the vignette [here.](https://cran.r-project.org/web/packages/gradeR/vignettes/gradeR.html). Instead, this vignette describes how to use the [Gradescope autograder](https://gradescope-autograders.readthedocs.io/en/latest/) with a helper function from this package. If you have already read the ["getting started" vignette](git remote add origin https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder.git), and you work for an institution/university that has an appropriate subscription to this service, then this is probably useful information for you.

## A High-Level view

The autograding code for each assignment must be comprised of several files:

1. `setup.sh` is a Linux Bash script that the Gradescope servers run to install `R` and any `R` packages that are required. For those of you have little to no experience with shell scripting, do not despair! This [Github repository](https://github.com/tbrown122387/Using-gradeR-for-the-Gradescope-Autograder) provides an example that will be easy to modify (TODO link). The name of this file must be `setup.sh` because that's what Gradescope expects. 

2. The file with all of the tests. This can have any name you want, and it will usually change depending on what assignment you're grading. In our example (TODO link), we call it `assignment1_grading_file.r` This file contains `test_that` tests. The example should be pretty self explanatory, but for those looking for more detail, see the original vignette, or the documentation of the [`testthat` package](https://testthat.r-lib.org/). 

3. The `.R` file that grades a single student submission. This can be named anything you want, too, but we call it TODO. This file is quite simple: it just calls `gradeR::calcGradesForGradescope' This function runs a single student's `.R` file submission, checks it against the `testthat` tests, and nicely formats the output in a way that Gradescope expects. 

4. `run_autograder` is another Linux Bash script that Gradescope servers run. This file must have this name, because Gradescope expects this. This small program is run every time a single student submission needs to be graded. It copies a single student submission into the folder/directory that the Gradescope server expects, and then it runs the previously-mentioned file. 

After all of these files have been written, they are then compressed into a single `.zip` file ([as described here](https://gradescope-autograders.readthedocs.io/en/latest/specs/)), and then uploaded to Gradescope. Gradescope takes care of the rest. 


## A Fully-Worked Example

Here's an example of an entire hypothetical assignment. The following files are `fake_hw1.pdf`, `data.csv`, `assignment1_test_file.r`, and all of the student submissions. They might be organized on your hard drive as follows:

```
├── distributed_assignment
│   ├── data.csv
│   ├── fake_hw1.pdf
├── grading_resources
│   ├── assignment1_test_file.r
└── submissions
    ├── jane_doe_hw1_submission.r
    └── john_doe_assignment1.r
```

This is what `fake_hw1.pdf` looks like. It's the set of instructions given to each students.

```{r, out.width = "400px", include=TRUE, fig.align="center", echo=F}
knitr::include_graphics("example/distributed_assignment/screenshot.png")
```

The external data set `data.csv` is also distributed to students. In this case, it looks like this:
```
a,b,c
1,2,3
4,5,700.01
```

The test file you create would look similar to this file, `assignment1_test_file.r`:

```
library(testthat)

setwd("~/path/to/where/dataset/is/")

# first test
test_that("first", {
  
  expect_equal( sum(myVector), 6) 

  })

# second test
test_that("second", {

  expect_true(is.character(myString))
  expect_true(nchar(myString) > 2)

})

# third test
test_that("third", {

  expect_equal(nrow(myDataFrame), 2)
  expect_equal(myDataFrame[1,1], 700.01, tolerance=1e-3)

})
```

This hypothetical class is very small, and it has only two students. These two students made the following submissions: first, `jane_doe_hw1_submission.r`:

```
# Jane Doe's assignment 1
# Aug. 8 2019
# STAT 101

# question 1
myVector <- 1:3

# question 2
myString <- "Jane Doe"

# question 3
myDataFrame <- read.csv("data.csv")
```
and second, `john_doe_assignment1.r`:

```
# John Doe's assignment 1

# question 1
myVector <- c(1,2,3)

# question 2
# I had a little trouble with this one!

# question 3
myDataFrame <- read.csv("data.csv")
```

And that's that! There aren't any more files that are required. The rest is just code you type into the console interactively. It might look something like this: 

```
# load in the package
library(gradeR)

# this is the directory with all of the student submissions
submissionDir <- "../submissions/"

# get the grades
grades <- calcGrades(submission_dir = submissionDir, 
                     your_test_file = "~/this/should/be/your/correct/path/assignment1_grading_file.r")
```

From there, you can do whatever you want. For instance, you can take the sum/average of all the questions they get correct, weight different questions by different amounts, apply a curve, calculate which percentage of students got each question correct, make histograms of the grades, etc. 


## Some Extra Functions

Currently, there are two other functions in this package: `findGlobalPaths` and `findBadEncodingFiles`. After you have provided a submission directory, these functions will find all student submissions (files that end with `.R` or `.r`) and scan every line to see if there are any problems. Specifically, they will check for 1.) if any file refers to global/machine-specific file paths, and 2.) if any file has unreadable characters (non-UTF-8). In my experience, these are the two most common problems with student submissions. The second problem often arises when students copy/paste code from strange text editors, or when their keyboards type in multiple languages.
