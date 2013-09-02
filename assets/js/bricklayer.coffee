# Declare a Bricklayer object for scripts to attach things to.
root = this
Bricklayer = root.Bricklayer = {}

###
# Construct a view with:
# * `selector`: the selector for the element to insert rendered templates into
# * `template`: the id of the script tag containing the template to manage
###
Bricklayer.View =
class View
    constructor: (@selector, @template) ->

    # `context` is an object that defines the variables in the handlebars template
    render: (context) ->
        $(@selector).html Handlebars.compile($(@template).html())(context)

Bricklayer.HeaderView =
HeaderView = new View '.header', '#templateUserHeader'

Bricklayer.SearchView =
SearchView = new View '.content', '#templateSearchFields'

Bricklayer.ResultsView =
ResultsView = new View '.content', '#templateSearchResults'

HeaderView.render {}
ResultsView.render {}
