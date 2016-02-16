import QtQuick 1.1
import "../../ICCustomElement"
import "PointEdit.js" as PData
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../../utils/utils.js" as Utils


Item {
    id:container
    property bool isEditorMode: false
    property variant points: []
    property int action: -1
    function createPoint(name, point){
        return {"pos":point, "pointName":name};
    }

    function usedMotorCount(){
        var ret = 0;
        if(motor0.isChecked)
            ++ret;
        if(motor1.isChecked)
            ++ret;
        if(motor2.isChecked)
            ++ret;
        if(motor3.isChecked)
            ++ret;
        if(motor4.isChecked)
            ++ret;
        if(motor5.isChecked)
            ++ret;
        return ret;
    }

    function getPoints(){
        var ret = [];
        var mP;
        for(var i = 0; i < pointViewModel.count; ++i){
            mP = Utils.cloneObject(pointViewModel.get(i));
            ret.push(createPoint(mP.pointName, mP.pos));
        }
        return ret;
    }

    function getSpeed(){
        return speed.configValue;
    }

    function getDelay(){
        return delay.configValue;
    }

    function refreshSelectablePoisnts(points){
        selReferenceName.configValue = -1;
        selReferenceName.items = points;
    }

    function isPoseMode(){
        return singlePoseType.isChecked || pose3DType.isChecked;
    }

    function clearPoints(){
        pointViewModel.clear();
    }

    function getAction(){

    }

    function onPointChanged(point){
        console.log(Teach.definedPoints.pointDescr(point));
        refreshSelectablePoisnts(Teach.definedPoints.pointNameList());
    }

//    onVisibleChanged: {
//        if(visible){
//            refreshSelectablePoisnts(Teach.definedPoints.pointNameList());
//            //            if(!isEditorMode){
//            //                clearPoints();
//            //            }
//        }
//    }

    onActionChanged: {
        if(action < 0) return;
        if(action == Teach.actions.F_CMD_LINE2D_MOVE_POINT){
            line2DType.setChecked(true);
        }else if(action == Teach.actions.F_CMD_LINE3D_MOVE_POINT){
            line3DType.setChecked(true);
        }else if(action == Teach.actions.F_CMD_ARC3D_MOVE_POINT){
            curve3DType.setChecked(true);
        }else if(action == Teach.actions.F_CMD_MOVE_POSE){
            singlePoseType.setChecked(true);
        }else if(action == Teach.actions.F_CMD_LINE3D_MOVE_POSE){
            pose3DType.setChecked(true);
        }else if(action == Teach.actions.F_CMD_JOINTCOORDINATE){
            freePathType.setChecked(true);
        }else if(action == Teach.actions.F_CMD_COORDINATE_DEVIATION){
            offsetPathType.setChecked(true);
        }
    }

    onPointsChanged: {
        pointViewModel.clear();
        for(var i = 0; i < points.length; ++i){
            pointViewModel.append(points[i]);
        }
    }

    width: 710
    height: 200

    Row{
        id:leftCommandContainer
        spacing: 6
        enabled: !offsetPathType.isChecked
        ICButton{
            id:setIn
            text: qsTr("Set In")
            width: PData.commandBtnWidth
            onButtonClicked: {
                //                console.log("clicked");
                //                console.log(panelRobotController.getConfigValueText("c_ro_0_32_0_900"));
                if(freePathType.isChecked){
                    motor0.configValue = (panelRobotController.statusValue("c_ro_0_32_0_901") / 1000).toFixed(3);
                    motor1.configValue = (panelRobotController.statusValue("c_ro_0_32_0_905") / 1000).toFixed(3);
                    motor2.configValue = (panelRobotController.statusValue("c_ro_0_32_0_909") / 1000).toFixed(3);
                    motor3.configValue = (panelRobotController.statusValue("c_ro_0_32_0_913") / 1000).toFixed(3);
                    motor4.configValue = (panelRobotController.statusValue("c_ro_0_32_0_917") / 1000).toFixed(3);
                    motor5.configValue = (panelRobotController.statusValue("c_ro_0_32_0_921") / 1000).toFixed(3);

                }else{
                    motor0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                    motor1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                    motor2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                    motor3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                    motor4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                    motor5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                }
            }
        }
        ICButton{
            id:setZero
            text: qsTr("Zero")
            width: PData.commandBtnWidth
            onButtonClicked: {
                motor0.configValue = 0;
                motor1.configValue = 0;
                motor2.configValue = 0;
                motor3.configValue = 0;
                motor4.configValue = 0;
                motor5.configValue = 0;
            }
        }
    }
    Rectangle{
        id:motorSettingContainer
        anchors.top: leftCommandContainer.bottom
        anchors.topMargin: 6
        width: motor0.width * 2 + 6
        height: motor0.height * 3 + 12
        Grid{
            rows:3
            columns: 2
            spacing: 6
            flow: Grid.TopToBottom

            ICCheckableLineEdit{
                id:motor0
                configName: AxisDefine.axisInfos[0].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: PData.axisEditWidth
                configNameWidth: PData.axisNameWidth
                isEditable: false
                visible: false
            }
            ICCheckableLineEdit{
                id:motor1
                configName: AxisDefine.axisInfos[1].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: PData.axisEditWidth
                configNameWidth: PData.axisNameWidth
                isEditable: false
                visible: false


            }
            ICCheckableLineEdit{
                id:motor2
                configName: AxisDefine.axisInfos[2].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: PData.axisEditWidth
                configNameWidth: PData.axisNameWidth
                isEditable: false
                visible: false

            }
            ICCheckableLineEdit{
                id:motor3
                configName: AxisDefine.axisInfos[3].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: PData.axisEditWidth
                configNameWidth: PData.axisNameWidth
                isEditable: false
                visible: false


            }
            ICCheckableLineEdit{
                id:motor4
                configName: AxisDefine.axisInfos[4].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: PData.axisEditWidth
                configNameWidth: PData.axisNameWidth
                isEditable: false
                visible: false


            }
            ICCheckableLineEdit{
                id:motor5
                configName: AxisDefine.axisInfos[5].name
                configAddr: "s_rw_0_32_3_1300"
                inputWidth: PData.axisEditWidth
                configNameWidth: PData.axisNameWidth
                isEditable: false
                visible: false

            }
        }
    }
    Rectangle{
        id:leftHorSplitLine
        height: 1
        width: motorSettingContainer.width
        anchors.top: motorSettingContainer.bottom
        anchors.topMargin: 2
        color: "gray"
    }

    ICButtonGroup{
        id:pointModeContainer
        layoutMode: 1
        anchors.top: leftHorSplitLine.bottom
        //        anchors.topMargin: 1

        spacing: 2
        isAutoSize: false
        height: newReferenceName.height + selReferenceName.height + 2* spacing
        ICCheckableLineEdit{
            id:newReferenceName
            configName: qsTr("New Point:")
            configNameWidth: 120
            inputWidth: 160
            isNumberOnly: false
            visible: false
        }

        ICCheckableComboboxEdit{
            id:selReferenceName
            configName: qsTr("Select Point:")
            configNameWidth: 120
            inputWidth: newReferenceName.inputWidth
            popupMode: 1
            z: 2
        }
    }

    Row{
        id:speedAndDelayContainer
        spacing: 6
        anchors.top: pointModeContainer.bottom
        anchors.topMargin: 2
        visible: !isEditorMode
        ICConfigEdit{
            id:speed
            configName: qsTr("Speed")
            configAddr: "s_rw_0_32_1_1200"
            unit: qsTr("%")
            inputWidth: PData.speedEditWidth

        }
        ICConfigEdit{
            id:delay
            configName: qsTr("Delay")
            configAddr: "s_rw_0_32_2_1100"
            unit: qsTr("s")
            inputWidth: PData.delayEditWidth
        }
    }

    Rectangle{
        id:middleVercSplitLine
        width: 1
        height: 204
        color: "gray"
        anchors.left: motorSettingContainer.right
        anchors.leftMargin: 6
    }

    Rectangle{
        color: "#A0A0F0"
        id:rightCommandContainer
        anchors.left: middleVercSplitLine.right
        anchors.leftMargin: 2
        width: 400
        height: 60
        SequentialAnimation{
            id: flicker
            loops: 1
            PropertyAnimation{ targets: [motorSettingContainer];properties: "color";to:rightCommandContainer.color;duration: 300}
            PauseAnimation { duration: 200 }
            PropertyAnimation{ targets: [motorSettingContainer];properties: "color";to:"white";duration: 300}

            PropertyAnimation{ targets: [pointViewContainer];properties: "color";to:rightCommandContainer.color;duration: 300}
            PauseAnimation { duration: 200 }
            PropertyAnimation{ targets: [pointViewContainer];properties: "color";to:"white";duration: 300}
        }
        ICButtonGroup{
            layoutMode: 2
            isAutoSize: false
            mustChecked: true
            enabled: !isEditorMode
            onCheckedItemChanged: {
                motor0.setChecked(false);
                motor1.setChecked(false);
                motor2.setChecked(false);
                motor3.setChecked(false);
                motor4.setChecked(false);
                motor5.setChecked(false);
                motor0.isEditable = false;
                motor1.isEditable = false;
                motor2.isEditable = false;
                motor3.isEditable = false;
                motor4.isEditable = false;
                motor5.isEditable = false;

                pointViewModel.clear();
                //                motorSettingContainer.color = rightCommandContainer.color;
                flicker.start();
                if(checkedItem == line2DType){
                    motor0.setChecked(true);
                    motor1.setChecked(true);
                    pointViewModel.append(pointViewModel.createModelItem());
                    action = Teach.actions.F_CMD_LINE2D_MOVE_POINT;
                }else if(checkedItem == line3DType){
                    motor0.setChecked(true);
                    motor1.setChecked(true);
                    motor2.setChecked(true);
                    pointViewModel.append(pointViewModel.createModelItem());
                    action = Teach.actions.F_CMD_LINE3D_MOVE_POINT;
                }else if(checkedItem == curve3DType){
                    motor0.setChecked(true);
                    motor1.setChecked(true);
                    motor2.setChecked(true);
                    action = Teach.actions.F_CMD_ARC3D_MOVE_POINT;
                    pointViewModel.append(pointViewModel.createModelItem());
                    pointViewModel.append(pointViewModel.createModelItem());


                }else if(checkedItem == singlePoseType){
                    motor3.setChecked(true);
                    motor4.setChecked(true);
                    motor5.setChecked(true);
                    pointViewModel.append(pointViewModel.createModelItem());
                    action = Teach.actions.F_CMD_MOVE_POSE;

                }else if(checkedItem == pose3DType){
                    motor0.setChecked(true);
                    motor1.setChecked(true);
                    motor2.setChecked(true);
                    motor3.setChecked(true);
                    motor4.setChecked(true);
                    motor5.setChecked(true);
                    pointViewModel.append(pointViewModel.createModelItem());
                    action = Teach.actions.F_CMD_LINE3D_MOVE_POSE;
                }else if(checkedItem == freePathType){
                    motor0.setChecked(true);
                    motor1.setChecked(true);
                    motor2.setChecked(true);
                    motor3.setChecked(true);
                    motor4.setChecked(true);
                    motor5.setChecked(true);
                    motor0.isEditable = true;
                    motor1.isEditable = true;
                    motor2.isEditable = true;
                    motor3.isEditable = true;
                    motor4.isEditable = true;
                    motor5.isEditable = true;
                    pointViewModel.append(pointViewModel.createModelItem());
                    action = Teach.actions.F_CMD_JOINTCOORDINATE;
                }else if(checkedItem == offsetPathType){
                    motor0.setChecked(true);
                    motor1.setChecked(true);
                    motor2.setChecked(true);
                    pointViewModel.append(pointViewModel.createModelItem());
                    action = Teach.actions.F_CMD_COORDINATE_DEVIATION;
                }

                motor0.visible = motor0.isChecked;
                motor1.visible = motor1.isChecked;
                motor2.visible = motor2.isChecked;
                motor3.visible = motor3.isChecked;
                motor4.visible = motor4.isChecked;
                motor5.visible = motor5.isChecked;
            }

            Flow{
                width: 375
                spacing: 4
                x:4
                y:2
                ICCheckBox{
                    id:line2DType
                    text: qsTr("Line 2D")
                }
                ICCheckBox{
                    id:line3DType
                    text: qsTr("Line 3D")
                }
                ICCheckBox{
                    id:curve3DType
                    text:qsTr("Curve 3D")
                }
                ICCheckBox{
                    id:singlePoseType
                    text: qsTr("Pose")
                }
                ICCheckBox{
                    id:pose3DType
                    text: qsTr("Pose 3D")
                }
                ICCheckBox{
                    id:freePathType
                    text: qsTr("Free Path")
                }
                ICCheckBox{
                    id:offsetPathType
                    text: qsTr("Offset Move")
                }
            }
        }
    }
    Rectangle{
        id:pointViewContainer
        x:rightCommandContainer.x
        height: 142
        anchors.top: rightCommandContainer.bottom
        anchors.topMargin: 2
        width: 400
        border.width: 1
        border.color: "black"
        ListView{
            id:pointView
            width: parent.width
            height: parent.height
            currentIndex: -1
            y:2
            ListModel{
                id:pointViewModel

                function itemText(point, name){

                    var ret = "";
                    if(name.length !== 0){
                        ret = name + "(";
                    }

                    var m;
                    for(var i = 0; i < 6; ++i){
                        m = "m" + i;
                        if(point.hasOwnProperty(m)){
                            ret += AxisDefine.axisInfos[i].name + ":" + point[m] + ","
                        }
                    }
                    ret = ret.substr(0, ret.length - 1);
                    if(name.length !== 0){
                        ret += ")";
                    }
                    return ret;
                }

                function createModelItem(){
                    var ret = {};

                    if(motor0.isChecked)
                        ret.m0 = motor0.configValue;
                    if(motor1.isChecked)
                        ret.m1 = motor1.configValue;
                    if(motor2.isChecked)
                        ret.m2 = motor2.configValue;
                    if(motor3.isChecked)
                        ret.m3 = motor3.configValue;
                    if(motor4.isChecked)
                        ret.m4 = motor4.configValue;
                    if(motor5.isChecked)
                        ret.m5 = motor5.configValue;
                    var pointName = "";
                    if(newReferenceName.isChecked){
                        var point = Teach.definedPoints.addNewPoint(newReferenceName.configValue,
                                                                    ret);
                        pointName = point.name;
                        refreshSelectablePoisnts(Teach.definedPoints.pointNameList());
                    }else if(selReferenceName.isChecked){
                        ret = Teach.definedPoints.getPoint(selReferenceName.configText()).point;
                        pointName = selReferenceName.configText();
                    }

                    return createPoint(pointName, ret);
                }
            }
            model: pointViewModel
            highlight: Rectangle {x:1;y:1;width: pointView.width -1;height: 24; color: "lightsteelblue"; }

            delegate: Column{
                spacing: 4
                x:2
                ICButton{
                    width: 180
                    text: {
                        if(pointViewModel.count > 1){
                            if(index == 0){
                                return qsTr("Set to Middle Point")
                            }
                        }
                        return qsTr("Set to End");
                    }
                    onButtonClicked: {
                        pointViewModel.set(index, pointViewModel.createModelItem());
                    }
                }
                Text {
                    text:pointViewModel.itemText(model.pos, model.pointName)
                    wrapMode: Text.Wrap
                    width: pointView.width
                    height: 32
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                }

            }
        }
    }
    Component.onCompleted: {
        setZero.clicked();
        Teach.definedPoints.registerPointsMonitor(container);
    }

}
