calc_weeks = function(week){
  int = interval(week, ceiling_date(today(), unit = "week", week_start = 1))
  n_weeks = as.period(int, unit = "day") /  as.period(dweeks(1))
  return(n_weeks)
}