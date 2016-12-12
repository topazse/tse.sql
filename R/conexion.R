#' Conecta R con la base de datos de analitica
#'
#' Usa paquete RODBC.
#' @param odbc nombre de odbc local para conectar
#' @export
t_conectarbd <- function(odbc = "analitica",
                         user = "topaz",
                         pass) {
  print("Conectando con base de datos de analitica...")
  require(RODBC)
  tpz_con <<- odbcConnect(dsn = odbc, 
                        uid = user, 
                        pwd = pass)
  print("conectado, en objeto: tpz_con")
}
