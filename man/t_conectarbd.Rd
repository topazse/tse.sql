% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/conexion.R
\name{t_conectarbd}
\alias{t_conectarbd}
\title{Conecta R con la base de datos de analitica}
\usage{
t_conectarbd(odbc = "analitica", user = "topaz", pass, export = FALSE)
}
\arguments{
\item{odbc}{nombre de odbc local para conectar}

\item{user}{usuario}

\item{pass}{contrasena}

\item{export}{si TRUE exporta la conexion sin guardar en environment}
}
\description{
Usa paquete RODBC.
}
