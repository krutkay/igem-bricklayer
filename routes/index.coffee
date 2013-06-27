brickSearch = require '../services/brickSearchService.coffee'

# GET '/'
index = (req, res) ->
    res.render 'index'

exports.initRoutes = (app) ->
    # page GETs
    app.get '/', index

    # API GETs
    app.get '/api/search', (req, res) -> res.send 200, "Stop it!"
    app.get '/api/search/text', brickSearch.search
    app.get '/api/search/thousand', brickSearch.search
    app.get '/api/search/subparts', brickSearch.search
    app.get '/api/search/superparts', brickSearch.search
