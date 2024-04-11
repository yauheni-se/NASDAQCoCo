use "C:\Projects\smwap_project\data\data_clean.dta" 
use "C:\Projects\smwap_project\data\data_clean.dta" 
cluster kmeans at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, k(5) measure(L2) start(firstk) name (kmeans_gr5)
cluster kmeans at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, k(10) measure(L2) start(firstk) name (kmeans_gr10)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(kmeans_gr5) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(kmeans_gr10) anova label(stock_id)
forjan at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, k(5) zgr(forjan_gr5) det label(stock_id)
forjan at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, k(10) zgr(forjan_gr10) det label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(forjan_gr5) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(forjan_gr10) anova label(stock_id)
wishart at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, l_grup(5) zgr(wishart_gr5) det label(stock_id)
wishart at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, l_grup(10) zgr(wishart_gr10) det label(stock_id)
mwroc at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, c(4) zgr(mwroc_gr5) label(stock_id)
mwroc at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, c(3.7) zgr(mwroc_gr10) label(stock_id)
dprima at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g k(5) zgr(dprima_gr5) label(stock_id)
dprima at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g k(10) zgr(dprima_gr10) label(stock_id)
degl at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, k(5) zgr(degl_gr5) label(stock_id)
degl at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, k(10) zgr(degl_gr10) label(stock_id)
label variable kmeans_gr5 ""
label variable kmeans_gr10 ""
tab kmeans_gr5
tab kmeans_gr10
tab forjan_gr5
tab forjan_gr10
tab wishart_gr5
tab wishart_gr10
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(wishart_gr5) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(wishart_gr10) anova label(stock_id)
tab mwroc_gr5
tab mwroc_gr10
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(mwroc_gr5) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(mwroc_gr10) anova label(stock_id)
tab dprima_gr5
replace dprima_gr5 = 5 if dprima_gr5 == 6
tab dprima_gr5
tab dprima_gr10
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(dprima_gr5) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(dprima_gr10) anova label(stock_id)
tab degl_gr5
tab degl_gr10
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(degl_gr5) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(degl_gr10) anova label(stock_id)
set seed 42
gen random_gr5 = round((4 * runiform())+1)
gen random_gr10 = round((9 * runiform())+1)
tab random_gr5
tab random_gr10
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(random_gr5) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(random_gr10) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(sector_gr5) anova label(stock_id)
sumg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, grupy(sector_gr10) anova label(stock_id)
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(kmeans_gr5 kmeans_gr10)
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(forjan_gr5 forjan_gr10)
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(wishart_gr5 wishart_gr10)
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(mwroc_gr5 mwroc_gr10)
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(dprima_gr5 dprima_gr10 )
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(degl_gr5 degl_gr10)
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(random_gr5 random_gr10)
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(sector_gr5 sector_gr10)
mopg at_ls cdp_ratio_s cftc_ws current_ratio_ls dividends_ls dte_ratio_ws eps_ws fcftni_ws gpm_ls imb_flag_s lp_ratio_ls ocfts_ws oip_ws q_ratio_ls roa_s roe_ws stmpp_ls target_s up_ratio_ls, g(dprima_gr5 dprima_gr10)
