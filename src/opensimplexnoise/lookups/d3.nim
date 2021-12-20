import ../constants/d3
import ../internaltypes
import ../constructors

var lookup3D*: array[LOOKUP_LEN_3D, Contribution3]

proc buildLookup3d*(): void =
  var contributions3D: array[int(p3D.len / 9), Contribution3]
  for i in countup(0, p3D.high, 9):
    var baseSet = base3D[p3D[i]]
    var previous: Contribution3 = nil
    var current: Contribution3 = nil
    for k in countup(0, baseSet.high, 4):
      current = newContribution3(float64(baseSet[k]), baseSet[k + 1], baseSet[k + 2], baseSet[k + 3])
      if isNil previous:
        contributions3D[int(i / 9)] = current
      else:
        previous.next = current
      previous = current
    current.next = newContribution3(float64(p3D[i + 1]), p3D[i + 2], p3D[i + 3], p3D[i + 4])
    current.next.next = newContribution3(float64(p3D[i + 5]), p3D[i + 6], p3D[i + 7], p3D[i + 8])
  for i in countup(0, lookupPairs3D.high, 2):
    lookup3D[lookupPairs3D[i]] = contributions3D[lookupPairs3D[i + 1]]

buildLookup3d()
