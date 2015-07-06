编程指令说明
============
教导程序组成
------------
一套教导程序为一个JSON数组.其结构如下:
`
[
指令对象,指令对象,指令对象,.....
]
`
指令对象为一个JSON对象,其共有如下的对象属性:
+ action
  - 同步开始:126
  - 同步结束:127
  - 序列开始:31
  - 序列结束:125
+ pos
+ speed
+ delay
+ limit
+ holdTime
+ flag
+ point
+ isBadEn
+ isEarlyEnd
+ isEarlyDown
+ earlyEndPos
+ earlyDownSpeed
+ comment
+ pointStatus
