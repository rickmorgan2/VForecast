
packs <- c("tidyverse", "rio", "vfcast", "states") 
# install.packages(packs, dependencies = TRUE)
# install.packages("C:/Users/rickm/Dropbox/VForecast/vfcast_0.0.1.tar.gz")
lapply(packs, library, character.only = TRUE)
setwd(vpath("Data/v9/v-dem"))
source("../../../regime-forecast/R/functions.R")

TARGET_YEAR <- 2019

VDem_GW_regime_shift_data <- import("output/VDem_GW_regime_shift_data_1970_v9.csv")%>%
  mutate(country_name = ifelse(country_id == 196, "Sao Tome and Principe", country_name))
dim(VDem_GW_regime_shift_data) ## 'data.frame':   7923 obs. of  26 variables:

Vdem_complete <- import("input/Country_Year_V-Dem_Full+others_CSV_v9/V-Dem-CY-Full+Others-v9.csv")%>%
	filter(year >= 1900)%>%
	group_by(country_id)%>%
		complete(country_id, year = min(year):TARGET_YEAR)%>%
	ungroup()%>%
	fill(country_name)%>%
	mutate(country_name = ifelse(country_id == 196, "Sao Tome and Principe", country_name), 
		gwcode = COWcode, 
		gwcode = case_when(gwcode == 255 ~ 260L,
		      gwcode == 679 ~ 678L,
		      gwcode == 345 & 
		      year >= 2006 ~ 340L, 
		      TRUE ~ gwcode))%>%
	select(country_name, country_text_id, gwcode, country_id, year, 
		v2x_polyarchy, v2x_liberal, v2xdl_delib, v2x_jucon, v2x_freexp_altinf,
		v2x_frassoc_thick, v2xel_frefair, v2x_elecoff, v2xcl_rol, v2xlg_legcon, 
		v2x_partip, v2x_cspart, v2x_egal, v2xeg_eqprotec, #v2xel_regelec,  See below... 
		v2xeg_eqaccess, v2xeg_eqdr, v2x_accountability, v2x_veracc, v2x_diagacc, 
		v2x_horacc, v2xex_elecleg, v2x_civlib, v2x_clphy, v2x_clpol, 
		v2x_clpriv, v2x_corr, v2x_EDcomp_thick, v2x_elecreg, v2x_freexp, 
		v2x_gencl, v2x_gencs, v2x_hosabort, v2x_hosinter, v2x_rule, 
		v2xcl_acjst, v2xcl_disc, v2xcl_dmove, v2xcl_prpty, v2xcl_slave, 
		v2xcs_ccsi, v2xel_elecparl, v2xel_elecpres, v2xex_elecreg, v2xlg_elecreg, 
		v2ex_legconhog, v2ex_legconhos, v2x_ex_confidence, v2x_ex_direlect, v2x_ex_hereditary, 
		v2x_ex_military, v2x_ex_party, v2x_execorr, v2x_pubcorr, v2x_legabort, 
		v2xlg_leginter, v2x_neopat, v2xnp_client, v2xnp_pres, v2xnp_regcorr, 
		v2elvotbuy, v2elfrcamp, v2elpdcamp, v2elpaidig, v2elmonref, 
		v2elmonden, v2elrgstry, v2elirreg, # v2elturnhos, v2elturnhog, 
		v2elintim, v2elpeace, v2elfrfair, v2elmulpar, v2elboycot, 
		v2elaccept, v2elasmoff, v2eldonate, v2elpubfin, v2ellocumul, 
		v2elprescons, v2elprescumul, v2elembaut, v2elembcap, v2elreggov,
		v2ellocgov, v2ellocons, v2elrsthos, v2elrstrct, v2psparban, 
		v2psbars, v2psoppaut, v2psorgs, v2psprbrch, v2psprlnks, 
		v2psplats, v2pscnslnl, v2pscohesv, v2pscomprg, v2psnatpar, 
		v2pssunpar, v2exremhsp, v2exdfdshs, v2exdfcbhs, v2exdfvths, 
		v2exdfdmhs, v2exdfpphs, v2exhoshog, v2exrescon, v2exbribe, 
		v2exembez, v2excrptps, v2exthftps, v2ex_elechos, v2ex_hogw, 
		v2expathhs, v2lgbicam, v2lgqstexp, v2lginvstp, v2lgotovst, 
		v2lgcrrpt, v2lgoppart, v2lgfunds, v2lgdsadlobin, v2lglegplo, 
		v2lgcomslo, v2lgsrvlo, v2ex_hosw, v2lgamend, v2dlreason, 
		v2dlcommon, v2dlcountr, v2dlconslt, v2dlengage, v2dlencmps, 
		v2dlunivl, v2jureform, v2jupurge, v2jupoatck, v2jupack, 
		v2juaccnt, v2jucorrdc, v2juhcind, v2juncind, v2juhccomp, 
		v2jucomp, v2jureview, v2clacfree, v2clrelig, v2cltort, 
		v2clkill, v2cltrnslw, v2clrspct, v2clfmove, v2cldmovem, 
		v2cldmovew, v2cldiscm, v2cldiscw, v2clslavem, v2clslavef, 
		v2clstown, v2clprptym, v2clprptyw, v2clacjstm, v2clacjstw, 
		v2clacjust, v2clsocgrp, v2clrgunev, v2svdomaut, v2svinlaut, 
		v2svstterr, v2cseeorgs, v2csreprss, v2cscnsult, v2csprtcpt, 
		v2csgender, v2csantimv, v2csrlgrep, v2csrlgcon, v2mecenefm, 
		v2mecrit, v2merange, v2meharjrn, v2meslfcen, v2mebias, 
		v2mecorrpt, v2pepwrses, v2pepwrsoc, v2pepwrgen, v2pepwrort, 
		v2peedueq, v2pehealth)%>%
	data.frame(stringsAsFactors = FALSE) 
