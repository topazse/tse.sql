#' Descarga datos de ifai
#'
#' Usa paquete RODBC, ver versiones.
#' @param con conexion string
#' @param version version
#' @export
t_ifai <- function(con, version = 1) {
  
  if(version == 1){
    q <- "SELECT 
    bt_alumnado.Y,
    ETAPA,
    NIVEL,
    OFERTA,
    CARRERA_TOPAZ,
    PROGRAMA,
    dim_programas.PROGRAMA_ID,
    dim_programas.CODIGO_SEP,
    CONTROL, 
    SOSTENIMIENTO_GRUPO,
    SOSTENIMIENTO, 
    COMPETIDOR AS GRUPO_COMPETENCIA,
    INSTITUCION,
    CCT_NOMBRE AS NOMBRE_CENTRO,
    bt_alumnado.CCT_ID,
    MUNICIPIO_IFAI AS MUNICIPIO, 
    MUNICIPIO_SEDE,
    CASE WHEN GENERO_ID = 0 THEN 'HOMBRES' ELSE
    CASE WHEN GENERO_ID = 1 THEN 'MUJERES' ELSE
    CASE WHEN GENERO_ID = 99 THEN 'TODOS LOS GENEROS' END END END AS GENERO, 
    FUENTE,
    SUM(ALUMNOS) as ALUMNOS
    from bt_alumnado
    inner join dim_etapasalumno on bt_alumnado.ETAPA_ID = dim_etapasalumno.ETAPA_ID
    inner join dim_programas on bt_alumnado.PROGRAMA_ID = dim_programas.PROGRAMA_ID
    inner join dim_ct on dim_ct.CCT_ID = bt_alumnado.CCT_ID
    inner join dim_ctfinanzas on dim_ctfinanzas.CCT_ID = dim_ct.CCT_ID
    inner join dim_sostenimiento on dim_sostenimiento.SOSTENIMIENTO_ID = dim_ctfinanzas.SOSTENIMIENTO_ID
    inner join dim_control on dim_control.CONTROL_ID = dim_ctfinanzas.CONTROL_ID
    inner join dim_niveles on dim_niveles.NIVEL_ID = dim_programas.NIVEL_ID
    left join 
    (select * from dim_instituciones
    where duplicado != '1')sq1 on sq1.INST_ID = dim_ct.INST_ID
    left join dim_competidores on dim_competidores.COMPETIDOR_ID = sq1.COMPETIDOR_ID
    left join dim_municipiosede on dim_municipiosede.MUNICIPIO_ID = dim_ct.MUNICIPIO_ID and dim_municipiosede.ESTADO_ID = dim_ct.ESTADO_ID
    left join dim_carrerastopaz on dim_carrerastopaz.CODIGO_SEP = dim_programas.CODIGO_SEP
    WHERE GENERO_ID IN (0,1)
  AND bt_alumnado.ETAPA_ID NOT IN ('E100', 'E111')
    GROUP BY 
    bt_alumnado.Y,
    NIVEL,
    OFERTA,
    INSTITUCION,
    COMPETIDOR,
    PROGRAMA,
    CARRERA_TOPAZ,
    CCT_NOMBRE,
    MUNICIPIO_IFAI, 
    MUNICIPIO_SEDE,
    SOSTENIMIENTO, 
    SOSTENIMIENTO_GRUPO,
    bt_alumnado.CCT_ID,
    dim_programas.PROGRAMA_ID,
    dim_programas.CODIGO_SEP,
    CONTROL, 
    CASE WHEN GENERO_ID = 0 THEN 'HOMBRES' ELSE
    CASE WHEN GENERO_ID = 1 THEN 'MUJERES' ELSE
    CASE WHEN GENERO_ID = 99 THEN 'TODOS LOS GENEROS' END END END, 
    ETAPA,
    FUENTE"
    
    print("Descargando datos con filtros: por genero (con estimaciones), sin etapas E100 y E111")
  }  
  
  
  
if(version == 2){
  q <- "SELECT 
  bt_alumnado.Y,
  dim_ct.ESTADO_ID, 
  dim_ct.MUNICIPIO_ID,
  dim_ct.ESTADO_ID+'-'+dim_ct.MUNICIPIO_ID as LLAVEGEO,
  SUM(ALUMNOS) as ALUMNOS
  from bt_alumnado
  inner join dim_etapasalumno on bt_alumnado.ETAPA_ID = dim_etapasalumno.ETAPA_ID
  inner join dim_programas on bt_alumnado.PROGRAMA_ID = dim_programas.PROGRAMA_ID
  inner join dim_ct on dim_ct.CCT_ID = bt_alumnado.CCT_ID
  inner join dim_ctfinanzas on dim_ctfinanzas.CCT_ID = dim_ct.CCT_ID and dim_ctfinanzas.Y = bt_alumnado.Y
  inner join dim_sostenimiento on dim_sostenimiento.SOSTENIMIENTO_ID = dim_ctfinanzas.SOSTENIMIENTO_ID
  inner join dim_control on dim_control.CONTROL_ID = dim_ctfinanzas.CONTROL_ID
  inner join dim_niveles on dim_niveles.NIVEL_ID = dim_programas.NIVEL_ID
  left join 
  (select * from dim_instituciones
  where duplicado != '1')sq1 on sq1.INST_ID = dim_ct.INST_ID
  left join dim_competidores on dim_competidores.COMPETIDOR_ID = sq1.COMPETIDOR_ID
  left join dim_municipiosede on dim_municipiosede.MUNICIPIO_ID = dim_ct.MUNICIPIO_ID and dim_municipiosede.ESTADO_ID = dim_ct.ESTADO_ID
  left join dim_carrerastopaz on dim_carrerastopaz.CODIGO_SEP = dim_programas.CODIGO_SEP
  inner join dim_geografia on dim_geografia.MUNICIPIO_ID = dim_ct.MUNICIPIO_ID and dim_geografia.ESTADO_ID = dim_ct.ESTADO_ID
  WHERE GENERO_ID IN (0,1)
  AND NIVEL = 'Profesional'
  AND bt_alumnado.ETAPA_ID NOT IN ('E100', 'E111')
  GROUP BY 
  bt_alumnado.Y,
  dim_ct.ESTADO_ID, 
  dim_ct.MUNICIPIO_ID"
  
  print("Descargando datos con filtros: Profesional y por genero (con estimaciones), sin etapas E100 y E111")
}
  d <- RODBC::sqlQuery(channel = con, 
                       query = q, 
                       stringsAsFactors = FALSE)
  return(d)
}
