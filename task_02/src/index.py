#!env/bin/python
from sympy import *

t, tau, v1, v2, s = symbols('t, tau, v1, v2, s')

integral = integrate (exp(-integrate(v2,(s, tau, t)))*v1, (tau, 0, t))

print(integral)