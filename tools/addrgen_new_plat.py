import re
import sys
import copy

spaceStr = ' '
commonStr = '//<'
tabStr = '  '
lfStr = '\n'
zhCommaStr = '，'
enCommaStr = ','
arrayStr = '['
zhSeparateStr = '；'
enSeparateStr = ';'
zhColonStr = '：'
enColonStr = ':'
startBlock = '/*'
endBlock = '*/'
equalStr = '='

g_struct = "undefine_struct_"
g_index = 0

g_configaddr = 'icconfigsaddr.h'
g_externaddr = 'icconfigsaddr.cpp'
g_addrlog = 'icaddrlog.txt'

g_sql = 'db.sql'
#g_defaultconfig = 'icdefaultconfig.txt'
#g_write_config = False
g_read_config = True


class parseCmd:
    def __init__(self, fileName, defaultName, addrDir, dbDir):
        if addrDir[-1] !='/':
            addrDir = addrDir + '/'
        if dbDir[-1] != '/':
            dbDir = dbDir + '/'
        self.__cmdHandle = open(fileName,'r' , encoding='utf-8')
        self.__writeHandle = open(addrDir +  g_configaddr ,'w',  encoding='utf-8')
        self.__externHandle = open(addrDir + g_externaddr, 'w', encoding='utf-8')
        self.__sqlRead = open(addrDir + g_externaddr,'r',  encoding='utf-8')
        self.__sqlWrite = open(dbDir + g_sql,'w', encoding='utf-8')
        self.__addrLog  = open(addrDir + g_addrlog,  'w', encoding = 'utf-8')

        if g_read_config:
            self.__defualtRead = open(defaultName,'r', encoding='utf-8')
            self.__firstDefault =  self.__defualtRead.read()
            self.__defualtRead.close()
        self.__secondDefault  = ''
        self.__structDict = { }
        self.__enumDict = { }
        self.__unionDict= { }
        self.__staticDict = {}
        self.__defaultDict = {}
        self.__defaultPermit = {}
#        self__sortDict = {}
        self.__Dict = {}
        self.isBlock = False
        self.parse()
    
    #解析默认值
    def parseDefaultConfig(self, defaultName):
        if g_read_config:
            self.__defualtRead = open(defaultName,'r', encoding='utf-8')
        line = self.__defualtRead.readline()
        while line:
#            print(line)
            line = line.strip('\n')
            _list = line.split(',')
#            print(_list)
            addr = int(_list[0].split('_')[-1])
            offset = int(_list[0].split('_')[2])
            size = int(_list[0].split('_')[3])
            value =int(_list[2])
            permit = None
            if   len(_list[-1]) > 0:
                permit = int(_list[-1])
            else:
                permit = _list[-1]
#            print(value)
            #save default value 
            if addr in self.__defaultDict.keys(): 
                self.__defaultDict[addr].append((offset, size, value)) 
            else:
                self.__defaultDict[addr] = []
                self.__defaultDict[addr].append((offset, size, value)) 
            #save default permit
            self.__defaultPermit[_list[0]] = permit
            line = self.__defualtRead.readline()
