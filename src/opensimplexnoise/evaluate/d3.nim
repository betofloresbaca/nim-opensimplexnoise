import ../constants
from ../constants/d3 as constants3d import STRETCH_3D, SQUISH_3D
import ../internaltypes
from ../noise import OpenSimplex
import ../utils
from ../lookups/d3 as look3d import lookup3D

proc evaluate3Base(noise: OpenSimplex, xs, ys, zs: float64): float64 =
  var xsb = fastFloor(xs)
  var ysb = fastFloor(ys)
  var zsb = fastFloor(zs)
  var xins = xs - xsb.float64
  var yins = ys - ysb.float64
  var zins = zs - zsb.float64
  var inSum = xins + yins + zins
  var squishOffsetIns = inSum * SQUISH_3D
  var dx0 = xins + squishOffsetIns
  var dy0 = yins + squishOffsetIns
  var dz0 = zins + squishOffsetIns
  var hash =
      int(yins - zins + 1) or
      int(xins - yins + 1) shl 1 or
      int(xins - zins + 1) shl 2 or
      int(inSum) shl 3 or
      int(inSum + zins) shl 5 or
      int(inSum + yins) shl 7 or
      int(inSum + xins) shl 9
  var c = lookup3D[hash]
  var value = 0.0
  while not isNil c:
    var dx = dx0 + c.dx
    var dy = dy0 + c.dy
    var dz = dz0 + c.dz
    var attn = 2 - dx * dx - dy * dy - dz * dz
    if attn > 0:
        var px = xsb + c.xsb
        var py = ysb + c.ysb
        var pz = zsb + c.zsb
        var grad = noise.permGrad3[
          noise.perm[
            noise.perm[px and PMASK] xor
            (py and PMASK)
          ] xor
          (pz and PMASK)
        ]
        var valuePart = grad.dx * dx + grad.dy * dy + grad.dz * dz
        attn *= attn
        value += attn * attn * valuePart
    c = c.next
  return value

proc evaluate*(noise: OpenSimplex, x, y, z: float64): float64 =
  var stretchOffset = (x + y + z) * STRETCH_3D
  var xs = x + stretchOffset
  var ys = y + stretchOffset
  var zs = z + stretchOffset
  return noise.evaluate3Base(xs, ys, zs)

proc evaluate3XYBeforeZ*(noise: OpenSimplex, x, y, z: float64): float64 =
  var xy = x + y
  var s2 = xy * 0.211324865405187
  var zz = z * 0.288675134594813
  var xs = s2 - x + zz
  var ys = s2 - y + zz
  var zs = xy * 0.577350269189626 + zz
  return noise.evaluate3Base(xs, ys, zs)

proc evaluate3XZBeforeY*(noise: OpenSimplex, x, y, z: float64): float64 =
  var xz = x + z
  var s2 = xz * 0.211324865405187
  var yy = y * 0.288675134594813
  var xs = s2 - x + yy
  var zs = s2 - z + yy
  var ys = xz * 0.577350269189626 + yy
  return noise.evaluate3Base(xs, ys, zs)