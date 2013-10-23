# Generates primers to link different parts (biobricks) together.
# It's pretty simple. Lets say we have three parts, and the user sorts them A-B-C. The app needs to make:
# 1) A regular forward primer for A (20+ bp, 55-60 degree Tm)

# 2) Primers to 'link' each part. In this case, A-B and B-C; so the app would take ~20bp from the end of part A (~55 degree Tm) and ~20bp from the beginning of part B (~55 degree Tm), and that would be one primer. In exactly the same way, it would take ~20bp from the end of part B and ~20bp from the beginning of part C.

# 3) Finally, a regular reverse primer for C (complementary, ~20bp, 55-60 degree Tm)

# So for example (using short parts for simplicity) say you're linking parts
# A = ACTTTG
# B = CTAGCC

# Then the primer is just
# Primer = TTGCTA  (Tm for TTG is 55 and for CTA is 55)

# In step (3), is it like this example (using short parts again):

# C = CCTAGAGATC
# Reverse = CTAGAGATCC
# ComplimentOfReverse = GATCTCTAGG
# Primer = GATCT

# Figures out the primer needed to combine two DNA parts
# The primer is a sequence that has the ending of partA and the beginning of partB.
# The first part of the primer (the head) is made from the end of the sequence from partA.
# the last part of the primer (the tail) is made from the beginning of the sequence from partB.
# Each part of the primer, the head and the tail, needs to have a melting temperature in the range of 50-60 degrees celsius.
# The ideal temperature is the midpoint, so we want primers with a melting temperature of 55 degrees celsius.
# The melting temperature of the primer changes as you make the primer longer.
getPrimerBetween = (partA, partB, minTemp=50, maxTemp=60) ->
    # The head of the primer is the ending of partA.
    # Start from the end of the partA and go backwards until the melting temperature is right.
    lengthOfPrimerHead = getLengthOfSubsequenceByTemp partA.split("").reverse().join(""), minTemp, maxTemp
    lengthOfPrimerTail = getLengthOfSubsequenceByTemp partB, minTemp, maxTemp
    console.log "Length of Head: " + lengthOfPrimerHead
    console.log "Length of Tail: " + lengthOfPrimerTail
    primerHead = partA.substring(partA.length - lengthOfPrimerHead)
    primerTail = partB.substring(0, lengthOfPrimerTail)
    console.log "Primer Head: " + primerHead
    console.log "Primer Tail: " + primerTail
    return primerHead + primerTail

# Takes a sequence and returns the length of a subsequence, starting from the beginning,
# whose melting temperature is closest to the midpoint of the minimum and maximum given melting temperatures.
# I think this function needs a better name
getLengthOfSubsequenceByTemp = (sequence, minTemp, maxTemp) ->
    return -1 if minTemp > maxTemp
    idealTemp = (minTemp + maxTemp) / 2
    lastDifference = null

    for _, i in sequence
        subsequence = sequence.substring(0, i+1)
        meltingTemp = getMeltingTemperature subsequence
        differenceFromIdeal = Math.abs(meltingTemp - idealTemp)
        # Realize that the difference will get smaller until you reach the ideal temperature. Then it will get bigger.
        # The previous length is the one with the ideal melting temperature for the given range.
        console.log "Melting temperature of: " + subsequence + " is " + meltingTemp
        if lastDifference and differenceFromIdeal > lastDifference
            console.log "Using length of previous subsequence... Length: #{subsequence.length - 1}"
            return subsequence.length - 1 # because we want the length of the previous subsequence, which is one less.
        else
            lastDifference = differenceFromIdeal
    # return the whole sequence if we run out of subsequences.
    # This will probably cause a bug. Should return -1 or an error like "The sequence is too short for PCR!"
    return sequence.length

# Takes a DNA sequence and counts the number of each nucleotide. Returns an hash of nucleotide: count
getNucleotideCounts = (sequence) ->
    counts =
        'A': 0
        'T': 0
        'C': 0
        'G': 0
    sequence = sequence.toUpperCase()
    for nucleotide, count in sequence
        counts[nucleotide]++
    counts

# Returns the melting temperature (in Celsius) of a DNA sequence.
# This formula sometimes spits out negative if the sequence is too short. I dunno
getMeltingTemperature = (sequence) ->
    nucleotides = getNucleotideCounts sequence
    return (64.9 + (41 * (nucleotides.G + nucleotides.C - 16.4) / sequence.length))

partA = 'ACTATCGTAGCTATATAGCTATATACGATCGATGCTAGCTAGCTAGCTAGCTAGCTATCGCTAGCTAGCATGCTAGCTAGCTAGCTATATATAGTTCGATGACTTTC'
partB = 'CTAGCTACTAGCTAGCTAGTCGGCGCGTAGCTAGCTAGCTAGCTATATGCTACGAGCGATCGATCGTAGCTAGCTACGTAGCTGACTGATCGTAGCTAGCTAGCAT'

console.log "Part A: #{partA}"
console.log "Part B: #{partB}"
console.log "Primer to link A and B: #{getPrimerBetween(partA, partB)}"
