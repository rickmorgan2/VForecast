
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Predicting Adverse Regime Transitions (PART)

README last compiled on: 2019-11-15

Data and code for the V-Dem VForecast/PART project to predict the risk
of adverse regime transitions.

*Note from Andy (mosty for future Andy and Rick): The original work in
late 2018 and early 2019 leading up to the May 2019 Policy Day was all
done on Dropbox in the `regime-forecast` folder. I copied some of the
contents of that folder here, and also bumped up one level a smaller
partial copy of `regime-forecast` that was in this repo from before.*

## Reproduction

To run the models, see the `train-model....R` R scripts in the `scripts`
folder. It should be possible to run all of the independently as long as
the neccessary packages listed at the top of each file are installed.
The working directory should be the root of this repo/project,
i.e. `basename(getwd())` should be `"VForecast"`.

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

## Related repos

  - [andybega/part](https://github.com/andybega/part) has one of the
    PART papers
  - [andybega/vfcast](https://github.com/andybega/vfcast) is a tiny R
    package that had paths to Dropbox for Andy and Rick, to avoid having
    some path finding logic at the top of every single script. Not
    really needed for git so I might delete it.

## Copy of Dropbox README

Below is a copy of the README.Rmd file that is on Dropbox. It has fit
summaries and stuff like that.

#### Summary performance

Cross-validation performance:

| name                                  | model | Brier | AUC\_ROC | AUC\_PR | Kappa | trained\_on |
| :------------------------------------ | :---- | ----: | -------: | ------: | ----: | :---------- |
| Lagged RoW logistic regression        | mdl1  |  0.04 |     0.71 |    0.08 |  0.00 | 2019-04-12  |
| Small feature set logistic regression | mdl2  |  0.04 |     0.77 |    0.14 |  0.00 | 2019-04-12  |
| Elastic net logistic regression       | mdl3  |  0.04 |     0.85 |    0.30 |  0.10 | 2019-04-12  |
| Random forest                         | mdl4  |  0.03 |     0.91 |    0.40 |  0.19 | 2019-04-12  |
| XGBoost                               | mdl5  |  0.04 |     0.92 |    0.42 |  0.25 | 2019-04-13  |
| Ensemble                              | mdl6  |  0.03 |     0.93 |    0.46 |  0.17 | 2019-04-13  |

Test forecast performance

| name                                  | model | Brier | AUC\_ROC | AUC\_PR | Kappa | trained\_on |
| :------------------------------------ | :---- | ----: | -------: | ------: | ----: | :---------- |
| Lagged RoW logistic regression        | mdl1  |  0.07 |     0.62 |    0.10 |  0.00 | 2019-04-12  |
| Small feature set logistic regression | mdl2  |  0.07 |     0.65 |    0.15 |  0.00 | 2019-04-12  |
| Elastic net logistic regression       | mdl3  |  0.06 |     0.78 |    0.26 |  0.08 | 2019-04-12  |
| Random forest                         | mdl4  |  0.06 |     0.82 |    0.37 |  0.05 | 2019-04-12  |
| XGBoost                               | mdl5  |  0.06 |     0.81 |    0.36 |  0.16 | 2019-04-13  |
| Ensemble                              | mdl6  |  0.06 |     0.84 |    0.39 |  0.10 | 2019-04-13  |

#### Definitions

  - **Brier –** The mean squared difference between the predicted
    probability and the observed outcome.
      - The **lower** the score, the **better** the predictions are
        **calibrated**.  
          
  - **AUC\_ROC –** Area Under the Curve-Receiver Operating
    Characteristic Curve: The total area under the curve created by
    plotting the **true positive** rate against the **false positive**
    rate across the range of **acceptance thresholds** (0, 1).
      - The **higher** the score, the **better**.  
          
  - **AUC\_PR –** Area Under the Curve-Precision Recall: The trade-off
    between precision – **false positive** rate – and recall – **false
    negative** rate – across the range of **acceptance thresholds** (0,
    1).
      - Better the AUC-ROC when classes are very imbalanced, as is the
        case in our data.
      - The **higher** the score, the **better**.  
          
  - **Kappa –** A metric that compares an observed accuracy with an
    expected accuracy (random chance). It takes into account agreement
    with a random classifier.
      - The **higher** the score, the **better**.

### Separation plots

#### Ordered predictions for all country-year obs. (1970-2017) from trained models (5-fold cross-validation)

  - **Black line –** The predicted probability for each observation
  - **Red lines –** Observations with an ART
  - **Beige lines –** Observations without an ART  
      

#### Rule of Thumb: More red to the right, the better

“currentRegimeDuration”, “v2x\_regime”, “v2x\_regime\_amb”,
“low\_border\_case”, “high\_border\_case”,“any\_neg\_change”,
“num\_of\_neg\_changes\_5yrs”, “gdp\_pc\_log”,

“v2x\_jucon\_new”, “diff\_year\_prior\_v2x\_jucon\_new”,
“v2xlg\_legcon\_new”, “diff\_year\_prior\_v2xlg\_legcon\_new”,
“v2x\_freexp\_altinf\_new”,
“diff\_year\_prior\_v2x\_freexp\_altinf\_new”,

“v2x\_elecreg\_new”, “diff\_year\_prior\_v2x\_elecreg\_new”,
“v2x\_elecoff\_new”, “diff\_year\_prior\_v2x\_elecoff\_new”,
“v2xel\_frefair\_new”, “diff\_year\_prior\_v2xel\_frefair\_new”
