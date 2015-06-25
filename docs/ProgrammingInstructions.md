编程指令说明
============
教导程序组成
------------
一套教导程序为一个JSON数组.其结构如下:
`
[
[指令对象,指令对象],[指令对象],.....
]
`
[]里面的指令同时运行,所有指令结束后才继续执行下一组指令.
指令对象为一个JSON对象,其共有如下的对象属性:
+ action
+ pos
+ speed
+ delay
+ limit
+ flag
+ point
+ isBadEn
+ isEarlyEnd
+ isEarlyDown
+ earlyEndPos
+ earlyDownSpeed
+ comment
+ childActions
