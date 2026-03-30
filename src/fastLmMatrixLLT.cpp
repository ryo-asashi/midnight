#include <RcppEigen.h>

// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::export]]
Rcpp::List fastLmMatrixLLT(
    const Rcpp::NumericMatrix x,
    const Rcpp::NumericMatrix y
) {

  if (x.nrow() != y.nrow()) Rcpp::stop("number of rows in 'x' doesn't match number of rows in 'y'");

  const Eigen::Map<Eigen::MatrixXd> X(const_cast<double*>(x.begin()), x.nrow(), x.ncol());
  const Eigen::Map<Eigen::MatrixXd> Y(const_cast<double*>(y.begin()), y.nrow(), y.ncol());

  const int n = X.rows();
  const int p = X.cols();
  const int k = Y.cols();

  Eigen::MatrixXd coef(p, k);
  Eigen::MatrixXd fitted(n, k);
  Eigen::MatrixXd resid(n, k);

  Eigen::MatrixXd XtX(p, p);
  XtX.setZero();
  XtX.selfadjointView<Eigen::Lower>().rankUpdate(X.adjoint());
  Eigen::LLT<Eigen::MatrixXd> Ch(XtX.selfadjointView<Eigen::Lower>());
  coef = Ch.solve(X.adjoint() * Y);
  fitted = X * coef;
  resid = Y - fitted;

  Rcpp::List out = Rcpp::List::create(
    Rcpp::Named("coefficients")  = coef,
    Rcpp::Named("fitted.values") = fitted,
    Rcpp::Named("residuals")     = resid
  );

  if (x.hasAttribute("dimnames") || y.hasAttribute("dimnames")) {
    Rcpp::List dx = x.attr("dimnames");
    Rcpp::List dy = y.attr("dimnames");
    Rcpp::RObject cnx = (dx.size() > 1) ? dx[1] : R_NilValue;
    Rcpp::RObject cny = (dy.size() > 1) ? dy[1] : R_NilValue;

    if (!cnx.isNULL() || !cny.isNULL()) {
      Rcpp::NumericMatrix out_coef = out["coefficients"];
      out_coef.attr("dimnames") = Rcpp::List::create(cnx, cny);
    }
  }

  return out;
}
