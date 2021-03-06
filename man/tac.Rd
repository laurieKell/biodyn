% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/biodyn-hcr.R
\docType{methods}
\name{tac,biodyn-method}
\alias{tac}
\alias{tac,biodyn-method}
\alias{tac-method}
\title{tac ,}
\usage{
\S4method{tac}{biodyn}(object, harvest, ...)
}
\arguments{
\item{object}{an object of class \code{biodyn} or}

\item{harvest}{an \code{FLQuant} object with harvest rate}

\item{...}{other arguments}
}
\value{
FLQuant object with TAC value(s)
}
\description{
Calculates the Total Allowable Catch for a \code{biodyn} object and target harvest rate
by projecting the last year.
}
\examples{
\dontrun{
tac(bd,FLQuant(0.1,dimnames=list(year=dims(bd)$maxyear)))
}
}
\seealso{
\code{\link{hcr}},  \code{\link{fwd}}
}

