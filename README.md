# rselegen

Organizar arquivos para pré e pós processamento no Selegen.  
Uso interno Suzano Papel e Celulose.


## Instalação


``` r
# install.packages("devtools")
devtools::install_github("italocegatta/rselegen")
```

## Utilização

1) Criar uma pasta contendo o arquivo do inventário;

2) Definir as variáveis que serão utilizadas na análise com o comando:

``` r
selegen_pre("caminho/para/arquivo_inventario.xlsx",  c("DAP","ALT", "SOB", "VOL"))
```

3) Executar o modelo desejado no Selegen

4) Extrair as informações do arquivo .Res para Excel

``` r
selegen_tab_mod94("caminho/para/variavel/arquivo_inventario_VXX.Res")
```
