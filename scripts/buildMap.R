library(leaflet)
library(dplyr)

# Builds a leaflet map and returns it with the dataframe information encoded.
buildMap <- function(userLocation) {
  data <- dplyr::select(userLocation, tweet = text, lon = place_lon, lat = place_lat, html = store.html)
  result.map <- leaflet(data) %>% addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                           attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
    addCircleMarkers(radius = 2, color = "grey", popup = data$html, fillOpacity = 0.5, clusterOptions = markerClusterOptions()) %>%
    setView(lng = -98.85, lat = 37.45, zoom = 4)
  return(result.map)
}






