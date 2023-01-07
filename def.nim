# import std/[os, parsecsv, strutils, sequtils, terminal]

from std/os import paramStr
from std/strutils import join, toLowerAscii, capitalizeAscii
from std/sequtils import concat, newSeqWith
from std/parsecsv import CsvParser, open, close, readRow
from std/terminal import styledWrite, styledWriteLine, fgRed, fgCyan, styleBright, resetAttributes

proc min4(a, b, c, d: int): int {.inline.} =
    min(min(a, b), min(c, d))

proc dldist(s, t: string): int =
    var dd = newSeqWith(s.len+2, newSeq[int](t.len+2))
    var cost, i1,j1, db: int
    var infinity: int = s.len + t.len;
    var da: array[256, int]

    dd[0][0] = infinity
    for i in 0 .. s.len:
        dd[i+1][1] = i
        dd[i+1][0] = infinity

    for j in 0 .. t.len:
        dd[1][j+1] = j
        dd[0][j+1] = infinity

    for i in 1 .. s.len:
        db = 0
        for j in 1 .. t.len:
            i1 = da[ord(t[j-1])]
            j1 = db
            cost = if s[i-1]==t[j-1]: 0 else: 1
            if(cost==0):
                db = j
            dd[i+1][j+1] = min4(dd[i][j]+cost, dd[i+1][j] + 1, dd[i][j+1]+1, dd[i1][j1] + (i-i1-1) + 1 + (j-j1-1))
        da[ord(s[i-1])] = i
    cost = dd[s.len+1, t.len+1]
    return cost

proc upTo[T](s: seq[T], size: int): seq[T] =
    return if s.len == 0: s else: s[0..min(s.len-1, size)] 

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
