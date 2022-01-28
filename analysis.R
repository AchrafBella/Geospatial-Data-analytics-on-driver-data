# =================================  functions ================================= 
 
# Plot the different facilities like: fast food, restaurant and trampstop...
plot_facilities <- function(){
  leaflet() %>%  
    addTiles() %>%
    addPolylines(data=osmFeatures$tramway, color='yellow') %>%
    addCircleMarkers(data = osmFeatures$fast_food$osm_points, color='blue',
                     stroke=FALSE, radius = 5,  fillOpacity = 0.6) %>%
    addCircleMarkers(data = osmFeatures$restaurant$osm_points, color='red',
                     stroke=FALSE, radius = 5, fillOpacity = 0.6) %>%
    addCircleMarkers(data = osmFeatures$food_court$osm_points, color='orange',
                     stroke=FALSE, radius = 5, fillOpacity = 0.6) %>%
    addCircleMarkers(data = osmFeatures$tramstop, color='green',
                     stroke=FALSE, radius = 5, fillOpacity = 0.6)  %>%
  addLegend('bottomright', colors = c('blue', 'red', 'orange', 'green', 'yellow'),
            labels = c('fast_food', 'restaurant', 'food_court', 
                       'tramstop', 'tramway'), opacity = 1)
  
}

# ==============================================================================

# Function to plot the locations where the driver was by night & day.
visulize_trace <- function(heetchM1, driver_id_, date){
  
  driver_info <- heetchM1
  driver_info <- driver_info %>% filter(driver_id == driver_id_) 
  driver_info <- driver_info %>% filter(YMD == date) 
  driver_info$workIn <- ifelse(driver_info$HOUR>12, 'PM', 'AM')  
  
  leaflet() %>%  
    addTiles() %>%
    addCircles(data = driver_info[driver_info$workIn == 'AM',], color='red') %>%
    addCircles(data = driver_info[driver_info$workIn == 'PM',], color='blue') %>%
    addLegend('bottomright', colors = c('red', 'blue'),
              labels = c('work at day', 'work at night'), opacity = 1)
}

# ==============================================================================

# This function aims to detect if the driver have been in specific place.
have_you_been_in_this_place <- function(name_of_place, data_of_place, 
                                        heetchM1, driver_id_, date){
  
  place <- data_of_place$osm_points %>% filter(name == name_of_place) 
  
  
  heetchM1 <- heetchM1 %>% filter(driver_id == driver_id_) 
  heetchM1 <- heetchM1 %>% filter(YMD == date) 
  
  # we define a matrix to store the place positions, the driver positions 
  # and the distance between these 2 points.
  m <- matrix(0, nrow = nrow(place), ncol = nrow(heetchM1))
  
  # loop function that compute the distances.
  for(i in 1:nrow( place)) {
    print(paste(i, toString(name_of_place)))
    for(j in 1:nrow(heetchM1)){ 
      m[i, j] <- st_distance(place[i, 50], heetchM1[j, 3])
    }
  }
  
  # we retrieve the indexes of the minimum distance that represent that 
  # the driver passed by this place. 
  indexes = which(m == min(m), arr.ind = TRUE)
  i_index = indexes[1]
  j_index = indexes[2]
  
  # we retrieve the geometry
  get_place = place[i_index, 50]
  get_driver_position = heetchM1[j_index, 3]
  
  # we plot the results
  leaflet() %>%  
    addTiles() %>%
    addMarkers(data=get_place, popup = toString(name_of_place)) %>%
    addMarkers(data=get_driver_position, popup='driver')
 
}

# ==============================================================================

# this function aims to compute the speed of the driver v = d/t,

speed_detector <- function(heetchM1, driver_id_, date){
  
  heetchM1 <- heetchM1 %>% filter(driver_id == driver_id_) 
  heetchM1 <- heetchM1 %>% filter(YMD == date) 
  heetchM1 <- heetchM1 %>% arrange(location_at_local_time)
  len <- nrow(heetchM1)
  
  d <- st_distance(heetchM1[2: len, 3], 
                   heetchM1[1: len-1, 3], by_element = TRUE) 
  
  t <- heetchM1$location_at_local_time[2: len] - 
    heetchM1$location_at_local_time[1: len-1]
  
  # convert distances to m
  d <- d / 1000
  # convert mins to hour
  t <- t / 60
  speed <- as.numeric(d) / as.numeric(t) 
  df_speed <- as.data.frame(speed, 'speed')
  df_speed$steps <- 1:nrow(df_speed)
  
  # we plot
  ggplot(df_speed) + 
    geom_line(aes(x= heetchM1$location_at_local_time[2: len], y= speed), 
              color = "blue", size = 1)+
    geom_hline(yintercept=60, linetype="dashed", color = "red") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
    ylab(" speed of the driver") + 
    ggtitle("the speed of the driver during the day")
  
}

# ==============================================================================
# this function calculate how many days or hours the driver worked during the 
# months
# the main idea is to calculate the difference between the minimum time and 
# the maximum time in a 1 day we used groupby to gather the days.