#        print(self.__defaultDict)
    
    def isStart(self, s):
        return '{' in s;
    
    def isEnd(self, s):
        return '}' in s;
    
    
    #解析处理标准类型数据结构
    def parseLine(self, line, string):
        __sparator = None
        if string == "enum":
            __sparator = enCommaStr
        elif string == "struct":
            __sparator = enSeparateStr
        elif string == "union":
            __sparator = enSeparateStr
        elif string == "static":
            __sparator = enCommaStr
        rs = []
        value = 0
        if spaceStr  in line:
            line = line.strip(spaceStr)
        if tabStr  in line:
            line = line.strip(tabStr)
        if lfStr in line:
            line = line.strip(lfStr)
        if line[0:2] == '//': 
            return
        elif line[0:2] == startBlock: 
            self.isBlock = True
        if endBlock in line: 
            self.isBlock = False
            return
        if self.isBlock:
            return      
        if zhSeparateStr in line:
            line = line.replace(zhSeparateStr, enSeparateStr)
        if zhColonStr in line:
            line = line.replace(zhColonStr, enColonStr)
        if zhCommaStr in line:
            line = line.replace(zhCommaStr, enCommaStr)  
        l = []
        index =  line.find(__sparator)
        if index != -1:
            l.append(line[0:index])
            comment = line[index + 1: len(line)]
            if comment: 
                l.append(comment)
        else:
            index =  line.find(spaceStr)
            if index != -1:
                l.append(line[0:index])
                comment = line[index + 1: len(line)]
                if comment: 
                    l.append(comment)
            else:
                pass
        #        print("no comment")
        #        print(l)
        for _l in l:
            if commonStr  in _l:
                if spaceStr in _l:
                    _l = _l.replace(spaceStr, '')
                _l = _l.strip(commonStr)
                _l = _l.split(enSeparateStr)
                if '' in _l:
                    _l.remove('')
                _dict = {}
                for __l in _l:
                    temp = __l.split(enColonStr)
                    if len(temp) != 2:
                        _dict['common'] = temp[0]
                    else:
                        _dict[temp[0]] = temp[1]
                if len(_dict):
                    rs.append(_dict)
            else:    
                if equalStr in _l:
                        _l = _l.split(equalStr)
                        rs.append(_l[0])
                        if _l[1].find("0x") != -1:
                            value = int(_l[1],16)
                        else:
                            value = int(_l[1])    #        
#                        print(_l[0], value)
                elif spaceStr in _l:
                    index = _l.find(spaceStr)
                    _dict = {}
                    _dict['type'] = _l[0:index]
                    second = _l[index+1:len(_l)] 
                    if enColonStr in second:
                        second = second.split(enColonStr)
                        _dict['name'] = second[0]
                        _dict['size'] = second[1]
                    elif _l[0:index] == 'uint16_t':
                        _dict['type'] = 'uint32_t'
                        _dict['name'] = second
                        _dict['size'] = 16
                    elif re.search('\w+\[\d+\]', second):
                        _dict['name'] = re.search('\w+', second).group()
                        _array = re.search('\[\d+\]', second).group()
                        _dict['length'] = re.search('\d+', _array).group()
                    else:
                        _dict['name'] = _l[index+1:len(_l)] 
                    rs.append(_dict)
                else:
                    rs.append(_l)

        if rs:
            return value, rs
        
        
    def readLine(self):
        ret =  self.__cmdHandle.readline()
        #print("test:", repr(ret.encode('ascii', 'ignore')))
        return ret
    
    #解析enum类型
    def parseEnum(self):
        enum = []
        count = 0
        rs = None
        line = self.readLine()
        while not self.isEnd(line):
            if line != '\n' and not self.isStart(line):
                result  = self.parseLine(line, "enum")  
                if result:
                    rs = result[1]
                    value = result[0]
                    if value:
                        count = value
                    if 'ICAddr_Write_Section_End' in rs[0]:
                        self.Section_End = count
                    enum.append([count, rs])
                    count = count + 1
            line = self.readLine()
#        print(re.findall('\w+', line))
        self.__enumDict[re.findall('\w+', line)[0]] =  enum
        return enum
        
    #生成db.sql
    def generateSql(self):
