library(selegen)

selegen_pre("data-raw/TCSP2141_2017_BME.xlsx",  c("DAP","ALT", "SOB", "VOL"))

selegen_tab_mod94("data-raw/DAP/TCSP2141_2017_BME_V01.Res")
selegen_tab_mod94("data-raw/ALT/TCSP2141_2017_BME_V02.Res")

selegen
# resultado <- "data-raw/ALT/TCSP2141_2017_BME_V02.Res"
#
# variaveis <- c("DAP","ALT", "SOB", "VOL")
# arquivo = "data-raw/TCSP2141_2017_BME.xlsx"
# i = 1
# library(magrittr)
#
# basename(arquivo)
# dirname(arquivo)
