# Declare an igem object for scripts to attach things to.
window.igem = {} || igem

# a map of form ids to search URLS
searches =
    '#text-search-form': '/api/search/text'
    '#thousand-search-form': '/api/search/thousand'
    '#sub-search-form': '/api/search/subparts'
    '#super-search-form': '/api/search/superparts'

# Attach event handlers
for searchId, url of searches
    # this is a closure around url.
    $(searchId).submit do (searchId, url) ->
        (e) ->
            e.preventDefault()
            igem.search url, $(searchId + " :text").val()
