
packs <- c("tidyverse", "rio", "leaflet", "shiny", "highcharter", "shinyWidgets")
# install.packages(packs, dependencies = TRUE)
lapply(packs, library, character.only = TRUE)


GW_shp_file_new <- readRDS("Data/new_map_data.rds")

GW_shp_file_data <- data.frame(GW_shp_file_new@data, stringsAsFactors = FALSE)%>%
  select(gwcode, country_name, regime, lagged_v2x_regime_amb_asCharacter, year, 
    prob_onset, map_color_prob, color_prob, regime_asCharacter, center_lon, center_lat, popUp_text)%>%
  na.omit(.)


bar_plot_dat <- readRDS("Data/bar_plot_dat.rds")
N <- length(bar_plot_dat[, 1])

prob1_dat <- readRDS("Data/prob1_dat.rds") 

country_characteristic_dat <- readRDS("Data/country_characteristic_dat.rds")
countryNamesText <- c("", sort(unique(country_characteristic_dat$country_name)))

extended_row_dat <- country_characteristic_dat%>%
      select(country_name, year, v2x_regime_amb_asCharacter)%>%
      rename(`Extended RoW Classification` = v2x_regime_amb_asCharacter)

plotsFontSize <- "13px"
v2x_polyarchy_color <- "#a6cee3" #"#AA4643"
v2x_liberal_color <- "#1f78b4" #"#BC449E"
v2xel_frefair_color <- "#b2df8a" #"#4572A7"
v2x_freexp_altinf_color <- "#33a02c" #"#3D96AE"
v2x_frassoc_thick_color <- "#fb9a99" #"#80699B"
v2xcl_rol_color <- "#e31a1c" #"#89A54E"
v2x_jucon_color <- "#fdbf6f" #"#DB843D"
v2xlg_legcon_color <- "#ff7f00" #"#92A8CD"
v2x_civlib_color <- "#cab2d6" #"#408C30"


