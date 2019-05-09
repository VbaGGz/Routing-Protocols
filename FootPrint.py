from random import randint
# This Program is used to generate 
# Node FootPrints for NS2

CL = [[499, 499], [499, 499],
[499, 499], [499, 499],
[499, 499], [499, 499],
[499, 499], [499, 499],
[499, 499], [499, 499]]

file = open("footPrint.tr", "a")
for x in range(0, 1000):
    for i in range(0, 10):
        randomint = randint(1, 4)
        if randomint == 1:
            CL[i][1] += 1
        elif randomint == 2:
            CL[i][1] -= 1
        elif randomint == 3:
            CL[i][0] += 1
        elif randomint == 4:
            CL[i][0] -= 1
        
        file.write ("{} {} {}\n".format(i, CL[i][0], CL[i][1]))
