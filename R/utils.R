#' Convert a Date or Datetime Object to Unix Datetime
#'
#' This is a general purpose helper function for this
#' package useful in converting a time stamp to unix time
#'
#' This function is inspired/borrowed from a github page
#' by Neal Richardson who did a similar work to convert the
#' general date time format to unix time.
#'
#' The unix time stamp is a way to track time as a running
#' total of seconds. This count starts at the Unix Epoch on
#' January 1st, 1970 at UTC. Therefore, the unix time stamp
#' is merely the number of seconds between a particular date
#' and the Unix Epoch.
#' @param x your date time stamp
#'
#' @return a unix time stamp.
#'
#' To convert the Start time to unix time

to_unixtime <- function (x) {
  orig <- x
  if (is.character(x)) {
    x <- from_8601(x)
  }
  if (inherits(x, c("POSIXt", "Date"))) {  # CHECKS if the date belongs to the POSIXt.Date class or not if yes than it converts to unix
    x <- as.POSIXct(x)
  }
  x <- as.integer(x)
  if (is.na(x)) {
    message("The date to be converted is not in the right format, please retry the api call with a correct parameter")
    stop()
  }
  return(x)
}

#' This function is called from the to_unixtime() function.
#' This takes a data-time object as a parameter and returns
#' a cleaner string by stripping out unnecessary objects
#' from the timestamp.
#'
#' @return a pattern/format of the timestamp to be converted
#' to unix time.
#'
#' @param x your timestamp passed from to_unixtime()
#'
#' Mind that the returned pattern has 'UTC' format.
#' @importFrom stats "na.omit"

from_8601 <- function (x) {
  # Parse ISO-8601-formatted date strings and return POSIXlt
  if (all(grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", na.omit(x)))) {
    pattern <- "%Y-%m-%d"
  } else if (any(grepl("+", x, fixed = TRUE))) {
    # Strip out a : from the timezone offset, if present
    x <- sub("^(.*[+-][0-9]{2}):([0-9]{2})$", "\\1\\2", x)
    pattern <- "%Y-%m-%dT%H:%M:%OS%z"
  } else {
    pattern <- "%Y-%m-%dT%H:%M:%OS"
  }
  return(strptime(x, pattern, tz = "UTC"))
}

