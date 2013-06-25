brickSearch = require '../services/brickSearchService.coffee'

# GET '/'
index = (req, res) ->
    res.render 'index'

exports.initRoutes = (app) ->
    # page GETs
    app.get '/', index

    # API GETs
    app.get '/api/search', brickSearch.search
