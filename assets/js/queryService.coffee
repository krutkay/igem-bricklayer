# Client-side script for querying data from partsregistry.org. queryService posts to our server,
# where there is another service that will make the actual request to partsregistry.org.
# This is because making a cross-domain request from the client side throws an error.. but seems to work
# from the node server.

igem = window.igem || {}

igem.search = (doSearch) ->
    console.log "Doing search!"
    $.ajax
        type: "GET"
        url: "/api/search"
        data:
            doSearch: doSearch
        success: (data) ->
            console.log "Seach came back! here's the data:"
            console.log data

