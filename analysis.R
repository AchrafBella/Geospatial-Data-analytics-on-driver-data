source('data_acquisition.R')

# =================================  functions ================================= 

# Function that allow you to detect if driver works in night or day.
check <- function(hour) {
  ifelse(hour>12, 'PM', 'AM')  
}


# Data about the driver.
driver_information <- function(driver_id_, date_, filter_by_date=FALSE){
  
  # this is a specific function that use heetch data
  # by setting TRUE on filter_by_date we get data for 1 day 
  
  heetchM1 <- heetchPoints
  if(filter_by_date == TRUE){
    heetchM1 <- heetchM1 %>% filter(YMD == date_)}
  heetch_driver_info <-  heetchM1 %>% filter(driver_id == driver_id_) 
  heetch_driver_info$workIn <- check(heetch_driver_info$HOUR)
  return(heetch_driver_info)
}

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
                     stroke=FALSE, radius = 5, fillOpacity = 0.6)  
  
}

# Function to plot the locations where the driver was by night & day.
plot_trace <- function(driver_info){

  AM = driver_info[driver_info$workIn == 'AM',]
  PM = driver_info[driver_info$workIn == 'PM',]
  
  leaflet() %>%  
    addTiles() %>%
    addCircles(data = AM, color='red') %>%
    addCircles(data = PM, color='blue')
}


# function that allows us if our driver has been in a fast food or 
# in a restaurant.
# the main idea of this method is to compute the distance between 2 points
# we store the results in a matrix with the elemnt i and j that represent respectively 
# the restaurant and the driver information
# indexes to compute the minimum distance
# i_index
# j_index
#
#
pizza_hut <- osmFeatures$restaurant$osm_points %>% filter(name == 'Pizza Hut') 

m <- matrix(0, nrow = nrow(pizza_hut), ncol = nrow(heetch_driver_info))

for(i in 1:nrow( pizza_hut)) {
  print(paste(i, 'pizza hut'))
  for(j in 1:nrow(heetch_driver_info)){
    m[i, j] <- st_distance(pizza_hut[i, 50], heetch_driver_info[j, 3])
  }
}

indexes = which(m == min(m), arr.ind = TRUE)
i_index = indexes[1]
j_index = indexes[2]


get_pizza_hut = pizza_hut[i_index, 50]
get_driver_position = heetch_driver_info[j_index, 3]


leaflet() %>%  
  addTiles() %>%
  addMarkers(data=get_pizza_hut, popup = 'Pizza Hut') %>%
  addMarkers(data=get_driver_position, popup='driver')






