#        self.__writeHandle.close()
        tb_addr_wrapper = "tb_addr_wrapper"
        tb_modify_record = "tb_config_zh_cn"
        tb_system_mould = "basesysconfig"
        tb_base_mould = "basemoldconfig"
        tb_alarm_record = "tb_alarm_zh_CN"
        tb_config_permission = "tb_config_permission"
        head = 'PRAGMA foreign_keys=OFF;\n\
BEGIN TRANSACTION;\n\n'
        tail = '''
        
DROP TABLE tb_default_moldconfig;
DROP TABLE tb_default_systemconfig;
CREATE TABLE tb_default_moldconfig AS SELECT * FROM basemoldconfig;
CREATE TABLE tb_default_systemconfig AS SELECT * FROM basesysconfig;
COMMIT;'''
        
        self.__sqlWrite.write(head)
        
        dropTable = "DROP TABLE  {0};\n\
DROP TABLE  {1};\n\
DROP TABLE  {2};\n\
DROP TABLE  {3};\n\
DROP TABLE  {4};\n\
DROP TABLE  {5};\n".format(tb_addr_wrapper, tb_modify_record, tb_system_mould, tb_base_mould, tb_alarm_record, tb_config_permission)
        self.__sqlWrite.write(dropTable)

        '''创建表'''
        sql = "CREATE TABLE \"{0}\" ( \n\
        name TEXT PRIMARAY KEY, \n\
        point  INTEGER,  \n\
        unit   TEXT\n);\n ".format(tb_addr_wrapper)
        self.__sqlWrite.write(sql)
        sql = "CREATE TABLE \"{0}\" ( \n\
        addr TEXT PRIMARAY KEY, \n\
        description   TEXT\n);\n ".format(tb_modify_record)
        self.__sqlWrite.write(sql)
        sql = "CREATE TABLE \"{0}\" ( \n\
        addr INTEGER PRIMARAY KEY, \n\
        value   TEXT\n);\n ".format(tb_system_mould)
        self.__sqlWrite.write(sql)
        sql = "CREATE TABLE \"{0}\" ( \n\
        addr INTEGER PRIMARAY KEY, \n\
        value   TEXT\n);\n".format(tb_base_mould)
        self.__sqlWrite.write(sql)
        sql = "CREATE TABLE \"{0}\" ( \n\
        alarmNum INTEGER PRIMARAY KEY, \n\
        description   TEXT\n);\n".format(tb_alarm_record)
        self.__sqlWrite.write(sql)
        line = self.__sqlRead.readline()
        sql = "CREATE TABLE \"{0}\" ( \n\
        addr TEXT NOT NULL, \n\
        perm_id INTEGER NOT NULL\n);\n".format(tb_config_permission)
        self.__sqlWrite.write(sql)
        line = self.__sqlRead.readline()
        
        #修改记录，地址表
        while line:
            if 'const' not in line:
                line = self.__sqlRead.readline()
                continue
            line = line.strip('\n')
            name = re.findall('\w+', line)[3]
            code = line.split(commonStr)[1]
#            text = re.findall('"[\w\W]*"', line)
#            line = line.replace('\"', '\'')
#            text2 =  line.split(',')
#            print(text2[-2], text2[-1])
            text = line.split(commonStr)[0].strip('); ').split(',')
#            print( text[-2], text[-1])
            sql = "INSERT INTO {0} VALUES  ('{1}',{2},{3});\n".format(tb_addr_wrapper, name, text[-2], text[-1])
            self.__sqlWrite.write(sql)
            sql = "INSERT INTO {0} VALUES  ('{1}','{2}');\n".format(tb_modify_record, name, code)
            self.__sqlWrite.write(sql)
            line = self.__sqlRead.readline()

        #模号和系统表
        for addr in self.__enumDict['ICAddr']:
            if len(addr) ==2:
                if len(addr[1]) != 2:
                    continue
                type = addr[1][1].get('类型')
#                print(addr[0], ":" ,addr);
                if type == '系统' and addr[0] < self.Section_End:
                    value = self.getDefaultValue(addr[0])
                    sql = "INSERT INTO {0} VALUES  ({1},{2});\n".format(tb_system_mould, addr[0], value)
                    self.__sqlWrite.write(sql)    
                elif type == '模号'  and addr[0] < self.Section_End:
                    value = self.getDefaultValue(addr[0])
                    sql = "INSERT INTO {0} VALUES  ({1},{2});\n".format(tb_base_mould, addr[0], value)
                    self.__sqlWrite.write(sql)    
                else:
                   pass
            else:
                pass
                
        #报警记录
        alarmList = self.__enumDict['ALARM_ADDR']
