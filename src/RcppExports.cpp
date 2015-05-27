// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>
#include <FLasher.h>

using namespace Rcpp;

// stockCPP
FLQuant stockCPP(FLQuant F, FLQuant C, FLQuant B, FLQuant params, double tol, int niter);
RcppExport SEXP biodyn_stockCPP(SEXP FSEXP, SEXP CSEXP, SEXP BSEXP, SEXP paramsSEXP, SEXP tolSEXP, SEXP niterSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< FLQuant >::type F(FSEXP);
    Rcpp::traits::input_parameter< FLQuant >::type C(CSEXP);
    Rcpp::traits::input_parameter< FLQuant >::type B(BSEXP);
    Rcpp::traits::input_parameter< FLQuant >::type params(paramsSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< int >::type niter(niterSEXP);
    __result = Rcpp::wrap(stockCPP(F, C, B, params, tol, niter));
    return __result;
END_RCPP
}
// fCPP
FLQuant fCPP(FLQuant F, FLQuant C, FLQuant B, FLQuant params, double tol, int niter);
RcppExport SEXP biodyn_fCPP(SEXP FSEXP, SEXP CSEXP, SEXP BSEXP, SEXP paramsSEXP, SEXP tolSEXP, SEXP niterSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< FLQuant >::type F(FSEXP);
    Rcpp::traits::input_parameter< FLQuant >::type C(CSEXP);
    Rcpp::traits::input_parameter< FLQuant >::type B(BSEXP);
    Rcpp::traits::input_parameter< FLQuant >::type params(paramsSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< int >::type niter(niterSEXP);
    __result = Rcpp::wrap(fCPP(F, C, B, params, tol, niter));
    return __result;
END_RCPP
}
