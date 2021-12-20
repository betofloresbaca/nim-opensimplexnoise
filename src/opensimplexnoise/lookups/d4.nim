import ../constants/d4
import ../internaltypes
import ../constructors

var lookup4D*: array[LOOKUP_LEN_4D, Contribution4]

proc buildLookup4d(): void =
  var contributions4D: array[int(p4D.len / 16), Contribution4]
  for i in countup(0, p4D.high, 16):
    var baseSet = base4D[p4D[i]]
    var previous: Contribution4 = nil
    var current: Contribution4 = nil
    for k in countup(0, baseSet.high, 5):
      current = newContribution4(
        float64(baseSet[k]),
        baseSet[k + 1],
        baseSet[k + 2],
        baseSet[k + 3],
        baseSet[k + 4]
      )
      if isNil previous:
        contributions4D[int(i / 16)] = current
      else:
        previous.next = current
      previous = current
    current.next = newContribution4(
      float64(p4D[i + 1]),
      p4D[i + 2],
      p4D[i + 3],
      p4D[i + 4],
      p4D[i + 5]
    )
    current.next.next = newContribution4(
      float64(p4D[i + 6]),
      p4D[i + 7],
      p4D[i + 8],
      p4D[i + 9],
      p4D[i + 10]
    )
    current.next.next.next = newContribution4(
      float64(p4D[i + 11]),
      p4D[i + 12],
      p4D[i + 13],
      p4D[i + 14],
      p4D[i + 15]
    )
  for i in countup(0, lookupPairs4D.high, 2):
    lookup4D[lookupPairs4D[i]] = contributions4D[lookupPairs4D[i + 1]]

buildLookup4d()