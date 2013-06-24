# Client-side script for querying data from partsregistry.org. queryService posts to our server,
# where there is another service that will make the actual request to partsregistry.org.
# This is because making a cross-domain request from the client side throws an error.. but seems to work
# from the node server.

search = (doSearch) ->
    $.ajax
        type: "POST"
        url: "/api/search"
        data:
            doSearch: doSearch

window.search = search
