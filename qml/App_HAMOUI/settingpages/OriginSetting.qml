import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/ConfigDefines.js" as ConfigDefines
import "../configs/AxisDefine.js" as AxisDefine
import "../ICOperationLog.js" as ICOperationLog
import "../teach/ManualProgramManager.js" as ManualProgramManager
import "../teach/Teach.js" as Teach


Item {

    id:container
    width: parent.width
    height: parent.height
    property variant originMode: [a0mode,a1mode,a2mode,a3mode,a4mode,a5mode,a6mode,a7mode];
    property variant originOrder: [a0order,a1order,a2order,a3order,a4order,a5order,a6order,a7order];
    property variant originSpeed: [a0speed,a1speed,a2speed,a3speed,a4speed,a5speed,a6speed,a7speed];
    property variant returnOrder: [a0returnorder,a1returnorder,a2returnorder,a3returnorder,a4returnorder,a5returnorder,a6returnorder,a7returnorder];
    property variant returnSpeed: [a0returnspeed,a1returnspeed,a2returnspeed,a3returnspeed,a4returnspeed,a5returnspeed,a6returnspeed,a7returnspeed];
    QtObject{
        id:pdata
        property int configNameWidth: 45
    }
    Column{
        spacing: 12
            Column{
                x:20
                spacing: 12
                Text{
                    text:qsTr("Origin Order:0 == first,1==second");
                    visible: a0text.visible
                }
                Text{
                    text:qsTr("Return Order:0 == first,1==second");
                    visible: a0text.visible
                }
            }

        Grid{
            id:structContainer
            rows: 9
            columns: 8

            spacing: 6

            Text{
                text:" ";
            }
            Text{
                id:mode;
                text: qsTr("Origin Mode");
            }
            Text{
                id:origin_order;
                text: qsTr("Origin Order");
            }
            Text{
                id:speed;
                text: qsTr("Origin Speed");
            }
            Text{
                text:" ";
            }
            Text{
                id:return_order;
                text: qsTr("Return Order");
            }
            Text{
                id:return_speed;
                text: qsTr("Return Speed");
            }
            Text{
                text:" ";
            }



            Text{
                id:a0text;
                text: AxisDefine.axisInfos[0].name;
            }
            ICComboBoxConfigEdit{
                id:a0mode
                visible: a0text.visible
                configValue: parseInt(panelRobotController.getCustomSettings("a0mode",0,"originMode"));
                z:80
                items: [qsTr("short"),qsTr("long")]
            }
            ICLineEdit{
                id:a0order
                visible: a0text.visible
                max:10
                text: panelRobotController.getCustomSettings("a0order",0,"originOrder");
            }
            ICLineEdit{
                id:a0speed
                visible: a0text.visible
                max:100
                text: panelRobotController.getCustomSettings("a0speed",10,"originSpeed");
            }
            Text{
                text:"%";
                visible: a0text.visible
            }
            ICLineEdit{
                id:a0returnorder
                visible: a0text.visible
                max:10
                text: panelRobotController.getCustomSettings("a0returnorder",0,"returnOrder");
            }
            ICLineEdit{
                id:a0returnspeed
                visible: a0text.visible
                max:100
                text: panelRobotController.getCustomSettings("a0returnspeed",10,"returnSpeed");
            }
            Text{
                text:"%";
                visible: a0text.visible
            }



            Text{
                id:a1text;
                text: AxisDefine.axisInfos[1].name;
            }
            ICComboBoxConfigEdit{
                id:a1mode
                visible: a1text.visible
                configValue: parseInt(panelRobotController.getCustomSettings("a1mode",0,"originMode"));
                z:70
                items: [qsTr("short"),qsTr("long")]
            }
            ICLineEdit{
                id:a1order
                visible: a1text.visible
                max:10
                text: panelRobotController.getCustomSettings("a1order",1,"originOrder");
            }
            ICLineEdit{
                id:a1speed
                visible: a1text.visible
                max:100
                text: panelRobotController.getCustomSettings("a1speed",10,"originSpeed");
            }
            Text{
                text:"%";
                visible: a1text.visible
            }
            ICLineEdit{
                id:a1returnorder
                visible: a1text.visible
                max:10
                text: panelRobotController.getCustomSettings("a1returnorder",1,"returnOrder");
            }
            ICLineEdit{
                id:a1returnspeed
                visible: a1text.visible
                max:100
                text: panelRobotController.getCustomSettings("a1returnspeed",10,"returnSpeed");
            }
            Text{
                text:"%";
                visible: a1text.visible
            }


            Text{
                id:a2text;
                text: AxisDefine.axisInfos[2].name;
            }
            ICComboBoxConfigEdit{
                id:a2mode
                visible: a2text.visible
                configValue: parseInt(panelRobotController.getCustomSettings("a2mode",0,"originMode"));
                z:60
                items: [qsTr("short"),qsTr("long")]

            }
            ICLineEdit{
                id:a2order
                visible: a2text.visible
                max:10
                text: panelRobotController.getCustomSettings("a2order",2,"originOrder");
            }
            ICLineEdit{
                id:a2speed
                visible: a2text.visible
                max:100
                text: panelRobotController.getCustomSettings("a2speed",10,"originSpeed");
            }
            Text{
                text:"%";
                visible: a2text.visible
            }
            ICLineEdit{
                id:a2returnorder
                visible: a2text.visible
                max:10
                text: panelRobotController.getCustomSettings("a2returnorder",2,"returnOrder");
            }
            ICLineEdit{
                id:a2returnspeed
                visible: a2text.visible
                max:100
                text: panelRobotController.getCustomSettings("a2returnspeed",10,"returnSpeed");
            }
            Text{
                text:"%";
                visible: a2text.visible
            }


            Text{
                id:a3text;
                text: AxisDefine.axisInfos[3].name;
            }
            ICComboBoxConfigEdit{
                id:a3mode
                visible: a3text.visible
                configValue: parseInt(panelRobotController.getCustomSettings("a3mode",0,"originMode"));
                z:50
                items: [qsTr("short"),qsTr("long")]

            }
            ICLineEdit{
                id:a3order
                visible: a3text.visible
                max:10
                text: panelRobotController.getCustomSettings("a3order",3,"originOrder");
            }
            ICLineEdit{
                id:a3speed
                visible: a3text.visible
                max:100
                text: panelRobotController.getCustomSettings("a3speed",10,"originSpeed");
            }
            Text{
                text:"%";
                visible: a3text.visible
            }
            ICLineEdit{
                id:a3returnorder
                visible: a3text.visible
                max:10
                text: panelRobotController.getCustomSettings("a3returnorder",3,"returnOrder");
            }
            ICLineEdit{
                id:a3returnspeed
                visible: a3text.visible
                max:100
                text: panelRobotController.getCustomSettings("a3returnspeed",10,"returnSpeed");
            }
            Text{
                text:"%";
                visible: a3text.visible
            }


            Text{
                id:a4text;
                text: AxisDefine.axisInfos[4].name;
            }
            ICComboBoxConfigEdit{
                id:a4mode
                visible: a4text.visible
                configValue: parseInt(panelRobotController.getCustomSettings("a4mode",0,"originMode"));
                z:40
                items: [qsTr("short"),qsTr("long")]

            }
            ICLineEdit{
                id:a4order
                visible: a4text.visible
                max:10
                text: panelRobotController.getCustomSettings("a4order",4,"originOrder");
            }
            ICLineEdit{
                id:a4speed
                visible: a4text.visible
                max:100
                text: panelRobotController.getCustomSettings("a4speed",10,"originSpeed");
            }
            Text{
                text:"%";
                visible: a4text.visible
            }
            ICLineEdit{
                id:a4returnorder
                visible: a4text.visible
                max:10
                text: panelRobotController.getCustomSettings("a4returnorder",4,"returnOrder");
            }
            ICLineEdit{
                id:a4returnspeed
                visible: a4text.visible
                max:100
                text: panelRobotController.getCustomSettings("a4returnspeed",10,"returnSpeed");
            }
            Text{
                text:"%";
                visible: a4text.visible
            }



            Text{
                id:a5text;
                text: AxisDefine.axisInfos[5].name;
            }
            ICComboBoxConfigEdit{
                id:a5mode
                visible: a5text.visible
                configValue: parseInt(panelRobotController.getCustomSettings("a5mode",0,"originMode"));
                z:30
                items: [qsTr("short"),qsTr("long")]

            }
            ICLineEdit{
                id:a5order
                visible: a5text.visible
                max:10
                text: panelRobotController.getCustomSettings("a5order",5,"originOrder");
            }
            ICLineEdit{
                id:a5speed
                visible: a5text.visible
                max:100
                text: panelRobotController.getCustomSettings("a5speed",10,"originSpeed");
            }
            Text{
                text:"%";
                visible: a5text.visible
            }
            ICLineEdit{
                id:a5returnorder
                visible: a5text.visible
                max:10
                text: panelRobotController.getCustomSettings("a5returnorder",5,"returnOrder");
            }
            ICLineEdit{
                id:a5returnspeed
                visible: a5text.visible
                max:100
                text: panelRobotController.getCustomSettings("a5returnspeed",10,"returnSpeed");
            }
            Text{
                text:"%";
                visible: a5text.visible
            }



            Text{
                id:a6text;
                text: AxisDefine.axisInfos[6].name;
            }
            ICComboBoxConfigEdit{
                id:a6mode
                visible: a6text.visible
                configValue: parseInt(panelRobotController.getCustomSettings("a6mode",0,"originMode"));
                z:20
                items: [qsTr("short"),qsTr("long")]

            }
            ICLineEdit{
                id:a6order
                visible: a6text.visible
                max:10
                text: panelRobotController.getCustomSettings("a6order",6,"originOrder");
            }
            ICLineEdit{
                id:a6speed
                visible: a6text.visible
                max:100
                text: panelRobotController.getCustomSettings("a6speed",10,"originSpeed");
            }
            Text{
                text:"%";
                visible: a6text.visible
            }
            ICLineEdit{
                id:a6returnorder
                visible: a6text.visible
                max:10
                text: panelRobotController.getCustomSettings("a6returnorder",6,"returnOrder");
            }
            ICLineEdit{
                id:a6returnspeed
                visible: a6text.visible
                max:100
                text: panelRobotController.getCustomSettings("a6returnspeed",10,"returnSpeed");
            }
            Text{
                text:"%";
                visible: a6text.visible
            }


            Text{
                id:a7text;
                text: AxisDefine.axisInfos[7].name;
            }
            ICComboBoxConfigEdit{
                id:a7mode
                visible: a7text.visible
                configValue: parseInt(panelRobotController.getCustomSettings("a7mode",0,"originMode"));
                z:10
                items: [qsTr("short"),qsTr("long")]
            }
            ICLineEdit{
                id:a7order
                visible: a7text.visible
                max:10
                text: panelRobotController.getCustomSettings("a7order",7,"originOrder");
            }
            ICLineEdit{
                id:a7speed
                visible: a7text.visible
                max:100
                text: panelRobotController.getCustomSettings("a7speed",10,"originSpeed");
            }
            Text{
                text:"%";
                visible: a7text.visible
            }
            ICLineEdit{
                id:a7returnorder
                visible: a7text.visible
                max:10
                text: panelRobotController.getCustomSettings("a7returnorder",7,"returnOrder");
            }
            ICLineEdit{
                id:a7returnspeed
                visible: a7text.visible
                max:100
                text: panelRobotController.getCustomSettings("a7returnspeed",10,"returnSpeed");
            }
            Text{
                text:"%";
                visible: a7text.visible
            }

        }
        ICButton{
            id:safe
            x:20
            text:qsTr("Safe")
            onButtonClicked: {
                var origin_Setting;
                var originList=[[],[],[],[],[],[],[],[],[],[]];
                var returnList=[[],[],[],[],[],[],[],[],[],[]];
                var m;
                for(var i=0;i<AxisDefine.usedAxisNum();i++)
                {
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="mode";
                    panelRobotController.setCustomSettings(origin_Setting, originMode[i].text, "originMode", false);
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="order";
                    m = parseInt(originOrder[i].text);
                    if(m>=0&&m<=10)originList[m].push(i);
                    panelRobotController.setCustomSettings(origin_Setting, originOrder[i].text, "originOrder", false);
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="speed";
                    panelRobotController.setCustomSettings(origin_Setting, originSpeed[i].text, "originSpeed", false);
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="returnorder";
                    m = parseInt(returnOrder[i].text);
                    if(m>=0&&m<=10)returnList[m].push(i);
                    panelRobotController.setCustomSettings(origin_Setting, returnOrder[i].text, "returnOrder", false);
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="returnspeed";
                    panelRobotController.setCustomSettings(origin_Setting, returnSpeed[i].text, "returnSpeed", true);
                }

                //console.log(JSON.stringify(originList));
                //console.log(JSON.stringify(returnList));
                var originOp = ManualProgramManager.manualProgramManager.getProgram(0);
                var returnOp = ManualProgramManager.manualProgramManager.getProgram(1);
                var temp;
                originOp.program=[];
                returnOp.program=[];
                for(var i=0;i<10;i++)
                {
                    switch(originList[i].length)
                    {
                    case 0:break;
                    case 1:
                        temp = originList[i][0];
                        originOp.program.push(Teach.generateOriginAction(
                                                  Teach.actions.F_CMD_FINE_ZERO,
                                                  temp,
                                                  originMode[temp].configValue+2,
                                                  originSpeed[temp].text,
                                                  0
                                               ));
                        break;
                    default:
                        originOp.program.push(Teach.generateSyncBeginAction());
                        for(var n=0;n<originList[i].length;n++)
                        {
                            temp = originList[i][n];
                            originOp.program.push(Teach.generateOriginAction(
                                                      Teach.actions.F_CMD_FINE_ZERO,
                                                      temp,
                                                      originMode[temp].configValue+2,
                                                      originSpeed[temp].text,
                                                      0
                                                   ));
                        }
                        originOp.program.push(Teach.generateSyncEndAction());
                        break;
                    }

                    switch(returnList[i].length)
                    {
                    case 0:continue;
                    case 1:
                        temp = returnList[i][0];
                        returnOp.program.push(Teach.generateAxisServoAction(
                                                  Teach.actions.F_CMD_SINGLE,
                                                  temp,
                                                  0,
                                                  returnSpeed[temp].text,
                                                  0
                                               ));
                        break;
                    default:
                        returnOp.program.push(Teach.generateSyncBeginAction());
                        for(var n=0;n<returnList[i].length;n++)
                        {
                            temp = returnList[i][n];
                            returnOp.program.push(Teach.generateAxisServoAction(
                                                      Teach.actions.F_CMD_SINGLE,
                                                      temp,
                                                      0,
                                                      returnSpeed[temp].text,
                                                      0
                                                   ));
                        }
                        returnOp.program.push(Teach.generateSyncEndAction());
                        break;
                    }
                }
                originOp.program.push(Teach.generteEndAction());
                returnOp.program.push(Teach.generteEndAction());
                console.log(JSON.stringify(originOp.program));
                console.log(JSON.stringify(returnOp.program));
                ManualProgramManager.manualProgramManager.updateProgram(originOp.id, originOp.name, originOp.program);
                ManualProgramManager.manualProgramManager.updateProgram(returnOp.id, returnOp.name, returnOp.program);
                panelRobotController.manualRunProgram(JSON.stringify(ManualProgramManager.manualProgramManager.getProgram(0).program),
                                                      "","", "", "", 19, false);
                panelRobotController.manualRunProgram(JSON.stringify(ManualProgramManager.manualProgramManager.getProgram(1).program),
                                                      "","", "", "", 18, false);



            }
        }
    }
    Component.onCompleted: {
        AxisDefine.registerMonitors(container);
        onAxisDefinesChanged();
    }
    function onAxisDefinesChanged(){
        a0text.visible = AxisDefine.axisInfos[0].visiable;
        a1text.visible = AxisDefine.axisInfos[1].visiable;
        a2text.visible = AxisDefine.axisInfos[2].visiable;
        a3text.visible = AxisDefine.axisInfos[3].visiable;
        a4text.visible = AxisDefine.axisInfos[4].visiable;
        a5text.visible = AxisDefine.axisInfos[5].visiable;
        a6text.visible = AxisDefine.axisInfos[6].visiable;
        a7text.visible = AxisDefine.axisInfos[7].visiable;
    }
}

