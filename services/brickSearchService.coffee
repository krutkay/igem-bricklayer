# Retrieve data from partsregistry.org. For how this works see partsRegistrySearchFormat.md
request = require 'request'

exports.routes = routes =
    text: "/api/search/text"
    thousand: "/api/search/thousand"
    subparts: "/api/search/subparts"
    superparts: "/api/search/superparts"

searchConfig =
    baseUrl: "http://parts.igem.org/cgi/partsdb/search.cgi?"
    text:
        nameTextInput: "searchfor1"
        nameSubmitButton: "searchfor"
    thousand:
        nameTextInput: "fist_part"
        nameSubmitButton: "search_from_to"
    subparts:
        nameTextInput: "part_list"
        nameSubmitButton: "search_subparts"
    superparts:
        nameTextInput: "super_part_list"
        nameSubmitButton: "search_superparts"

# Construct the url needed to submit a search on partsregistry.org
# http://parts.igem.org/cgi/partsdb/search.cgi?[nameTextInput]=[STRING];[nameSubmitButton]=Search`
# * `textInput`: The name of the text input. Should come from searchConfig
# * `submitButton`: The name of the submit button. Should come from searchConfig
# * `searchString`: The string to search for.
getQueryUrl = (textInput, submitButton, searchString) ->
    searchConfig.baseUrl + textInput + "=" + searchString + ";" + submitButton + "=Search"

search = (req, res) ->
    path = req.route.path
    searchTerms = req.query.searchTerms
    # callback
    done = (error, response, body) ->
        if error then res.send 404, error
        else res.send 200, body

    if path is routes.text
        searchText searchTerms, done
    else if path is routes.thousand
        searchThousand searchTerms, done
    else if path is routes.subparts
        searchSubparts searchTerms, done
    else if path is routes.superparts
        searchSuperparts searchTerms, done

searchText = (searchTerms, done) ->
    url = getQueryUrl(
        searchConfig.text.nameTextInput,
        searchConfig.text.nameSubmitButton,
        searchTerms
        )
    console.log url
    request url, done

searchThousand = (searchTerms, done) ->
    url = getQueryUrl(
        searchConfig.thousand.nameTextInput,
        searchConfig.thousand.nameSubmitButton,
        searchTerms
        )
    console.log url
    request url, done

searchSubparts = (searchTerms, done) ->
    url = getQueryUrl(
        searchConfig.subparts.nameTextInput,
        searchConfig.subparts.nameSubmitButton,
        searchTerms
        )
    console.log url
    request url, done

searchSuperparts = (searchTerms, done) ->
    url = getQueryUrl(
        searchConfig.superparts.nameTextInput,
        searchConfig.superparts.nameSubmitButton,
        searchTerms
        )
    console.log url
    request url, done

# search = (req, res) ->
#     doSearch = req.query.doSearch
#     url = "http://igempartview.appspot.com/query/json?param=categories&value=/cds/membrane"
#     request url, (error, response, body) ->
#         data = JSON.parse body
#         res.send 200, data

# Builds a queryString from a params object, then returns url + queryString
# TODO: Adds an unnecessary "&" to the end of the url. Get rid of it.
attachQueryString = (url, params) ->
    queryString = "?"
    for paramKey, value of params
        queryString += paramKey + "=" + value + "&"
    url + queryString

# Exports
exports.search = search
exports.searchText = searchText
exports.searchThousand = searchThousand
exports.searchSubparts = searchSubparts
exports.searchSuperparts = searchSuperparts
