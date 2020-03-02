bootstrapPage(div(class = "outer",
      tags$head(includeCSS("styles.css")),
    fluidPage(id = "ARTPage", 
      titlePanel("V-Forecast : Prévision des changements de régime défavorables (PART: Predicting Adverse Regime Transitions)"), 
        fluidRow(
          column(12, 
            wellPanel(id = "intro", class = "panel panel-default", #fixed = FALSE,
              h3(tags$span(style = "font-size: 80%; color: black;", "Le projet PART utilise des données de l’Institut ", a(href= "https://www.v-dem.net", "Varieties of Democracy (V-Dem)", target="_blank"), " et d'autres sources pour estimer le risque de changements de régime défavorables au cours des ", tags$b("deux années suivantes (2019-2020)."), 
                br(),
                br(), 
                "Une transition de régime défavorable est définie comme une diminution sur un an de l’", 
                a(href = "https://www.v-dem.net/files/5/Regimes%20of%20the%20World%20-%20Final.pdf", "Indicateur des régimes du monde (RoW: Regimes of the World),", target="_blank"), 
                "qui classe les régimes politiques en tant que ", tags$b("autocratie fermée, autocratie électorale, démocratie électorale ou démocratie libérale. "), "", 
                br(),
                br(), 
                "Pour plus de détails, consultez le", a(href= "https://www.v-dem.net/media/filer_public/b9/b2/b9b2c233-ec45-425d-a397-1cd80dadb63a/v-dem_working_paper_2019_89.pdf", " document de travail.", target="_blank"), "Les commentaires sont bienvenus."
                )
              )
            )
          )
        ),

      fluidRow(
        column(7, id = "mapPanel",   
          leafletOutput("map1", width = "100%", height = "550px")), 
        column(5, id = "hcbarplotID",
          highchartOutput("hcbarplot", height = "575px"))
        ),

      fluidRow(
        column(12,  
                h3(tags$span(style = "font-size: 80%; color: black;",
                "Cliquez sur un pays figurant sur la carte, sur le graphique ou sélectionnez un pays dans la liste ci-dessous pour visualiser son risque estimé et sélectionner les caractéristiques du régime.")), 
        h3(tags$b("Caractéristiques du pays :"))
        )
      ),

      fluidRow(
        column(4, 
        selectInput("countrySelect", choices = countryNamesText, 
          label = h4(tags$b("1) Sélectionnez un pays")), selectize = TRUE)), 
        column(8, 
          h3(textOutput("ROWclass")))
        ),
      fluidRow(
        column(2,
          checkboxGroupInput("checkGroup", label = h4(tags$b("2) Sélectionnez les indicateurs de V-Dem à comparer")), inline = FALSE, 
            choiceNames = list(
            tags$span("Volet libéral", style = paste("color:", v2x_liberal_color, "; font-weight: bold; font-size: 90%;", sep = "")), 
            tags$span("Égalité devant la loi et Liberté individuelle", style = paste("color:", v2xcl_rol_color, "; font-weight: bold; font-size: 90%;", sep = "")), 
            tags$span("Contraintes judiciaires sur l'exécutif", style = paste("color:", v2x_jucon_color, "; font-weight: bold; font-size: 90%;", sep = "")), 
            tags$span("Contraintes législatives sur l'exécutif", style = paste("color:", v2xlg_legcon_color, "; font-weight: bold; font-size: 90%;", sep = "")),
            tags$span("Libertés civiles", style = paste("color:", v2x_civlib_color, "; font-weight: bold; font-size: 90%;", sep = "")),
            tags$span("Démocratie électorale", style = paste("color:", v2x_polyarchy_color, "; font-weight: bold; font-size: 90%;", sep = "")), 
            tags$span("Élections libres et transparentes", style = paste("color:", v2xel_frefair_color, "; font-weight: bold; font-size: 90%;", sep = "")), 
            tags$span("Liberté d'expression et Sources alternatives d'information", style = paste("color:", v2x_freexp_altinf_color, "; font-weight: bold; font-size: 90%;", sep = "")),
            tags$span("Liberté d'association (étendue)", style = paste("color:", v2x_frassoc_thick_color, "; font-weight: bold; font-size: 90%;", sep = ""))),
        choiceValues = c(
              "v2x_liberal",
              "v2xcl_rol",
              "v2x_jucon",
              "v2xlg_legcon",
              "v2x_civlib",
              "v2x_polyarchy",
              "v2xel_frefair",
              "v2x_freexp_altinf",
              "v2x_frassoc_thick")),
          checkboxInput("plotCIs", label = "Intervales de confiance (IC)", value = FALSE)),
        column(6, id = "hcbarplotID2",
          highchartOutput("TimeSeriesPlot", height = "475px")),
        column(4, id = "hcbarplotID1",
          highchartOutput("riskPlot", height = "475px"))#, 
        ),
     fluidRow(
      column(2, ""),
      column(6, 
        wellPanel(id = "note1", class = "panel panel-default",
          h5(tags$span(style = "font-size: 100%;", 
            tags$b("Interprétation :"),"La complexité des modèles utilisés (basés sur l'apprentissage automatique) rend difficile l'identification spécifique des variables ayant un impact décisif sur les prédictions. Aussi, ",tags$b("le graphique des séries chronologiques n'a qu'un but descriptif."), "Il est destiné à aider à identifier des tendances parmi les principaux indicateurs de V-Dem, et non des relations de cause à effet. Pour accéder aux séries chronologiques par pays pour toutes les variables V-Dem, veuillez utiliser l'outil Graphique par pays de V-Dem ",tags$b(a(href= "https://www.v-dem.net/en/analysis/CountryGraph/", "ici", target="_blank"))))
          )
        ),
      column(4, 
        wellPanel(id = "note2", class = "panel panel-default",
          h5(tags$span(style = "font-size: 100%; font-weight: bold; color: #0498F0;", "Les barres bleues"), " indiquent qu'un changement de régime défavorable a eu lieu durant la période de 2 ans", br(), tags$span(style = "font-size: 100%; font-weight: bold; color: #C48BC8;", "Les barres violettes"), " indiquent qu'aucun changement de régime défavorable n'a eu lieu durant la période de 2 ans", br(), tags$span(style = "font-size: 100%; font-weight: bold; color: #A29C97;", "La barre grise"), " indique le risque estimé pour la période de prévision de deux ans en cours"))
        )
      ),

     fluidRow( 
      column(12, 
        wellPanel(id = "methods", class =  "panel panel-default",
          # h3(tags$b("Note :")), 
          h3(tags$b("Méthodologie"),  tags$span(style = "font-size: 70%; color: black;", "(Cf. le", a(href= "https://www.v-dem.net/media/filer_public/b9/b2/b9b2c233-ec45-425d-a397-1cd80dadb63a/v-dem_working_paper_2019_89.pdf", "document de travail", target="_blank"), " pour plus de précisions)")), 
          h4(tags$span(style = "font-size: 90%; color: black;", "Il est important de noter que ces prévisions sont probabilistes : un risque estimé élevé ne signifie pas qu'un changement défavorable de régime se produira avec certitude ; de même, un risque estimé faible ne signifie pas qu'il n'y a aucune chance qu'un changement défavorable de régime se produise.", 
            br(),
            br(),
            "En outre, puisqu'il s'agit de la première année de ce projet, nous ne savons pas encore avec quelle précision ce projet peut prévoir les changements futurs dans le monde réel par delà les simulations et tests statistiques. Toutefois, nous publions ces prévisions dans un souci de transparence.")), 
          h4(tags$span(style = "font-size: 90%; color: black;", tags$b("Crédits:"), br(),"Modélisation et analyse: Richard K. Morgan, Andreas Beger, Adam Glynn (2019), Varieties of Forecasts: Predicting Adverse Regime Transitions. V-Dem Working Paper No. 89.
Données sources: V-Dem.", br(),
"Développement: Andreas Beger, Richard K. Morgan.", br(),
" Adaptation et traduction: Mayeul Kauffmann (Cybis-UGA).
")),
          h4(tags$span(style = "font-size: 90%; color: black;", tags$b("Détails méthodologiques (en anglais):"), "")),
          h4(tags$span(style = "font-size: 90%; color: black;", tags$b("Yearly Risk Estimates"), " - We derive risk estimates for 2011-2017 using a simulation framework that mimics the process we use to produce our 2019-2020 forecasts. In short, we first train our models using all data from 1970 to 2009. We then use data from 2010 to produce estimated risk forecasts for 2011-12. We then retrain our models using all data from 1970 to 2010, use data from 2011 to produce estimates for 2012-12. We conduct this iterative model check procedure for all years, 2011 to 2017.")),
          h4(tags$span(style = "font-size: 90%; color: black;", tags$b("Data"), "- To produce our estimated risk forecasts, we use", a(href= "https://www.v-dem.net/en/data/data-version-9/", "V-Dem data version 9", target="_blank"), "along with" , a(href= "https://unstats.un.org/unsd/snaama/Index", "UN GDP and population data,", target="_blank"), a(href= "https://icr.ethz.ch/publications/integrating-data-on-ethnicity-geography-and-conflict/", "ethnic power relations data (Vogt et al. 2015),", target="_blank"), a(href= "https://www.jonathanmpowell.com/coup-detat-dataset.html", "coup event data (Powell and Thyne 2011),", target="_blank"), "and", a(href= "https://ucdp.uu.se/downloads/", "UCDP armed conflict data (Pettersson and Eck 2018),", target="_blank"), "over 400 variables altogether. We lag all variables one year and derive the first differences for a number of variables. All of variables we use in our models are lagged one year. Thus, data for 2016 is used to estimate the risk of ARTs for 2017/18.")), 
          h4(tags$span(style = "font-size: 90%; color: black;", tags$b("Unit of analysis "), "- We use country-years as our unit of analysis and limit our temporal frame to 1970-2018. We reconcile the differences between the V-Dem country-year set and the", a(href= "https://www.andybeger.com/states/reference/gwstates.html", "Gleditsch and Ward", target="_blank"), "country-year set. This leaves 169 countries for our 2019-2020 forecasts. The number of countries in our data per year ranges from 135 to 169. Our training and validation country-year set covers 7,754 country-year observations.")), 
          h4(tags$span(style = "font-size: 90%; color: black;", tags$b("Effective positive rate"), "- The yearly rate of adverse regime transitions of our dependent variable in any given year ranges from around 1.4 percent to 10 percent; 75 percent of our yearly positive rates are between 3.8 percent and 5.6 percent.")), 
          h4(tags$span(style = "font-size: 90%; color: black;", tags$b("Models"),"- We use three machine learning models: logit with elastic-net regularization, random forest, and gradient boosted forest. To help account for differences across these models, we use an unweighted model average ensemble. This is our preferred approach, as it helps smooth out our predicted risk estimates while improving accuracy. The estimates shown above are from this ensemble model.")),
          h4(tags$span(style = "font-size: 90%; color: black;", tags$b("Model Assessment"),"- Our unweighted model average ensemble model reports an AUC-PR score of 0.46 in a 2x7 repeated cross-validation procedure (1970-2017) and an AUC-PR score of 0.39 in our set of yearly test forecasts (2011-2017). As a general benchmark of performance, an AUC-PR score that is higher than the observed frequency of events in the data is a signal that the model is an improvement over chance. With an observed frequency of ARTs at roughly 4 percent, our unweighted model average ensemble exceeds performance expectations."))
          )
        )
      )
  )  ))