#        print(alarmList)
        for alarm in alarmList:
            common = ''
            if len(alarm[1]) == 2:
                common = alarm[1][1].get('名字')
                if not common:
                    common = ''
            sql = "INSERT INTO {0} VALUES  ({1},'{2}');\n".format(tb_alarm_record, alarm[0], common)
            self.__sqlWrite.write(sql)    
        #权限表配置
        for addr in self.__defaultPermit.keys():
            permit = self.__defaultPermit.get(addr)
#            if (permit != ''):
#                print(permit)
            if isinstance(permit, int):
                sql = "INSERT INTO {0} VALUES  ('{1}',{2});\n".format(tb_config_permission, addr, permit )
                self.__sqlWrite.write(sql)   

        self.__sqlWrite.write(tail)
        self.__sqlWrite.close()
        
    #根据地址获取默认值
    def getDefaultValue(self, addr):
        value = 0
#        print(addr)
        rs = self.__defaultDict[addr]
        for l in rs:
            value = value + (l[2] << l[0])
        return value 
            
            

    def parseStruct(self, parent = None):
        struct = []
        line = self.readLine()
        while not self.isEnd(line) and not self.isStart(line):
            if line != '\n':
                result  = self.parseLine(line, "struct")  
                if result:
                    struct.append( result[1])
            line = self.readLine()
        name = None
        global g_index
        if len(re.findall('\w+', line)):
            name = re.findall('\w+', line)[0]
        else:
            name = g_struct +str(g_index)
            g_index = g_index + 1
        self.__structDict[name] = struct
        _list = []
        _dict = {}
        _dict['type'] = name
        _list.append(_dict)
        return _list        
    
    #处理union数据结构    
    def parseUnion(self):
        union = []
        line = self.readLine()
        while not self.isEnd(line):
            if line != '\n':
                if self.isStart(line):
                    if 'struct' in line:
                        rs = self.parseStruct()
                        union.append(rs)
                result  = self.parseLine(line, "union")  
                if result:
                    union.append(result[1])
            line = self.readLine()
        self.__unionDict[re.findall('\w+', line)[0]] =  union
        return union
    
    def findSymbol(self, s):
        if s in self.__enumDict.keys():
            return ("enum", self.__enumDict[s])
        if s in self.__structDict.keys():
            return ("struct", self.__structDict[s])
        if s in self.__unionDict.keys():
            return ("union", self.__unionDict[s])
   
    def findType(self, s):
        type =  s[0][0]
#        print(type)
        if isinstance(type, dict):
            return type.get('type')
        elif isinstance(type, list):
            pass
#            print (s)
                
    def getRootStruct(self, symbol):
        type = self.findSymbol(symbol)
        while type[0] != 'struct' and type:
            symbol = self.findType(type[1])
            type = self.findSymbol(symbol)
        return type[1]
    #递归展开struct，注释合并
    def getChildrenContent(self, symbol, parentCommon = ''):
        type = self.findSymbol(symbol)
        result = []
#        if not type:

        while type:
            #print("getChildrenContent:", type)
            if type[0] == 'struct':
                for l in type[1]:
                    symbol = l[0].get('type')
                    if symbol != 'uint32_t':
                        length =  l[0].get('length')
                        common = parentCommon
                        if len(l) == 2:
                            if l[1].get('名字'):
                                common = common + l[1].get('名字')
