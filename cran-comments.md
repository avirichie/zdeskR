## First package submission

* This is our initial submission. The package facilitates connecting to the Zendesk system API. There is another Zendesk R API package, `zendeskR`, which has several limitations. Before we started development on this package we attempted to contact the maintainer of `zendeskR` and they did not reply.
 + That package only uses "basic" authentication which we believe is less secure and may not be utilized in the future by Zendesk. We use token authentication.
 + That package has a function to retrieve all ticket data, but not to incrementally download recent tickets. An organization with many tickets would not want to have to download all of them every time. Our `get_tickets` function allows the user to only get recently modified tickets. This is a much better match with our intended workflow using the package.

## Test environments

* Developed on and tested with Windows 10, R 4.0.2
* Tested on R-devel with devtools::check_win_devel()
* Testing against multiple Linux platforms with devtools::check_rhub()

## R CMD check results
0 errors √ | 0 warning x | 0 notes √

## No reverse dependencies

