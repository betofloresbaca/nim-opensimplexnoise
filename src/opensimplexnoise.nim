import ./opensimplexnoise/noise
import ./opensimplexnoise/evaluate/d2 as evald2
import ./opensimplexnoise/evaluate/d3 as evald3
import ./opensimplexnoise/evaluate/d4 as evald4

# Types

export OpenSimplex

# Constructors

export newOpenSimplex

# Evaluate functions

export evald2.evaluate
export evald3.evaluate
export evald3.evaluate3XYBeforeZ
export evald3.evaluate3XZBeforeY
export evald4.evaluate