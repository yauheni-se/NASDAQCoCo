use "C:\Projects\smwap_project\data\data.dta" 
use "C:\Projects\smwap_project\data\data.dta"
summarize
histogram ask_price
qnorm ask_price
histogram asset_turnover
qnorm asset_turnover
histogram ask_size
qnorm ask_size
histogram bid_price
qnorm bid_price
histogram bid_size
qnorm bid_size
histogram cash_dividends_paid_ratio
qnorm cash_dividends_paid_ratio
histogram cash_flow_to_capex
qnorm cash_flow_to_capex
histogram current_ratio
qnorm current_ratio
histogram debt_to_equity_ratio
qnorm debt_to_equity_ratio
histogram dividends
qnorm dividends
histogram eps
qnorm eps
histogram far_price
qnorm far_price
histogram free_cash_flow_to_net_income
qnorm free_cash_flow_to_net_income
histogram gross_profit_margin
qnorm gross_profit_margin
histogram imb_flag
qnorm imb_flag
histogram imb_size
qnorm imb_size
histogram lower_price_ratio
qnorm lower_price_ratio
histogram matched_size
qnorm matched_size
histogram near_price
qnorm near_price
histogram operating_cash_flow_to_sales
qnorm operating_cash_flow_to_sales
histogram operating_income_perc
qnorm operating_income_perc
histogram quick_ratio
qnorm quick_ratio
histogram rdi_perc
qnorm rdi_perc
qnorm ref_price
histogram ref_price
histogram return_on_assets
qnorm return_on_assets
histogram return_on_equity
histogram std_to_mean_price_perc
qnorm std_to_mean_price_perc
histogram upper_price_ratio
qnorm upper_price_ratio
histogram target
qnorm target
histogram wap
tabstat ask_price ask_size asset_turnover bid_price bid_size cash_dividends_paid_ratio cash_flow_to_capex current_ratio debt_to_equity_ratio dividends eps far_price free_cash_flow_to_net_income gross_profit_margin imb_flag imb_size lower_price_ratio matched_size near_price operating_cash_flow_to_sales operating_income_perc quick_ratio rdi_perc ref_price return_on_assets return_on_equity std_to_mean_price_perc target upper_price_ratio wap, statistics(mean sd cv)
drop ask_price bid_price far_price near_price ref_price wap
rename cash_dividends_paid_ratio cdp_ratio
rename cash_flow_to_capex cftc
rename debt_to_equity_ratio dte_ratio
rename free_cash_flow_to_net_income fcftni
rename gross_profit_margin gpm
rename lower_price_ratio lp_ratio
rename operating_cash_flow_to_sales ocfts
rename operating_income_perc oip
rename return_on_assets roa
rename return_on_equity roe
rename std_to_mean_price_perc stmpp
rename upper_price_ratio up_ratio
rename quick_ratio q_ratio
rename rdi_perc rdip
summarize
replace asset_turnover = 0 if missing(asset_turnover)
replace cdp_ratio = 0 if missing(cdp_ratio)
replace cftc = 0 if missing(cftc)
summarize
replace current_ratio = 0 if missing(current_ratio)
replace dte_ratio = 0 if missing(dte_ratio)
replace fcftni = 0 if missing(fcftni)
summarize
replace gpm = 0 if missing(gpm)
replace ocfts = 0 if missing(ocfts)
replace oip = 0 if missing(oip)
replace q_ratio = 0 if missing(q_ratio)
replace rdip = 0 if missing(rdip)
replace roe = 0 if missing(roe)
summarize
tabstat ask_size asset_turnover bid_size cdp_ratio cftc current_ratio dividends dte_ratio eps fcftni gpm imb_flag imb_size lp_ratio matched_size ocfts oip q_ratio rdip roa roe stmpp target up_ratio, statistics(mean sd cv)
gen ask_size_l = log(ask_size + 0.0001)
gen bid_size_l = log(bid_size + 0.0001)
gen dividends_l = log(dividends + 0.0001)
gen imb_size_l = log(imb_size + 0.0001)
gen matched_size_l = log(matched_size + 0.0001)
gen q_ratio_l = log(q_ratio + 0.0001)
tabstat ask_size_l  asset_turnover bid_size_l  cdp_ratio cftc current_ratio dividends_l  dte_ratio eps fcftni gpm imb_flag imb_size_l  lp_ratio matched_size_l  ocfts oip q_ratio_l  rdip roa roe stmpp target up_ratio, statistics(mean sd cv)
histogram q_ratio_l
qnorm q_ratio_l
histogram dividends_l
drop ask_size ask_size_l bid_size bid_size_l imb_size imb_size_l matched_size matched_size_l
gen asset_turnover_l = log(asset_turnover + 0.0001)
tabstat asset_turnover_l, statistics(mean sd cv)
histogram asset_turnover_l
qnorm asset_turnover_l
qnorm dividends_l
drop asset_turnover
gen up_ratio_l = log(up_ratio + 0.0001)
summarize
tabstat up_ratio up_ratio_l, statistics(mean sd cv)
qnorm up_ratio_l
histogram up_ratio_l
drop up_ratio
gen lp_ratio_l = log(lp_ratio + 0.0001)
tabstat lp_ratio lp_ratio_l, statistics(mean sd cv)
qnorm lp_ratio_l
histogram lp_ratio_l
gen stmpp_l = log(stmpp + 0.0001)
tabstat stmpp stmpp_l, statistics(mean sd cv)
qnorm stmpp_l
histogram stmpp_l
drop stmpp
gen gpm_l = log(gpm + 0.0001)
summarize
replace gpm_l = 0 if missing(gpm_l)
replace asset_turnover_l = 0 if missing(asset_turnover_l)
tabstat gpm gpm_l , statistics(mean sd cv)
qnorm gpm_l
histogram gpm_l
drop gpm
summarize ocfts, detail
summarize fcftni, detail
summarize dte_ratio, detail
summarize current_ratio, detail
gen current_ratio_l = log(current_ratio + 0.0001)
tabstat current_ratio current_ratio_l, statistics(mean sd cv)
qnorm current_ratio_l
histogram current_ratio_l
drop current_ratio 
summarize cftc, detail
drop lp_ratio 
ssc install winsor
winsor cftc, p(0.02) gen(cftc_w)
tabstat cftc cftc_w, statistics(mean sd cv)
histogram cftc_w
qnorm cftc_w
drop cftc
winsor dte_ratio, p(0.02) gen(dte_ratio_w)
qnorm dte_ratio_w
histogram dte_ratio_w
tabstat dte_ratio dte_ratio_w, statistics(mean sd cv)
drop dte_ratio
winsor fcftni, p(0.02) gen(fcftni_w)
qnorm fcftni_w
histogram fcftni_w
tabstat fcftni fcftni_w, statistics(mean sd cv)
drop fcftni
winsor ocfts, p(0.02) gen(ocfts_w)
qnorm ocfts_w
histogram ocfts_w
winsor roe, p(0.03) gen(roe_w)
histogram roe_w
qnorm roe_w
drop roe
drop ocfts
winsor oip, p(0.02) gen(oip_w)
qnorm oip_w
histogram oip_w
drop oip
drop rdip
drop dividends
drop q_ratio
winsor eps, p(0.02) gen(eps_w)
histogram eps_w
qnorm eps_w
drop eps
summarize
tabstat asset_turnover_l cdp_ratio cftc_w current_ratio_l dividends_l dte_ratio_w eps_w fcftni_w gpm_l imb_flag lp_ratio_l ocfts_w oip_w q_ratio_l roa roe_w stmpp_l target up_ratio_l, statistics(mean sd cv)
swilk asset_turnover_l cdp_ratio cftc_w current_ratio_l dividends_l dte_ratio_w eps_w fcftni_w gpm_l imb_flag lp_ratio_l ocfts_w oip_w q_ratio_l roa roe_w stmpp_l target up_ratio_l
corr asset_turnover_l cdp_ratio cftc_w current_ratio_l dividends_l dte_ratio_w eps_w fcftni_w gpm_l imb_flag lp_ratio_l ocfts_w oip_w q_ratio_l roa roe_w stmpp_l target up_ratio_l
helw asset_turnover_l cdp_ratio cftc_w current_ratio_l dividends_l dte_ratio_w eps_w fcftni_w gpm_l imb_flag lp_ratio_l ocfts_w oip_w q_ratio_l roa roe_w stmpp_l target up_ratio_l
egen at_ls = std(asset_turnover_l)
egen cdp_ratio_s = std(cdp_ratio)
egen cftc_ws = std(cftc_w)
egen current_ratio_ls = std(current_ratio_l)
egen dividends_ls = std(dividends_l)
egen dte_ratio_ws = std(dte_ratio_w)
egen eps_ws = std(eps_w)
egen fcftni_ws = std(fcftni_w)
egen gpm_ls = std(gpm_l)
egen imb_flag_s = std(imb_flag)
egen lp_ratio_ls = std(lp_ratio_l)
egen ocfts_ws = std(ocfts_w)
egen oip_ws = std(oip_w)
egen q_ratio_ls = std(q_ratio_l)
egen roa_s = std(roa)
egen roe_ws = std(roe_w)
egen stmpp_ls = std(stmpp_l)
egen target_s = std(target)
egen up_ratio_ls = std(up_ratio_l)
drop asset_turnover_l cdp_ratio cftc_w current_ratio_l dividends_l dte_ratio_w eps_w fcftni_w gpm_l imb_flag lp_ratio_l ocfts_w oip_w q_ratio_l roa roe_w stmpp_l target up_ratio_l
helw at_ls cdp_ratio_s cftc_ws  current_ratio_ls  dividends_ls  dte_ratio_ws  eps_ws  fcftni_ws  gpm_ls  imb_flag_s  lp_ratio_ls  ocfts_ws  oip_ws  q_ratio_ls  roa_s  roe_ws  stmpp_ls  target_s  up_ratio_ls
corr at_ls cdp_ratio_s cftc_ws  current_ratio_ls  dividends_ls  dte_ratio_ws  eps_ws  fcftni_ws  gpm_ls  imb_flag_s  lp_ratio_ls  ocfts_ws  oip_ws  q_ratio_ls  roa_s  roe_ws  stmpp_ls  target_s  up_ratio_ls
tabstat at_ls cdp_ratio_s cftc_ws  current_ratio_ls  dividends_ls  dte_ratio_ws  eps_ws  fcftni_ws  gpm_ls  imb_flag_s  lp_ratio_ls  ocfts_ws  oip_ws  q_ratio_ls  roa_s  roe_ws  stmpp_ls  target_s  up_ratio_ls, statistics(cv)
tabstat at_ls cdp_ratio_s cftc_ws  current_ratio_ls  dividends_ls  dte_ratio_ws  eps_ws  fcftni_ws  gpm_ls  imb_flag_s  lp_ratio_ls  ocfts_ws  oip_ws  q_ratio_ls  roa_s  roe_ws  stmpp_ls  target_s  up_ratio_ls, statistics(mean sd cv)
save "C:\Projects\smwap_project\data\data_cleaned.dta"
