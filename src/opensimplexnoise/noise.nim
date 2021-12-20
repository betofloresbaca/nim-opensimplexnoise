import std/monotimes
import ./constants
import ./constants/d2
import ./constants/d3
import ./constants/d4
import ./internaltypes

type
  OpenSimplex* = ref object
    perm*: array[PSIZE, int16]
    permGrad2*: array[PSIZE, Grad2]
    permGrad3*: array[PSIZE, Grad3]
    permGrad4*: array[PSIZE, Grad4]

proc newOpenSimplex*(seed: int64): OpenSimplex =
  var vSeed: int64 = seed
  var noise = OpenSimplex()
  var source: array[PSIZE, int16]
  for i in 0..<PSIZE:
    source[i] = i.int16
  {.push overflowChecks: off.}
  for i in countdown(PSIZE-1, 0):
    vSeed = vSeed * 6364136223846793005 + 1442695040888963407
    var r = (int)((vSeed + 31) mod (i + 1))
    if r < 0:
      r += (i + 1)
    noise.perm[i] = source[r]
    noise.permGrad2[i] = gradients2D[noise.perm[i]]
    noise.permGrad3[i] = gradients3D[noise.perm[i]]
    noise.permGrad4[i] = gradients4D[noise.perm[i]]
    source[r] = source[i]
  {.pop.}
  return noise

proc newOpenSimplex*(): OpenSimplex =
  return newOpenSimplex(getMonoTime().ticks)