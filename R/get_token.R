get_token = function(id = Sys.getenv("stravaID"), secret = Sys.getenv("stravaSecret")){

app = httr::oauth_app("strava", id, secret)
endpoint = httr::oauth_endpoint(
  request = NULL,
  authorize = "https://www.strava.com/oauth/authorize",
  access = "https://www.strava.com/oauth/token"
)

token = httr::oauth2.0_token(endpoint, app, as_header = FALSE,
                       scope = "activity:read_all")
return(token)
}