# Presets ----
library(tidyverse)
library(haven)
library(plotly)
options(scipen = 999)

# I etap ----
df <- data.table::fread('C:/Projects/smwap_project/data/data.csv') %>% as_tibble()
df$stock_id
df %>% write_dta('C:/Projects/smwap_project/data/data.dta')

# II etap ----
df %>% filter(return_on_equity == min(return_on_equity, na.rm = TRUE)) %>% pull(stock_id)
df %>% filter(free_cash_flow_to_net_income == min(free_cash_flow_to_net_income, na.rm = TRUE)) %>% pull(stock_id)
df %>% filter(operating_cash_flow_to_sales == min(operating_cash_flow_to_sales, na.rm = TRUE)) %>% pull(stock_id)
df %>% filter(cash_flow_to_capex == max(cash_flow_to_capex, na.rm = TRUE)) %>% pull(stock_id)
df %>% filter(debt_to_equity_ratio == min(debt_to_equity_ratio, na.rm = TRUE)) %>% pull(stock_id)

classify_stock_sector <- function(x) {
  case_when(
    x %in% c(
      "ADI", "AVGO", "LRCX", "LSCC", "INTC", "ENTG", "KLAC", "AMAT", "AMD", "MRVL", "MCHP", "ON", "NVDA", "QRVO", "MU",
      "TXN", "TER", "SWKS"
    )   ~ "Semiconductors", # 1
    x %in% c(
      "DXCM", "ISRG", "INCY", "ILMN", "IDXX", "GILD", "GH", "GEN", "ALGN", "ALNY", "AMGN", "APLS", "AXON", "HOLX", "MASI",
      "MRNA", "NVCR", "NBIX", "REGN", "RGEN", "PARA", "PODD", "SGEN", "SWAV", "TLRY", "TXG", "VRTX", "VTRS", "WBA", "XRAY",
      "UTHR"
    )  ~ "Healthcare", # 2
    x %in% c(
      "CG", "CINF", "CME", "COIN", "AFRM", "HBAN", "FCNCA", "LPLA", "HOOD", "FITB", "ONEW", "MKTX", "PFG", "NDAQ", "PYPL",
      "WBD", "ZION", "TROW", "SOFI", "SSNC", "JKHY", "MQ","AGNC"
    ) ~ "Financials", # 3
    x %in% c(
      "BYND", "COST", "KDP", "KHC", "DLTR", "MDLZ", "MNST", "PEP"
    )  ~ "Consumer Staples", # 4
    x %in% c(
      "CSX", "LSTR", "JBHT", "JBLU", "FAST", "EXPD", "AAL", "CHRW", "CTAS", "ODFL", "SAIA", "UAL"
    )   ~ "Transportation & Logistics", # 5
    x %in% c(
      "AKAM", "CDNS", "DDOG", "CSCO", "LITE", "MTCH", "PANW", "PAYX", "OKTA", "PCTY", "SNPS", "WDAY", "ZBRA", "ZM", "TRMB",
      "TEAM", "TECH", "ADBE", "ADSK", "CFLT", "APP", "DOCU", "ADP", "CDW", "CTSH", "MSFT", "ROKU", "PTC", "ZS", "CRWD", 
      "FTNT", "FFIV", "ENPH", "LYFT", "SEDG", "TTWO", "SPWR", "Z"
    ) ~ 'Technology', # 6
    x %in% c(
      "CPRT", "HON", "MIDD", "PCAR", "LCID", "ROP", "STLD", "TSLA", "AEP", "LNT", "EXC", "APA", "BKR", "CHK", "FANG"
    )  ~ "Industrials", # 7
    x %in% c(
      "ASO", "CROX", "HAS", "FIVE", "LULU", "LKQ", "MAR", "ORLY", "ULTA", "POOL", "ROST", "PTON", "SBUX", "TXRH", "TSCO",
      "WING", "DKNG", "CZR", "PENN", "AMZN", "EBAY", "ETSY", "OPEN", "BKNG", "CAR", "ABNB", "HTZ", "EXPE", "XEL", "RUN", "HST"
    )   ~ "Consumer Discretionary", # 8
    x %in% c(
      "FOXA", "CMCSA", "LBRDK", "GOOGL", "META", "EA", "NFLX", "TMUS", "SBAC"
    )  ~ "Communication Services", # 9
    x %in% c(
      "DBX", "MDB", "MSTR", "NTAP", "SMCI", "WDC", "ZI", "VRSK", "SPLK", "EQIX", "CSGP"
    ) ~ 'Analytics', # 10
    TRUE ~ "Other"
  )
}
classify_stock_sector2 <- function(x) {
  case_when(
    x %in% c("Communication Services", "Analytics", "Semiconductors") ~ "Technology",
    x %in% c("Consumer Discretionary", "Consumer Staples") ~ "Staples & Discretionary",
    x %in% c("Transportation & Logistics", "Industrials") ~ "Industrials",
    TRUE ~ x
  )
}


df <- read_dta('C:/Projects/smwap_project/data/data_cleaned.dta')
df <- df[-c(df$stock_id %>% duplicated() %>% which()), ]
df %>% 
  mutate(sector_gr10 = classify_stock_sector(stock_id)) %>% 
  mutate(sector_gr5 = classify_stock_sector2(sector_gr10)) %>% 
  mutate(
    sector_gr5 = as.factor(sector_gr5) %>% as.integer(),
    sector_gr10 = as.factor(sector_gr10) %>% as.integer()
  ) %>% 
  as.data.frame() %>% write_dta('C:/Projects/smwap_project/data/data_clean.dta')

# III etap ----
read_table('C:/Projects/smwap_project/images/grouping/compare/popr.txt') %>%
  `colnames<-`(c('Metoda', "Srednia", "Mediana", "MinMax")) %>%
  arrange(desc(Srednia)) %>% 
  plot_ly(
    x =~reorder(Metoda, Srednia),
    y =~ Srednia,
    text =~ Srednia,
    type = 'bar',
    marker = list(color = '#6e8e84')
  ) %>% 
  layout(
    xaxis = list(title = 'Metoda grupowania'),
    yaxis = list(title = 'Średnia odległość')
  )

read_table('C:/Projects/smwap_project/images/grouping/compare/popr.txt') %>%
  `colnames<-`(c('Metoda', "Srednia", "Mediana", "MinMax")) %>%
  arrange(desc(Srednia)) %>% 
  plot_ly(
    x =~reorder(Metoda, Mediana),
    y =~ Mediana,
    text =~ Mediana,
    type = 'bar',
    marker = list(color = '#6e8e84')
  ) %>% 
  layout(
    xaxis = list(title = 'Metoda grupowania'),
    yaxis = list(title = 'Medialna odległość')
  )

read_table('C:/Projects/smwap_project/images/grouping/compare/popr.txt') %>%
  `colnames<-`(c('Metoda', "Srednia", "Mediana", "MinMax")) %>%
  arrange(desc(Srednia)) %>% 
  plot_ly(
    x =~reorder(Metoda, MinMax),
    y =~ MinMax,
    text =~ MinMax,
    type = 'bar',
    marker = list(color = '#6e8e84')
  ) %>% 
  layout(
    xaxis = list(title = 'Metoda grupowania'),
    yaxis = list(title = 'Min/Max odległość')
  )
