% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/biodyn-plots.R
\name{plotPrd}
\alias{plotPrd}
\alias{plotPrd,biodyn,FLBRP-method}
\alias{plotPrd,biodyn,FLQuant-method}
\alias{plotPrd,biodyn,missing-method}
\title{plotPrd}
\usage{
plotPrd(x, biomass, ...)
}
\arguments{
\item{x}{an object of class \code{biodyn}}

\item{biomass}{optional argument, an FLQuant with biomass at beginning of year}

\item{...}{other arguments}
}
\value{
an \code{ggplot2} object
}
\description{
Creates a \code{ggplot2} object that plots equilibrium values of biomass, harvest rate and catch against each other.
The basic object can then be modified by adding ggpot2 layers.
}
\examples{
\dontrun{
 refpts('logistic',FLPar(msy=100,k=500))
}
}
\seealso{
\code{\link{plotMSE}}, \code{\link{plotEql}}
}

