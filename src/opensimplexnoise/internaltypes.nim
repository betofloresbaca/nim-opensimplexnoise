type
  Grad2* = tuple
    dx, dy : float64

  Grad3* = tuple
    dx, dy, dz : float64

  Grad4* = tuple
    dx, dy, dz, dw : float64

  Contribution2* = ref object
    dx*, dy*: float64
    xsb*, ysb*: int
    next*: Contribution2

  Contribution3* = ref object
    dx*, dy*, dz*: float64
    xsb*, ysb*, zsb*: int
    next*: Contribution3

  Contribution4* = ref object
    dx*, dy*, dz*, dw*: float64
    xsb*, ysb*, zsb*, wsb*: int
    next*: Contribution4