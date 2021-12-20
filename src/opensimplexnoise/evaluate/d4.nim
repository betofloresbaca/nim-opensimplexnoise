import ../constants
from ../constants/d4 as constants4d import STRETCH_4D, SQUISH_4D
import ../internaltypes
from ../noise import OpenSimplex
import ../utils
from ../lookups/d4 as look4d import lookup4D

proc evaluate*(noise: OpenSimplex, x, y, z, w: float64): float64 =
  var stretchOffset = (x + y + z + w) * STRETCH_4D
  var xs = x + stretchOffset
  var ys = y + stretchOffset
  var zs = z + stretchOffset
  var ws = w + stretchOffset
  var xsb = fastFloor(xs)
  var ysb = fastFloor(ys)
  var zsb = fastFloor(zs)
  var wsb = fastFloor(ws)
  var xins = xs - xsb.float64
  var yins = ys - ysb.float64
  var zins = zs - zsb.float64
  var wins = ws - wsb.float64
  var inSum = xins + yins + zins + wins
  var squishOffsetIns = inSum * SQUISH_4D
  var dx0 = xins + squishOffsetIns
  var dy0 = yins + squishOffsetIns
  var dz0 = zins + squishOffsetIns
  var dw0 = wins + squishOffsetIns
  var hash =
      int(zins - wins + 1) or
      int(yins - zins + 1) shl 1 or
      int(yins - wins + 1) shl 2 or
      int(xins - yins + 1) shl 3 or
      int(xins - zins + 1) shl 4 or
      int(xins - wins + 1) shl 5 or
      int(inSum) shl 6 or
      int(inSum + wins) shl 8 or
      int(inSum + zins) shl 11 or
      int(inSum + yins) shl 14 or
      int(inSum + xins) shl 17
  var c = lookup4D[hash]
  var value = 0.0
  while not isNil c:
    var dx = dx0 + c.dx
    var dy = dy0 + c.dy
    var dz = dz0 + c.dz
    var dw = dw0 + c.dw
    var attn = 2 - dx * dx - dy * dy - dz * dz - dw * dw
    if attn > 0:
      var px = xsb + c.xsb
      var py = ysb + c.ysb
      var pz = zsb + c.zsb
      var pw = wsb + c.wsb
      var grad = noise.permGrad4[
        noise.perm[
          noise.perm[
            noise.perm[px and PMASK] xor
            (py and PMASK)
          ] xor
          (pz and PMASK)
        ] xor
        (pw and PMASK)
      ]
      var valuePart = grad.dx * dx + grad.dy * dy + grad.dz * dz + grad.dw * dw
      attn *= attn
      value += attn * attn * valuePart
    c = c.next
  return value
