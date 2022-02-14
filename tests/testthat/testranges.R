# test data will have 5 cases
#   a row of all zeros, the minimum
#   a row of 3s and 4s, the maximum
#     The maximum response is 3 for the last question because it is an anxiety question #        (so 4 and/or 5 corresponds to missing data).
#     The maximum response is 3 for many other questions that didn't have any 4s
#        in training data (see vector "three" below)
#   a row of 4s (except the final question)
#   a row of 5s -> all responses correspond to "don't for non-vision reason"
#   a row of NAs -> all responses correspond to missing/blank cell

nq <- 59
three <- c(20, 44:52, 53, 54, 56, 57)
ttt <- lapply(seq(nq), function(i)
  c(0,
    if (i %in% c(three, 59)) 3 else 4,
    if (i %in% 59) 3 else 4,
    if (i %in% 59) 4 else 5,
    NA))
names(ttt) <- sprintf("Q%0.2d", seq(nq))
dat <- do.call(data.frame, ttt)
dat$ID <- c("MIN", "MAX", "ALL4", "ALL5", "ALLNA")
dat <- dat[c("ID", grep("ID", names(dat), value = TRUE, invert = TRUE))]
# dat
# print(scoreMRDQ(dat), digits = 15)

MIN <- data.frame(
  ID  = "MIN",
  CV  = -1.95439406042228,
  Col = -1.34801952682591,
  Cnt = -1.40104429241404,
  SF  = -2.00521073720102,
  PF  = -1.26169503404321,
  MF  = -1.77145752827356,
  PS  = -2.27818252960787)

expect_equal(scoreMRDQ(dat[1, ])$thetas, MIN)

MAX <- data.frame(
  ID  = "MAX",
  CV  = 3.04539390193616,
  Col = 2.43108092951508,
  Cnt = 2.97579590585608,
  SF  = 2.42299412452036,
  PF  = 2.80297628554470,
  MF  = 2.42210898910922,
  PS  = 2.89051967433846)

expect_equal(scoreMRDQ(dat[2, ])$thetas, MAX)

expect_equal(scoreMRDQ(dat[3, ])$thetas[-1], MAX[-1])

NAdf <- data.frame(ID = "NA", CV = NA_real_, Col = NA_real_, Cnt = NA_real_, SF = NA_real_, PF = NA_real_, MF = NA_real_, PS = NA_real_)

expect_equal(scoreMRDQ(dat[4, ])$thetas[-1], NAdf[-1])
expect_equal(scoreMRDQ(dat[5, ])$thetas[-1], NAdf[-1])

expect_equal(scoreMRDQ(dat)$thetas[-1], rbind(MIN, MAX, MAX, NAdf, NAdf)[-1])
