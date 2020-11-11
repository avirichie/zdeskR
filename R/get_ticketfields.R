#' Get Zendesk Ticket Fields
#'
#' This function takes your Email Id, authentication token,
#' sub-domain  as parameters and gets all the system and
#' custom fields available for a zendesk ticket.
#'
#' Its not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesn't require you to use any one in particular.
#'
#' @references \url{https://developer.zendesk.com/rest_api
#' /docs/support/ticket_fields}
#'
#' @param email_id Zendesk Email Id (username).
#' @param token Zendesk API token.
#' @param subdomain Your organization's Zendesk sub-domain.
#'
#' @return a Data Frame containing all ticket fields
#'
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#'
#' @export
#'
#' @examples \dontrun{
#' all_ticketfields <- get_ticketfields(email_id, token, subdomain)
#' }


get_ticketfields <- function(email_id, token, subdomain){


  user <- paste0(email_id, "/token")
  pwd <- token
  subdomain <- subdomain
  url_fields <- paste0("https://",subdomain,".zendesk.com/api/v2/ticket_fields.json")

  field_req <- httr::RETRY("GET",
                           url = url_fields,
                           httr::authenticate(user, pwd),
                           times = 4,
                           pause_min = 10,
                           terminate_on = NULL,
                           terminate_on_success = TRUE,
                           pause_cap = 5)

  field_content <- httr::content(field_req, 'text')
  field_json <- jsonlite::fromJSON(field_content,flatten = TRUE)
  field_df <- as.data.frame(field_json$ticket_fields)


  return(field_df)
}
