# Parse HTML pages
cheerio = require 'cheerio'

exports.parseListFromPage =
parseListFromPage = (html) ->
    $ = cheerio.load html
    parts = []
    $('A[href^="view.cgi"]').each (index, element) ->
        parts.push $(element).text()
    parts
