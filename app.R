# library(RJDBC)
# 
# drv <- JDBC("com.simba.cassandra.jdbc42.Driver",
#             "/home/user/libs/datastax/CassandraJDBC42.jar")
# conn <- dbConnect(drv,
#                   "jdbc:cassandra://127.0.01;AuthMech=1;UID=user;PWD=pass;DefaultKeySpace=production")
# data <- dbGetQuery(conn, "SELECT * FROM pedigree LIMIT 10")
# print(data)
# dbDisconnect(conn)
# 

# 

library("DBI")
library("rJava")
library("RJDBC")
library("RODBC")

con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "/usr/lib/libcassandraodbc_sb64.so",
                      Host     = "127.0.0.1",
                      Port     = 9042,
                      Keyspace = "production",
                      AuthMech = 1,
                      UID = "cassandra",
                      PWD = "cassandra"
                      # UID      = rstudioapi::askForPassword("Database user"),
                      # PWD      = rstudioapi::askForPassword("Database password")
)
data <- dbGetQuery(con, "SELECT * FROM pedigree LIMIT 10")
print(data)

