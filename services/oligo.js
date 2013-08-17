function validateConcentrationOfMonovalentIons(concentrationToValidate){
	// all units assumed to be Molar
	
	/* Range of valid concentrations of monovalent ions (+): [5mM, 1500mM].
	 * Default value: 50.0mM.
	 * Applicable to concentration of K+, Na+, Tris+.
	 * Synonymous with [Na+] in our calculations
	 */
	if((concentrationToValidate > 0.005) && (concentrationToValidate < 1.5)){
		return true;
	}
	
	else{
		return false;
	}
	
}

function validateConcentrationOfDivalentIons(concentrationToValidate, oligoConcentration, numberOfBasePairs){
	// all units assumed to be Molar
	
	/* Range of valid concentrations of divalent ions (++): [0.01mM, 600mM].
	 * Cannot be lower than [oligo] * nBP.
	 * Default value: 0.0mM.
	 * Applicable to concentration of K+, Na+, Tris+.
	 * Also used when tMg++ is named.
	 * Synonymous with [Mg++] in our calculations
	 */
	
	if(concentrationToValidate < (oligoConcentration * numberOfBasePairs)){
		return false;
	}
	
	else if((concentrationToValidate > 0.00001) && (concentrationToValidate < 0.6) ){
		return true;
	}
	
	else{
		return false;
	}
	
}

function validateConcentrationOfdNTP(concentrationToValidate, concentrationOfMg){
	// default concentration is 0
	
	if((concentrationToValidate > 0) && (concentrationToValidate < 1) && !(concentrationToValidate > 1.2 * concentrationOfMg) ){
		return true;
	}
	
	else{
		return false;
	}
}

// melting temperature: ANALYZE Function

function meltingTemperatureAnalyze(sequenceToAnalyze, concOligo){
	
	var deltaH = 0;
	var deltaS = 0;
	
	var R = 1.987;
	
	/* how do we calculate:
	 * enthalpy;
	 * entropy;
	 * [oligo]
	 * ? not discussed in documentation...
	*/
	
	for(var i=0; i<sequenceToAnalyze.length-1; i++) {
	var nnValues = findValues(sequenceToAnalyze.substring(i,i+2));
	deltaH+=nnValues[0];
	deltaS+=nnValues[1];
	}

	var startingValues = initValues(sequence.charAt(0));
	var endingValues = initValues(sequence.charAt(sequence.length-1));
	deltaH = deltaH + startingValues[0] + endingValues[0];
	deltaS = deltaS + startingValues[1] + endingValues[1];

	var temperature = ((deltaH*1000) / (deltaS + (R * Math.log(concOligo / 2)) )) - 273.15;

	return temperature;
	
}

function meltingTemperatureSodiumCorrected(concOligo, concentrationOfNa, sequenceToAnalyze){
	var fractionOfGCbp = 0;
	var numberOfBasePairs = 0;
	
	var temperatureNa = 1/(meltingTemperatureAnalyze(sequenceToAnalyze, concOligo)) + ((4.29 * fractionOfGCbp - 3.95) * Math.log(concentrationOfNa) + 0.940 * (Math.log(concentrationOfNa))^2) * Math.pow(10, -5);
	
	return (1/temperatureNa);
}

function meltingTemperatureMagnesiumCorrected(concOligo, concentrationOfMg, concentrationOfNa, sequenceToAnalyze, engageWarpDriveCommander){
	var fractionOfGCbp = 0;
	var numberOfBasePairs = 0;
	
	// for high values of R the values of a, d, and g, "default"
	if(engageWarpDriveCommander){
		var a = 3.92;
		var d = 1.42;
		var g = 8.31;
	}
	
	else{
		var a = 3.92 * (0.843 - 0.352 * Math.sqrt(concentrationOfNa) * Math.log(concentrationOfNa) );
		var d = 1.42 * (1.279 - 4.03 * Math.pow(10, -3) * Math.log(concentrationOfNa) - 8.03 * Math.pow(10, -3) * (Math.log(concentrationOfNa))^2 );
		var g = 8.31 * (0.486 - 0.258 * Math.log(concentrationOfNa) + 5.25 * Math.pow(10, -3) * (Math.log(concentrationOfNa)^3));
	}
	
	var temperatureMg = 1/(meltingTemperatureAnalyze(sequenceToAnalyze, concOligo)) + ( a - 0.911 * Math.log(concentrationOfMg) + fractionOfGCbp * (6.26 + d * Math.log(concentrationOfMg)) + (1/ (2 * (numberOfBasePairs - 1)) ) * (-48.2 + 52.5 * Math.log(concentrationOfMg) + g * (Math.log(concentrationOfMg)^2) ) ) * Math.pow(10, -5);
	
	return (1/temperatureMg);
	
}

