

library("DBI")
#library("rJava")
#library("RJDBC")
library("RODBC")

con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "/usr/lib/libcassandraodbc_sb64.so",
                      Host     = "127.0.0.1",
                      Port     = 9042,
                      Keyspace = "production",
                      AuthMech = 1,
                      UID = "cassandra",
                      PWD = "cassandra"

)
data <- dbGetQuery(con, "SELECT * FROM production.pedigree LIMIT 10")
print(data)
