import std/sequtils
import std/sugar
import ../constants
import ../internaltypes

const STRETCH_3D* = -1.0 / 6.0            # (1/sqrt(3+1)-1)/3
const SQUISH_3D* = 1.0 / 3.0              # (sqrt(3+1)-1)/3
const LOOKUP_LEN_3D* = 2048
const N3 = 26.92263139946168

const grad3: seq[Grad3]  = [
  (-1.4082482904633333,  -1.4082482904633333,  -2.6329931618533333),
  (-0.07491495712999985, -0.07491495712999985, -3.29965982852),
  ( 0.24732126143473554, -1.6667938651159684,  -2.838945207362466),
  (-1.6667938651159684,   0.24732126143473554, -2.838945207362466),
  (-1.4082482904633333,  -2.6329931618533333,  -1.4082482904633333),
  (-0.07491495712999985, -3.29965982852,       -0.07491495712999985),
  (-1.6667938651159684,  -2.838945207362466,    0.24732126143473554),
  ( 0.24732126143473554, -2.838945207362466,   -1.6667938651159684),
  ( 1.5580782047233335,   0.33333333333333337, -2.8914115380566665),
  ( 2.8914115380566665,  -0.33333333333333337, -1.5580782047233335),
  ( 1.8101897177633992,  -1.2760767510338025,  -2.4482280932803),
  ( 2.4482280932803,      1.2760767510338025,  -1.8101897177633992),
  ( 1.5580782047233335,  -2.8914115380566665,   0.33333333333333337),
  ( 2.8914115380566665,  -1.5580782047233335,  -0.33333333333333337),
  ( 2.4482280932803,     -1.8101897177633992,   1.2760767510338025),
  ( 1.8101897177633992,  -2.4482280932803,     -1.2760767510338025),
  (-2.6329931618533333,  -1.4082482904633333,  -1.4082482904633333),
  (-3.29965982852,       -0.07491495712999985, -0.07491495712999985),
  (-2.838945207362466,    0.24732126143473554, -1.6667938651159684),
  (-2.838945207362466,   -1.6667938651159684,   0.24732126143473554),
  ( 0.33333333333333337,  1.5580782047233335,  -2.8914115380566665),
  (-0.33333333333333337,  2.8914115380566665,  -1.5580782047233335),
  ( 1.2760767510338025,   2.4482280932803,     -1.8101897177633992),
  (-1.2760767510338025,   1.8101897177633992,  -2.4482280932803),
  ( 0.33333333333333337, -2.8914115380566665,   1.5580782047233335),
  (-0.33333333333333337, -1.5580782047233335,   2.8914115380566665),
  (-1.2760767510338025,  -2.4482280932803,      1.8101897177633992),
  ( 1.2760767510338025,  -1.8101897177633992,   2.4482280932803),
  ( 3.29965982852,        0.07491495712999985,  0.07491495712999985),
  ( 2.6329931618533333,   1.4082482904633333,   1.4082482904633333),
  ( 2.838945207362466,   -0.24732126143473554,  1.6667938651159684),
  ( 2.838945207362466,    1.6667938651159684,  -0.24732126143473554),
  (-2.8914115380566665,   1.5580782047233335,   0.33333333333333337),
  (-1.5580782047233335,   2.8914115380566665,  -0.33333333333333337),
  (-2.4482280932803,      1.8101897177633992,  -1.2760767510338025),
  (-1.8101897177633992,   2.4482280932803,      1.2760767510338025),
  (-2.8914115380566665,   0.33333333333333337,  1.5580782047233335),
  (-1.5580782047233335,  -0.33333333333333337,  2.8914115380566665),
  (-1.8101897177633992,   1.2760767510338025,   2.4482280932803),
  (-2.4482280932803,     -1.2760767510338025,   1.8101897177633992),
  ( 0.07491495712999985,  3.29965982852,        0.07491495712999985),
  ( 1.4082482904633333,   2.6329931618533333,   1.4082482904633333),
  ( 1.6667938651159684,   2.838945207362466,   -0.24732126143473554),
  (-0.24732126143473554,  2.838945207362466,    1.6667938651159684),
  ( 0.07491495712999985,  0.07491495712999985,  3.29965982852),
  ( 1.4082482904633333,   1.4082482904633333,   2.6329931618533333),
  (-0.24732126143473554,  1.6667938651159684,   2.838945207362466),
  ( 1.6667938651159684,  -0.24732126143473554,  2.838945207362466)
].map((g3: Grad3) => (g3.dx / N3, g3.dy / N3, g3.dz / N3))

