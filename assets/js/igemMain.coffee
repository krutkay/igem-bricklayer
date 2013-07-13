# Declare an igem object for scripts to attach things to.
window.igem = {} || igem

# a map of form ids to search URLS
searches =
    '#form-text-search': '/api/search/text'
    '#form-thousand-search': '/api/search/thousand'
    '#form-subpart-search': '/api/search/subparts'
    '#form-superpart-search': '/api/search/superparts'

# Attach event handlers
for searchId, url of searches
    # this is a closure around url.
    $(searchId).submit do (searchId, url) ->
        (e) ->
            e.preventDefault()
            igem.search url, $(searchId + " :text").val()
