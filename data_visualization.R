source('analysis.R')
# you only need to run the sources once
# =================================  visualization ============================= 

# Sample function to choose a driver randomly.
dr_id <- sample(heetchPoints$driver_id, 1)


# Sample function to choose a day randomly.
date <-sample(heetchPoints$YMD, 1)


# retrieve driver data.
heetch_driver_info <- driver_information(driver_id_ = dr_id, date_ = date, 
                                         one_day = TRUE)

# plot the trace point of the driver with the day and the night.
visulize_trace(heetch_driver_info)


# plot facilities
plot_facilities()


# plot the place where the driver ate.
# we can apply this method to any thing we want like hospitals or any place
place_name = 'Pizza Hut'  
data_of_place = osmFeatures$restaurant
have_you_been_in_this_place(place_name, data_of_place, heetch_driver_info)


# let's visualize  the speed of a driver 
speed_detector( heetch_driver_info, 500)

# plot bar plot of the work 
driver_time_of_woks(driver_information(driver_id_ = dr_id, date_ = date, 
                                       one_day = FALSE))














  
