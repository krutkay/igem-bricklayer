# Declare a Bricklayer object for scripts to attach things to.
root = this
Bricklayer = root.Bricklayer = {}

headerClass = '.header'
contentClass = '.content'

headerTemplateId = '#templateUserHeader'

homeTemplateId = '#templateSearchFields'
resultsTemplateId = '#templateSearchResults'

$(headerClass).html $(headerTemplateId).html()

Bricklayer.toggleHome = ->
    Handlebars.compile($(homeTemplateId).html())
    $(contentClass).html $(homeTemplateId).html()

Bricklayer.toggleSearch = ->
    $(contentClass).html $(resultsTemplateId).html()

Bricklayer.toggleSearch()

class Bricklayer.View
    constructor: (@id, @template) ->
