#' This function is used to import all the tickets metrics
#'
#' This function takes your emailid,authentication token,
#' sub-domain and parse all the tickets and its corresponding
#' metrics in a list. Since each iteration only returns 100
#' tickets at a time. We have to run the loop till we find
#' "next_page" parameter equal to null.
#'
#' Its not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesnt require you to use any one in particular.
#'
#'
#' @references  \url{https://developer.zendesk.com/rest_api
#' /docs/support/incremental_export#start_time}
#'
#' @param email_id your Zendesk emailid
#' @param token your Zendesk API token
#' @param subdomain your organization's name
#'
#' @return a Data Frame of all ticket metrics for all tickets
#'
#' @import dplyr
#' @importFrom jsonlite "fromJSON"
#' @importFrom httr "content"
#' @importFrom purrr "map_dfr"
#'
#' @export
#'
#' @examples \dontrun{
#' allTicketMetrics <- getAllTicketMetrics(email_id,token,subdomain,
#' start_time=0)
#' }



getAllTicketMetrics <-  function(email_id,token,subdomain){

                user <- paste0(email_id,"/token")
                pwd <- token
                subdomain <- subdomain
                url_metrics <- paste0("https://",subdomain,".zendesk.com/api/v2/ticket_metrics.json?page=")

                #Stop Pagination when the parameter "next_page" is null
                req_metrics <- list()
                stop_paging <- FALSE
                i <- 1
                while(stop_paging == FALSE){
                  req_metrics[[i]] <-  httr::GET(url=paste0(url_metrics,i),httr::authenticate(user,pwd))
                  if(is.null((jsonlite::fromJSON(httr::content(req_metrics[[i]],'text')))$next_page)){
                    stop_paging <- TRUE
                  }
                  i <- i+1
                }

                build_data_frame <- function(c){
                  metrics <- as.data.frame((jsonlite::fromJSON(httr::content(req_metrics[[c]],"text"),flatten = TRUE))$ticket_metrics)
                }

                ticket_metrics_df <- purrr::map_dfr(1:length(req_metrics), build_data_frame)

                return(ticket_metrics_df)

}