driver_time_of_woks <- function(heetchM1, driver_id_){
   
  heetchM1 <- heetchM1 %>% filter(driver_id == driver_id_) 
  
  vecDif <- heetchM1$location_at_local_time[2:nrow(heetchM1)] - 
    heetchM1$location_at_local_time[1:nrow(heetchM1)-1]
  
  # sélection des points avec seuil à 8h (480 minutes)
  idOff <- which(as.numeric(vecDif) > 480)
  heetchM1 <- heetchM1[idOff, ]
  
  time_of_work <- c()
  # we retrieve all the days of the month & we sort them
  month_days <- heetchM1$YMD %>% unique %>% str_sort  
  
  # we compute the difference between the minimum and maximum of time
  for(i in 1:length(month_days)){
    data_grouped <- heetchM1 %>% filter(YMD == month_days[i])
    time1 <- max(data_grouped$DATE)
    time2 <- min(data_grouped$DATE)
    # calcul it in a range of time 8h  
    
    time_of_work <- append(time_of_work, as.numeric(difftime(time1, time2))) 
  }
  
  # we convert it a data frame
  df_time_of_work <- as.data.frame(time_of_work, 'time_of_work')
  df_time_of_work$days <- 1:nrow(df_time_of_work)
  
  # we plot
  ggplot(df_time_of_work)+
    geom_bar(aes(y = time_of_work, x = month_days), stat="identity") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    ylab(" time of work per hour") +
    ggtitle("The time of work of the driver in a month") 
                                           
}

# ==============================================================================

driver_distance_crossed <- function(heetchM1, driver_id_){
  
  heetchM1 <- heetchM1 %>% filter(driver_id == driver_id_) 
   
  month_days <- heetchM1$YMD %>% unique %>% str_sort  
  
  distances <- c()
  
  for(i in 1:length(month_days)){
    data_grouped <- heetchM1 %>% filter(YMD == month_days[i])
    
    # compute the distance
    d <- st_distance(data_grouped[2: nrow(data_grouped), 3], 
                     data_grouped[1: nrow(data_grouped)-1, 3], by_element = TRUE) 
    d <- sum(as.numeric(d)) / 1000 
    
    distances <- append(distances, as.numeric(d))
  }

  df_dstances <- as.data.frame(distances, 'distances')
  df_dstances$days <- 1:nrow(df_dstances)
  
  # we plot
  ggplot(df_dstances)+
    geom_bar(aes(y = distances, x = month_days), stat="identity") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    ylab("distance km") +
    ggtitle("The distances crossed by the driver") 
  
}

# ==============================================================================

detect_home <- function(heetchM1, dr_id, date){
  
  heetchM1 <- heetchM1 %>% filter(driver_id == dr_id) 
  heetchM1 <- heetchM1 %>% filter(YMD == date) 
  
   
  vecDif <- heetchM1$location_at_local_time[2:nrow(heetchM1)] - 
    heetchM1$location_at_local_time[1:nrow(heetchM1)-1]
  
   idOff <- which(as.numeric(vecDif) > 500)
  homeList <- heetchM1[idOff, ]
  
  casaGridgeom <- st_make_grid(x = heetchM1, n = 40)
  casaGrid <- st_sf(IDGRID = seq(1, length(casaGridgeom), 1),
                    geometry = casaGridgeom)
  
  pointsInGrid <- st_contains(x = casaGrid, y = homeList)
  casaGrid$NPTS <- sapply(X = pointsInGrid, FUN = length)
  homeZone <- casaGrid[which.max(casaGrid$NPTS), ]
 
  nbr_pts_cel = sapply(pointsInGrid, sum)
  n_grid <- casaGrid 
  n_grid$nbr_pts = nbr_pts_cel
  leaflet(data = n_grid %>% filter(nbr_pts == max(nbr_pts))) %>% 
    addTiles() %>% 
    addPolygons(
      fillColor = 'blue',
      weight = 2,
      opacity = 1,
      color = "grey",
      dashArray = "3",
      fillOpacity = 0.3,
      highlight = highlightOptions(
        weight = 5,
        color = "#666",
        dashArray = "",
        fillOpacity = 1,
        bringToFront = TRUE))

 }

# ==============================================================================
# metrcis to evaluate the correctness of the algrithm home dectec 

MSE_home_detect <- function(heetchM1, dr_id){
  
  month_days <- heetchM1$YMD %>% unique %>% str_sort  
  
  # let define a home estimation to be fixed
  home <- home_detect_1(heetchM1, dr_id, month_days[1]) 
  
  home_estimations <- c()
  
  for(i in 2:length(month_days)){
    data_grouped <- heetchM1 %>% filter(YMD == month_days[i])
    home_estimation <- home_detect_1(data_grouped, dr_id, month_days[i]) 
    tryCatch( 
    distance <- st_distance(home, home_estimations)
    )
    # home_estimations <- append(home_estimations, distance)
  }
  
} 

# ==============================================================================

home_detect_1 <- function(heetchM1, dr_id, date){
  # in order to test my MSE_home_detector I invented a new home detector
  # function that return a home 1 point
  casaGridgeom <- st_make_grid(x = heetchM1, n = 40)
  casaGrid <- st_sf(IDGRID = seq(1, length(casaGridgeom), 1),
                    geometry = casaGridgeom)
  casagridcoord <- st_transform(casaGrid, crs=4326)
  
  heetchM1 <- heetchM1 %>% filter(YMD == date) 
  driver <-  heetchM1 %>%  filter(driver_id == dr_id)
  
  hPoints_driver <- heetchPoints[heetchPoints$driver_id == dr_id,]
  hPoints_driver <- hPoints_driver[order(hPoints_driver$location_at_local_time),]
  min_diff <- hPoints_driver$location_at_local_time[2:nrow(hPoints_driver)] %>%
    - hPoints_driver$location_at_local_time[1:nrow(hPoints_driver)-1]
  
  #liste de positions du chauffeur par calcul d'intervals 
  homeList <- hPoints_driver[which(as.numeric(min_diff)>700),]
  
  pointsInGrid <- st_contains(x = casagridcoord, y = homeList)
  casagridcoord$NBPTS = sapply(X = pointsInGrid, FUN = length)
  
  home <- casagridcoord[which.max(casagridcoord$NBPTS),]
  return(home)
}


# ==============================================================================
