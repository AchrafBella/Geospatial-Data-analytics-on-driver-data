source('analysis.R')

# =================================  visualization ============================= 

# Sample function to choose a driver randomly.
dr_id <- sample(heetchPoints$driver_id, 1)

# Sample function to choose a day randomly.
date <-sample(heetchPoints$YMD, 1)

# plot the trace point of the driver with the day and the night.
visulize_trace(heetchPoints, dr_id, date)

# plot facilities
plot_facilities()

# plot the place where the driver ate.
have_you_been_in_this_place('Pizza Hut', osmFeatures$restaurant, heetchPoints,
                        dr_id, date)

# let's visualize  the speed of a driver 
speed_detector(heetchPoints, dr_id, date)

# How many hours this driver works ?
driver_time_of_woks(heetchPoints, dr_id)

# the distance cross by the driver each day.
driver_distance_crossed(heetchPoints, dr_id)

# detect home
detect_home(heetchPoints, dr_id, date)

# MSE home detector 
MSE_home_detect(heetchPoints, date)
   