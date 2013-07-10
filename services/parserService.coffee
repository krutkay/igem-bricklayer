# Parse HTML pages
cheerio = require 'cheerio'

exports.parseListFromPage =
parseListFromPage = (html) ->
    $ = cheerio.load html
    console.log html
    console.log $('a')
    []

