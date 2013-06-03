# GET '/'
exports.index = (req, res) ->
    response = 
        title: 'iGEM Bricklayer'
        text: 'Layin ma bricks' 
    res.render 'index', response