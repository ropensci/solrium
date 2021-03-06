#' Add documents from R objects
#'
#' @export
#' @param x Documents, either as rows in a data.frame, or a list.
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) A collection or core name. Required.
#' @param commit (logical) If `TRUE`, documents immediately searchable.
#' Default: `TRUE`
#' @param commit_within (numeric) Milliseconds to commit the change, the
#' document will be added within that time. Default: NULL
#' @param overwrite (logical) Overwrite documents with matching keys.
#' Default: `TRUE`
#' @param boost (numeric) Boost factor. Default: NULL
#' @param wt (character) One of json (default) or xml. If json, uses
#' [jsonlite::fromJSON()] to parse. If xml, uses [xml2::read_xml()] to
#' parse
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' `wt` param
#' @param ... curl options passed on to [crul::HttpClient]
#'
#' @details Works for Collections as well as Cores (in SolrCloud and Standalone
#' modes, respectively)
#'
#' @seealso \code{\link{update_json}}, \code{\link{update_xml}},
#' \code{\link{update_csv}} for adding documents from files
#'
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create the boooks collection
#' if (!collection_exists(conn, "books")) {
#'   collection_create(conn, name = "books", numShards = 1)
#' }
#'
#' # Documents in a list
#' ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
#' add(ss, conn, name = "books")
#' conn$get(c(1, 2), "books")
#'
#' # Documents in a data.frame
#' ## Simple example
#' df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
#' add(df, conn, "books")
#' df <- data.frame(id = c(77, 78), price = c(1, 2.40))
#' add(df, conn, "books")
#'
#' ## More complex example, get file from package examples
#' # start Solr in Schemaless mode first: bin/solr start -e schemaless
#' file <- system.file("examples", "books.csv", package = "solrium")
#' x <- read.csv(file, stringsAsFactors = FALSE)
#' class(x)
#' head(x)
#' if (!collection_exists(conn, "mybooks")) {
#'   collection_create(conn, name = "mybooks", numShards = 2)
#' }
#' add(x, conn, "mybooks")
#'
#' # Use modifiers
#' add(x, conn, "mybooks", commit_within = 5000)
#'
#' # Get back XML instead of a list
#' ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
#' # parsed XML
#' add(ss, conn, name = "books", wt = "xml")
#' # raw XML
#' add(ss, conn, name = "books", wt = "xml", raw = TRUE)
#' }
add <- function(x, conn, name, commit = TRUE, commit_within = NULL,
                overwrite = TRUE, boost = NULL, wt = 'json', raw = FALSE, ...) {
  UseMethod("add")
}

#' @export
add.list <- function(x, conn, name, commit = TRUE, commit_within = NULL,
  overwrite = TRUE, boost = NULL, wt = 'json', raw = FALSE, ...) {

  check_sr(conn)
  if (!is.null(boost)) {
    x <- lapply(x, function(z) modifyList(z, list(boost = boost)))
  }
  conn$add(x, name, commit, commit_within, overwrite, boost, wt, raw, ...)
}

#' @export
add.data.frame <- function(x, conn, name, commit = TRUE, commit_within = NULL,
  overwrite = TRUE, boost = NULL, wt = 'json', raw = FALSE, ...) {

  check_sr(conn)
  if (!is.null(boost)) x$boost <- boost
  x <- apply(x, 1, as.list)
  conn$add(x, name, commit, commit_within, overwrite, boost, wt, raw, ...)
}
