
<!-- README.md is generated from README.Rmd. Please edit that file -->

# scoreMRDQ

<!-- badges: start -->
<!-- badges: end -->

The goal of scoreMRDQ is to convert the 59 responses from the Michigan
Retinal Degeneration Questionnaire (MRDQ) to seven domain scores:
Central Vision, Color Vision, Contrast Sensitivity, Scotopic Function,
Photopic Peripheral Vision, Mesopic Peripheral Vision, and
Photosensitivity.

## Installation

You can install the development version of scoreMRDQ from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("chrisandrewsphd/scoreMRDQ")
```

## Examples

### Example 1

This is a basic example which shows you how to score data from a single
individual. `justme` is a data.frame with 60 variables and 1 row. The 60
variables are the patient identifier followed by their 59 responses.

This is a basic example which shows you how to solve a common problem:

``` r
library(scoreMRDQ)

justme <- read.table(
  text = "Me,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,2,0,0,0,0,1,1,1,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,2,1,1,0,0,0,0,0,2,0,0,0",
  sep = ",")
justme
#>   V1 V2 V3 V4 V5 V6 V7 V8 V9 V10 V11 V12 V13 V14 V15 V16 V17 V18 V19 V20 V21
#> 1 Me  0  0  0  0  0  0  0  0   1   1   1   0   0   0   1   1   1   2   0   0
#>   V22 V23 V24 V25 V26 V27 V28 V29 V30 V31 V32 V33 V34 V35 V36 V37 V38 V39 V40
#> 1   0   0   1   1   1   0   0   0   0   1   0   0   1   0   0   1   0   0   1
#>   V41 V42 V43 V44 V45 V46 V47 V48 V49 V50 V51 V52 V53 V54 V55 V56 V57 V58 V59
#> 1   0   0   1   0   0   1   0   0   2   1   1   0   0   0   0   0   2   0   0
#>   V60
#> 1   0

scoreMRDQ(justme)
#> $thetas
#>   ID        CV      Col       Cnt         SF         PF        MF        PS
#> 1 Me -1.084061 -1.34802 0.0638529 -0.4436402 -0.6177631 -1.383663 -1.432964
#> 
#> $ses
#>   ID        CV      Col       Cnt        SF        PF        MF        PS
#> 1 Me 0.2925954 0.578973 0.2301166 0.1294696 0.3168945 0.3393907 0.3869802
```

### Example 2

If you need to score many respondents (or the same respondent at several
visits), you can include them all in a single data.frame and call
`scoreMVAQ()`. The data.frame must have 60 columns still but can have
more than 1 row.

``` r
library(scoreMRDQ)

justme <- read.table(
  text = "Me,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,2,0,0,0,0,1,1,1,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,2,1,1,0,0,0,0,0,2,0,0,0",
  sep = ",")
justyou <- data.frame(ID="You", matrix(nrow=1, sample(0:4, 59, TRUE)))
andyoutoo <- data.frame(ID="You 2", matrix(nrow=1, sample(0:4, 59, TRUE)))

names(justme) <- names(justyou) <- names(andyoutoo) <- 
  c("ID", sprintf("Q%0.2d", seq(59)))

justus <- rbind(justme, justyou, andyoutoo)
justus
#>      ID Q01 Q02 Q03 Q04 Q05 Q06 Q07 Q08 Q09 Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18
#> 1    Me   0   0   0   0   0   0   0   0   1   1   1   0   0   0   1   1   1   2
#> 2   You   1   4   0   0   3   2   4   4   2   0   0   2   0   3   1   1   0   3
#> 3 You 2   3   1   4   3   3   2   1   1   3   4   0   4   4   2   4   1   1   4
#>   Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37
#> 1   0   0   0   0   1   1   1   0   0   0   0   1   0   0   1   0   0   1   0
#> 2   3   3   2   0   4   3   0   3   0   0   0   3   1   0   3   4   1   0   2
#> 3   0   4   2   1   2   0   2   1   0   2   0   0   3   1   3   1   1   1   1
#>   Q38 Q39 Q40 Q41 Q42 Q43 Q44 Q45 Q46 Q47 Q48 Q49 Q50 Q51 Q52 Q53 Q54 Q55 Q56
#> 1   0   1   0   0   1   0   0   1   0   0   2   1   1   0   0   0   0   0   2
#> 2   0   3   4   3   3   1   0   1   4   4   1   0   0   1   3   3   1   0   3
#> 3   1   3   4   1   2   4   4   0   1   2   0   3   2   3   2   4   3   4   0
#>   Q57 Q58 Q59
#> 1   0   0   0
#> 2   4   1   1
#> 3   1   2   2

scoreMRDQ(justus, verbose = 1)
#> i =  1 
#> i =  2 
#> i =  3
#> $thetas
#>      ID          CV        Col       Cnt          SF         PF         MF
#> 1    Me -1.08406062 -1.3480195 0.0638529 -0.44364017 -0.6177631 -1.3836631
#> 2   You -0.04157573  0.3145136 0.4648305  0.37856900  0.4750286  0.3625904
#> 3 You 2  0.79139894  1.8843134 0.7767391 -0.07789574  0.5115362  0.6160961
#>           PS
#> 1 -1.4329642
#> 2  0.4926968
#> 3  0.6693134
#> 
#> $ses
#>      ID        CV       Col       Cnt        SF        PF        MF        PS
#> 1    Me 0.2925954 0.5789730 0.2301166 0.1294696 0.3168945 0.3393907 0.3869802
#> 2   You 0.2340796 0.3760582 0.2444857 0.1760781 0.2417927 0.2580260 0.2873508
#> 3 You 2 0.1829368 0.3923008 0.2273556 0.1699661 0.1859557 0.2443135 0.3448256
```

The option `verbose = 1` provides some messaging during the execution of
`scoreMRDQ()`.