dim(Vdem_complete) ## 19513   194

Vdem_complete[is.na(Vdem_complete$v2xlg_legcon) & between(Vdem_complete$year, 1970, 2018), c("country_name", "year")]

Vdem_clean_data <- Vdem_complete%>%
    group_by(country_id)%>%
      arrange(year)%>% 
        mutate(is_jud_new = ifelse(is.na(v2x_jucon), 0, 1), ## This helps address whether v2xlg_legcon is NA because there isn't a jud branch
              is_leg_new = ifelse(v2lgbicam > 0, 1, 0), ## This helps address whether v2xlg_legcon is NA because there isn't a leg branch or for some other reason
              is_elec_new = ifelse(v2x_elecreg == 0, 0, 1), ## This helps address whether the NAs in the various election variables are because there were no elections (not permitted) rather than whether there are NAs in the years between elections... 
              is_election_year_new = ifelse(!is.na(v2elirreg), 1, 0))%>% 
              fill(v2elrgstry)%>%
              fill(v2elvotbuy)%>%
              fill(v2elirreg)%>%
              fill(v2elintim)%>%
              fill(v2elpeace)%>%
              fill(v2elfrfair)%>%
              fill(v2elmulpar)%>%
              fill(v2elboycot)%>%
              fill(v2elaccept)%>%
              fill(v2elasmoff)%>%
              fill(v2elfrcamp)%>%
              fill(v2elpdcamp)%>%
              fill(v2elpaidig)%>%
              fill(v2elmonref)%>%
              fill(v2elmonden)%>%
              # fill(v2elturnhog)%>%
              # fill(v2elturnhos)%>%
              mutate(v2elrgstry_new = ifelse(is.na(v2elrgstry) & v2x_elecreg == 0, 0, v2elrgstry),
                v2elvotbuy_new = ifelse(is.na(v2elvotbuy) & v2x_elecreg == 0, 0, v2elvotbuy),
                v2elirreg_new = ifelse(is.na(v2elirreg) & v2x_elecreg == 0, 0, v2elirreg),
                v2elintim_new = ifelse(is.na(v2elintim) & v2x_elecreg == 0, 0, v2elintim),
                v2elpeace_new = ifelse(is.na(v2elpeace) & v2x_elecreg == 0, 0, v2elpeace),
                v2elfrfair_new = ifelse(is.na(v2elfrfair) & v2x_elecreg == 0, 0, v2elfrfair),
                v2elmulpar_new = ifelse(is.na(v2elmulpar) & v2x_elecreg == 0, 0, v2elmulpar),
                v2elboycot_new = ifelse(is.na(v2elboycot) & v2x_elecreg == 0, 0, v2elboycot),
                v2elaccept_new = ifelse(is.na(v2elaccept) & v2x_elecreg == 0, 0, v2elaccept),
                v2elasmoff_new = ifelse(is.na(v2elasmoff) & v2x_elecreg == 0, 0, v2elasmoff),
                v2eldonate_new = v2eldonate,
                v2elpubfin_new = v2elpubfin, 
                v2ellocons_new = v2ellocons, 
                v2ellocumul_new = v2ellocumul, 
                v2elprescons_new = v2elprescons, 
                v2elprescumul_new = v2elprescumul, 
                v2elpaidig_new = ifelse(is.na(v2elpaidig) & v2x_elecreg == 0, 0, v2elpaidig),
                v2elfrcamp_new = ifelse(is.na(v2elfrcamp) & v2x_elecreg == 0, 0, v2elfrcamp),
                v2elpdcamp_new = ifelse(is.na(v2elpdcamp) & v2x_elecreg == 0, 0, v2elpdcamp), 
                v2elpdcamp_new = ifelse(is.na(v2elpdcamp) & v2x_elecreg == 0, 0, v2elpdcamp), 
                v2elmonref_new = ifelse(is.na(v2elmonref) & v2x_elecreg == 0, 0, v2elmonref),
                v2elmonden_new = ifelse(is.na(v2elmonden) & v2x_elecreg == 0, 0, v2elmonden))%>%#,
                # v2elturnhog_new = ifelse(is.na(v2elturnhog) & v2x_elecreg == 0, 0, v2elturnhog),
                # v2elturnhos_new = ifelse(is.na(v2elturnhos) & v2x_elecreg == 0, 0, v2elturnhos))%>%
      ungroup()%>%
            mutate(v2x_polyarchy_new = v2x_polyarchy, 
              v2x_freexp_altinf_new = v2x_freexp_altinf, 
              v2x_frassoc_thick_new = v2x_frassoc_thick, 
              v2xel_frefair_new = v2xel_frefair,
              v2x_liberal_new = v2x_liberal,
              v2xcl_rol_new = v2xcl_rol,
              v2x_jucon_new = ifelse(is_jud_new == 0, 0, v2x_jucon), 
              
              v2xlg_legcon_new = ifelse(is_leg_new == 0, 0, v2xlg_legcon), 
              v2x_cspart_new = v2x_cspart,
              v2xeg_eqprotec_new = v2xeg_eqprotec, 
              v2xeg_eqaccess_new = v2xeg_eqaccess, 
              v2elembaut_new = v2elembaut, 
              v2elembcap_new = v2elembcap, 
              v2elreggov_new = v2elreggov, 
              v2ellocgov_new = v2ellocgov,
              v2ellocons_new = v2ellocons,
              v2elmonref_new = ifelse(is.na(v2elmonref_new) & is_elec_new == 1, 0, v2elmonref_new),
              v2elmonden_new = ifelse(is.na(v2elmonden_new) & is_elec_new == 1, 0, v2elmonden_new),

              v2elrsthos_new = v2elrsthos, 
              v2elrsthos_new = ifelse(is.na(v2elrsthos_new) & country_name == "South Africa" & between(year, 2017, 2018), 1, v2elrsthos_new), ## Not sure why this is NA... It has been a 1 since 1993
              v2elrsthos_new = ifelse(is.na(v2elrsthos_new) & country_name == "Haiti" & between(year, 2017, 2018), 1, v2elrsthos_new), ## Not sure why this is NA... All other years are 1
    
              v2elrstrct_new = v2elrstrct, 
              v2elrstrct_new = ifelse(is.na(v2elrstrct_new) & country_name == "Timor-Leste" & between(year, 2017, 2018), 1, v2elrstrct_new), ## Not sure why this is NA... All other years are 
# v2elturnhog_new = ifelse(is.na(v2elturnhog_new) & is_elec_new == 1, 0, v2elturnhog_new),
# v2elturnhos_new = ifelse(is.na(v2elturnhos_new) & is_elec_new == 1, 0, v2elturnhos_new),
              v2psparban_new = v2psparban,
              v2psbars_new = v2psbars,

              v2psoppaut_new = v2psoppaut, ## There are 164 NAs: Saudi Arabia (1970-2018), Kuwait (2017-18), Qatar (1971-2018), UAE (1971-2018), and Oman (2000-2018)
              v2psoppaut_new = ifelse(is.na(v2psoppaut_new) & country_name == "Saudi Arabia" & between(year, 1970, 2018), -3.527593, v2psoppaut_new), ## Opposition parties are banned in Saudi Arabia. Going with the min score in the data (1970-2017)
              v2psoppaut_new = ifelse(is.na(v2psoppaut_new) & country_name == "Kuwait" & between(year, 1970, 2018), -2.250289, v2psoppaut_new), ## Carry forward. has the same score 1970-2016
              v2psoppaut_new = ifelse(is.na(v2psoppaut_new) & country_name == "Qatar" & between(year, 1971, 2018), -3.527593, v2psoppaut_new), ## Opposition parties are banned in Qatar. Going with the min score in the data (1970-2017)
              v2psoppaut_new = ifelse(is.na(v2psoppaut_new) & country_name == "United Arab Emirates" & between(year, 1971, 2018), -3.527593, v2psoppaut_new), ## Opposition parties are banned in UAE. Going with the min score in the data (1970-2017)
              v2psoppaut_new = ifelse(is.na(v2psoppaut_new) & country_name == "Oman" & between(year, 2000, 2018), -2.46780629, v2psoppaut_new), ## Carry forward. There are a handful of nominal opposition parties, but they are co-opted. No much changed after 1999... 

              v2psorgs_new = v2psorgs,
              v2psprbrch_new = v2psprbrch, 
              v2psprlnks_new = v2psprlnks, 
              v2psplats_new = v2psplats, 
              v2pscnslnl_new = v2pscnslnl, 
              v2pscohesv_new = v2pscohesv, 
              v2pscomprg_new = v2pscomprg,
              v2psnatpar_new = v2psnatpar,
              v2pssunpar_new = v2pssunpar,
              v2exremhsp_new = v2exremhsp,
              v2exdfdshs_new = v2exdfdshs,
              v2exdfcbhs_new = v2exdfcbhs, 
              v2exdfvths_new = v2exdfvths,
              v2exdfdmhs_new = v2exdfdmhs,
              v2exdfpphs_new = v2exdfpphs,
              v2exhoshog_new = v2exhoshog,
              v2exrescon_new = v2exrescon,
              v2exbribe_new = v2exbribe,
              v2exembez_new = v2exembez,
              v2excrptps_new = v2excrptps,
              v2exthftps_new = v2exthftps,
              v2ex_hogw_new = v2ex_hogw,
              v2lgbicam_new = v2lgbicam,
              v2lgqstexp_new = ifelse(is_leg_new == 0, 0, v2lgqstexp), 
              v2lginvstp_new = ifelse(is_leg_new == 0, 0, v2lginvstp), 
              v2lgotovst_new = ifelse(is_leg_new == 0, 0, v2lgotovst), 
              v2lgcrrpt_new = ifelse(is_leg_new == 0, 0, v2lgcrrpt), 
              v2lgoppart_new = ifelse(is_leg_new == 0, 0, v2lgoppart),
              v2lgfunds_new = ifelse(is_leg_new == 0, 0, v2lgfunds), 
              v2lgdsadlobin_new = ifelse(is_leg_new == 0, 0, v2lgdsadlobin),
              v2lglegplo_new = ifelse(is_leg_new == 0, 0, v2lglegplo), 
              v2lgcomslo_new = ifelse(is_leg_new == 0, 0, v2lgcomslo), 
              v2lgsrvlo_new =  ifelse(is_leg_new == 0, 0, v2lgsrvlo),  
              v2ex_hosw_new = v2ex_hosw, 
              v2lgamend_new = ifelse(is.na(v2lgamend) & is_leg_new == 0, 0, v2lgamend),
              v2lgamend_new = ifelse(is.na(v2lgamend_new) & country_name == "Ghana" & year == 2018, 1, v2lgamend_new),
              v2dlreason_new = v2dlreason,
              v2dlcommon_new = v2dlcommon, 
              v2dlcountr_new = v2dlcountr,
              v2dlconslt_new = v2dlconslt,
              v2dlengage_new = v2dlengage,
              v2dlencmps_new = v2dlencmps,
              v2dlunivl_new = v2dlunivl, 
              v2jureform_new = v2jureform, 
              v2jupurge_new = v2jupurge,
              v2jupoatck_new = v2jupoatck,
              v2jupack_new = v2jupack,
              v2juaccnt_new = v2juaccnt,
              v2jucorrdc_new = v2jucorrdc,
              v2juhcind_new = v2juhcind,
              v2juncind_new = v2juncind,
              v2juhccomp_new = v2juhccomp,
              v2jucomp_new = v2jucomp,
              v2jureview_new = v2jureview,
              v2clacfree_new = v2clacfree,
              v2clrelig_new = v2clrelig,
              v2cltort_new = v2cltort,
              v2clkill_new = v2clkill,
              v2cltrnslw_new = v2cltrnslw,
              v2clrspct_new = v2clrspct,
              v2clfmove_new = v2clfmove,
              v2cldmovem_new = v2cldmovem,
              v2cldmovew_new = v2cldmovew,
              v2cldiscm_new = v2cldiscm,
              v2cldiscw_new = v2cldiscw,
              v2clslavem_new = v2clslavem,
              v2clslavef_new = v2clslavef,
              v2clstown_new = v2clstown,
              v2clprptym_new = v2clprptym,
              v2clprptyw_new = v2clprptyw,
              v2clacjstm_new = v2clacjstm,
              v2clacjstw_new = v2clacjstw,
              v2clacjust_new = v2clacjust,
              v2clsocgrp_new = v2clsocgrp,
              v2clrgunev_new = v2clrgunev,
              v2svdomaut_new = v2svdomaut,
              v2svinlaut_new = v2svinlaut,
              v2svstterr_new = v2svstterr,
              v2cseeorgs_new = v2cseeorgs,
              v2csreprss_new = v2csreprss,
              v2cscnsult_new = v2cscnsult,
              v2csprtcpt_new = v2csprtcpt,
              v2csgender_new = v2csgender,
              v2csantimv_new = v2csantimv,
              v2csrlgrep_new = v2csrlgrep,
              v2csrlgcon_new = v2csrlgcon,
              v2mecenefm_new = v2mecenefm,
              v2mecrit_new = v2mecrit,
              v2merange_new = v2merange,
              v2meharjrn_new = v2meharjrn,
              v2meslfcen_new = v2meslfcen,
              v2mebias_new = v2mebias,
              v2mecorrpt_new = v2mecorrpt,
              v2pepwrses_new = v2pepwrses,
              v2pepwrsoc_new = v2pepwrsoc,
              v2pepwrgen_new = v2pepwrgen,
              v2pepwrort_new = v2pepwrort,
              v2peedueq_new = v2peedueq,
              v2pehealth_new = v2pehealth,
              v2x_accountability_new = v2x_accountability, 
              v2x_veracc_new = v2x_veracc, 
              v2x_diagacc_new = v2x_diagacc, 
              v2x_horacc_new = v2x_horacc, 
              v2xex_elecleg_new = v2xex_elecleg,
              v2x_civlib_new = v2x_civlib,
              v2x_clphy_new = v2x_clphy,
              v2x_clpol_new = v2x_clpol,
              v2x_clpriv_new = v2x_clpriv,
              v2x_corr_new = v2x_corr,
              v2x_EDcomp_thick_new = v2x_EDcomp_thick,
              v2x_elecreg_new = v2x_elecreg,
              v2x_freexp_new = v2x_freexp,
              v2x_gencl_new = v2x_gencl,
              v2x_gencs_new = v2x_gencs,
              v2x_hosabort_new = v2x_hosabort, 
              v2x_hosinter_new = v2x_hosinter,
              v2x_pubcorr_new = v2x_pubcorr,
              v2x_rule_new = v2x_rule,
              v2xcl_acjst_new = v2xcl_acjst,
              v2xcl_disc_new = v2xcl_disc,
              v2xcl_dmove_new = v2xcl_dmove,
              v2xcl_prpty_new = v2xcl_prpty,
              v2xcl_slave_new = v2xcl_slave,
              v2xcs_ccsi_new = v2xcs_ccsi,
              v2xel_elecparl_new = v2xel_elecparl,
              v2xel_elecpres_new = v2xel_elecpres,
              v2xex_elecreg_new = v2xex_elecreg,
              v2xlg_elecreg_new = v2xlg_elecreg, 
              v2x_ex_confidence_new = v2x_ex_confidence, 
              v2x_ex_direlect_new = v2x_ex_direlect,
              v2x_ex_hereditary_new = v2x_ex_hereditary,
              v2x_ex_military_new = v2x_ex_military,
              v2x_ex_party_new = v2x_ex_party,
              v2x_execorr_new = v2x_execorr,
              v2x_legabort_new = v2x_legabort,
              v2xlg_leginter_new = v2xlg_leginter,
              v2x_neopat_new = v2x_neopat,
              v2xnp_client_new = v2xnp_client,
              v2xnp_pres_new = v2xnp_pres,
              v2xnp_regcorr_new = v2xnp_regcorr)%>%
	select(country_name, country_text_id, gwcode, country_id, year, contains("_new"))%>%
                    data.frame(stringsAsFactors = FALSE)
