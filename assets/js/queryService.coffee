# Client-side script for querying data from partsregistry.org. queryService posts to our server,
# where there is another service that will make the actual request to partsregistry.org.
# This is because making a cross-domain request from the client side throws an error.. but seems to work
# from the node server.

igem = window.igem || {}

brickUrl = 'api/v1/brick/'

igem.search = (url, searchTerms) ->
    console.log "Doing search!"
    $.ajax
        type: "GET"
        url: url
        data:
            searchTerms: searchTerms
        success: (data) ->
            # The data here is an array of biobrick names
            console.log "Seach came back! here's the data:"
            displayBricks data
        error: (error) ->
            console.log error

# Step 1: Start rendering of a table
# Step 2: Fetch full information for each brick, one by one
displayBricks = (bricks) ->
    for brick in bricks
        $.ajax
            type: "GET"
            url: brickUrl + brick
            success: do (brick) ->
                (data) ->
                    console.log "Data for brick #{brick}"
                    console.log data
            error: (error) ->
                console.log error