const gradients3D*: seq[Grad3] = collect:
  for i in 0..<PSIZE:
    grad3[i mod grad3.len]

const base3D* = @[
  @[ 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1 ],
  @[ 2, 1, 1, 0, 2, 1, 0, 1, 2, 0, 1, 1, 3, 1, 1, 1 ],
  @[ 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 2, 1, 1, 0, 2, 1, 0, 1, 2, 0, 1, 1 ]
]

const p3D* = [ 
  0, 0, 1, -1, 0, 0, 1, 0, -1, 0, 0, -1, 1, 0, 0, 0,
  1, -1, 0, 0, -1, 0, 1, 0, 0, -1, 1, 0, 2, 1, 1, 0,
  1, 1, 1, -1, 0, 2, 1, 0, 1, 1, 1, -1, 1, 0, 2, 0,
  1, 1, 1, -1, 1, 1, 1, 3, 2, 1, 0, 3, 1, 2, 0, 1,
  3, 2, 0, 1, 3, 1, 0, 2, 1, 3, 0, 2, 1, 3, 0, 1,
  2, 1, 1, 1, 0, 0, 2, 2, 0, 0, 1, 1, 0, 1, 0, 2,
  0, 2, 0, 1, 1, 0, 0, 1, 2, 0, 0, 2, 2, 0, 0, 0,
  0, 1, 1, -1, 1, 2, 0, 0, 0, 0, 1, -1, 1, 1, 2, 0,
  0, 0, 0, 1, 1, 1, -1, 2, 3, 1, 1, 1, 2, 0, 0, 2,
  2, 3, 1, 1, 1, 2, 2, 0, 0, 2, 3, 1, 1, 1, 2, 0,
  2, 0, 2, 1, 1, -1, 1, 2, 0, 0, 2, 2, 1, 1, -1, 1,
  2, 2, 0, 0, 2, 1, -1, 1, 1, 2, 0, 0, 2, 2, 1, -1,
  1, 1, 2, 0, 2, 0, 2, 1, 1, 1, -1, 2, 2, 0, 0, 2,
  1, 1, 1, -1, 2, 0, 2, 0
]

const lookupPairs3D* = [
  0, 2, 1, 1, 2, 2, 5, 1, 6, 0, 7, 0, 32, 2, 34, 2,
  129, 1, 133, 1, 160, 5, 161, 5, 518, 0, 519, 0, 546, 4, 550, 4,
  645, 3, 647, 3, 672, 5, 673, 5, 674, 4, 677, 3, 678, 4, 679, 3,
  680, 13, 681, 13, 682, 12, 685, 14, 686, 12, 687, 14, 712, 20, 714, 18,
  809, 21, 813, 23, 840, 20, 841, 21, 1198, 19, 1199, 22, 1226, 18, 1230, 19,
  1325, 23, 1327, 22, 1352, 15, 1353, 17, 1354, 15, 1357, 17, 1358, 16, 1359, 16,
  1360, 11, 1361, 10, 1362, 11, 1365, 10, 1366, 9, 1367, 9, 1392, 11, 1394, 11,
  1489, 10, 1493, 10, 1520, 8, 1521, 8, 1878, 9, 1879, 9, 1906, 7, 1910, 7,
  2005, 6, 2007, 6, 2032, 8, 2033, 8, 2034, 7, 2037, 6, 2038, 7, 2039, 6
]