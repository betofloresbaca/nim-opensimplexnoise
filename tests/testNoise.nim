import unittest
import json
import os
import opensimplexnoise

const suiteDir = "tests/suite"

test "evaluate(x, y) produces expected noise":
  var testSuite = parseJson(readFile(joinPath(suiteDir, "xy.json")))
  for seedTest in testSuite:
    var seed = seedTest["seed"].getInt
    var noise: OpenSimplex = newOpenSimplex(seed)
    for tCase in seedTest["cases"]:
      var x = tCase[0].getFloat
      var y = tCase[1].getFloat
      var n = tCase[2].getFloat
      check noise.evaluate(x, y) == n

test "evaluate(x, y, z) produces expected noise":
  var testSuite = parseJson(readFile(joinPath(suiteDir, "xyz.json")))
  for seedTest in testSuite:
    var seed = seedTest["seed"].getInt
    var noise: OpenSimplex = newOpenSimplex(seed)
    for tCase in seedTest["cases"]:
      var x = tCase[0].getFloat
      var y = tCase[1].getFloat
      var z = tCase[2].getFloat
      var n = tCase[3].getFloat
      check noise.evaluate(x, y, z) == n

test "evaluate3XYBeforeZ(x, y, z) produces expected noise":
  var testSuite = parseJson(readFile(joinPath(suiteDir, "xy_z.json")))
  for seedTest in testSuite:
    var seed = seedTest["seed"].getInt
    var noise: OpenSimplex = newOpenSimplex(seed)
    for tCase in seedTest["cases"]:
      var x = tCase[0].getFloat
      var y = tCase[1].getFloat
      var z = tCase[2].getFloat
      var n = tCase[3].getFloat
      check noise.evaluate3XYBeforeZ(x, y, z) == n

test "evaluate3XZBeforeY(x, y, z) produces expected noise":
  var testSuite = parseJson(readFile(joinPath(suiteDir, "xz_y.json")))
  for seedTest in testSuite:
    var seed = seedTest["seed"].getInt
    var noise: OpenSimplex = newOpenSimplex(seed)
    for tCase in seedTest["cases"]:
      var x = tCase[0].getFloat
      var y = tCase[1].getFloat
      var z = tCase[2].getFloat
      var n = tCase[3].getFloat
      check noise.evaluate3XZBeforeY(x, y, z) == n

test "evaluate(x, y, z, w) produces expected noise":
  var testSuite = parseJson(readFile(joinPath(suiteDir, "xyzw.json")))
  for seedTest in testSuite:
    var seed = seedTest["seed"].getInt
    var noise: OpenSimplex = newOpenSimplex(seed)
    for tCase in seedTest["cases"]:
      var x = tCase[0].getFloat
      var y = tCase[1].getFloat
      var z = tCase[2].getFloat
      var w = tCase[3].getFloat
      var n = tCase[4].getFloat
      check noise.evaluate(x, y, z, w) == n