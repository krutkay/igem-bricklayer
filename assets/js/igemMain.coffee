# Declare an igem object for scripts to attach things to.
window.igem = {} || igem

# Some ids
searchId = "#search"

# Attach event handlers
$(searchId).click (e) ->
    e.preventDefault()
    igem.search true

