update_data = function(){
  df = readRDS("data/all_activies.RDS")
  
  recent_date = max(df$start_date)
  new = get_data(after_date = recent_date) 
  
  if (nrow(new) == 0) {
    cli::cli_alert_info("No new activites to pull")
  } else {
    new = clean_dates(new)
    activities = bind_rows(df, new) %>%
      distinct()
    saveRDS(activities, file = "data/all_activies.RDS")
  }
  
  
}