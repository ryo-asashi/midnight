#define EIGEN_DONT_VECTORIZE

#include <RcppEigen.h>

// [[Rcpp::depends(RcppEigen)]]
//' @rdname fastLmMatrix
//' @export
// [[Rcpp::export]]
Rcpp::List fastLmMatrixLDLT(
    const Rcpp::NumericMatrix x,
    const Rcpp::NumericMatrix y,
    const double tol = 0.0000001
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
  int rank = p;

  auto Dplus = [](const Eigen::ArrayXd& d, double tolerance) {
    Eigen::ArrayXd di(d.size());
    double comp = d.maxCoeff() * tolerance;
    for (int j = 0; j < d.size(); ++j) {
      di[j] = (d[j] < comp) ? 0.0 : 1.0 / d[j];
    }
    return di;
  };

  Eigen::MatrixXd XtX(p, p);
  XtX.setZero();
  XtX.selfadjointView<Eigen::Lower>().rankUpdate(X.adjoint());
  Eigen::LDLT<Eigen::MatrixXd> Ch(XtX.selfadjointView<Eigen::Lower>());
  Eigen::ArrayXd di = Dplus(Ch.vectorD(), tol * tol);
  rank = (di > 0.0).count();
  coef = Ch.solve(X.adjoint() * Y);
  fitted = X * coef;
  resid = Y - fitted;

  Rcpp::List out = Rcpp::List::create(
    Rcpp::Named("coefficients")  = coef,
    Rcpp::Named("fitted.values") = fitted,
    Rcpp::Named("residuals")     = resid,
    Rcpp::Named("rank")          = rank
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
