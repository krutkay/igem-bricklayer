brickUrl = 'api/v1/brick/'

Bricklayer.BrickBin =
class BrickBin
    constructor: ->
        @bricks = new Array()

    addBrick: (brickName, link) ->
        console.log "Adding brick"

        console.log "Brickname: [" + brickName + "]"
        console.log link

        if this.indexOf(brickName) != -1
            if(link != undefined)
                $('#toggle-bin-' + brickName).text("remove")
                $('#toggle-bin-' + brickName).on('click', ( ->
                    Bricklayer.bin.removeBrick(brickName, link)
                ))
            return

        $.ajax
            type: "GET"
            url: brickUrl + brickName
            success: (brick) =>

                mybrick = new Bricklayer.BioBrick brick
                mybrick.inBin = true
                console.log mybrick
                console.log @bricks
                @bricks.push mybrick

                console.log "Added"

                this.save()

                if(link != undefined)
                    $('#toggle-bin-' + brickName).text("remove")
                    $('#toggle-bin-' + brickName).on('click', ( ->
                        Bricklayer.bin.removeBrick(brickName, link)
                    ))

                error: (error) ->
                    console.log error


    # addBrick: (brickName) =>
    #   addBrick(brickName, null)


    removeBrick: (brickName, link) =>
        index = this.indexOf(brickName)

        if index != -1
            @bricks.splice(index, 1)
            this.save()

        if(link != undefined)
            $('#toggle-bin-' + brickName).text("add")
            $('#toggle-bin-' + brickName).on('click', ( ->
                    Bricklayer.bin.addBrick(brickName, link)
                ))

    indexOf: (brick) ->
        index = -1

        for selBrick, i in @bricks
            if brick == selBrick.name
                index = i
                break

        return index


    save: ->
        console.log @bricks

        partNames = ""

        for brick in @bricks
            partNames += brick.name + "|"

        $.cookie("storedBin", partNames, {expires: 10000})


    load: ->
        cookie = $.cookie("storedBin")

        if cookie == undefined
            return

        partNames = cookie.split "|"

        for part in partNames
            console.log "Part is [" + part + "]"
            if part == ""
                continue

            this.addBrick(part)


# Run at startup
Bricklayer.bin = new Bricklayer.BrickBin();
Bricklayer.bin.load()

# Handlebars.registerHelper('if', ((brick, options) ->
#   # console.log brick
#   # console.log Bricklayer.bin.indexOf(brick)
#   # console.log options
#   if(Bricklayer.bin.indexOf(brick) != -1)
#       options.fn(this)
#   else
#       options.inverse(this)
# ))

# Handlebars.registerHelper 'checkBrick', (name) ->
#      if Bricklayer.bin.indexOf(brickName) == -1 then return false
#      else
#          return true
