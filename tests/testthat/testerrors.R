
nq <- 59
ttt <- lapply(seq(nq), function(i) c(0, 1, 2, 3, 4, NA))
names(ttt) <- sprintf("Q%0.2d", seq(nq))
dat <- do.call(data.frame, ttt)
dat$ID <- c("0", "1", "2", "3", "4", "NA")
dat <- dat[c("ID", grep("ID", names(dat), value = TRUE, invert = TRUE))]
# dat

datx <- dat

expect_error(scoreMRDQ(dat[[2]]), "dat must be a data.frame")
expect_error(scoreMRDQ(dat[-14]), "dat must have 60 columns")
expect_error(scoreMRDQ(dat[c(2:60, 1)]), "Last 59 columns must be numeric")
dat[1,2] <- -1
expect_error(scoreMRDQ(dat), "Last 59 columns cannot contain negative numbers")
dat[1,2] <- 2.5
expect_error(scoreMRDQ(dat), "Last 59 columns must be integers")

# datx[1,2] <- 6
# expect_warning(scoreMRDQ(datx, verbose = 2), "Numbers above 5")
