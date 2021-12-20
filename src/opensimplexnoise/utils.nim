proc fastFloor*(x: float64): int =
  var xi = x.int
  if x < xi.float64:
    return xi - 1
  else:
    return xi