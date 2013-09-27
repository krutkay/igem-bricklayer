class RFCAssemblyMethod
    constructor: (@incompatibleSequences) ->

    isCompatible: (sqnc) ->
        for incompatibleSequence in @incompatibleSequences
            if sqnc.search incompatibleSequence != -1
                return false
        return true

RFC10 = new RFCAssemblyMethod ['GAATTC','TCTAGA','ACTAGT','CTGCAG','GCGGCCGC']
RFC12 = new RFCAssemblyMethod ['GAATTC','ACTAGT','GCTAGC','CTGCAG','GCGGCCGC']
RFC21 = new RFCAssemblyMethod ['GAATTC', 'AGATCT', 'GGATCC', 'CTCGAG']
RFC21.isCompatible = (sqnc) ->
    for incompatibleSequence in @incompatibleSequences
        if sqnc.search incompatibleSequence != -1
            return false
        return true



# RFC21 =
class RFC21 extends RFCAssemblyMethod
    isCompatible: (sqnc) ->

#RFC21
var isCompatible = function(sqnc) {
    if(sqnc.search("GAATTC") !== -1) {
        return false;
    } else if(sqnc.search("AGATCT") !== -1) {
        return false;
    } else if(sqnc.search("GGATCC") !== -1) {
        return false;
    } else {
        return true;
    }

    var position = sqnc.search("CTCGAG");
    if(position !== 0){
        var secondPosition = sqnc.substring(position).search("CTCGAG");
        if(secondPosition !== 0){
            console.log("WARNING: the sequence has more than one XhoI site");
        }
    }
};




RFC23 =
RFC25 =
