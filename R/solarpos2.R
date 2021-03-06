#' Calculate solar position(s) for location and time
#'
#' This is a wrapper function around \code{maptools::solarpos}, adapted for accepting location as a \code{Spatial*} layer or a \code{Raster}. The function calculates layer centroid, transforms it to lon-lat, then calls \code{maptools::solarpos} to calculate solar position(s) for that point at the given time(s)
#'
#' @param	location	A \code{Spatial*} or a \code{Raster} object
#' @param	time	A \code{SpatialLines*} or a \code{SpatialPolygons*} object
#' @return	A \code{matrix} with two columns representing sun position(s); first column is the solar azimuth (in decimal degrees from North), second column is sun elevation (in decimal degrees); rows represent different times corresponding to \code{time}
#'
#' @examples
#' time = as.POSIXct("2004-12-24 13:30:00", tz = "Asia/Jerusalem")
#' solarpos2(build, time)
#'
#' @export

solarpos2 = function(location, time) {

  # Checks
  stopifnot(methods::is(location, "Spatial") | methods::is(location, "Raster"))
  .checkTime(time)

  if(methods::is(location, "Raster")) location = raster::rasterToPoints(location, spatial = TRUE)

  # Find centroid
  location_ctr = rgeos::gCentroid(location)

  # Transform to lon-lat
  location_ctr = sp::spTransform(location_ctr, "+proj=longlat +datum=WGS84")

  # Calculate solar position
  maptools::solarpos(location_ctr, time)

}
