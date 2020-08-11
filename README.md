# zdeskR
Connect to your Zendesk data with R!

## Purpose
zdeskR facilitates making a connection to the Zendesk API and executing various queries. You can use it to get tickets and ticket metrics in the form of data frames.

## Installation
The development version can be installed from GitHub: `devtools::install_github("chrisumphlett/zdeskR")`.

## Usage
The API uses Zendesk email id and the token associated with it to make queries. Once you have this parameters then we create a username and password:

> username <- paste0(email_id, "/token")

> password <- token

This username and password will be used in every API call along with a function specific URL to fetch the data.

The current version has several functions to make requests to the API

* `get_tickets()`. Returns all the tickets of your Zendesk organization after a given start time.
* `get_all_tickets_metrics()`. Returns all the ticket metrics in your Zendesk organization. Zendesk does not have an incremental version of this API endpoint; you cannot get the data starting after a certain date as of August 2020.
