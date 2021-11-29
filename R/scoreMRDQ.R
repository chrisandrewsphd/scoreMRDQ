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
scoreMRDQ <- function(dat, verbose = 0) {
  # Score MRDQ v 1.1
  # Chris Andrews
  # 2021 11 28

  # INPUT
  # Load Data data.frame/tibble
  #   with 1+59 columns and N rows (1 per participant)
  #   subject IDs stored in first column
  #   59 responses stored in remaining columns

  # OUTPUT
  # list with two components, each an N by 7 matrix
  #   thetas = 7 Domain Scores for each of N participants
  #   ses = 7 Standard Errors for each of N participants

  # must have 'mirt' package installed. Do this once if it isn't.
  # install.packages('mirt')

  # if (!require(mirt)) stop("Package 'mirt' required.")

  # load model object
  # attach("./R/MRDQ_deid_objects.RData", pos=2, name = "MRDQscales")
  scalevec <- c("CV", "Col", "Cnt", "SF", "PF", "MF", "PS")

  # create storage
  theta_se_CV <- theta_se_Col <- theta_se_Cnt <- theta_se_SF <- theta_se_MF <- theta_se_PF <- theta_se_PS <- matrix(NA_real_, nrow = nrow(dat), ncol = 2)

  # score patients one at a time
  for (i in seq(nrow(dat))) {
    if (verbose>0) cat("i = ", i, "\n")

    mat <- data.matrix(dat[i, -1, drop = FALSE])
    rownames(mat) <- dat[i, 1]
    # dimnames(mat)

    mat_CV <- mat[, 1:11, drop = FALSE]
    mat_Col<- mat[, c(12, 13, 20, 22), drop = FALSE]
    mat_Cnt<- mat[, c(14:19, 21), drop = FALSE]
    mat_SF <- mat[, c(23:25, seq(from=27, by=3, length.out=9)), drop = FALSE]
    mat_PF <- mat[, seq(from=26, by=3, length.out=9), drop = FALSE]
    mat_MF <- mat[, seq(from=28, by=3, length.out=9), drop = FALSE]
    mat_PS <- mat[, 53:59, drop = FALSE]
    mat_PS[which(mat_PS[, 7] == 5), 7] <- 4 # invalid response for this question


    # # load models
    # data(
    #   list = list("model4_CV", "model4_Col", "model4_Cnt", "model4_SF", "model4_MF", "model4_PF", "model4_PS"),
    #   package = "scoreMRDQ",
    #   envir = environment())

    # compute disabilities and standard errors
    theta_se_CV [i, ] <- mirt::fscores(model4_CV , response.pattern = mat_CV , append_response.pattern = FALSE)
    theta_se_Col[i, ] <- mirt::fscores(model4_Col, response.pattern = mat_Col, append_response.pattern = FALSE)
    theta_se_Cnt[i, ] <- mirt::fscores(model4_Cnt, response.pattern = mat_Cnt, append_response.pattern = FALSE)
    theta_se_SF [i, ] <- mirt::fscores(model4_SF , response.pattern = mat_SF , append_response.pattern = FALSE)
    theta_se_MF [i, ] <- mirt::fscores(model4_MF , response.pattern = mat_MF , append_response.pattern = FALSE)
    theta_se_PF [i, ] <- mirt::fscores(model4_PF , response.pattern = mat_PF , append_response.pattern = FALSE)
    theta_se_PS [i, ] <- mirt::fscores(model4_PS , response.pattern = mat_PS , append_response.pattern = FALSE)
  }

  # detach("MRDQscales")


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
