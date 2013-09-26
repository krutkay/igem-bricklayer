brickUrl = 'api/v1/brick/'

Bricklayer.BrickBin = 
class BrickBin
	constructor: ->
		@bricks = new Array()

	addBrick: (brickName) ->
		console.log "Adding brick"

		for brick in @bricks
			if brick.name == brickName
				return

		console.log "Brick not in bin already"

		$.ajax
			type: "GET"
			url: brickUrl + brickName
			success: (brick) =>
				console.log "Got brick"
				console.log brick

				mybrick = new Bricklayer.BioBrick brick
				console.log mybrick
				console.log @bricks
				@bricks.push mybrick

				console.log "Added"

				this.save()

				error: (error) ->
					console.log error


	removeBrick: (brick) ->
		index = -1

		for selBrick, i in @bricks
			if brick == selBrick.name
				index = i
				break

		if index != -1
			@bricks.splice(index, 1)
			this.save()


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
