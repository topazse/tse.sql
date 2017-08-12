#' Descarga Censo Económico
#'
#' Usa paquete RODBC, ver versiones.
#' @param y year
#' @param nivel nivel MUNICIPIO o ESTADO
#' @param canal canal de conexion a R
#' @export
t_descargar_censoecon <- function(y = 2004, nivel = "MUNICIPIO", canal = tpz_con){
      # Descarga de todos los indicadores para sectores que no son 31 y 33
  s1 <- paste0("SELECT 
  LLAVEGEO, 
  ---ACTIVIDAD_ECONOMICA, 
  bt_censoecon.AE_ID,
  ---Y,
  SECTOR_AGREG,
  H203A as PERS_ADMIN, --- personal administrativo
  H101A as PERS_VTA,  --- personal de ventas, todo...
  H001A as PERS_TOT,  --- personal ocupado total
  K060A as GTO_SERV, --- contratacion de servicios de consultoria y profesionales
  A700A as GTO_TOT, --- total de gastos
  A111A as PROD_TOT,  --- produccion total
  A800A AS ING_TOT, --- ingresos totales
  UE --- unidades
  FROM bt_censoecon
    INNER JOIN 
    dim_ae on dim_ae.ae_id = bt_censoecon.AE_ID
    WHERE 
        GEO_AGREG = '",nivel,"' AND 
        ACTIVIDAD_NIVEL ='SECTOR' AND
        Y = '",y,"' AND 
  EDAD = 'Todas' 
  and TAM = 'Todos'")
      
  d1 <- sqlQuery(channel = canal, query = s1)
  
  # voy a quitar los nulos!! 
  d1$GTO_SERV <- as.numeric(ifelse(d1$GTO_SERV=="NULL",0, d1$GTO_SERV))
      # ---------------------------------------------------------------------------
      # Descarga del sector 31 y 33 (que bajo a nivel subsector)
  s2 <- paste0("
SELECT 
LLAVEGEO, 
'31' as AE_ID,
  avg(cast(SECTOR_AGREG as float)) as SECTOR_AGREG,
  sum(cast(PERS_ADMIN as float)) as PERS_ADMIN, --- personal administrativo
  sum(cast(PERS_VTA as float)) as PERS_VTA,  --- personal de ventas, todo...
  sum(cast(PERS_TOT as float)) as PERS_TOT,  --- personal ocupado total
  sum(cast(GTO_SERV as float)) as GTO_SERV, --- contratacion de servicios de consultoria y profesionales
  sum(cast(GTO_TOT as float)) as GTO_TOT, --- total de gastos
  sum(cast(PROD_TOT as float)) as PROD_TOT,  --- produccion total
  sum(cast(ING_TOT as float)) AS ING_TOT, --- ingresos totales
  sum(cast(UE as float)) as UE --- unidades
  FROM ( 
SELECT 
  LLAVEGEO, 
  ---ACTIVIDAD_ECONOMICA, 
  bt_censoecon.AE_ID,
  ---Y,
  SECTOR_AGREG,
  H203A as PERS_ADMIN, --- personal administrativo
  H101A as PERS_VTA,  --- personal de ventas, todo...
  H001A as PERS_TOT,  --- personal ocupado total
  K060A as GTO_SERV, --- contratacion de servicios de consultoria y profesionales
  A700A as GTO_TOT, --- total de gastos
  A111A as PROD_TOT,  --- produccion total
  A800A AS ING_TOT, --- ingresos totales
  UE --- unidades
  FROM bt_censoecon
    INNER JOIN 
    dim_ae on dim_ae.ae_id = bt_censoecon.AE_ID
    WHERE 
        ACTIVIDAD_SECTOR = 'INDUSTRIA' 
    AND ACTIVIDAD_NIVEL = 'SUBSECTOR' 
    and SUBSTRING(bt_censoecon.AE_ID,1,1)='3' 
        AND Y = '",y, "' AND GEO_AGREG = '", nivel, "' and  
  EDAD = 'Todas' 
  and TAM = 'Todos'
  )Sq_manufactura
group by 
  LLAVEGEO")
  
  d2 <- sqlQuery(channel = canal, query = s2)
  d2$GTO_SERV <- as.numeric(ifelse(d2$GTO_SERV=="NULL",0, d2$GTO_SERV))
      # -------------------------------------
      # quitamos los niveles, para evitar errores cuando pegamos las dos bases
  
  d1$AE_ID <- as.character(d1$AE_ID)
  d1$SECTOR_AGREG <- as.character(d1$SECTOR_AGREG)
  d1$LLAVEGEO <- as.character(d1$LLAVEGEO)
  
  d2$AE_ID <- as.character(d2$AE_ID)
  d2$SECTOR_AGREG <- as.character(d2$SECTOR_AGREG)
  d2$LLAVEGEO <- as.character(d2$LLAVEGEO)
  
      # ----- bind
  d <- rbind.data.frame(d1, d2)
  d
}
