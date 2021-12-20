import ../constants/d2
import ../internaltypes
import ../constructors

var lookup2D*:array[LOOKUP_LEN_2D, Contribution2]

proc buildLookup2d(): void =
  var contributions2D: array[(p2D.len / 4).int, Contribution2]
  for i in countup(0, p2D.high, 4):
    var baseSet = base2D[p2D[i]]
    var previous: Contribution2 = nil
    var current: Contribution2 = nil
    for k in countup(0, baseSet.high, 3):
      current = newContribution2(float64(baseSet[k]), baseSet[k + 1], baseSet[k + 2])
      if isNil previous:
        contributions2D[int(i / 4)] = current
      else:
        previous.next = current
      previous = current
    current.next = newContribution2(float64(p2D[i + 1]), p2D[i + 2], p2D[i + 3])
  for i in countup(0, lookupPairs2D.high, 2):
    lookup2D[lookupPairs2D[i]] = contributions2D[lookupPairs2D[i + 1]]

buildLookup2d()