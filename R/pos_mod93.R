selegen_tab_mod93 <- function(resultado) {
  #base
  txt <- read.delim2(resultado, header = FALSE, stringsAsFactors = FALSE)

  # auxiliares
  aux_var <- which(stringr::str_detect(txt$V1, "1. Componentes de Variância"))
  aux_var_nome <- c("Va", "Vparc", "Ve", "Vf", "h2a", "h2aj", "c2parc", "h2mp", "Acprog", "h2ad", "CVgi%", "CVgp%", "CVe%", "CVr", "Média geral")

  aux_efeito_fico1 <- which(stringr::str_detect(txt$V1, "Medias dos Efeitos Fixos"))
  aux_efeito_fico2 <- which(stringr::str_detect(txt$V1, "2. Componentes de Média"))

  aux_sel_ind <- which(stringr::str_detect(txt$V1, "Seleção de Indivíduos"))
  aux_sel_ind_nome <- c("Ordem", "Bloco", "Familia", "Árvore", "f", "a", "u+a", "Ganho", "Nova Média", "Ne", "d", "g")

  aux_sel_gen <- which(stringr::str_detect(txt$V1, "Seleção de Genitores"))
  aux_sel_gen_nome <- c("Ordem", "Genitor", "a", "Ganho", "Nova Média")

  aux_sel_sob_gen <- which(stringr::str_detect(txt$V1, "Seleção com Sobreposição de Gerações"))
  aux_sel_sob_gen_nome <- c("Ordem", "Bloco", "Familia", "Árvore", "a", "Ganho", "Nova Média")

  #tabelas
  deviance <- txt %>%
    dplyr::filter(stringr::str_detect(V1, "Deviance")) %>%
    dplyr::mutate(x = stringr::str_extract(V1, "[0-9|\\.]+")) %>%
    dplyr::pull(x) %>%
    as.numeric() %>%
    dplyr::data_frame(
      estatistica = "Deviance",
      Valor = .
    )

  variancia <- txt %>%
    '['((aux_var+1):(aux_var+15), ) %>%
    stringr::str_split("=", simplify = TRUE) %>%
    '['(, 2) %>%
    stringr::str_extract("[0-9|\\.]+") %>%
    as.numeric() %>%
    dplyr::data_frame(
      estatistica = aux_var_nome,
      Valor = .
    ) %>%
    dplyr::bind_rows(deviance)

  efeito_fixo <- txt %>%
    '['((aux_efeito_fico1+2):(aux_efeito_fico2-1), ) %>%
    stringr::str_split("[:space:]+", simplify = TRUE) %>%
    '['( ,-1) %>%
    dplyr::as_data_frame() %>%
    `names<-`(c("Ef. Fixo", "Valor")) %>%
    dplyr::mutate_all(as.numeric)

  sel_ind <- txt %>%
    '['((aux_sel_ind+2):(aux_sele_gen-1), ) %>%
    stringr::str_split("[:space:]+", simplify = TRUE) %>%
    '['( ,-1) %>%
    dplyr::as_data_frame() %>%
    `names<-`(aux_sel_ind_nome) %>%
    dplyr::mutate_all(as.numeric)

  sel_gen <- txt %>%
    '['((aux_sel_gen+2):(aux_sel_sob_gen-1), ) %>%
    stringr::str_split("[:space:]+", simplify = TRUE) %>%
    '['( ,-1) %>%
    dplyr::as_data_frame() %>%
    `names<-`(aux_sel_gen_nome) %>%
    dplyr::mutate_all(as.numeric)

  sel_sob_gen <- txt %>%
    '['((aux_sel_sob_gen+2):nrow(.), ) %>%
    stringr::str_split("[:space:]+", simplify = TRUE) %>%
    '['( ,-1) %>%
    dplyr::as_data_frame() %>%
    `names<-`(aux_sel_sob_gen_nome) %>%
    dplyr::mutate_all(as.numeric)

  writexl::write_xlsx(
    list(
      `Componentes de Variância` = variancia,
      `Medias dos Efeitos Fixos` = efeito_fixo,
      `Seleção de Indivíduos` = sel_ind,
      `Seleção de Genitores` = sel_gen,
      `Seleção com Sobre. de Gerações` = sel_sob_gen
    ),
    stringr::str_replace(resultado, ".Res", ".xlsx")
  )
}
