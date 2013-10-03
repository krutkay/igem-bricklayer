class RFCAssemblyMethod
    constructor: (@incompatibleSequences) ->

    isCompatible: (sqnc) ->
        for incompatibleSequence in @incompatibleSequences
            if sqnc.search incompatibleSequence != -1
                return false
        return true

RFC10 = new RFCAssemblyMethod ['GAATTC','TCTAGA','ACTAGT','CTGCAG','GCGGCCGC']
RFC12 = new RFCAssemblyMethod ['GAATTC','ACTAGT','GCTAGC','CTGCAG','GCGGCCGC']
RFC23 = new RFCAssemblyMethod ['GAATTC','TCTAGA','ACTAGT','CTGCAG','GCGGCCGC']
RFC25 = new RFCAssemblyMethod ['GAATTC','TCTAGA','ACTAGT','CTGCAG','GCGGCCGC','ACCGGT','GCCGGC']
RFC21 = new RFCAssemblyMethod ['GAATTC', 'AGATCT', 'GGATCC', 'CTCGAG']
RFC21.isCompatible = (sqnc) ->
    for incompatibleSequence in @incompatibleSequences
        if sqnc.search incompatibleSequence != -1
            if incompatibleSequence is 'CTCGAG'
                # This cant be right
                position = sqnc.search 'CTCGAG'
                if position != 0
                    secondPosition = sqnc.substring(position).search 'CTCGAG'
                    if secondPosition != 0
                        return false
            else
                return false
    return true

