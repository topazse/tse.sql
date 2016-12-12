#' Conecta R con la base de datos de analitica
#'
#' Usa paquete RODBC.
#' @param odbc nombre de odbc local para conectar
t_conectarbd <- function(odbc = "analitica",
                         user = "topaz",
                         pass) {
  print("Conectando con base de datos de analitica...")
  require(RODBC)
  t.con <<- odbcConnect(dsn = odbc, 
                        uid = user, 
                        pwd = pass)
  print("Conectando con base de datos de analitica...")
}
