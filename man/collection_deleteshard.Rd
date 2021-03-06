% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collection_deleteshard.R
\name{collection_deleteshard}
\alias{collection_deleteshard}
\title{Delete a shard}
\usage{
collection_deleteshard(conn, name, shard, raw = FALSE, ...)
}
\arguments{
\item{conn}{A solrium connection object, see \link{SolrClient}}

\item{name}{(character) Required. The name of the collection that includes the shard
to be deleted}

\item{shard}{(character) Required. The name of the shard to be deleted}

\item{raw}{(logical) If \code{TRUE}, returns raw data}

\item{...}{curl options passed on to \link[crul:HttpClient]{crul::HttpClient}}
}
\description{
Deleting a shard will unload all replicas of the shard and remove
them from clusterstate.json. It will only remove shards that are inactive, or
which have no range given for custom sharding.
}
\examples{
\dontrun{
(conn <- SolrClient$new())

# create collection
if (!conn$collection_exists("buffalo")) {
  conn$collection_create(name = "buffalo")
  # OR: bin/solr create -c buffalo
}

# find shard names
names(conn$collection_clusterstatus()$cluster$collections$buffalo$shards)

# split a shard by name
collection_splitshard(conn, name = "buffalo", shard = "shard1")

# now we have three shards
names(conn$collection_clusterstatus()$cluster$collections$buffalo$shards)

# delete shard
conn$collection_deleteshard(name = "buffalo", shard = "shard1_1")
}
}
