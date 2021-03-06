% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/core_exists.R
\name{core_exists}
\alias{core_exists}
\title{Check if a core exists}
\usage{
core_exists(conn, name, callopts = list())
}
\arguments{
\item{conn}{A solrium connection object, see \link{SolrClient}}

\item{name}{(character) The name of the core to be created. Required}

\item{callopts}{curl options passed on to \link[crul:HttpClient]{crul::HttpClient}}
}
\value{
A single boolean, \code{TRUE} or \code{FALSE}
}
\description{
Check if a core exists
}
\details{
Simply calls \code{\link[=core_status]{core_status()}} internally
}
\examples{
\dontrun{
# start Solr with Schemaless mode via the schemaless eg:
#   bin/solr start -e schemaless
# you can create a new core like: bin/solr create -c corename
# where <corename> is the name for your core - or create as below

# connect
(conn <- SolrClient$new())

# exists
conn$core_exists("gettingstarted")

# doesn't exist
conn$core_exists("hhhhhh")
}
}
