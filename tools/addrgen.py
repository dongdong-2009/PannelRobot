import os
import sys
import argparse

parser = argparse.ArgumentParser(description='Generate addr from a define file and output a .h and .cpp file')
parser.add_argument('input',help='define file')
parser.add_argument('outputdir',help='output dir')

args = parser.parse_args()
class AddrWrapper:
    def  __init__(self, name, type, perm, baseAddr, startPos, size, decimal, unit):
        self.name = name
        self.type = type
        self.perm = perm
        self.baseAddr = baseAddr
        self.startPos = startPos
        self.size = size
        self.decimal = decimal
        self.unit = unit

defineRows =  open(args.input, 'r').read().split("\n")
del defineRows[len(defineRows) -1]
rowItems = []
addrWrappers = []
for row in defineRows:
    rowItems = row.split(",")
    addrWrappers.append(AddrWrapper(rowItems[0].replace('"',''),
                                    rowItems[1].replace('"',''),
                                    rowItems[2].replace('"',''),
                                    rowItems[3],
                                    rowItems[4],
                                    rowItems[5],
                                    rowItems[6],
                                    rowItems[7].replace(' ','')))

typeToInt = {"c":1, "m":2, "s":3}
permToInt = {"r":1, "w":2, "rw":3}
toWriteH = '#include "icaddrwrapper.h"\n'
toWriteSource = '#include "icaddrwrapper.h"\n'
for addr in addrWrappers:
    toWriteH += "extern  const ICAddrWrapper  {0}_{1}_{2}_{3}_{4};    //< {5}\n".format(addr.type,
                                                                                        addr.perm,
                                                                                        addr.startPos,
                                                                                        addr.size,
                                                                                        addr.baseAddr,
                                                                                        addr.name);
    toWriteSource += "extern  const ICAddrWrapper  {0}_{1}_{2}_{3}_{4}({5},{6},{2},{3},{4},{7},{8});    //< {9}\n".format(addr.type,
                                                                                                                        addr.perm,
                                                                                                                        addr.startPos,
                                                                                                                        addr.size,
                                                                                                                        addr.baseAddr,
                                                                                                                        typeToInt[addr.type],
                                                                                                                        permToInt[addr.perm],
                                                                                                                        addr.decimal,
                                                                                                                        addr.unit,
                                                                                                                        addr.name)

open(os.path.join(args.outputdir, "icconfigsaddr.h"),'w').write(toWriteH)
open(os.path.join(args.outputdir, "icconfigsaddr.cpp"),'w').write(toWriteSource)
