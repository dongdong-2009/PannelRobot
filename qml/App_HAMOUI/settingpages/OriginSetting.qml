import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/ConfigDefines.js" as ConfigDefines
import "../configs/AxisDefine.js" as AxisDefine
import "../ICOperationLog.js" as ICOperationLog


Item {

    id:container
    width: parent.width
    height: parent.height
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
                id:a0reutrnspeed
                visible: a0text.visible
                max:100
                text: panelRobotController.getCustomSettings("a0reutrnspeed",10,"returnSpeed");
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
                id:a1reutrnspeed
                visible: a1text.visible
                max:100
                text: panelRobotController.getCustomSettings("a1reutrnspeed",10,"returnSpeed");
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
                id:a2reutrnspeed
                visible: a2text.visible
                max:100
                text: panelRobotController.getCustomSettings("a2reutrnspeed",10,"returnSpeed");
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
                id:a3reutrnspeed
                visible: a3text.visible
                max:100
                text: panelRobotController.getCustomSettings("a3reutrnspeed",10,"returnSpeed");
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
                id:a4reutrnspeed
                visible: a4text.visible
                max:100
                text: panelRobotController.getCustomSettings("a4reutrnspeed",10,"returnSpeed");
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
                id:a5reutrnspeed
                visible: a5text.visible
                max:100
                text: panelRobotController.getCustomSettings("a5reutrnspeed",10,"returnSpeed");
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
                id:a6reutrnspeed
                visible: a6text.visible
                max:100
                text: panelRobotController.getCustomSettings("a6reutrnspeed",10,"returnSpeed");
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
                id:a7reutrnspeed
                visible: a7text.visible
                max:100
                text: panelRobotController.getCustomSettings("a7reutrnspeed",10,"returnSpeed");
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
                for(var i=0;i<AxisDefine.usedAxisNum();i++)
                {
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="mode";
                    console.log(origin_Setting);
                    console.log(JSON.stringify(structContainer));
                    panelRobotController.setCustomSettings(origin_Setting, structContainer[origin_Setting].text, "originMode", true);
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="order";
                    panelRobotController.setCustomSettings(origin_Setting, structContainer[origin_Setting].text, "originOrder", true);
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="speed";
                    panelRobotController.setCustomSettings(origin_Setting, structContainer[origin_Setting].text, "originSpeed", true);
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="returnorder";
                    panelRobotController.setCustomSettings(origin_Setting, structContainer[origin_Setting].text, "returnOrder", true);
                    origin_Setting="a";
                    origin_Setting += i;
                    origin_Setting+="returnspeed";
                    panelRobotController.setCustomSettings(origin_Setting, structContainer[origin_Setting].text, "returnSpeed", true);
                }

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

