#include <RcppEigen.h>

// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::export]]
Rcpp::List fastLmMatrixSVD(
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

  Eigen::JacobiSVD<Eigen::MatrixXd> UDV(X, Eigen::ComputeThinU | Eigen::ComputeThinV);
  Eigen::ArrayXd d = UDV.singularValues().array();
  Eigen::ArrayXd di = Dplus(d, tol);
  rank = (di > 0.0).count();
  Eigen::MatrixXd VDi = UDV.matrixV() * di.matrix().asDiagonal();
  coef = VDi * UDV.matrixU().adjoint() * Y;
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