topNriskFun <- function(dat, N){
  canvasClickFunction <- JS("function(event) {Shiny.onInputChange('canvasClicked', [this.name, event.point.category]);}")
  dat%>%
    hchart(type = "bar", hcaes(x = paste(seq(1, N, 1), country_name, sep = ": "), y = floor(prob_onset * 100), color = color_prob, pointWidth = 20), name = "Estimated Risk")%>% #
    hc_tooltip(formatter = JS("function(){return false;}"))%>%
    hc_xAxis(title = "", 
           labels = list(style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold")))%>%
    hc_yAxis(min = 0, max = 50,
           title = list(text = paste("", N, " pays les plus à risque pour 2019-2020 (risque en %)", sep = ""),
                         style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold")), 
           labels = list(style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold"),
                          step = 1),
           opposite = TRUE)%>%
    hc_plotOptions(series = list(stacking = FALSE, events = list(click = canvasClickFunction)))

}

riskPlotFun <- function(dat){
  Plot1 <- dat%>%
    hchart(type = "column", hcaes(x = year_string, y = prob_1, z = ART_current_year, color = colors), name = "Estimated Risk", pointPadding = -0.1)%>%
    hc_xAxis(title = list(text = ""), 
            labels = list(style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold")))%>%
    hc_yAxis(min = 0, max = 60, title = list(text = "Risque estimé (%)",
                         style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold")), 
           labels = list(style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold")))%>% 
    hc_title(text = "<b>Estimations du risque annuel : 2011-2020</b>",
             margin = 20, align = "center",
             style = list(fontSize = plotsFontSize, useHTML = TRUE))
  }

blankRiskPlotFun <- function(){
  blank_dat <- data.frame(year_string = c("2011/12", "2012/13", "2013/14", "2014/15", "2015/16", "2016/17", "2017/18", "2019/20"), prob_1 = 0)

  blank_dat%>%
    hchart(type = "column", hcaes(x = year_string, y = prob_1), name = "Estimated Risk", pointPadding = -0.1)%>%
    hc_xAxis(title = list(text = ""), 
            labels = list(style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold")))%>%
    hc_yAxis(min = 0, max = 60, title = list(text = "Risque estimé (%)",
                         style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold")), 
           labels = list(style = list(
                            fontSize = plotsFontSize, 
                            fontWeight = "bold")))%>% 
    hc_title(text = "<b>Estimations du risque annuel : 2011-2020</b>",
             margin = 20, align = "center",
             style = list(fontSize = plotsFontSize, useHTML = TRUE))
  }

blankTimeSeriesFun <- function(){
  blank_dat <- data.frame(year = c(2010:2018), Value = NA)

  blank_dat%>%
    hchart(type = "line", hcaes(x = year, y = Value), name = "blank")%>%
          hc_yAxis(min = 0, max = 1,
             title = list(text = "",
                           style = list(
                              fontSize = plotsFontSize, 
                              fontWeight = "bold")), 
             labels = list(style = list(
                              fontSize = plotsFontSize, 
                              fontWeight = "bold")))%>%
          hc_xAxis(data = blank_dat$year, tickInterval = 1,
             title = list(text = "",
                           style = list(
                              fontSize = plotsFontSize, 
                              fontWeight = "bold")),
             labels = list(style = list(
                              fontSize = plotsFontSize, 
                              fontWeight = "bold")))%>%
      hc_plotOptions(series = list(marker = list( enabled = FALSE, radius = 1.2, symbol = "circle"), states = list(hover = list (enabled = TRUE, radius = 3))))%>%
      hc_tooltip(shared = TRUE, crosshairs = TRUE)
}

timeSeriesPlotFun <- function(dat, to_plot, CIs){
  blank_dat <- data.frame(year = c(2010:2018), Value = NA)

  PlotHC <- blank_dat%>%
    hchart(type = "line", hcaes(x = year, y = Value), name = "blank")%>%
          hc_yAxis(min = 0, max = 1,
             title = list(text = "",
                           style = list(
                              fontSize = plotsFontSize, 
                              fontWeight = "bold")), 
             labels = list(style = list(
                              fontSize = plotsFontSize, 
                              fontWeight = "bold")))%>%
          hc_xAxis(data = blank_dat$year, tickInterval = 1,
             title = list(text = "",
                           style = list(
                              fontSize = plotsFontSize, 
                              fontWeight = "bold")),
             labels = list(style = list(
                              fontSize = plotsFontSize, 
                              fontWeight = "bold")))%>%
      hc_plotOptions(series = list(marker = list( enabled = FALSE, radius = 1.2, symbol = "circle"), states = list(hover = list (enabled = TRUE, radius = 3))))%>%
      hc_tooltip(shared = TRUE, crosshairs = TRUE)

  if("v2x_liberal" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2x_liberal),
          name = "Volet libéral", color = v2x_liberal_color, id = "p2")
      if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2x_liberal_codelow, high = v2x_liberal_codehigh),
          name = "IC Volet libéral", fillOpacity = 0.15, lineWidth = 0, color = v2x_liberal_color, linkedTo = "p2") 
      }
  } 
  if(!("v2x_liberal" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Volet libéral", "IC Volet libéral"))
  } 
  if("v2xcl_rol" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2xcl_rol),
          name = "Égalité devant la loi et Liberté individuelle", color = v2xcl_rol_color, id = "p6")
      if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2xcl_rol_codelow, high = v2xcl_rol_codehigh),
          name = "IC Égalité devant la loi et Liberté individuelle", fillOpacity = 0.15, lineWidth = 0, color = v2xcl_rol_color, linkedTo = "p6") 
      }
  } 
  if(!("v2xcl_rol" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Égalité devant la loi et Liberté individuelle", "IC Égalité devant la loi et Liberté individuelle"))
  } 
  if("v2x_jucon" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2x_jucon),
          name = "Contraintes judiciaires sur l'exécutif", color = v2x_jucon_color, id = "p7")
      if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2x_jucon_codelow, high = v2x_jucon_codehigh),
          name = "IC Contraintes judiciaires sur l'exécutif", fillOpacity = 0.15, lineWidth = 0, color = v2x_jucon_color, linkedTo = "p7") 
      }
  } 
  if(!("v2x_jucon" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Contraintes judiciaires sur l'exécutif", "IC Contraintes judiciaires sur l'exécutif"))
  } 
  if("v2xlg_legcon" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2xlg_legcon),
          name = "Contraintes législatives sur l'exécutif", color = v2xlg_legcon_color, id = "p8")
      if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2xlg_legcon_codelow, high = v2xlg_legcon_codehigh),
          name = "IC Contraintes législatives sur l'exécutif", fillOpacity = 0.15, lineWidth = 0, color = v2xlg_legcon_color, linkedTo = "p8") 
      }
  } 
  if(!("v2xlg_legcon" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Contraintes législatives sur l'exécutif", "IC Contraintes législatives sur l'exécutif"))
  } 
  if("v2x_civlib" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2x_civlib),
          name = "Libertés civiles", color = v2x_civlib_color, id = "p9")
      if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2x_civlib_codelow, high = v2x_civlib_codehigh),
          name = "IC Libertés civiles", fillOpacity = 0.15, lineWidth = 0, color = v2x_civlib_color, linkedTo = "p9") 
      }
  } 
  if(!("v2x_civlib" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Libertés civiles", "IC Libertés civiles"))
  } 

  if("v2x_polyarchy" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2x_polyarchy),
          name = "Démocratie électorale", color = v2x_polyarchy_color, id = "p1")
      if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2x_polyarchy_codelow, high = v2x_polyarchy_codehigh),
          name = "IC Démocratie électorale", fillOpacity = 0.15, lineWidth = 0, color = v2x_polyarchy_color, linkedTo = "p1") 
      }
  } 
  if(!("v2x_polyarchy" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Démocratie électorale", "IC Démocratie électorale"))
  } 

  if("v2xel_frefair" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2xel_frefair),
          name = "Élections libres et transparentes", color = v2xel_frefair_color, id = "p3")
    if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2xel_frefair_codelow, high = v2xel_frefair_codehigh),
          name = "IC Élections libres et transparentes", fillOpacity = 0.15, lineWidth = 0, color = v2xel_frefair_color, linkedTo = "p3") 
      }
  } 
  if(!("v2xel_frefair" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Élections libres et transparentes", "IC Élections libres et transparentes"))
  }
  if("v2x_freexp_altinf" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2x_freexp_altinf),
          name = "Liberté d'expression et Sources alternatives d'information", color = v2x_freexp_altinf_color, id = "p4")
      if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2x_freexp_altinf_codelow, high = v2x_freexp_altinf_codehigh),
          name = "IC Liberté d'expression et Sources alternatives d'information", fillOpacity = 0.15, lineWidth = 0, color = v2x_freexp_altinf_color, linkedTo = "p4") 
      }
  } 
  if(!("v2x_freexp_altinf" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Liberté d'expression et Sources alternatives d'information", "IC Liberté d'expression et Sources alternatives d'information"))
  } 
  if("v2x_frassoc_thick" %in% to_plot){
    PlotHC <- PlotHC%>%
      hc_add_series(data = dat, type = "line", hcaes(x = year, y = v2x_frassoc_thick),
          name = "Liberté d'association", color = v2x_frassoc_thick_color, id = "p5")
      if(CIs){
      PlotHC <- PlotHC%>%
        hc_add_series(data = dat, type = "arearange", hcaes(x = year, low = v2x_frassoc_thick_codelow, high = v2x_frassoc_thick_codehigh),
          name = "IC Liberté d'association", fillOpacity = 0.15, lineWidth = 0, color = v2x_frassoc_thick_color, linkedTo = "p5") 
      }
  } 
  if(!("v2x_frassoc_thick" %in% to_plot)){
    PlotHC <- PlotHC%>%
        hc_rm_series(name = c("Liberté d'association", "IC Liberté d'association"))
  } 
  PlotHC
}


# colorGeneratorFun <- function(n) {
#   hues = seq(15, 375, length = n + 1)
#   hcl(h = hues, l = 50, c = 105)[1:n]
# } #From https://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette

# colorpal <- colorGeneratorFun(9)
# v2x_liberal_color <- colorpal[1]
# v2xcl_rol_color <- colorpal[2]
# v2x_jucon_color <- colorpal[3]
# v2xlg_legcon_color <- colorpal[4]
# v2x_civlib_color <- colorpal[5]
# v2x_polyarchy_color <- colorpal[6]
# v2xel_frefair_color <- colorpal[7]
# v2x_freexp_altinf_color <- colorpal[8]
# v2x_frassoc_thick_color <- colorpal[9]