# Client-side script for querying data from partsregistry.org. queryService posts to our server,
# where there is another service that will make the actual request to partsregistry.org.
# This is because making a cross-domain request from the client side throws an error.. but seems to work
# from the node server.

brickUrl = 'api/v1/brick/'

class BioBrick
    constructor: (xml) ->
        @xml = $($.parseXML xml)
        @name          = @getContent "part_name"
        @description   = @getContent "part_short_desc"
        @type          = @getContent "part_type"
        @releaseStatus = @getContent "release_status"
        @partResults   = @getContent "part_results"
        @partUrl       = @getContent "part_url"
        @dateEntered   = @getContent "part_entered"
        @author        = @getContent "part_author"
        @sequence      = @getContent "seq_data"

    getContent: (tagName) ->
        @xml.find(tagName).contents()[0]?.data

    getContents: (tagName) ->
        content.data for content in @xml.find(tagName).contents()

Bricklayer.search = (url, searchTerms) ->
    console.log "Doing search!"
    $.ajax
        type: "GET"
        url: url
        data:
            searchTerms: searchTerms
        success: (data) ->
            # The data here is an array of biobrick names
            displayBricks data
        error: (error) ->
            console.log error

# Step 1: Start rendering of a table
# Step 2: Fetch full information for each brick, one by one
displayBricks = (brickList) ->
    bricks = []
    for brick in brickList
        $.ajax
            type: "GET"
            url: brickUrl + brick
            success: do (brick) ->
                (data) ->
                    # console.log "Data recieved for brick #{brick}"
                    bricks.push new BioBrick data
                    console.log bricks
            error: (error) ->
                console.log error