#                                print(common)
                        _rs = self.getChildrenContent(symbol, common)
                        if not _rs:
                            continue
                        if length:
                            for i in range(0,int(length)):
                                result= result+ _rs
                        else:
                            result= result+ _rs
                    else:
                        length =  l[0].get('length')
                        #print("getChildr length:", length, l[0])
                        if length:
                            temp = copy.deepcopy(l) #深拷贝
                            if len(l) == 2:
                               if  l[1].get('名字'):
                                    temp[1]['名字'] = temp[1]['名字'] + parentCommon
                               else:
                                    temp[1]['名字'] = parentCommon
                            for i in range(0, int(length)):
                                result.append(temp)
                        else:
                            temp = copy.deepcopy(l)  #深拷贝
                            if len(l) == 2:
                               if  l[1].get('名字'):
                                    temp[1]['名字'] = temp[1]['名字'] + parentCommon
                               else:
                                   temp[1]['名字'] = parentCommon
                            result.append(temp)
                return result
            elif type[0] == 'union':
                symbol = self.findType(type[1])
#                print(symbol)
            type = self.findSymbol(symbol)
    #获取index在rs中的下标
    def getIndex(self, rs, index):
        sum = 0
        _index = 0
        #print("getIndex:", index)
        if not index:
            return index
        #print("test", rs)
        #print("End")
        for (i, l) in enumerate(rs):
            #print("test:", i, l)
            size =  l[0].get('size')
            if size:
                sum += int(size)
#                print('size:',size,' sum:', sum)
                if sum == 32:
                    _index = _index + 1
                    sum = 0
                elif sum > 32:
                    print("sum :", sum)
            else:
                _index = _index + 1
            if _index == index:
                if (i + 1) == len(rs):
                    print("i+1 = len(rs)", i + 1, len(rs))
                else:
                    return i+1
    #获取addr对应的类型    
    def getType(self, addr):
        type = addr[1].get('类型')
        if type:
            typeEnum = wapper.enumList[0]
            for l in typeEnum[1]:
#                print(l[1][0])
                if type in l[1][1].get('common'):
#                    return (wapper.className + '::' + l[1][0], l[1][0].strip('kICAddrType')[0].lower())
                    return (l[0],   l[1][0][len('kICAddrType'):][0].lower(), type)
            
            print(type, ' not find in ', wapper.className)
            return (0, 'n', type)
        else:
            return (0, 'n', type)
    #获取addr对应的权限   
    def getPermission(self, addr):
            if addr < self.Section_End:
#                return (wapper.className + '::' +  'kICAddrPermissionRW', 'rw')
                return (3, 'rw')
            elif addr > self.Section_End:
