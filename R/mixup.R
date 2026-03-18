#' Generate Synthetic Data using Mixup
#'
#' @description
#' \code{mixup()} generates synthetic data points by combining pairs of existing observations.
#' For numeric variables, it calculates a convex combination.
#' For categorical variables (such as factors or characters), it randomly selects one of the two values based on the generated combination weight.
#'
#' @details
#' The Mixup algorithm creates a new synthetic observation \eqn{x_{new}} from two randomly sampled observations \eqn{x_1} and \eqn{x_2}.
#' A combination weight \eqn{\lambda} is drawn from a Beta distribution, \eqn{\text{Beta}(\alpha, \alpha)}.
#'
#' For numeric variables, the synthetic data is generated via a convex combination:
#' \deqn{x_{new} = \lambda x_1 + (1 - \lambda) x_2}
#'
#' For non-numeric variables, the value is chosen from \eqn{x_1} with probability \eqn{\lambda}, and from \eqn{x_2} with probability \eqn{1 - \lambda}.
#'
#' @param object a data frame or matrix containing the original data.
#' @param n an integer specifying the number of synthetic observations to generate. Defaults to the number of observations.
#' @param weights an optional numeric vector of probability weights for sampling the observations.
#' @param alpha a numeric scalar representing the shape parameter of the Beta distribution. Smaller values (e.g., 0.2) generate data closer to the original points (acting as a local perturbation). Defaults to 0.2.
#' @param seed an optional integer to set the random seed for reproducibility.
#'
#' @examples
#' # fit a model
#' fit <- lm(Volume ~ I(Girth^2) + Girth + Height, trees)
#'
#' # generate new synthetic rows
#' mixup_trees <- mixup(trees, 500)
#' summary(mixup_trees)
#'
#' # combine with the original data
#' combined_trees <- rbind(trees, mixup_trees)
#'
#' # fit MID models
#' mid1 <- midr::interpret(Volume ~ ., trees, fit, k = 25, ok = TRUE)
#' mid2 <- midr::interpret(Volume ~ ., combined_trees, fit, ok = TRUE)
#' mid3 <- midr::interpret(Volume ~ ., trees, fit, lambda = .1, ok = TRUE)
#'
#' # compare effects
#' ml <- midr::midlist(singular = mid1, mixup = mid2, penalty = mid3)
#' plot(ml, "Height")
#' hclpal <- midr::color.theme("HCL")$palette(3)
#' legend("topleft", labels(ml), lty = 1, col = hclpal)
#' @returns
#' \code{mixup()} returns an object of the same class as \code{object} (either "matrix" or "data.frame") containing \code{n} generated synthetic observations.
#'
#' @export
#'
mixup <- function(
    object, n = nrow(object), weights = NULL, alpha = 0.2, seed = NULL
) {
  n_obs <- nrow(object)
  if (!is.null(weights) && length(weights) != n_obs) {
    stop("length of 'weights' does not match the number of observations")
  }
  if (!is.null(seed)) set.seed(seed)
  idx_1 <- sample.int(n_obs, n, replace = TRUE, prob = weights)
  idx_2 <- sample.int(n_obs, n, replace = TRUE, prob = weights)
  props <- rbeta(n, shape1 = alpha, shape2 = alpha)
  ismat <- is.matrix(object)
  if (ismat && is.numeric(object)) {
    mixed <- props * object[idx_1, , drop = FALSE] +
      (1 - props) * object[idx_2, , drop = FALSE]
    return(mixed)
  }
  mixed <- list()
  for (i in seq_len(ncol(object))) {
    x <- object[, i]
    if (is.numeric(x)) {
      mixed[[i]] <- props * x[idx_1] + (1 - props) * x[idx_2]
    } else {
      res <- x[idx_2]
      use_1 <- rbinom(n, size = 1, prob = props) == 1
      res[use_1] <- x[idx_1][use_1]
      mixed[[i]] <- res
    }
  }
  if (!is.null(colnames(object))) {
    names(mixed) <- colnames(object)
  }
  mixed <- as.data.frame(mixed)
  if (ismat) {
    mixed <- as.matrix(mixed)
  }
  return(mixed)
}
