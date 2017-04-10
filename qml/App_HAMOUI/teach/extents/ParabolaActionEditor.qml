import QtQuick 1.1
import "../../../ICCustomElement"
import "../../configs/AxisDefine.js" as AxisDefine
import "ExtentActionDefine.js" as ExtentActionDefine
import "../Teach.js" as Teach


ExtentActionEditorBase {
    id:instance
    width: content.width + 20
    height: content.height
    property alias ePos0: firAxis.configValue
    property alias ePos1: secAxis.configValue
    property alias endType: whichEnd.checkedIndex
    property alias surfaceType: whichSurface.checkedIndex
    property alias pL: pLEdit.configValue
    property alias a: aEdit.configValue
    property alias speed: speedEdit.configValue
    property alias delay: delayEdit.configValue

    property variant points: []

    onActionObjectChanged:{
        if(actionObject == null) return;
        if(actionObject.points.length >0)
            relPoint.isChecked = true;
        else{
            relPoint.isChecked = false;
            pointsSel.currentIndex = -1;
            return;
        }
        var pt = Teach.currentRecord.definedPoints.pointNameList();
        for(var i=0,len = pt.length;i<len;++i){
            if(actionObject.points[0].pointName == pt[i]){
                pointsSel.currentIndex = i;
                return;
            }
        }
        pointsSel.currentIndex = -1;


    }

    function syncPoints(){

        if(!relPoint.isChecked)
            points =  [];
        else if(pointsSel.currentIndex < 0)
            points = [];
        else{
            var pt = Teach.currentRecord.definedPoints.getPoint(pointsSel.currentText());
            points =  [{"pointName":pt.name, "pos":pt.point}];
        }
    }

    function onPointAdded(point){
        var pNL = Teach.currentRecord.definedPoints.pointNameList();
        var type;
        var fPNs = [];
        for(var i = 0; i < pNL.length; ++i){
            type = pNL[i][0];
            if(type === Teach.DefinePoints.kPT_Locus){
                fPNs.push(pNL[i]);
            }
        }
        pointsSel.items = fPNs;

    }

    function onPointDeleted(point){
        onPointAdded(point);
    }

    function onPointsCleared(){
        onPointAdded(null);
    }

    function onPointChanged(point){
        onPointAdded(point);
    }

    Column{
        id:content
        spacing: 6

        ICButtonGroup{
            id:whichSurface
            spacing: 6
            mustChecked: true
            checkedIndex: 0
            checkedItem: xySurface
            ICCheckBox{
                id:xySurface
                text: qsTr("XY")
                isChecked: true
            }
            ICCheckBox{
                id:xzSurface
                text: qsTr("XZ")
            }
            ICCheckBox{
                id:yzSurface
                text: qsTr("YZ")
            }
        }

        Row{
            width: 398
            spacing: 6
            ICCheckBox{
                id:relPoint
                text: qsTr("Rel Points")
                onIsCheckedChanged: {
                    syncPoints();
//                    console.log(pointSet.width);
                }
            }

            ICConfigEdit{
                id:firAxis
                configName: whichSurface.checkedIndex == 2?"Y":"X"
                configValue: "0.000"
                visible: !relPoint.isChecked
            }
            ICConfigEdit{
                id:secAxis
                configName: whichSurface.checkedIndex == 0?"Y":"Z"
                configValue: "0.000"
                visible: !relPoint.isChecked
            }

            ICComboBox{
                id:pointsSel
                visible: relPoint.isChecked
                onCurrentIndexChanged:  {
                    syncPoints();
                }
            }

            ICButton{
                id:setIn
                text: qsTr("Set In")
                visible:!relPoint.isChecked
                onButtonClicked: {
                    var f = whichSurface.checkedIndex == 2?1:0;
                    var s = whichSurface.checkedIndex == 0?1:2;
                    firAxis.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[f].wAddr) / 1000).toFixed(3);
                    secAxis.configValue = (panelRobotController.statusValue(AxisDefine.axisInfos[s].wAddr) / 1000).toFixed(3);
                }
                height: relPoint.height
            }
        }
        Row{
            Text {
                text:qsTr("End type")
            }
            ICButtonGroup{
                id:whichEnd
                spacing: 6
                mustChecked: true
                checkedIndex: 0
                checkedItem: xySurface
                ICCheckBox{
                    id:stopOnPos
                    text: qsTr("On")
                    isChecked: true
                }
                ICCheckBox{
                    id:stopbeforePos
                    text: qsTr("Before")
                }
                ICCheckBox{
                    id:stopAfterPos
                    text: qsTr("After")
                }
            }
        }
        Row{
            spacing: 10
            ICConfigEdit{
                id:pLEdit
                configName: qsTr("period len")
                configValue: "0.000"
                min:0
                decimal: 3
            }
            ICConfigEdit{
                id:aEdit
                configNameWidth: pLEdit.configNameWidth
                configName: qsTr("A")
                configValue: "0.000"
                min:0
                decimal: 3
            }
        }
        Row{
            spacing: 10
            ICConfigEdit{
                id:speedEdit
                configNameWidth: pLEdit.configNameWidth
                configName: qsTr("speed")
                configValue: "80.0"
                configAddr: "s_rw_1_31_1_289"
            }
            ICConfigEdit{
                id:delayEdit
                configNameWidth: pLEdit.configNameWidth
                configName: qsTr("delay")
                configValue: "0.00"
                min:0
                decimal: 2
            }
        }
    }
    onVisibleChanged: {
        if(visible){
            onPointAdded(null);
        }
    }
    function onTeachInited(){
        Teach.currentRecord.definedPoints.registerPointsMonitor(instance);
        onPointAdded(null);
    }

    Component.onCompleted: {
        bindActionDefine(ExtentActionDefine.extentParabolaAction);
        if(Teach.currentRecord == null)
            Teach.registerWatiTeachInitedObj(instance);
        else
            onTeachInited();
    }
}
