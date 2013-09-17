$(function() {
	var container = $("#scroller");

	/**
	 * Calculates the width of the rendered DNA fragment.
	 */
	function computeWidth() {
		var margin = 5;
		var addWidth = 30; // Width of the add button
		var partWidth = 150;
		return parts.length * 150 +
			parts.length * 4 * margin +
			parts.length * addWidth +
			addWidth + margin + margin;
	}

	function createAddElement(idx) {
		return $("<div>").addClass("add").data("index", idx);
	}

	function createAddBrickElement(brick, idx) {
		var apLi = $("<li>");
		var apDiv = $("<div>").addClass(brick.type).text(brick.code + ": " + brick.name);
		apDiv.addClass("addBrickButton");
		apDiv.data("brickIndex", idx);
		return apDiv.appendTo(apLi);
	}

	/**
	 * Returns a jQuery object representing a renderable brick HTML element.
	 */
	function createBrickBinElement(brick) {
		var brickLi = $("<li>");
		var brickDiv = $("<div>").addClass(brick.type).addClass("part");
		var brickTitle = $("<div>").text(brick.code).addClass("title").appendTo(brickDiv);
		var brickContent = $("<div>").text(brick.name).appendTo(brickDiv);
		brickDiv.appendTo(brickLi);
		return brickLi;
	}

	/**
	 * Returns a jQuery object representing a renderable brick HTML element in the part.
	 */
	function createBrickPartElement(brick) {
		var brickDiv = $("<div>").addClass(brick.type).addClass("part");
		var brickTitle = $("<div>").text(brick.code).addClass("title").appendTo(brickDiv);
		var brickContent = $("<div>").text(brick.name).appendTo(brickDiv);
		return brickDiv;
	}

	/**
	 * Renders the brick bin.
	 * @return {[type]} [description]
	 */
	function renderBin() {
		var bin = $("#brickBin");
		var addPartList = $("#addPartList");
		bin.empty();
		addPartList.empty();

		for (var i = 0; i < brickBin.length; i++) {
			var brick = brickBin[i];
			bin.append(createBrickBinElement(brick));

			addPartList.append(createAddBrickElement(brick, i));
		}
	}

	/**
	 * Renders the part
	 */
	function renderPart() {
		container.empty();

		for (var i = 0; i < parts.length; i++) {
			container.append(createAddElement(i));

			var part = createBrickPartElement(parts[i]).addClass("part");
			container.append(part);
		};

		container.append(createAddElement(parts.length));
		container.css("width", computeWidth());
	}

	renderBin();
	renderPart();

	// Bind events
	// Show part info when clicking on a part
	container.on("click", ".part", function(e) {
		var target = $(e.currentTarget);
		$(".part").removeClass("selected");
		target.addClass("selected");

		// Populate part info
		$("#info-title").text("part info: " + "K12345");
		$("#info-pane").text("This is the part info fetched from the registry.");
	});

	// Prompt to add a part when clicking on an add link
	container.on("click", ".add", function(e) {
		window.addIndex = $(e.currentTarget).data("index");
		$.colorbox({ inline: true, href: "#addPartForm" });
	});

	$(".addBrickButton").click(function(e) {
		// Get the brick to add
		var target = $(e.currentTarget);
		var brickToAdd = brickBin[target.data("brickIndex")];

		// Figure out where to add the brick
		var idx = addIndex;
		console.log(addIndex);
		if (parts.length == 0) {
			parts.push(brickToAdd);
		}
		else {
			var parts2 =[];
			for (var i = 0; i < idx; i++)
				parts2.push(parts[i]);
			parts2.push(brickToAdd)
			for (var i = idx; i < parts.length; i++)
				parts2.push(parts[i]);

			parts = [];
			for (var i = 0; i < parts2.length; i++)
				parts.push(parts2[i]);
		}

		renderPart();
		$.colorbox.close();
	});
});