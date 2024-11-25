[96,96,96,128,255,0,128,0,0,255,128,204,0,128,255,0,128,0,0,255,128,204,0,199,45,250,250,250,250],
[66,66,66,128,0,128,64,255,255,213,0,170,0,128,0,128,64,255,255,213,0,170,0,68,112,126,126,126,126],
[166,166,166,128,0,255,0,255,0,0,255,0,0,128,0,255,0,255,0,0,255,0,0,64,179,25,25,25,25]

#6060A6, #6060A6, #6060A6, #808080, #FF00FF, #008000, #804000, #00FFFF, #00FF00, #FFD500, #8000FF, #CCAA00, #008000, #800080, #FF0000, #0080FF, #8040FF, #00FF00, #0000FF, #FF00FF, #80CCFF, #CC00FF, #00C740, #2D68B3, #FAB319, #FAFAB3, #FFFAB3, #FFFFFF, #FFFFFF


### Constants

C_{SelectionCircle}=0.25
C_{colors} = rgb([Red array], [Green array], [Blue array])

### Visuals and Relationships

# 1. Key Equations and Visual Constraints
# Distance from orbit centers:
|distance((x, y), C_n) - R_n|[L].max < 0.25

# Distance from S:
distance((x, y), S).max < 0.25

# Color Representation:
color = rgb(
  [Red array],
  [Green array],
  [Blue array]
)

# 2. Key Subsets and Functions
# Subset of N based on indices L:
S = N[L]

# Rotational Function:
O(t) = (sin(t), cos(t))

# Orbits with Offsets:
R_n * O(τt) + C_n

# Main Positions for N:
N = R_n * O(T / P_n) + C_n


### Functions and Approximations

# 1. Primary Functional Evaluation
# Main Function F:
F(x, y) = (
  F_r^[0.8, 0.8, 0.8, 1.0].total * D(N[1]) + F_ri[1]
)^4.5 * Product_over_k(
  (F_h * D(N[L[k]]) + F_ri[k])^e_k
)

# 2. Distance Metric D:
# For a center z:
D(z) = (1 - 4 * ((x - z.x)^2 + (y - z.y)^2))^6

# 3. Special Transformation h:
# Transform h(a, b) with c = b - a:
h(a, b) = (
  sqrt((0.25 / (c.x^2 + c.y^2)) - 1) * (c.y, -c.x) + b + a
) / 2


### Set Representations

# 1. Filtered Points H:
H = {(u, v) : distance((u, v), S) < 0.25}

# 2. Main Subset C₁:
# With Constraints:
C₁ = C₂[
  (S.x.max - 0.2501 < C₂.x < S.x.min + 0.2501) AND
  (S.y.max - 0.2501 < C₂.y < S.y.min + 0.2501)
]

# Using:
C₂ = [
  h(x, y) for x in S, y in S
].join(
  x + y for x in S, y in ([.25, -.25, 0, 0], [0, 0, .25, -.25])
)


### Raw Data (Parameters)

# 1. Orbit Centers and Radii
# Centers C_n:
C_n = [
  (x_1, y_1), ..., (x_29, y_29)
]

# Radii R_n:
R_n = [0.3, 0.3, ..., 0.9]

# 2. Periods for Rotation
P_n = [
  604800, -172800, ..., 86400
]

# 3. Parameters for Time
T = (
  523304198642.7387904 + 2333509100 + 86400 * t_1 + t_2
) * τ
