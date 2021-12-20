import ./constants/d2
import ./constants/d3
import ./constants/d4
import ./internaltypes

proc newContribution2*(multiplier: float64, xsb, ysb: int): Contribution2 = 
  return Contribution2(
    dx: -xsb.float64 - multiplier * SQUISH_2D,
    dy: -ysb.float64 - multiplier * SQUISH_2D,
    xsb: xsb,
    ysb: ysb
  )

proc newContribution3*(multiplier: float64, xsb, ysb, zsb: int): Contribution3 = 
  return Contribution3(
    dx: -xsb.float64 - multiplier * SQUISH_3D,
    dy: -ysb.float64 - multiplier * SQUISH_3D,
    dz: -zsb.float64 - multiplier * SQUISH_3D,
    xsb: xsb,
    ysb: ysb,
    zsb: zsb
  )

proc newContribution4*(multiplier: float64, xsb, ysb, zsb, wsb: int): Contribution4 = 
  return Contribution4(
    dx: -xsb.float64 - multiplier * SQUISH_4D,
    dy: -ysb.float64 - multiplier * SQUISH_4D,
    dz: -zsb.float64 - multiplier * SQUISH_4D,
    dw: -wsb.float64 - multiplier * SQUISH_4D,
    xsb: xsb,
    ysb: ysb,
    zsb: zsb,
    wsb: wsb
  )