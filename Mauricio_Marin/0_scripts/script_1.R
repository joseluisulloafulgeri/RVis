# JLUF & MMG 02/08/2024

# Cargar librerías necesarias
library(dplyr)
library(stringr)
library(tidyr)

# Ruta del archivo
file_path <- "Mauricio_Marin/1_data/TREVS_RESPUESTAS.txt"

# Leer el archivo de texto
dat <- readLines(file_path)

# Extraer metadatos (desde las líneas 2 a la 6)
metadata <- dat[1:6]
id <- str_extract(metadata[2], "\\d+")
age <- str_extract(metadata[3], "\\d+")
gender <- str_extract(metadata[4], "\\w$")
laterality <- str_extract(metadata[5], "\\w$")
date <- str_extract(metadata[6], "\\d{2}-\\d{2}-\\d{4}")
time <- str_extract(metadata[6], "\\d{2}:\\d{2}:\\d{2}")

# Inicializar dataframe vacío para los ensayos
TREVS <- data.frame(
  ID = character(),
  Age = character(),
  Gender = character(),
  Laterality = character(),
  Date = character(),
  Time = character(),
  Series = character(),
  Trial = character(),
  Reaction_Time = numeric(),
  Stimulus = character(),
  stringsAsFactors = FALSE
)

# Procesar las líneas de los ensayos a partir de la línea 8
for (line in dat[8:length(dat)]) {
  if (grepl("Inicio de Serie", line)) {
    series <- str_extract(line, "\\d+")
    print(paste("Serie detectada:", series))
  } else {
    trial_info <- unlist(strsplit(line, ";"))
    if (length(trial_info) == 4) {
      trial <- str_trim(trial_info[2])
      reaction_time <- as.numeric(gsub(",", ".", str_extract(trial_info[3], "\\d+,\\d+")))
      stimulus <- str_trim(sub("Stimulus: ", "", trial_info[4]))
# Crear una fila de datos con los metadatos y los datos del ensayo
      trials <- data.frame(
        ID = id,
        Age = age,
        Gender = gender,
        Laterality = laterality,
        Date = date,
        Time = time,
        Series = series,
        Trial = trial,
        Reaction_Time = reaction_time,
        Stimulus = stimulus,
        stringsAsFactors = FALSE
      )
      TREVS <- rbind(TREVS, trials)
      rm(trials)
    }
  }
}

# Mostrar el dataframe de ensayos
print(TREVS)