#                return (wapper.className + '::' +  'kICAddrPermissionReadOnly', 'ro')
                return (1, 'ro')
    
    def writeData(self, rs, index, ICAddr, common):
        addr = ICAddr[0]
        pos = 0
        #print("test:", rs, index)
        rsIndex = self.getIndex(rs, index)

        permission, spermission =  self.getPermission( addr)
        if  rsIndex == None:
            print(ICAddr[1][0], ' out of range')

        #print("test:",rs, rsIndex)
        size =  rs[rsIndex][0].get('size')
        sum = 0 
        while  sum != 32:
            _common = ''
            _decimal = ''
            _unit = ''
            if size:
                #print(len(rs), rsIndex, rs[rsIndex])
                if rs[rsIndex][1].get('名字') :
                    _common = common +  rs[rsIndex][1].get('名字') 
                if rs[rsIndex][1].get('精度') :
                    _decimal = _decimal +  rs[rsIndex][1].get('精度') 
                if rs[rsIndex][1].get('单位') :
                    _unit = _unit +  rs[rsIndex][1].get('单位') 
                type, stype, typeName = self.getType(rs[rsIndex])
                compareRS = self.compareSystemType(ICAddr, typeName, _common)
                if compareRS:
                    self.__addrLog.write(compareRS)
                if  not _decimal:
                    _decimal = 0
                else:
                    _decimal = int(_decimal)
                addrValue = type  + ( permission << 3) + (pos << 5) + (int(size) << 10) + (addr << 16) + (_decimal << 30)
                name = '{0}_{1}_{2}_{3}_{5}_{4}'.format(stype, spermission,pos, int(size), addr, _decimal) 
                s = "extern  const {0}  {1};  //< {3} {2}\n".format(wapper.className, name, _common, addrValue)          
                extern  = "extern  const {0}  {1}({2},{3},{4},{5},{6},{8},\"{9}\");   //<{7}\n".format(wapper.className, name, type, permission, pos, int(size), addr, _common, _decimal, _unit)          
                self.__externHandle.write(extern)
                self.__writeHandle.write(s)
                if '_ro_' not  in name:
                    defaultValue = "{0},{1},0,,\n".format(name,_common )
                    self.__secondDefault = self.__secondDefault + defaultValue
                sum = sum + int(size)
                pos = pos + int(size )
                rsIndex += 1
                if rsIndex != len(rs):
                   # print("test:",rs[rsIndex][0])
                    size =  rs[rsIndex][0].get('size')
                else:
                    break;
            else:
                #print(len(rs), rsIndex, rs[rsIndex])
                if rs[rsIndex][1].get('名字') :
                    _common = common +  rs[rsIndex][1].get('名字') 
                if rs[rsIndex][1].get('精度') :
                    _decimal = _decimal +  rs[rsIndex][1].get('精度') 
                if rs[rsIndex][1].get('单位') :
                    _unit = _unit +  rs[rsIndex][1].get('单位') 
                type, stype, typeName= self.getType(rs[rsIndex])
                compareRS = self.compareSystemType(ICAddr, typeName, _common)
                if compareRS:
                    self.__addrLog.write(compareRS)
                if  not _decimal:
                    _decimal = 0
                else:
                    _decimal = int(_decimal)
                addrValue = type  + ( permission << 3) + (pos << 5) + (32 << 10) + (addr << 16) + (_decimal << 30)
                name = '{0}_{1}_{2}_{3}_{5}_{4}'.format(stype, spermission,0, 32, addr, _decimal) 
                s = "extern  const {0}  {1};    //< {3} {2}\n".format(wapper.className, name, _common, addrValue)          
                extern = "extern  const {0}  {1}({2},{3},{4},{5},{6},{8},\"{9}\");    //<{7}\n".format(wapper.className, name, type, permission, 0,32, addr, _common, _decimal, _unit)    
                self.__writeHandle.write(s)
                self.__externHandle.write(extern)
                if '_ro_' not  in name:
                    defaultValue = "{0},{1},0,,\n".format(name,_common )
                    self.__secondDefault = self.__secondDefault + defaultValue
#                print("UINT32", rsIndex, s)
                break;
    #默认值进行 行合并
    def mergeString(self, first, second):
        defaultList = first.split(',')
        secondList =  second.split(',')
        #print(len(defaultList), len(secondList))
        #print(defaultList[1], defaultList[3], secondList[3], defaultList[3] != secondList[3])
        if defaultList[2] != secondList[2]:
            secondList[2]= defaultList[2]
        if len(defaultList)>3 and  defaultList[3] != secondList[3]:
            print(defaultList[1])
            secondList[3]= defaultList[3]
        if len(defaultList)>4 and  defaultList[4] != secondList[4]:
            secondList[4]= defaultList[4]
        return ','.join(secondList)

    #读取地址表头文件生成0默认值并且和标准默认值进行合并    
    def mergeDefaultValue(self,fileName):
        self.__defualtWrite = open(fileName,'w', encoding='utf-8')
        firstList = self.__firstDefault.split('\n')
        secondList = self.__secondDefault.split('\n')
        #print(firstList)
        #print("fsfsdfsdfsdfsdf----------------------")
        #print(secondList)
        firstDict = {}
        secondDict = {}
        for l in firstList:
            if l == '':
                continue
            name = l.split(',')[0]
            firstDict[name] = l
        for l in secondList:
            if l == '':
                continue
            name = l.split(',')[0]
            secondDict[name] = l
        for key in secondDict.keys():
            if key in firstDict.keys():
                secondDict[key] = self.mergeString(firstDict[key], secondDict[key])
