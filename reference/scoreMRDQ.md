# Score the Michigan Retinal Degeneration Questionnaire

Score the Michigan Retinal Degeneration Questionnaire

## Usage

``` r
scoreMRDQ(dat, verbose = 0)
```

## Arguments

- dat:

  data.frame with N rows and 60 columns. First column is patient ID and
  the remaining columns are responses to the 59 items. Responses should
  be integers from 0 to 5.

- verbose:

  A number indicating the amount of printing during function execution.
  0 (default) is none. Higher numbers may result in more printing.

## Value

A list with two components, each an N by 8 matrix. The first, named
thetas, contains the ID and 7 domain scores for each patient. The
second, named ses, contains the ID and the standard errors of the
thetas.

## Examples

``` r
justme <- read.table(
  text = "Me,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,2,0,0,0,0,1,1,1,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,2,1,1,0,0,0,0,0,2,0,0,0",
  sep = ",")
scoreMRDQ(justme)
#> $thetas
#>   ID       CV      Col        Cnt         SF         PF        MF        PS
#> 1 Me -1.08406 -1.34802 0.06385294 -0.4440405 -0.6177632 -1.383663 -1.432964
#> 
#> $ses
#>   ID        CV      Col       Cnt        SF        PF       MF        PS
#> 1 Me 0.2925964 0.578973 0.2301165 0.1298078 0.3168943 0.339391 0.3869802
#> 

justyou <- data.frame(ID="You", matrix(nrow=1, sample(0:3, 59, TRUE)))
scoreMRDQ(justyou)
#> $thetas
#>    ID        CV        Col       Cnt          SF        PF         MF
#> 1 You 0.2239247 -0.1329925 0.6187017 -0.07138063 0.6354889 -0.1214556
#>            PS
#> 1 -0.09537667
#> 
#> $ses
#>    ID       CV       Col       Cnt        SF        PF        MF        PS
#> 1 You 0.200412 0.3700498 0.2378693 0.1785198 0.1857847 0.1873412 0.3504917
#> 

names(justme) <- names(justyou) <- c("ID", sprintf("Q%0.2d", seq(59)))
justus <- rbind(justme, justyou)
scoreMRDQ(justus, verbose = 1)
#> i =  1 
#> i =  2 
#> $thetas
#>    ID         CV        Col        Cnt          SF         PF         MF
#> 1  Me -1.0840599 -1.3480195 0.06385294 -0.44404047 -0.6177632 -1.3836627
#> 2 You  0.2239247 -0.1329925 0.61870174 -0.07138063  0.6354889 -0.1214556
#>            PS
#> 1 -1.43296419
#> 2 -0.09537667
#> 
#> $ses
#>    ID        CV       Col       Cnt        SF        PF        MF        PS
#> 1  Me 0.2925964 0.5789730 0.2301165 0.1298078 0.3168943 0.3393910 0.3869802
#> 2 You 0.2004120 0.3700498 0.2378693 0.1785198 0.1857847 0.1873412 0.3504917
#> 
```
