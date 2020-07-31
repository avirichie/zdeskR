#' Create a Zendesk API Session
#'
#' This function takes your userid and authentication token
#' and combines them into a single string and pass it as
#' part of the API call. The combination of the email
#' address and the token should be a Base-64 encoded string.
#'
#' Its not a good practice to write down these authentication
#' parameters in your code. There are various methods and
#' packages available that are more secure; this package
#' doesnt require you to use any one in particular.
#'
#'
#' @references  \url{https://developer
#' .zendesk.com/rest_api/docs/support/introduction
#' #security-and-authentication}
#'
#' @param email_id your Zendesk emailid
#' @param token your Zendesk password
#' @param subdomain your organization's name
#' @param url your url for authentication
#'
#'
#' @importFrom jsonlite base64_enc
#'
#' @export
#'
#' @examples \dontrun{
#' email_id <- "your organization's registered email id"
#' token <- "9ffdfsqwrereflj45gklfkg"
#' subdomain <- "your_site"
#' url <- "http://www.subdomain.zendesk.com/(apistring)"
#' }
#'
#'

zendesk_auth <- function(email_id,token,subdomain,url){
    if (is.null(email_id) | is.null(token) | is.null(url)){
    message(paste0("The emailID, token, url for zendesk authentication must be provided by the organization "))
    stop()
  } else {
    # If both email and token are not null
    user <- paste0(email_id, "/token")
    pwd <- token
    subdomain <- subdomain
    url <- url
  }
}












