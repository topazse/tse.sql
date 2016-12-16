#' Obtiene datos de capacidades por Sede UNID
#'
#' Base de Datos de Sedes UNID
#' @param con nombre de la conexion (ver t_conectarbd())
#' @param actual si TRUE, obtiene la fecha más actual de actualización por campus
#' @param negocio default = UNID
#' @export
t_capacidades <- function(con, actual = TRUE, negocio = "UNID", version = 1){
  if(negocio!="UNID"){stop("Negocio no reconocido")}

  if(version == 1){
    if(actual){
      q <- "
      SELECT
      CENTRO as Campus,
      DIA_DESC as Dia,
      INICIO_HORA as HoraInicio,
      HORAS as DuracionClase,
      count(distinct(AULA)) AS Aulas,
      Sum(CAPACIDAD) as CapacidadInstalada,
      sum(INSCRITOS) as Inscritos,
      CASE WHEN sum(INSCRITOS) = 0
      THEN 0 ELSE
      sum(INSCRITOS)/sum(CAPACIDAD)
      END AS PorcentajeCapacidad
      FROM bt_capacidades
      INNER JOIN dim_centros ON
      bt_capacidades.CENTRO_ID = dim_centros.CENTRO_ID
      INNER JOIN dim_diasunid ON
      dim_diasunid.DIA_UNID = bt_capacidades.DIA
      INNER JOIN (
      SELECT
      CENTRO_ID,
      max(FECHA_ACTUALIZACION) as FechaMax
      FROM bt_capacidades
      GROUP BY CENTRO_ID
      )sq1
      on bt_capacidades.CENTRO_ID = sq1.CENTRO_ID
      and bt_capacidades.FECHA_ACTUALIZACION = sq1.FechaMax
      WHERE ASIGNADO = 1
      GROUP BY
      CENTRO, INICIO_HORA, DIA_DESC, HORAS
      ORDER BY Campus, Dia, HoraInicio"

      d <- RODBC::sqlQuery(channel = con, query = q, stringsAsFactors = FALSE)
    }else{

      q <- "SELECT
      CENTRO as Campus,
      DIA_DESC as Dia,
      INICIO_HORA as HoraInicio,
      HORAS as DuracionClase,
      count(distinct(AULA)) AS Aulas,
      Sum(CAPACIDAD) as CapacidadInstalada,
      sum(INSCRITOS) as Inscritos,
      CASE WHEN sum(INSCRITOS) = 0
      THEN 0 ELSE
      sum(INSCRITOS)/sum(CAPACIDAD)
      END AS PorcentajeCapacidad
      FROM bt_capacidades
      INNER JOIN dim_centros ON
      bt_capacidades.CENTRO_ID = dim_centros.CENTRO_ID
      INNER JOIN dim_diasunid ON
      dim_diasunid.DIA_UNID = bt_capacidades.DIA
      GROUP BY
      CENTRO, INICIO_HORA, DIA_DESC, HORAS
      ORDER BY Campus, Dia, HoraInicio"

      print("Descargando todos los datos, si buscas lo mas actual usar actual = TRUE")

      d <- RODBC::sqlQuery(channel = con, query = q, stringsAsFactors = FALSE)
    }
  }else{
    if(version == 2){
      # version con tipo de aulas...
      if(actual){
        q <- "
        SELECT
        CENTRO as Campus, TIPO_AULA as TipoAula,
        DIA_DESC as Dia,
        INICIO_HORA as HoraInicio,
        HORAS as DuracionClase,
        count(distinct(AULA)) AS Aulas,
        Sum(CAPACIDAD) as CapacidadInstalada,
        sum(INSCRITOS) as Inscritos,
        CASE WHEN sum(INSCRITOS) = 0
        THEN 0 ELSE
        sum(INSCRITOS)/sum(CAPACIDAD)
        END AS PorcentajeCapacidad
        FROM bt_capacidades
        INNER JOIN dim_centros ON
        bt_capacidades.CENTRO_ID = dim_centros.CENTRO_ID
        INNER JOIN dim_diasunid ON
        dim_diasunid.DIA_UNID = bt_capacidades.DIA
        INNER JOIN (
        SELECT
        CENTRO_ID,
        max(FECHA_ACTUALIZACION) as FechaMax
        FROM bt_capacidades
        GROUP BY CENTRO_ID
        )sq1
        on bt_capacidades.CENTRO_ID = sq1.CENTRO_ID
        and bt_capacidades.FECHA_ACTUALIZACION = sq1.FechaMax
        WHERE ASIGNADO = 1
        GROUP BY
        CENTRO, INICIO_HORA, DIA_DESC, HORAS
        ORDER BY Campus, Dia, HoraInicio"

      d <- RODBC::sqlQuery(channel = con, query = q, stringsAsFactors = FALSE)
    }else{

      q <- "SELECT
      CENTRO as Campus, TIPO_AULA as TipoAula,
      DIA_DESC as Dia,
      INICIO_HORA as HoraInicio,
      HORAS as DuracionClase,
      count(distinct(AULA)) AS Aulas,
      Sum(CAPACIDAD) as CapacidadInstalada,
      sum(INSCRITOS) as Inscritos,
      CASE WHEN sum(INSCRITOS) = 0
      THEN 0 ELSE
      sum(INSCRITOS)/sum(CAPACIDAD)
      END AS PorcentajeCapacidad
      FROM bt_capacidades
      INNER JOIN dim_centros ON
      bt_capacidades.CENTRO_ID = dim_centros.CENTRO_ID
      INNER JOIN dim_diasunid ON
      dim_diasunid.DIA_UNID = bt_capacidades.DIA
      GROUP BY
      CENTRO, INICIO_HORA, DIA_DESC, HORAS
      ORDER BY Campus, Dia, HoraInicio"

      print("Descargando todos los datos, si buscas lo mas actual usar actual = TRUE")

      d <- RODBC::sqlQuery(channel = con, query = q, stringsAsFactors = FALSE)
    }

    }else{
      stop("version no reconocida... ")
    }

  }

  #p <- tse.utils::t_printnum(nrow(d))
  #print(paste0("Datos descargados. ", p, " renglones"))
  return(d)
}
