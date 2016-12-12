#' Conecta R con la base de datos de analitica
#'
#' Usa paquete RODBC.
#' @param odbc nombre de odbc local para conectar
#' @param user usuario 
#' @param pass contrasena
#' @param export si TRUE exporta la conexion sin guardar en environment
#' @export
t_conectarbd <- function(odbc = "analitica",
                         user = "topaz",
                         pass, 
                         export = FALSE) {
  print("Conectando con base de datos de analitica...")
  require(RODBC)
  if(export){
    odbcConnect(dsn = odbc, 
                uid = user, 
                pwd = pass) 
  }else{
    tpz_con <<- odbcConnect(dsn = odbc, 
                            uid = user, 
                            pwd = pass)  
  }
  print("conectado, en objeto: tpz_con")
}
