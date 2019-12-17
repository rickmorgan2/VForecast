
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Predicting Adverse Regime Transitions (PART)

README last compiled on: 2019-12-17

Data and code for the V-Dem VForecast/PART project to predict the risk
of adverse regime transitions.

*Note from Andy (mosty for future Andy and Rick): The original work in
late 2018 and early 2019 leading up to the May 2019 Policy Day was all
done on Dropbox in the `regime-forecast` folder. I copied some of the
contents of that folder here, and also bumped up one level a smaller
partial copy of `regime-forecast` that was in this repo from before.*

## Reproduction

The `Data_management` folder contains all of the `R` scripts necessary
for data organization. Due to the size of the data files, we cannot
share them through this repo. However, you can find the finished
product, `ALL_data_final_USE_v9.csv`, in the `Models/input` folder. For
this project we use V-Dem V9 along with a number of external data
sources (See: `Data_management/compile_external_data.R`). Please contact
Andy for access to these data.

The `Models` folder contains the scripts to estimate models. To run the
models, see the `train-model....R` R scripts in the `scripts` folder. It
should be possible to run all of the independently as long as the
neccessary packages listed at the top of each file are installed. The
working directory should be the `Models` folder under this repo/project,
i.e. `basename(getwd())` should be `Models`.

Each model runner script depends on the input data in the `input`
folder, and on the `0-setup-training-environment.R` script to setup data
and other joint parameters shared by all the models.

The `output` folder contains copies of the output from when we ran the
full set of models the last time before the May 2019 V-Dem Policy Day.
Cross-validation is used to tune and assess models. We did not set seeds
when running this, so some variation in output might be expected from
randomness in the CV data partitions.

*AB 2019-11-25: I made minimal changes to be able to run
`train-model1.R` from the GH repo. I only checked that script as the
other models can take a while to run. I noticed that the output changes
slightly, not sure why.*

The `ForecastApp` folder contains the code for the Shiny dashboard on
the V-Dem website [here](https://www.v-dem.net/en/analysis/Forecast)

## Related repos

  - [andybega/part](https://github.com/andybega/part) has one of the
    PART papers
  - [andybega/vfcast](https://github.com/andybega/vfcast) is a tiny R
    package that had paths to Dropbox for Andy and Rick, to avoid having
    some path finding logic at the top of every single script. Not
    really needed for git so I might delete it.

<!-- ## Copy of Dropbox README -->

<!-- Below is a copy of the README.Rmd file that is on Dropbox. It has fit summaries and stuff like that.  -->

<!-- ```{r setup, include=FALSE} -->

<!-- knitr::opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE) -->

<!-- library("dplyr") -->

<!-- library("readr") -->

<!-- library("purrr") -->

<!-- library("readr") -->

<!-- library("tidyr") -->

<!-- library("dplyr") -->

<!-- all_perf <- dir("output/performance",  -->

<!--                 pattern = "mdl[0-9]+[a-z-]+performance.csv",  -->

<!--                 full.names = TRUE) %>% -->

<!--   # so that dfr id is not just index -->

<!--   setNames(., .) %>% -->

<!--   map_dfr(., read_csv, col_types = cols( -->

<!--     model = col_character(), -->

<!--     set = col_character(), -->

<!--     measure = col_character(), -->

<!--     value = col_double()), -->

<!--     .id = "file_path") %>% -->

<!--   # add file mod time so we know when model was trained -->

<!--   mutate(trained_on = map_chr(file_path, function(x) { -->

<!--     out <- file.info(x)[["mtime"]] -->

<!--     as.character(as.Date(out)) -->

<!--   })) %>% -->

<!--   mutate(name = case_when( -->

<!--     model=="mdl1" ~ "Lagged RoW logistic regression", -->

<!--     model=="mdl2" ~ "Small feature set logistic regression", -->

<!--     model=="mdl3" ~ "Elastic net logistic regression", -->

<!--     model=="mdl4" ~ "Random forest", -->

<!--     model=="mdl5" ~ "XGBoost", -->

<!--     model=="mdl6" ~ "Ensemble", -->

<!--     TRUE ~ "fill me in" -->

<!--   )) %>% -->

<!--   select(-file_path) -->

<!-- ``` -->

<!-- #### Summary performance -->

<!-- Cross-validation performance: -->

<!-- ```{r} -->

<!-- cv_perf <- all_perf %>% -->

<!--   filter(set=="CV") %>% -->

<!--   spread(measure, value) %>% -->

<!--   arrange(model) %>% -->

<!--   select(name, model, Brier, AUC_ROC, AUC_PR, Kappa, trained_on)#, everything()) ## Accuracy,  -->

<!-- cv_perf %>% -->

<!--   knitr::kable(digits = 2) -->

<!-- ``` -->

<!-- Test forecast performance -->

<!-- ```{r} -->

<!-- test_perf <- all_perf %>% -->

<!--   filter(set=="test forecasts") %>% -->

<!--   spread(measure, value) %>% -->

<!--   arrange(model) %>% -->

<!--   select(name, model, Brier, AUC_ROC, AUC_PR, Kappa, trained_on)#, everything()) ## Accuracy,  -->

<!-- test_perf %>% -->

<!--   knitr::kable(digits = 2) -->

<!-- ``` -->

<!-- #### Definitions -->

<!-- * **Brier --** The mean squared difference between the predicted probability and the observed outcome.  -->

<!--     + The **lower** the score, the **better** the predictions are **calibrated**.   -->

<!--     \ -->

<!-- * **AUC_ROC --** Area Under the Curve-Receiver Operating Characteristic Curve: The total area under the curve created by plotting the **true positive** rate against the **false positive** rate across the range of **acceptance thresholds** (0, 1).  -->

<!--     + The **higher** the score, the **better**.   -->

<!--     \ -->

<!-- * **AUC_PR --** Area Under the Curve-Precision Recall: The trade-off between precision -- **false positive** rate -- and recall -- **false negative** rate -- across the range of **acceptance thresholds** (0, 1).  -->

<!--     + Better the AUC-ROC when classes are very imbalanced, as is the case in our data. -->

<!--     + The **higher** the score, the **better**.   -->

<!--     \ -->

<!-- * **Kappa --** A metric that compares an observed accuracy with an expected accuracy (random chance). It takes into account agreement with a random classifier. -->

<!--     + The **higher** the score, the **better**. -->

<!-- ### Separation plots  -->

<!-- #### Ordered predictions for all country-year obs. (1970-2017) from trained models (5-fold cross-validation) -->

<!-- * **Black line --** The predicted probability for each observation -->

<!-- * **Red lines --** Observations with an ART -->

<!-- * **Beige lines --** Observations without an ART   -->

<!--     \ -->

<!-- #### Rule of Thumb: More red to the right, the better -->

<!-- ```{r, results='asis'} -->

<!-- plots <- dir("output/figures", pattern = "sepplot_RM", full.names = TRUE) -->

<!-- mdl_no <- stringr::str_extract(plots, "[0-9]") %>% as.integer() -->

<!-- for (i in seq_along(plots)) { -->

<!--   cat(sprintf("\n**Model %s**\n\n", mdl_no[i])) -->

<!--   cat(sprintf("![](%s)\n", plots[i])) -->

<!-- } -->

<!-- ``` -->