dim(Vdem_clean_data) ## 19513   189

Vdem_clean_data_lagged <- Vdem_clean_data%>%
  mutate(year = year + 1)
  names(Vdem_clean_data_lagged)[-c(1:5)] <- paste("lagged_", str_replace_all(names(Vdem_clean_data_lagged), "_new$", "")[-c(1:5)], sep = "")
dim(Vdem_clean_data_lagged) ## 19513   189

Vdem_clean_data_lagged_diff <- Vdem_clean_data_lagged%>%
    group_by(country_id)%>%
      arrange(year)%>%
        mutate_at(vars(-c(country_name, country_text_id, gwcode, country_id, year, lagged_is_jud, lagged_is_leg, lagged_is_elec, lagged_is_election_year)), LagDifFun, 1)%>% 
        ungroup()%>%
      arrange(country_id, year)
names(Vdem_clean_data_lagged_diff)[-c(6:9)] <- str_replace_all(names(Vdem_clean_data_lagged)[-c(6:9)], "lagged_", "lagged_diff_year_prior_")

Vdem_data <- Vdem_clean_data_lagged%>%
  left_join(Vdem_clean_data_lagged_diff)
dim(Vdem_data) ## 19513   369

VDem_GW_data <- VDem_GW_regime_shift_data%>%
  left_join(Vdem_data)%>%
    group_by(gwcode)%>%
      arrange(year)%>%
        fill(1:length(.), .direction = "up")%>%
    ungroup()%>%
      arrange(country_id, year)
dim(VDem_GW_data) ## 7923  390
# summary(VDem_GW_data)

naCountFun(VDem_GW_data, TARGET_YEAR + 1)
naCountFun(VDem_GW_data, TARGET_YEAR)


export(VDem_GW_data, "../input/VDem_GW_data_final_USE_2yr_target_v9.csv")
export(VDem_GW_data, "output/VDem_GW_data_final_USE_2yr_target_v9.csv")
# export(VDem_GW_data, "../../../regime-forecast/input/VDem_GW_data_final_USE_2yr_target_v9.csv")


# VDem_GW_data <- import("../../../regime-forecast/input/VDem_GW_data_final_USE_2yr_target_v9.csv")