#        for key in secondDict:
#            print(secondDict[key])
        #对icdefaultconfig.txt内容进行排序
        self.__defualtWrite.write('\n'.join(sorted(secondDict.values(), key = lambda s:(
                                                                                            int(s.split(',')[0].split('_')[-1]), 
                                                                                            int(s.split(',')[0].split('_')[2])
                                                                                            )
                                                                            )
                                                                )
                                                    )
        self.__defualtWrite.close()
#        print(len(firstList), len(secondList))


    def compareSystemType(self, addr, type, _common):
        parentType = addr[1][1] .get('类型')     
        if not (parentType == type):
#            print(addr[1][0], _common)
            s  = "{0},{1},{2}\n".format(addr[1][0], addr[1][1].get('结构'), _common)
            return s

    #生成 'icconfigsaddr.h' 'icconfigsaddr.cpp'
    def outputConfigAddr(self):
#        try:      
        distictList = []
        for addr in self.__enumDict['ICAddr']:
            if len(addr[1]) == 2:
                struct = addr[1][1].get('结构')
                if not struct:
                    continue
                if struct not in distictList:
                    distictList.append(struct)
                if not self.__Dict.get(struct):
                    self.__Dict[struct] = []
                self.__Dict[struct] .append(addr)
            elif (int)(addr[0]) > self.Section_End:
                pass
            header = '''#include "icaddrwrapper.h"

'''
#            tail ='\n\n\n#endif // ICCONFIGSADDR_H\n'
        self.__writeHandle.write(header)
        self.__externHandle.write(header)
        for addr in self.__enumDict['ICAddr']:
            if len(addr[1]) == 2:
                struct = addr[1][1].get('结构')
                common = addr[1][1].get('名字')
                if struct:
                    rs = self.getChildrenContent(struct)
                    index =  self.__Dict[struct].index(addr)
                    #print("test:", addr, rs, index, struct)

                    self.writeData(rs, index, addr, common)
#                    for l in rs:
#                        print(l[0].get('size'))
#                    print("debug..............")
                else:
                    pass

#        self.__writeHandle.write(tail)
        self.__addrLog.close()
        self.__externHandle.close()
        self.__writeHandle.close()

    #处理静态数据结构
    def parseStatic(self, firstline):
        static = []
        line = self.readLine()
        while not self.isEnd(line):
            if line != '\n' and not self.isStart(line):
                result  = self.parseLine(line, 'static')  
                if result:
                    static.append(result[1])
            line = self.readLine()
        self.__staticDict[re.findall('\w+', firstline)[-1]] = static
  
    #解析标准类型  enum,struct,union,static const    
    def parse(self):
        line = self.readLine()
        while line:
            if 'enum' in line :
                self.parseEnum()
            elif 'struct' in line:
                self.parseStruct()
            elif 'union' in line:
                self.parseUnion()
            elif 'static const' in line:
                self.parseStatic(line)
            line = self.readLine()
