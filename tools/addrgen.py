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
line = 0
for row in defineRows:
    ++line
    rowItems = row.split(",")
    if len(rowItems) != 8:
        print(line)
        continue
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
toWriteH = '#ifndef ICADDRWRAPPER_H\n#define ICADDRWRAPPER_H\n#include "icaddrwrapper.h"\n#include <QList>\n'
toWriteSource = '#include "icaddrwrapper.h"\n'
moldFncs = "static ICAddrWrapperMapper CreateMoldFncMap(){ICAddrWrapperMapper ret;"
sysConfigs = "static ICAddrWrapperMapper CreateSysConfigsMap(){ICAddrWrapperMapper ret;"
status = "static ICAddrWrapperMapper CreateStatusConfigsMap(){ICAddrWrapperMapper ret;"
for addr in addrWrappers:
    addrTmp =  "{0}_{1}_{2}_{3}_{4}_{5}".format(addr.type,
                                            addr.perm,
                                            addr.startPos,
                                            addr.size,
                                            addr.decimal,
                                            addr.baseAddr);
    toWriteH += "extern  const ICAddrWrapper  {0};    //< {1}\n".format(addrTmp, addr.name);
    toWriteSource += "extern  const ICAddrWrapper  {0}_{1}_{2}_{3}_{7}_{4}({5},{6},{2},{3},{4},{7},{8});    //< {9}\n".format(addr.type,
                                                                                                                        addr.perm,
                                                                                                                        addr.startPos,
                                                                                                                        addr.size,
                                                                                                                        addr.baseAddr,
                                                                                                                        typeToInt[addr.type],
                                                                                                                        permToInt[addr.perm],
                                                                                                                        addr.decimal,
                                                                                                                        addr.unit,
                                                                                                                        addr.name)
    if addr.type == 'm':
        moldFncs += 'ret.insert("{0}", &{0});'.format(addrTmp)
    elif addr.type == 's':
        sysConfigs += 'ret.insert("{0}", &{0});'.format(addrTmp)
    elif addr.type == 'c':
        status += 'ret.insert("{0}", &{0});'.format(addrTmp)


#toWriteH += moldFncs + "return ret;}\nconst ICAddrWrapperMapper moldFncsMapper = CreateMoldFncMap();\n"
#toWriteH += sysConfigs +  "return ret;}\nconst ICAddrWrapperMapper sysAddrsMapper = CreateSysConfigsMap();\n"
#toWriteH += status +  "return ret;}\nconst ICAddrWrapperMapper statusAddrsMapper = CreateStatusConfigsMap();\n"
#toWriteH += "inline static const ICAddrWrapper* MappedAddrWrapper(const QString& addr){ if(moldFncsMapper.contains(addr)){ return moldFncsMapper.value(addr);} if(sysAddrsMapper.contains(addr)){ return sysAddrsMapper.value(addr); } if(statusAddrsMapper.contains(addr)){ return statusAddrsMapper.value(addr);} return NULL;}\n"

toWriteH += "#endif // ICADDRWRAPPER_H"
open(os.path.join(args.outputdir, "icconfigsaddr.h"),'w').write(toWriteH)
open(os.path.join(args.outputdir, "icconfigsaddr.cpp"),'w').write(toWriteSource)
