clean_dates = function(df){
  df = 
    df %>%
    mutate(across(c(start_date, start_date_local),
                  lubridate::ymd_hms))
  return(df)
}