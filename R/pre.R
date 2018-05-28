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
      
      df <- readxl::read_excel(arquivo) %>% 
        dplyr::mutate(id_linha = seq_len(nrow(.)))
      
      df2 <- df %>% 
        dplyr::left_join(
          df %>% 
            dplyr::group_by(UP, Experimento, Bloco, Tratamento, Navr) %>% 
            dplyr::summarise(n_fuste = n()) %>% 
            dplyr::filter(n_fuste > 1),
          by = c("UP", "Experimento", "Bloco", "Tratamento", "Navr")
        )
      
      df_norm <- dplyr::filter(df2, is.na(n_fuste))
      df_bif_ok <- df2 %>% 
        dplyr::filter(!is.na(n_fuste)) %>% 
        dplyr::inner_join(
          df2 %>% 
            dplyr::group_by(UP, Experimento, Bloco, Tratamento, Navr) %>% 
            dplyr::summarise(DAP = max(DAP, na.rm = TRUE)),
          by = c("UP", "Experimento", "Bloco", "Tratamento", "Navr", "DAP")
        ) %>%
        dplyr::distinct(UP, UP, Experimento, Bloco, Tratamento, Navr, DAP, .keep_all = TRUE)
      
      if (nrow(df_bif_ok) == 0) {
        df_base <- readxl::read_excel(arquivo)
      }
      
      df_base <- dplyr::bind_rows(df_norm, df_bif_ok) %>% 
        dplyr::arrange(id_linha) %>% 
        dplyr::select(-c(id_linha, n_fuste))
      
      df_temp <- df_base %>%
        dplyr::mutate(
          IND = 1:nrow(.),
          PARC = paste0(Tratamento, Bloco),
          SOB = dplyr::case_when(
          Cod %in% c("FALHA", "MORTA", "QUEBRADA", "TOCO") ~ 0,
            TRUE ~ 1
          )
        ) %>%
        dplyr::select(IND, Tratamento, Bloco, PARC, Navr, DAP, Htotal, Vol_ind, SOB, Cod)
      
      df_temp[
        df_temp$Cod %in% c("FALHA", "MORTA", "QUEBRADA"),
        c("DAP", "Htotal", "Vol_ind")
      ] <- 0
      
      df_temp %>% 
        dplyr::select(-Cod) %>% 
        write.table(file_out, dec = ".", row.names = F, na = "0", quote = FALSE)
    }
  }
}


