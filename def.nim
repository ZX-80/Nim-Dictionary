# import std/[os, parsecsv, strutils, sequtils, terminal]

from std/os import paramStr
from std/strutils import join, toLowerAscii, capitalizeAscii
from std/sequtils import concat, newSeqWith
from std/parsecsv import CsvParser, open, close, readRow
from std/terminal import styledWrite, styledWriteLine, fgRed, fgCyan, styleBright, resetAttributes

proc `[]`(b: seq[seq[int]], r, c: int): int {.inline.} =
    b[r][c]

proc `[]=`(b: var seq[seq[int]], r, c, val: int) {.inline.} =
    b[r][c] = val
  
proc min4(a, b, c, d: int): int {.inline.} =
    min(min(a, b), min(c, d))

proc dldist(stringA, stringB: string): int =
    ## Damerau–Levenshtein distance implementation
    var last_row: array[256, int] # Holds last row each element was encountered
    var matrix = newSeqWith(stringA.len + 2, newSeq[int](stringB.len + 2)) # Matrix: (A.len + 2) x (B.len + 2)
    let max_distance: int = stringA.len + stringB.len; # Used to prevent transpositions for first characters

    matrix[0, 0] = max_distance
    for row in 0 .. stringA.len:
        matrix[row + 1, 1] = row
        matrix[row + 1, 0] = max_distance

    for column in 0 .. stringB.len:
        matrix[1, column + 1] = column
        matrix[0, column + 1] = max_distance

    # Fill in costs
    for row in 1 .. stringA.len:
        var last_match_column = 0                                                # Column of last match on this row
        for column in 1 .. stringB.len:
            var last_matching_row = last_row[ord(stringB[column - 1])]           # Last row with matching character
            var cost = if stringA[row - 1] == stringB[column - 1]: 0 else: 1 # Cost of substitution

            # Compute substring distance
            matrix[row + 1, column + 1] = min4(
                matrix[row, column] + cost,    # Substitution
                matrix[row + 1, column] + 1,   # Addition
                matrix[row, column + 1] + 1,   # Deletion
                matrix[last_matching_row, last_match_column] + (row - last_matching_row - 1) + (column - last_match_column - 1) + 1 # Transposition
            )

            if(cost==0):                       # If there was a match, update last_match_col
                last_match_column = column
        last_row[ord(stringA[row - 1])] = row  # Update last row for current character
    matrix[stringA.len + 1, stringB.len + 1]   # Return last element

proc upTo[T](s: seq[T], size: int): seq[T] =
    ## Get up to size elements from a sequence
    if s.len == 0: s else: s[0..min(s.len-1, size)] 

proc main() =
    const bucket_count = 4
    const bucket_max_len = 16
    var buckets = newSeq[seq[string]](bucket_count)

    let user_word = paramStr(1).toLowerAscii().capitalizeAscii()
    var match_count, distance: int

    var csv: CsvParser
    csv.open("OPTED_DICTIONARY.csv")
    while csv.readRow() and (distance==0 or match_count==0):
        distance = dldist(user_word, csv.row[0])
        if distance == 0:
            if match_count == 0:
                stdout.styledWriteLine(fgRed, styleBright, csv.row[0])
            stdout.styledWrite(fgCyan, styleBright, " ", $(match_count + 1), ". (", csv.row[1], ") ")
            stdout.writeLine(csv.row[2])
            match_count.inc()

        elif distance < bucket_count and buckets[distance].len < bucket_max_len and not buckets[distance].contains(csv.row[0]):
            buckets[distance].add(csv.row[0])
    close(csv)

    if match_count == 0:
        stdout.writeLine("No match found.")
        if concat(buckets).len != 0:
            stdout.writeLine("Did you mean: ", join(concat(buckets).upTo(bucket_max_len), ", "))
            
    stdout.resetAttributes()

when isMainModule:
    main()
