import numpy as np

def frange(start:float, stop:float, interval:float) :
    r = start
    while r < stop:
        yield r
        r = round(r + interval, 5)

def coordinates2d(x0, y0, x1, y1, xinterval, yinterval):
    x1 = x1 + xinterval
    y1 = y1 + yinterval
    coord = []

    for x in frange(x0, x1, xinterval):
        for y in frange(y0, y1, yinterval):
            coord.append((x, y))

    print(coord)
    print("Size")
    print(len(coord))

def coordinates3d(x0:float, y0:float,z0:float, x1:float, y1:float, z1:float, xinterval:float, yinterval:float, zinterval:float,):
    x1 = x1 + xinterval
    y1 = y1 + yinterval
    z1 = z1 + zinterval
    coord = []

    for x in np.arange(x0, x1, xinterval):
        for y in np.arange(y0, y1, yinterval):
            for z in np.arange(z0, z1, zinterval):
                coord.append((x, y, z))

    print(coord)
    print("Size")
    print(len(coord))


#def test(): 
xmin = 0.2
ymin = 0.0
zmin = 0.0
xmax = 1.6
ymax = 0.0
zmax = 0.0
dx = 0.002
dy = 0.1
dz = 0.1

print("2D")
coordinates2d(xmin, ymin, xmax, ymax, dx, dy)

#print("3D")
#coordinates3d(xmin, ymin, zmin, xmax, ymax, dx, dy, dz)
