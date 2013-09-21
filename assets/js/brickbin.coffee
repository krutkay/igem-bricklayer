

class Bricklayer.BrickBin
	constructor: ->
		@bricks = new Array()

	addBrick: (brickName) ->

		for brick in @bricks
			if brick.name == brickName
				return

		$.ajax
			type: "GET"
			url: brickUrl + brickName
			success: do(brick) ->
				(data) ->
					brick = new BioBrick data
					@bricks.push brick

					save

				error: (error) ->
					console.log error

			
			

	removeBrick: (brick) ->
		index = -1

		for(i = 0; i < @bricks.length; i++)
			if @bricks[i].name == brick
				index = i
				break

		if(index != -1)
			@bricks.splice(index, 1)
			save

	save: ->
		console.log @bricks

		partNames = ""

		for brick in @bricks
			partNames += brick.name + "|"

		$.cookie("storedBin", partNames, {expires: 10000})


Bricklayer.CreateBin: ->
	Bricklayer.bin = new Bricklayer.BrickBin();
	loadbin(Bricklayer.bin)


loadbin: (bin) ->
	cookie = $.cookie("storedBin")

	if cookie == undefined
		return

	partNames = cookie.split 

	for part of partNames
		if part == ""
			continue

		bin.addBrick(part)
