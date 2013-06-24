brickSearch = require '../services/brickSearchService.coffee'

# GET '/'
index = (req, res) ->
    response =
        title: 'iGEM Bricklayer'
        text: 'Layin ma bricks'
    res.render 'index', response

exports.initRoutes = (app) ->
    # GETs
    app.get '/', index
    app.get '/api/search', brickSearch.search
