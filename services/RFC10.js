/*-----------------------------------------------
  ------- Sequences should not have these -------
  -----------------------------------------------*/

var isCompatible = function(sqnc) {
	if(sqnc.search("GAATTC") !== -1) {
		return false;
	} else if(sqnc.search("TCTAGA") !== -1) {
		return false;
	} else if(sqnc.search("ACTAGT") !== -1) {
		return false;
	} else if(sqnc.search("CTGCAG") !== -1) {
		return false;
	} else if(sqnc.search("GCGGCCGC") !== -1) {
		return false;
	} else {
		return true;
	}
};

var warningSites = function(sqnc) {
	var warning = [];
	if(sqnc.search("CAGCTG") !== -1) {
		warning.push("CAGCTG");
	} else if(sqnc.search("CTCGAG") !== -1) {
		warning.push("CTCGAG");
	} else if(sqnc.search("CCTAGG") !== -1) {
		warning.push("CCTAGG");
	} else if(sqnc.search("GCTAGC") !== -1) {
		warning.push("GCTAGC");
	} else if(sqnc.search("GCTCTTC") !== -1) {
		warning.push("GCTCTTC");
	} else if(sqnc.search("GAAGAGC") !== -1) {
		warning.push("GAAGAGC");
	}

	//Alerting the user
	if(warning.length !== 0) {
		var mess = "WARNING: the sequence has the following restricted sites...\n" + warning.join("\n");
		alert(mess);
	}
};

/*------------------------------------
  ------- Counting Nucleotides -------
  ------------------------------------*/
var countNts = function(sqnc) {
	var nts = [0,0,0,0]; // ATGC in corresponding index
	for(var i=0; i<sqnc.length; i++){
		var c = sqnc.charAt(i);
		switch(c) {
			case "A":
				nts[0]++;
				break;
			case "T":
				nts[1]++;
				break;
			case "G":
				nts[2]++;
				break;
			case "C":
				nts[3]++;
				break;
			default:
				/*Do nothing*/
		}
	}
	return nts;
};

/*------------------------------------------------
  ------- Calculating Melting Temperatures -------
  ------------------------------------------------*/
var calcMeltTemp = function(sqnc) {
	var nts = countNts(sqnc);
	return (64.9 + (41 * (nts[2] + nts[3] - 16.4) / sqnc.length));
};

/*-------------------------------------------
  ------- Complimentary sequence code -------
  -------------------------------------------*/
var reverseNts = function(sqnc) {
	sqnc = sqnc.replace("A","T");
	sqnc = sqnc.replace("T","A");
	sqnc = sqnc.replace("G","C");
	sqnc = sqnc.replace("C","G");
	sqnc = sqnc.split("").reverse().join("");
	return sqnc;
};

/*-----------------------------
  ------- Fp's and Rp's -------
  -----------------------------*/

var generatePrimers = function(sqnc) {
	var fp = "GAATTCGCGGCCGCTTCTAGAG";
	var rp = "CTGCAGCGGCCGCTACTAGTA";
	var coding = (sqnc.search("ATG") === 0);
	var answer = prompt("Is this part coding or non-coding? (y/n)").toLowerCase();
	switch(answer) {
		case "y":
			if(!coding) {
				alert("ATG start codon was not found. Fp for non-coding will be used.");
			} else {
				fp = "GAATTCGCGGCCGCTTCTAG";
			}
		case "n":
			if(coding) {
				alert("ATG start codon was found. Fp for coding will be used.");
				fp = "GAATTCGCGGCCGCTTCTAG";
			}
	}

	var temp = [fp + sqnc, rp + reverseNts(sqnc)];

	//Calculating for Fp
	fp = temp[0].substring(0,18);
	for(var i=18; i<temp[0].length; i++){
		var meltTemp = calcMeltTemp(fp)
		if(55 <= meltTemp && meltTemp <= 60){
			break;
		} else {
			fp = fp.concat(temp[0].charAt(i));
		}
	}

	//Calculating for Rp
	rp = temp[1].substring(0,18);
	for(var i=18; i<temp[1].length; i++){
		var meltTemp = calcMeltTemp(rp)
		if(55 <= meltTemp && meltTemp <= 60){
			break;
		} else {
			rp = rp.concat(temp[1].charAt(i));
		}
	}

	return [fp,rp];
};

/*--------------------------
  ------- Stop codon -------
  --------------------------*/

var stopCodon = function(sqnc) {
	var endOfSqnc = sqnc.substring(sqnc.length-7,sqnc.length);
	if(endOfSqnc !== "TAATAA") {
		alert("It is recommended that each coding region ends with the stop codon TAATAA");
	}
};

/*------------------
  ------- UI -------
  ------------------*/
var sequence = prompt("Enter sequence:").toUpperCase();
if(isCompatible(sequence)) {
	warningSites(sequence);
	var primers = generatePrimers(sequence);
	stopCodon(sequence);
	window.confirm("Forward primer: " + primers[0] + "\nReverse primer: " + primers[1]);
	console.log("Forward primer: " + primers[0]);
	console.log("Reverse primer: " + primers[1]);
} else {
	alert("THIS SEQUENCE IS NOT COMPATIBLE WITH RFC10!")
};