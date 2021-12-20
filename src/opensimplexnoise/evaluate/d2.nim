import ../constants
from ../constants/d2 as constants2d import STRETCH_2D, SQUISH_2D
import ../internaltypes
from ../noise import OpenSimplex
import ../utils
from ../lookups/d2 as look2d import lookup2D

proc evaluate*(noise: OpenSimplex, x, y: float64): float64 =
  var stretchOffset = (x + y) * STRETCH_2D
  var xs = x + stretchOffset
  var ys = y + stretchOffset
  var xsb = fastFloor(xs)
  var ysb = fastFloor(ys)
  var xins = xs - xsb.float64
  var yins = ys - ysb.float64
  var inSum = xins + yins
  var squishOffsetIns = inSum * SQUISH_2D
  var dx0 = xins + squishOffsetIns
  var dy0 = yins + squishOffsetIns
  var hash =
    (int)(xins - yins + 1) or
    (int)(inSum) shl 1 or
    (int)(inSum + yins) shl 2 or
    (int)(inSum + xins) shl 4
  var c = lookup2D[hash]
  var value = 0.0
  while not isNil c:
    var dx = dx0 + c.dx
    var dy = dy0 + c.dy
    var attn = 2 - dx * dx - dy * dy
    if attn > 0:
      var px = xsb + c.xsb
      var py = ysb + c.ysb
      var grad = noise.permGrad2[
        noise.perm[px and PMASK] xor (py and PMASK)
      ]
      var valuePart = grad.dx * dx + grad.dy * dy
      attn *= attn
      value += attn * attn * valuePart
    c = c.next
  return value