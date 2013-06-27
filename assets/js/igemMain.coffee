# Declare an igem object for scripts to attach things to.
window.igem = {} || igem

# a map of form ids to search URLS
searches =
    '#text-search-form': '/api/search/text'
    '#thousand-search-form': '/api/search/thousand'
    '#sub-search-form': '/api/search/subparts'
    '#super-search-form': '/api/search/superparts'

eventClosure = (url) ->
    (e) ->
        e.preventDefault()
        console.log url

# Attach event handlers
for searchId, url of searches
    console.log url
    $(searchId).submit eventClosure url
