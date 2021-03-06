% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/biodyn-xval.R
\name{xval}
\alias{xval}
\alias{xval,biodyn-method}
\alias{xval-method}
\title{xval}
\usage{
xval(object, index, ...)
}
\arguments{
\item{object}{an object of class \code{biodyn}}

\item{index}{an \code{FLQuant} or \code{FLQuants} with index of relative stock abundance}

\item{minyear}{last year to fit data to}

\item{maxyear}{last year to project to, by default is the last year in the catch}
}
\description{
Performs a cross-validation uisng a hindcast
}
\details{
Returns a data.frame with index, year, obs and hat
}
\examples{
\dontrun{

}
}

