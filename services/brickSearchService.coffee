# Retrieve data from partsregistry.org
request = require 'request'

search = (doSearch) ->
    url = "http://igempartview.appspot.com/query/json?param=categories&value=/cds/membrane"
    request url, (error, response, body) ->
        data = JSON.parse body
        console.log data

# Builds a queryString from a params object, then returns url + queryString
# TODO: Adds an unnecessary "&" to the end of the url. Get rid of it.
attachQueryString = (url, params) ->
    queryString = "?"
    for paramKey, value of params
        queryString += paramKey + "=" + value + "&"
    url + queryString

# Exports
exports.search = search
