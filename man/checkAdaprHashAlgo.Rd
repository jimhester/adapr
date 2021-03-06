% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Digest.R
\name{checkAdaprHashAlgo}
\alias{checkAdaprHashAlgo}
\title{Checks or changes the specified adapr hash algorithm (adaprHashAlgo option)}
\usage{
checkAdaprHashAlgo(hashAlgorithm = "")
}
\arguments{
\item{hashAlgorithm}{characters specifying adaprHash algorithm if changing}
}
\value{
value is specified algorithm or default algorithm
}
\description{
Checks or changes the specified adapr hash algorithm (adaprHashAlgo option)
}
\details{
Current default is sha1. If algorithm not recognized then will not change option.
}
\examples{
\dontrun{
 checkAdaprHashAlgo()
} 

}
