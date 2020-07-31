#' Get Zendesk Tickets
#'
#' This function takes your Email Id, authentication token,
#' sub-domain and start time as parameters and gets all the
#' tickets which have been updated on or after the start
#' time parameter. By default each page returns 1000 unique
#' tickets and an "after_cursor" value which stores a
#' pointer to the next page. After getting the first page
#' it uses the pointer to fetch the subsequent pages.
#'
#' The start time parameter here should be in 'UTC' format as
#' Zendesk uses the 'UTC' time format to export results. For eg
#' "2020-07-30 20:00:00 EDT" will be "2020-08-01 00:00:00 UTC".
#' So the user must do proper adjustment to the time format to
#' convert the desired time from their time zone to UTC format.
#' A wrong time format wont throw any error but it will not import
#' accurate information.
#'
#' Its not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesn't require you to use any one in particular.
#'
#'
#' @references \url{https://developer.zendesk.com/rest_api
#' /docs/support/incremental_export#start_time}
#'
#' @param email_id your Zendesk emailid
#' @param token your Zendesk API token
#' @param start_time Date or Datetime object to get all
#' tickets modified after that date.
#' @param subdomain your organization's name
#'
#' @return a Data Frame containing all tickets after the
#' start time
#'
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' @importFrom tidyr "pivot_wider"
#' @importFrom purrr "map_dfr"
#' @importFrom plyr "rbind.fill"
#'
#' @export
#'
#' @examples \dontrun{
#' allTickets <- getTickets(email_id, token, subdomain, start_time = 0)
#' }


get_tickets <- function(email_id, token, subdomain, start_time = 0){

  user <- paste0(email_id, "/token")
  pwd <- token
  subdomain <- subdomain
  url <- paste0("https://", subdomain,
                ".zendesk.com/api/v2/incremental/tickets/cursor.json?start_time=",
                to_unixtime(start_time))

  cursor_url <- paste0("https://",
                       subdomain,
                       ".zendesk.com/api/v2/incremental/tickets/cursor.json?cursor=")

  #To get the cursor
  after_cursor <- NULL
  while(is.null(after_cursor)){
    request_ticket<-  httr::GET(url = url,httr::authenticate(user, pwd))
    if(!is.null((jsonlite::fromJSON(httr::content(request_ticket, 'text')))$after_cursor)){
      after_cursor <- (jsonlite::fromJSON(httr::content(request_ticket, 'text')))$after_cursor
    }
  }
  ticket_content1 <- httr::content(request_ticket, 'text')
  content_json1 <- jsonlite::fromJSON(ticket_content1, flatten = TRUE)
  ticket_df1 <- as.data.frame(content_json1$tickets)


  #Now we have to use the cursor to paginate it through other pages
  request_ticket_cur <- list()

  i <- 1
  stop_paging <- FALSE
  while(stop_paging == FALSE){
    request_ticket_cur[[i]] <- httr::GET(url = paste0(cursor_url, after_cursor), httr::authenticate(user, pwd))
    after_cursor <- (jsonlite::fromJSON(httr::content(request_ticket_cur[[i]], 'text'),flatten = TRUE))$after_cursor
    if(isTRUE((jsonlite::fromJSON(httr::content(request_ticket_cur[[i]], 'text'), flatten = TRUE))$end_of_stream)){
      stop_paging <- TRUE
    }
    i <- i+1
  }


  build_data_frame <- function(c){
    tickets <- as.data.frame((jsonlite::fromJSON(httr::content(request_ticket_cur[[c]], 'text'),flatten = TRUE))$tickets)
  }


  ticket_df2 <- purrr::map_dfr(1:length(request_ticket_cur), build_data_frame)

  #Merging both the dataframes obtained using Cursor and Time based incremental export
  ticket_merged <- plyr::rbind.fill(ticket_df1, ticket_df2)

  #There is a column called "custom fields" inside the tickets data frame  and that is specific to each subdomain(organization).
  #Its a dataframe so we need to extract it and add them as column headers

 pivot_data_frame <- function(c){
   pivot_df <- as.data.frame(ticket_merged$custom_fields[c])%>%
     tidyr::pivot_wider(.data, names_from=.data$id, values_from=.data$value)
  }


 ticket_final <- purrr::map_dfr(1:nrow(ticket_merged), pivot_data_frame)
 ticket_final <- bind_cols(ticket_merged, ticket_final)

 return(ticket_final)

}






