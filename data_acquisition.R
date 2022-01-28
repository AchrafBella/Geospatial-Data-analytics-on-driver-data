library(sf)           # manipulation des données spatiales
library(osmdata)      # extraction des données OpenStreetMap
library(leaflet)      # visualisation interactive avec leaflet
library(mapsf)        # cartographie statistique
library(lubridate)    # manipulation des dates
library(tidyverse)    # méta-package d'Hadley Wickham
library(ggplot2)      # to plot graphs
library(data.table)   # 

# ========================= Data acquisition ===================================

casaBound <- st_read("DATA/casabound.geojson")
osmFeatures <- readRDS("DATA/osmfeatures.Rds")
heetchPoints <- readRDS("DATA/heetchmarchcrop.Rds")

heetchPoints$DATE <- ymd_hms(heetchPoints$location_at_local_time,
                             tz = "Africa/Casablanca")

heetchPoints$YMD <- substr(heetchPoints$location_at_local_time, 1, 10)
heetchPoints$HOUR <- substr(heetchPoints$location_at_local_time, 12, 13)

# ======================= Download new OSM data ================================

osmFeatures$fast_food <- opq(bbox = st_bbox(casaBound)) %>%
  add_osm_feature(key = "amenity", 
                  value = "fast_food") %>% 
  osmdata_sf()

osmFeatures$food_court <- opq(bbox = st_bbox(casaBound)) %>%
  add_osm_feature(key = "amenity", 
                  value = "food_court") %>% 
  osmdata_sf()

osmFeatures$restaurant <- opq(bbox = st_bbox(casaBound)) %>%
  add_osm_feature(key = "amenity", 
                  value = "restaurant") %>% 
  osmdata_sf()
