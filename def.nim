# import std/[os, parsecsv, strutils, sequtils, terminal]

from std/os import paramStr
from std/strutils import join
from std/sequtils import concat
from std/parsecsv import CsvParser, open, close, readRow
from std/terminal import styledWrite, styledWriteLine, fgRed, fgCyan, styleBright, resetAttributes

# TODO: rewrite in nim
{.compile: "dld2.c".}
proc dldist2(s, t: cstring, n, m: cint): cint {.importc.}

proc upTo[T](s: seq[T], size: int): seq[T] =
    return if s.len == 0: s else: s[0..min(s.len-1, size)] 

proc main() =
    const bucket_count = 4
    const bucket_max_len = 16
    var buckets: seq[seq[string]] = newSeq[seq[string]](bucket_count)

    let user_word = cstring(paramStr(1))
    var match_count, distance: int

    var csv: CsvParser
    csv.open("OPTED_DICTIONARY.csv")
    while csv.readRow() and (distance==0 or match_count==0):
        distance = dldist2(user_word, cstring(csv.row[0]), cast[cint](user_word.len), cast[cint](csv.row[0].len))
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
