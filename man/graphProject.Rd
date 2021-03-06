% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_program_graph_2.R
\name{graphProject}
\alias{graphProject}
\title{Make plot of project programs only
Summarize all programs. Sync status is assessed and indicated.}
\usage{
graphProject(project = getProject(), testSync = TRUE)
}
\arguments{
\item{project}{Project id of program}

\item{testSync}{logical to test synchronization status}
}
\value{
List of data.frame of programs vertices, data.frame of edges, ggplot ,rgrapher=igraph
}
\description{
Make plot of project programs only
Summarize all programs. Sync status is assessed and indicated.
}
\details{
Uses ggplot2. Is a wrapper for create_program_graph.
}
\examples{
\dontrun{
graphProject("adaprHome")
} 
 
}