class parseWapper:
    def __init__(self, fileName):
        self.__wapperHandle = open(fileName, encoding='utf-8')
        self.enumList = []
        self.className = None #类名
        self.isBlock = False
        self.parse()
        
    def readLine(self):
        return self.__wapperHandle.readline()
 
    def parseLine(self, line, string):
        __sparator = None
        if string == "enum":
            __sparator = enCommaStr
        elif string == "struct":
            __sparator = enSeparateStr
        elif string == "union":
            __sparator = enSeparateStr
        elif string == "static":
            __sparator = enCommaStr
        rs = []
        value = 0
        if spaceStr  in line:
            line = line.strip(spaceStr)
        if tabStr  in line:
            line = line.strip(tabStr)
        if lfStr in line:
            line = line.strip(lfStr)
        if line[0:2] == '//': 
            return
        elif line[0:2] == startBlock: 
            self.isBlock = True
        if endBlock in line: 
            self.isBlock = False
            return
        if self.isBlock:
            return      
        if zhSeparateStr in line:
            line = line.replace(zhSeparateStr, enSeparateStr)
        if zhColonStr in line:
            line = line.replace(zhColonStr, enColonStr)
        if zhCommaStr in line:
            line = line.replace(zhCommaStr, enCommaStr)  
        l = []
        index =  line.find(__sparator)
        if index != -1:
            l.append(line[0:index])
            comment = line[index + 1: len(line)]
            if comment: 
                l.append(comment)
        else:
            index =  line.find(spaceStr)
            if index != -1:
                l.append(line[0:index])
                comment = line[index + 1: len(line)]
                if comment: 
                    l.append(comment)
            else:
                print("no comment")
        #        print(l)
        for _l in l:
            if commonStr  in _l:
                if spaceStr in _l:
                    _l = _l.replace(spaceStr, '')
                _l = _l.strip(commonStr)
                _l = _l.split(enSeparateStr)
                if '' in _l:
                    _l.remove('')
                _dict = {}
                for __l in _l:
                    temp = __l.split(enColonStr)
                    if len(temp) != 2:
                        _dict['common'] = temp[0]
                    else:
                        _dict[temp[0]] = temp[1]
                if len(_dict):
                    rs.append(_dict)
            else:    
                if equalStr in _l:
                        _l = _l.split(equalStr)
                        rs.append(_l[0])
                        value = int(_l[1])    #        print(rs)
                elif spaceStr in _l:
                    index = _l.find(spaceStr)
                    _dict = {}
                    _dict['type'] = _l[0:index]
                    second = _l[index+1:len(_l)] 
                    if enColonStr in second:
                        second = second.split(enColonStr)
                        _dict['name'] = second[0]
                        _dict['size'] = second[1]
                    elif _l[0:index] == 'uint16_t':
                        _dict['type'] = 'uint32_t'
                        _dict['name'] = second
                        _dict['size'] = 16
                    elif re.search('\w+\[\d+\]', second):
                        _dict['name'] = re.search('\w+', second).group()
                        _array = re.search('\[\d+\]', second).group()
                        _dict['length'] = re.search('\d+', _array).group()
                    else:
                        _dict['name'] = _l[index+1:len(_l)] 
                    rs.append(_dict)
                else:
                    rs.append(_l)

        if rs:
            return value, rs
    def parseEnum(self, first):
        enum = []
        count = 0
        line = self.readLine()
        while not self.isEnd(line):
            if line != '\n':
                result  = self.parseLine(line, "enum")  
                if result:
                    value = result[0]
                    if value:
                        count = int(value)
                    enum.append([count, result[1]])
                    count = count + 1

            line = self.readLine()
#        print(re.findall('IC\w+', first))
        self.enumList.append((re.findall('IC\w+', first), enum))
    def isStart(self, s):
        return '{' in s;
    
    def isEnd(self, s):
        return '}' in s;
    
    def parse(self):
        line = self.readLine()
        while line:
            if 'enum' in line:
                self.parseEnum(line)
            if 'class' in line:
                self.className = re.findall('\w+', line.strip(lfStr))[2]
            line = self.readLine()


usage = 'usage: \n\
    python3 {0}  hccommparagenericdef.h icaddrwrapper.h icdefaultconfig.txt  icaddrwrapperdir dbdir\n\
output file:\n\
    db.sql  icaddrwrapper.h icaddrwrapper.cpp'.format(sys.argv[0].split('/')[-1])



if len(sys.argv) != 6:
    print(usage)
    sys.exit()

import os
addrFile = sys.argv[1]
wapperFile = sys.argv[2]
defaultValueFile = sys.argv[3]
wapperDirFile = (sys.argv[4])
dbDirFile = (sys.argv[5])

cmd = parseCmd(addrFile, defaultValueFile, wapperDirFile, dbDirFile )
wapper = parseWapper(wapperFile)
cmd.outputConfigAddr()
cmd.mergeDefaultValue(defaultValueFile)
cmd.parseDefaultConfig(defaultValueFile)
cmd.generateSql()

