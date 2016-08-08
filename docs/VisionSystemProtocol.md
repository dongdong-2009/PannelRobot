华成手控系统与视觉系统通信协议
===========================

所有的通信帧都为JSON格式

## 1. 位置数据格式

```javascript
{
    "dsID":"www.geforcevision.com.cam", //唯一标识,我要用来区别不同的数据源
    "dsData":
    [
        {
            "camID":"0",
            "data":
            [
                {"ModelID":"0","X":"888.001","Y":"1345.001","Angel":"123.123","ExtValue_0":null,"ExtValue_1":null},
                {"ModelID":"1","X":"888.001","Y":"1345.001","Angel":"123.123","ExtValue_0":null,"ExtValue_1":null},
                {"ModelID":"2","X":"888.001","Y":"1345.001","Angel":"123.123","ExtValue_0":null,"ExtValue_1":null},
                {"ModelID":"3","X":"888.001","Y":"1345.001","Angel":"123.123","ExtValue_0":null,"ExtValue_1":null}
            ]
        },
        {
            "camID":"1",
            "data":
            [
                {"ModelID":"0","X":"888.001","Y":"1345.001","Angel":"123.123","ExtValue_0":null,"ExtValue_1":null},
                {"ModelID":"1","X":"888.001","Y":"1345.001","Angel":"123.123","ExtValue_0":null,"ExtValue_1":null},
                {"ModelID":"2","X":"888.001","Y":"1345.001","Angel":"123.123","ExtValue_0":null,"ExtValue_1":null},
                {"ModelID":"3","X":"888.001","Y":"1345.001","Angel":"123.123","ExtValue_0":null,"ExtValue_1":null}
            ]
        },
    ]
}
```

ExtValue_1:代表相似度

## 2. 标定

标定的工作过程:
1).标定纸上我们标了标记,每个标记有一个序号.
2).用户在从我们机械手的控制器中移动机械手到指定的序号, 点击按钮保存下该序号的世界坐标位置.用户把所要标定的点都执行这个操作
3).用户在视觉系统上,把每个标定点的图像位置都设定好
4).用户在机械手控制器中点击开始标定, 机械手系统会按照上面格式把标定点的数据都发送给视觉系统.标定完成.

标定格式

```javascript
{
    "dsID":"www.geforcevision.com.cam",
    "reqType":"standardize", //命令类型:标定
    "camID":0,
    "data":
    [
        { "X":0.000,"Y":0.000 }, //第1个点的机械手的世界坐标
        { "X":0.000,"Y":0.000 }, //第2个点的机械手的世界坐标
        { "X":0.000,"Y":0.000 }, //...
    ]
}
```

## 3. 通信拍照

```javascript
{
    "dsID":"www.geforcevision.com.cam",
    "reqType":"photo", //命令类型:拍照
    "camID":0,
}
```


## 4. 请求模板信息

我们系统发送如下请求获取模板信息的命令:

```javascript
{
    "dsID":"www.geforcevision.com.cam",
    "reqType":"listModel", //命令类型:获取模板信息
}
```

视觉系统按如下格式回传:


```javascript
{
    "dsID":"www.geforcevision.com.cam",
    "reqType":"listModel", //命令类型:获取模板信息
    "currentModel":{"name":"模板名称", "modelID":0}
    "data":
    [
        {
            "name":"模板名称",
            "models":
            [
                {"id":0, "offsetX":1.000, "offsetY":2.000, "offsetA":3.000, "modelImgPath":"http://图片在视觉服务器系统中的路径.png"},
                {"id":1, "offsetX":1.000, "offsetY":2.000, "offsetA":3.000, "modelImgPath":"http://图片在视觉服务器系统中的路径.png"},
                ...
            ]
        },
        {
            "name":"模板名称",
            "models":
            [
                {"id":0, "offsetX":1.000, "offsetY":2.000, "offsetA":3.000, "modelImgPath":"http://图片在视觉服务器系统中的路径.png"},
                {"id":1, "offsetX":1.000, "offsetY":2.000, "offsetA":3.000, "modelImgPath":"http://图片在视觉服务器系统中的路径.png"},
                ...
            ]
        },
        ...
    ]
}
```

## 5. 设置模板偏移

我们系统向视觉系统发送如下格式来改变模板的偏移值

```javascript
{
    "dsID":"www.geforcevision.com.cam",
    "reqType":"setModelOffset", //命令类型:设定模板偏移
    "name":"模板名称",
    "model":0, //模板里面的模型ID
    "offsetX": 1.000,
    "offsetY": 2.000,
    "offsetA": 3.000
}
```

## 6. 选择模板

我们系统向视觉系统发送如下格式来改变视觉系统所使用的模板

```javascript
{
    "dsID":"www.geforcevision.com.cam",
    "reqType":"changeModel", //命令类型:选择模板
    "name":"模板名称",
    "model":0, //模板里面的模型ID
}
```





