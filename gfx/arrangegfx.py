import sys

def chunks(lst, n):
    """Yield successive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]


files = [
("idle",4),
("idle2",10),
("hdown",9),
("hup",9),
("fcharge",11),
("fidle",4),
("fend",4),
("hurt",13),
("death",6),
("chase",8)
]

if __name__ == "__main__":
    with open("graphics.bin",'rb') as file:
        file = list(chunks(file.read(), 32)) # Split into 8x8

        n = 0
        outl = []
        order = [0x0,0x1,0x2,0x3,0x4,0x5,
                0x20,0x21,0x22,0x23,0x24,0x25,
                0x40,0x41,0x42,0x43,
                0x10,0x11,0x12,0x13,0x14,0x15,
                0x30,0x31,0x32,0x33,0x34,0x35,
                0x50,0x51,0x52,0x53,
                0x44,0x45,0x54,0x55]
        

        for fname, num in files:
            while num > 0:
                
                for x in order:
                    outl.extend(file[n+x])
                n = n + 0x8
                num -= 1
                if num > 0:
                    for x in order:
                        outl.extend(file[n+x])
                num -= 1    
                n = n + 0x78

            with open(fname+".bin",'wb') as fileout:
                fileout.write(bytes(outl))
                outl = []