get_data = function(after_date = "2000-01-01 00:00:00"){
  
  after = as.numeric(lubridate::ymd_hms(after_date))
  done = FALSE
  all_df = list()
  i = 1
  
  while (done == FALSE) {
    request <- httr::GET(
      url = "https://www.strava.com/api/v3/athlete/activities",
      config = token,
      query = list(per_page = 200, page = i, after = after)
    )
    
    new_df = 
      request %>%
      httr::content(as = "text") %>%
      jsonlite::fromJSON(flatten = TRUE) %>%
      tibble::as_tibble()
    
    if (nrow(new_df) == 0) {
      done = TRUE
    } else {
      all_df[[i]] = new_df
      i = i + 1
    }
  }
  activities = dplyr::bind_rows(all_df)
  return(activities)
}
