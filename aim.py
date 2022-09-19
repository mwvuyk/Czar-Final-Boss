import math, os, sys

os.chdir(os.path.dirname(sys.argv[0]))

pi = math.pi

xoff = 64
yoff = 64
targetx = -320
targety = 0x30
speed = 0x1D
speedx = []
speedy = []

def points_on_circumference(center=(0, 0), r=50, n=100):
    return [
        (
            center[0]+int((math.cos((0.4 * pi / n * x)+1.7*pi) * r)),  # x
            center[1]+int((math.sin((0.4 * pi / n * x)+1.7*pi) * r))   # y

        ) for x in range(0, n + 1)]


def output(label, list):
    file.write(label+":\n")
    file.write("db "+",".join(list)+"\n")

c = points_on_circumference(center=(xoff,yoff), r=192,n=10)

print(c)

xcoord = [x[0]+xoff for x in c]
xhi = [str((x>>8)&255) for x in xcoord]
xcoord = [str(x&255) for x in xcoord]

ycoord = [x[1]+yoff for x in c]
yhi = [str((x>>8)&255) for x in ycoord]
ycoord = [str(x&255) for x in ycoord]

for x, y in c:
    vecx = targetx - x
    vecy = targety - y
    norm = math.sqrt((vecx*vecx)+(vecy*vecy))
    speedx.append(str(int((speed*vecx)/norm)))
    speedy.append(str(int((speed*vecy)/norm)))
    
with open("gentbl.asm","w") as file:
    output("RingXPos",xcoord)
    output("RingXHi",xhi)
    output("RingYPos",ycoord)
    output("RingYHi",yhi)
    output("RingXSpeed",speedx)
    output("RingYSpeed",speedy)




