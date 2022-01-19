source('analysis.R')
# you only need to run the sources once
# =================================  visualization ================================= 

# Sample function to choose a driver randomly.
dr_id <- sample(heetchPoints$driver_id, 1)

# Sample function to choose a day randomly.
date <-sample(heetchPoints$YMD, 1)

# retrieve driver data.
heetch_driver_info <- driver_information(driver_id_ = dr_id, date_ = date, 
                                         filter_by_date = FALSE)

# plot the trace point of the driver with the day and the night.
plot_trace(heetch_driver_info)


# plot facilities
plot_facilities()



  





















  