function calculateTemperatureWithNaOrMg(concentrationOfMg, concentrationOfNa, sequenceToAnalyze){
	
	if(concentrationOfNa === 0){
		var ratio = 1;
	}
	
	else{
		var ratio = Math.sqrt(concentrationOfMg) / concentrationOfNa;
	}
	
	if(ratio < 0.22){
		return meltingTemperatureSodiumCorrected(concentrationOfNa, sequenceToAnalyze);
	}
	
	else if(ratio < 6.0){
		return meltingTemperatureMagnesiumCorrected(concentrationOfMg, concentrationOfNa, sequenceToAnalyze, false);
	}
	
	else{
		return meltingTemperatureMagnesiumCorrected(concentrationOfMg, concentrationOfNa, sequenceToAnalyze, true);
	}
	
}

function calculateConcentrationOfFreeMg(concentrationOfdNTP, concentrationOfMg){
	// should not be used unless the values for [dNTP] and [Mg++] are supplied:
	// otherwise the program defaults them to 0.0 mM.
	var kA = 3 * Math.pow(10, 4);
	
	var D = Math.pow((kA * concentrationOfdNTP - kA * concentrationOfMg + 1), 2) + 4 * kA * concentrationOfMg;
	
	var concentrationOfFreeMg = ((-(ka * concentrationOfdNTP - kA * concentrationOfMg + 1) + Math.sqrt(D)) / (2 * kA));
	
	return concentrationOfFreeMg;
	
}

function calcuationOfOligoConcentration(concentrationOfStrand1, concentrationOfStrand2){
	/* acceptable range of 10^-4 microM (100pM) to 10^5 microM (100mM).
	 default [oligo] is 0.25 microM, which is typical in biological applications
	 [oligo] is assumed to be significantly larger (>6x) than concentrations of the complimentary target (true in the majority of molecular biology experiments).
	 if it's NOT the case, this function comes into play.
	*/
	
	if(concentrationOfStrand1 >= concentrationOfStrand2){
		var concentrationOfOligo = (concentrationOfStrand1 - concentrationOfStrand2) / 2;
	}
	
	else{
		var concentrationOfOligo = (concentrationOfStrand1 + concentrationOfStrand2) / 4;
	}
	
	return concentrationOfOligo;
}

function calculateMismatchMeltingTemperature(concentrationOfStrand1, concentrationOfStrand2){
	
	var entropy = 0;
	var enthalpy = 0;
	var R = 1.987;
	
	if(concentrationOfStrand1>= concentrationOfStrand2){
		var temperature = enthalpy / (entropy + R * Math.log(concentrationOfStrand1 - (concentrationOfStrand1 / 2) ));
		return temperature;
	}
	
	else{
		throw new Error("error in calculateMismatchMeltingTemperature: concentration of strand 1 should be higher than (or equal to) concentration of strand 2");
	}
	
}

function hybridizationPercentBound(concentrationOfStrand1, concentrationOfStrand2, hybridizationTemperature){
	var theta = 0;
	
	var enthalpy = 0;
	var deltaH = enthalpy;
	var entropy = 0;
	var deltaS = entropy;
	
	var R = 1.987;
	
	var Ka = Math.pow(Math.exp((-(deltaH - T * deltaS))/R*T)
	
	theta = 1 - ( ((Ka(concentrationOfStrand2 - concentrationOfStrand1) - 1)/(2 * Ka * concentrationOfStrand2)) + ((Math.sqrt(Ka*Ka * Math.pow(concentrationOfStrand1 - concentrationOfStrand2, 2) + 2 * Ka * Math.pow(concentrationOfStrand1 - concentrationOfStrand2, 2) + 1)) / (2 * Ka * concentrationOfStrand2)));
	
	return theta;
	
}

/*-----------------------------------
  ------- Finding Temperature -------
  -----------------------------------*/

var findValues = function(neighbor) {
	var nnThermo = [0,0];

	switch(neighbor){
		case "AA":
		case "TT":
			nnThermo = [-7.9, -22.2];
			break;
		case "AT":
			nnThermo = [-7.2, -20.4];
			break;
		case "TA":
			nnThermo = [-7.2, -21.3];
			break;
		case "CA":
		case "TG":
			nnThermo = [-8.5, -22.7];
			break;
		case "GT":
		case "AC":
			nnThermo = [-8.4, -22.4];
			break;
		case "CT":
		case "AG":
			nnThermo = [-7.8, -21];
			break;
		case "GA":
		case "TC":
			nnThermo = [-8.2, -22.2];
			break;
		case "CG":
			nnThermo = [-10.6, -27.2];
			break;
		case "GC":
			nnThermo = [-9.8, -24.4];
			break;
		case "GG":
		case "CC":
			nnThermo = [-8, -19.9];
			break;
		default:
	}
	return nnThermo;
};

var initValues = function(c) {
	var result = [];
	switch(c) {
		case "A":
		case "T":
			result = [2.3, 4.1];
			break;
		case "G":
		case "C":
			result = [0.1, -2.8];
			break;
		default:
	}
	return result;
};