% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parcc_calcs.R
\name{calculate_agg_parcc_prof}
\alias{calculate_agg_parcc_prof}
\title{Aggregate PARCC results across multiple grade levels}
\usage{
calculate_agg_parcc_prof(end_year, subj, gradespan = "3-11")
}
\arguments{
\item{end_year}{school year / testing year}

\item{subj}{one of 'ela' or 'math'}

\item{gradespan}{one of c('3-11', '3-8', '9-11').  default is '3-11'}
}
\value{
dataframe
}
\description{
a wrapper around fetch_parcc and parcc_aggregate_calcs that simplifies
the calculation of multi-grade PARCC aggregations
}
