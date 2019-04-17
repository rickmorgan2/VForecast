#
#   Assess model results
#   2019-02-20
#

packs <- c("tidyverse", "rio", "mlr", "glmnet", "here", "MLmetrics", "pROC", 
           "xtable", "futile.logger", "parallelMap", "e1071", "MLmetrics", 
           "doParallel", "states", "vfcast")
# install.packages(packs, dependencies = TRUE)
lapply(packs, library, character.only = TRUE)

setwd(vpath("regime-forecast"))
source("R/functions.R")

#   This relies on model_prefix to find relevant files
#
model_prefix <- "mdl6"

# model_prefixs <- paste0("mdl", 3:6, sep = "")

# for(r in model_prefixs){

# model_prefix <- r
# print(model_prefix)


plot_title <- switch(model_prefix,
                     mdl1 = "Base rate Model",
                     mdl2 = "Logistic Regression /w some features",
                     mdl3 = "Elastic-net Regularization",
                     mdl4 = "Random Forest",
                     mdl5 = "Gradient-boosted Forest", 
                     mdl6 = "Average of All ML Models")

#
#   Load needed data
#   _________________

dv_dat <- import("input/VDem_GW_data_final_USE_2yr_target_v9.csv")%>%
	select(gwcode, year, any_neg_change, any_neg_change_2yr)%>%
  rename(any_neg_change_v9 = any_neg_change, any_neg_change_2yr_v9 = any_neg_change_2yr)
# cv_preds <- read_rds(sprintf("output/predictions/%s_cv_preds.rds", model_prefix))
test_forecasts <- read_rds(sprintf("output/predictions/%s_test_forecasts.rds", model_prefix))%>%
    ungroup()

test_forecasts_v9 <- left_join(test_forecasts, dv_dat)

# live_forecasts <- read_rds(sprintf("output/predictions/%s_live_forecast.rds", model_prefix))

# #
# #   Cross-validation 
# #   ________________

# bin_class_summary(cv_preds$truth, cv_preds$prob.1) %>%
#   tibble(model = model_prefix, set = "CV", measure = names(.), value = .) %T>%
#   write_csv(., sprintf("output/performance/%s-cv-performance.csv", model_prefix)) %>%
#   print()

# p <- ggsepplot(cv_preds$truth, cv_preds$prob.1)
# ggsave(sprintf("output/figures/%s-sepplot-cv.pdf", model_prefix), plot = p, height = 2, width = 8)
# ggsave(sprintf("output/figures/%s-sepplot-cv.png", model_prefix), plot = p, height = 2, width = 8)

#
#   Test forecasts
#   _______________

test_fcast_perf_v9 <- bin_class_summary(test_forecasts_v9$any_neg_change_2yr_v9, test_forecasts_v9$prob.1) %>%
  tibble(model = model_prefix, set = "test forecasts", measure = names(.), value = .) 

test_fcast_perf_v9 %T>%
  write_csv(., sprintf("output/performance/%s-test-forecast-performance_v9.csv", model_prefix)) %>%
  print()

p <- ggsepplot(test_forecasts_v9$any_neg_change_2yr_v9, test_forecasts_v9$prob.1)
ggsave(sprintf("output/figures/%s-sepplot-test-forecsts_v9.pdf", model_prefix), plot = p, height = 2, width = 8)

# Yearly check plots
for (y in unique(test_forecasts_v9$year)) {
  
  test_forecasts_this_year <- test_forecasts_v9 %>%
    filter(year==y) %>%
    mutate(Pr1 = round(prob.1, 4)) %>%
    arrange(Pr1)#%>%
    # left_join(dv_dat)
  
  perf_this_year <- bin_class_summary(test_forecasts_this_year$any_neg_change_2yr_v9, test_forecasts_this_year$prob.1)
  
  BaseSepPlotsFun(sprintf("output/figures/%s-%s-yearly-check_v9.pdf", model_prefix, y), 
                  threshold = 0.05,
                  year = y,
                  N = 34,
                  preds = test_forecasts_this_year$Pr1,
                  truth = test_forecasts_this_year$any_neg_change_2yr_v9,
                  any_neg_change = test_forecasts_this_year$any_neg_change_v9,
                  country_names = test_forecasts_this_year$country_name,
                  kappa_score  = perf_this_year["Kappa"],
                  auc_pr_score = perf_this_year["AUC_PR"],
                  brier_score  = perf_this_year["Brier"],
                  model_name   = plot_title)
}
# Live forecast plots 

# live_forecasts <- live_forecasts%>%
# 	mutate(color_prob = case_when(prob.1 < 0.03 ~ "#fef0d9",
#                         prob.1 < 0.05 ~ "#fdcc8a",
#                         prob.1 < 0.1 ~ "#fc8d59", 
#                         prob.1 < 0.15 ~ "#e34a33", 
#                         prob.1 > 0.15 ~ "#b30000"), 
# 		Pr1 = round(prob.1, 4))%>%
#     arrange(Pr1)


# BaseSepPlotsFun_live(sprintf("output/figures/%s-live-forecast_v9.pdf", model_prefix), 
# 					# threshold = 0.1, 
# 					year = 2018, 
# 					N = 34, 
# 					preds = live_forecasts$Pr1, 
# 					country_names = live_forecasts$country_name, 
# 					model_name = plot_title, 
# 					colors = live_forecasts$color_prob)
# # }
