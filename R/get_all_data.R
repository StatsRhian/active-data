get_all_data = function(){
activities = get_data() %>%
  clean_dates()
 saveRDS(activities, file = "data/all_activies.RDS")
}


