#' Prepara arquivos para analise no Selegen.
#'
#' @export
selegen_pre <- function(arquivo, variaveis) {

  if (stringr::str_detect(arquivo, "\\/")) {
    path <-  dirname(arquivo)
    file <- basename(arquivo)
  } else {
    path <- ""
  }

  for (i in seq_len(length(variaveis))) {
    path_i <- paste(path, variaveis[i], sep = "/")

    if (!dir.exists(path_i)) {
      dir.create(path_i)
    }
    file <- stringr::str_replace(file, "xlsx", "txt")
    file_out <- paste(path_i, file, sep = "/")

    if (!file.exists(file_out)) {
      readxl::read_excel(arquivo) %>%
        dplyr::mutate(
          IND = 1:nrow(.),
          PARC = paste0(Tratamento, Bloco),
          SOB = dplyr::case_when(
            Cod %in% c("FALHAS", "MORTA", "QUEBRADA", "ARV MORTA QUEBRADA") ~ 0,
            TRUE ~ 1
          )
        ) %>%
        dplyr::select(IND, Tratamento, Bloco, PARC, Navr, DAP, Htotal, Vol_ind, SOB, Cod) %>%
        write.table(file_out, dec = ".", row.names = F, na = "0", quote = FALSE)
    }
  }
}


