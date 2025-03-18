
#' @export
genid <- function() {
  paste(sample(letters, 5), collapse = "")
}

#' @export
cassandraColumnTypes <- c('ascii','bigint','blob','boolean','counter','date','decimal','double','duration','float','inet','int','smallint','text','time','timestamp','timeuuid','tinyint','uuid','varchar','varint')

