library("tidyverse")
library("lubridate")
source("R/calc_weeks.R")
source("R/clean_dates.R")
source("R/get_all_data.R")
source("R/get_data.R")
source("R/get_token.R")
source("R/update_data.R")

token = get_token()
update_data()

df = readRDS("data/all_activies.RDS")
df = df %>%
  clean_dates()

df %>%
  mutate(wday = wday(start_date, label = TRUE, week_start = 1),
         week = floor_date(start_date, unit = "week", week_start = 1),
         weeks_before = calc_weeks(week)) %>% 
  filter(weeks_before <= 10) %>%
  ggplot(aes(x = wday, y = week)) +
  geom_point(aes(col = type, size = distance), alpha = 0.8) + 
  scale_size(range = c(10, 20)) +
  theme_void()  +
  theme(legend.position = "top") + 
  guides(size = FALSE) + 
  scale_colour_manual(
    values = c("Run" = "firebrick",
               "Hike" = "brown",
               "Ride" = "forestgreen",
               "Walk" = "purple",
               "Swim" = "blue",
               "VirtualRide" = "green")
  )

# Run activity count
df %>%
  mutate(month_year = floor_date(start_date, unit = "month")) %>%
  filter(type == "Run") %>%
  ggplot(aes(x = month_year)) + 
  geom_bar(fill = "skyblue") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


unit = "distance"

unit_per_date =
  df %>%
  mutate(date = lubridate::date(start_date)) %>%
  mutate(distance = distance / 1000) %>%
  group_by(date) %>%
  summarise(
    distance = sum(distance),
    time = sum(moving_time) / 3600,
    unit = !!sym(unit)
  ) %>%
  ungroup() %>%
  tidyr::complete(
    date = seq(min(date), max(date), by = "1 day"),
    fill = list(dist = NA)
  )

ggTimeSeries::ggplot_calendar_heatmap(
  unit_per_date,
  "date", "unit",
  dayBorderSize = 0.5,
  dayBorderColour = "white",
  monthBorderSize = 0.75,
  monthBorderColour = "transparent",
  monthBorderLineEnd = "round"
) +
  scale_fill_continuous(
    name = if (unit == "distance") "km" else "hr",
    low = "#FFE6D6",
    high = "#FE5502",
    na.value = "#f9f8f8"
  ) +
  theme_void() + 
  facet_wrap(~Year, ncol = 1) +
  theme(strip.text = element_text(), axis.ticks = element_blank(), legend.position = "right")

  