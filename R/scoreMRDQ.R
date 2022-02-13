#' Score the Michigan Retinal Degeneration Questionnaire
#'
#' @param dat data.frame with N rows and 60 columns.  First column is patient ID and the remaining columns are responses to the 59 items.  Responses should be integers from 0 to 5.
#' @param verbose A number indicating the amount of printing during function execution. 0 (default) is none. Higher numbers may result in more printing.
#'
#' @return A list with two components, each an N by 7 matrix. The first, named thetas, contains the 7 domain scores for each patient.  The second, named ses, contains the standard errors of the thetas.
#' @export
#'
#' @examples
#' justme <- read.table(
#'   text = "Me,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,2,0,0,0,0,1,1,1,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,2,1,1,0,0,0,0,0,2,0,0,0",
#'   sep = ",")
#' scoreMRDQ(justme)
#'
#' justyou <- data.frame(ID="You", matrix(nrow=1, sample(0:3, 59, TRUE)))
#' scoreMRDQ(justyou)
#'
#' names(justme) <- names(justyou) <- c("ID", sprintf("Q%0.2d", seq(59)))
#' justus <- rbind(justme, justyou)
#' scoreMRDQ(justus, verbose = 1)
#'
scoreMRDQ <- function(dat, verbose = 0) {
  # Score MRDQ v 1.2
  # Chris Andrews
  # 2022 02 13

  # INPUT
  # Load Data data.frame
  #   with 1+59 columns and N rows (1 per participant)
  #   subject IDs stored in first column
  #   59 responses stored in remaining columns
  if (!is.data.frame(dat)) stop("dat must be a data.frame")
  if (ncol(dat) != 60) stop("dat must have 60 columns")
  mat <- as.matrix(dat[-1])
  row.names(mat) <- dat[[1]]
  if (!is.numeric(mat)) stop("Last 59 columns must be numeric")
  if (!isTRUE(all.equal(trunc(mat), mat))) stop("Last 59 columns must be integers")
  if (min(mat, na.rm = TRUE) < 0) stop("Last 59 columns cannot contain negative numbers")
  if (max(mat, na.rm = TRUE) > 5) {
    if (verbose > 1) cat("Numbers above 5 in last 59 columns will be treated as missing responses.\n")
  }

  # might want these warnings to just be printed when verbose > 0.
  AnxietyQuestions <- 59
  if (any(mat[, AnxietyQuestions] == 5, na.rm = TRUE)) {
    for (aq in AnxietyQuestions) mat[which(mat[, aq] == 5), aq] <- 4
    if (verbose > 1) cat("Anxiety Question (59, PS7) only has responses 0-4. '5' will be treated as '4' (missing).\n")
  }
  ThreeBetaQuestions <- c(20, 44:52, 53, 54, 56, 57)
  if (any(mat[, ThreeBetaQuestions] == 4, na.rm = TRUE)) {
    for (tbq in ThreeBetaQuestions) mat[which(mat[, tbq] == 4), tbq] <- 3
    if (verbose > 1) cat("Some Questions (", ThreeBetaQuestions , ") had only had responses 0-3 in model building data. '4' ('does not help' or 'my vision is too poor') will be treated as '3' ('always' or 'extreme difficulty').\n")
  }

  mat[is.na(mat)] <- 6 # avoid error from fscores when all responses are missing (get warning instead)

  # OUTPUT
  # list with two components, each an N by 7 matrix
  #   thetas = 7 Domain Scores for each of N participants
  #   ses = 7 Standard Errors for each of N participants
  scalevec <- c("CV", "Col", "Cnt", "SF", "PF", "MF", "PS")

  # create storage
  theta_se_CV <- theta_se_Col <- theta_se_Cnt <- theta_se_SF <- theta_se_MF <- theta_se_PF <- theta_se_PS <- matrix(NA_real_, nrow = nrow(dat), ncol = 2)

  # score patients one at a time
  for (i in seq(nrow(dat))) {
    if (verbose>0) cat("i = ", i, "\n")

    # mat <- data.matrix(dat[i, -1, drop = FALSE]) # would mishandle factors
    # rownames(mat) <- dat[i, 1]
    # dimnames(mat)
    mati <- mat[i, , drop = FALSE]

    mat_CV <- mati[, 1:11, drop = FALSE]
    mat_Col<- mati[, c(12, 13, 20, 22), drop = FALSE]
    mat_Cnt<- mati[, c(14:19, 21), drop = FALSE]
    mat_SF <- mati[, c(23:25, seq(from=27, by=3, length.out=9)), drop = FALSE]
    mat_PF <- mati[, seq(from=26, by=3, length.out=9), drop = FALSE]
    mat_MF <- mati[, seq(from=28, by=3, length.out=9), drop = FALSE]
    mat_PS <- mati[, 53:59, drop = FALSE]
    # mat_PS[which(mat_PS[, 7] == 5), 7] <- 4 # invalid response for this question


    # compute disabilities and standard errors
    # consider suppressing warnings from fscores when NA produced
    # (e.g., when all responses are missing)
    if (verbose > 1) {
    theta_se_CV [i, ] <- mirt::fscores(model4_CV , response.pattern = mat_CV , append_response.pattern = FALSE)
    theta_se_Col[i, ] <- mirt::fscores(model4_Col, response.pattern = mat_Col, append_response.pattern = FALSE)
    theta_se_Cnt[i, ] <- mirt::fscores(model4_Cnt, response.pattern = mat_Cnt, append_response.pattern = FALSE)
    theta_se_SF [i, ] <- mirt::fscores(model4_SF , response.pattern = mat_SF , append_response.pattern = FALSE)
    theta_se_MF [i, ] <- mirt::fscores(model4_MF , response.pattern = mat_MF , append_response.pattern = FALSE)
    theta_se_PF [i, ] <- mirt::fscores(model4_PF , response.pattern = mat_PF , append_response.pattern = FALSE)
    theta_se_PS [i, ] <- mirt::fscores(model4_PS , response.pattern = mat_PS , append_response.pattern = FALSE)
    } else {
      theta_se_CV [i, ] <- suppressWarnings(mirt::fscores(model4_CV , response.pattern = mat_CV , append_response.pattern = FALSE))
      theta_se_Col[i, ] <- suppressWarnings(mirt::fscores(model4_Col, response.pattern = mat_Col, append_response.pattern = FALSE))
      theta_se_Cnt[i, ] <- suppressWarnings(mirt::fscores(model4_Cnt, response.pattern = mat_Cnt, append_response.pattern = FALSE))
      theta_se_SF [i, ] <- suppressWarnings(mirt::fscores(model4_SF , response.pattern = mat_SF , append_response.pattern = FALSE))
      theta_se_MF [i, ] <- suppressWarnings(mirt::fscores(model4_MF , response.pattern = mat_MF , append_response.pattern = FALSE))
      theta_se_PF [i, ] <- suppressWarnings(mirt::fscores(model4_PF , response.pattern = mat_PF , append_response.pattern = FALSE))
      theta_se_PS [i, ] <- suppressWarnings(mirt::fscores(model4_PS , response.pattern = mat_PS , append_response.pattern = FALSE))
    }
  }


  # build report from 7 thetas
  thetas <- data.frame(
    ID =dat[[1]],
    CV =theta_se_CV [,1],
    Col=theta_se_Col[,1],
    Cnt=theta_se_Cnt[,1],
    SF =theta_se_SF [,1],
    PF =theta_se_PF [,1],
    MF =theta_se_MF [,1],
    PS =theta_se_PS [,1])

  # standard errors
  ses <- data.frame(
    ID =dat[[1]],
    CV =theta_se_CV [,2],
    Col=theta_se_Col[,2],
    Cnt=theta_se_Cnt[,2],
    SF =theta_se_SF [,2],
    PF =theta_se_PF [,2],
    MF =theta_se_MF [,2],
    PS =theta_se_PS [,2])

  return(list(thetas = thetas, ses = ses))
}
