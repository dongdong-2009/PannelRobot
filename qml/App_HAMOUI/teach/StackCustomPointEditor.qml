import QtQuick 1.1
import "../../ICCustomElement"
import "Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../../utils/stringhelper.js" as ICString
import "StackCustomPointEditor.js" as PData

MouseArea{
    id:instance

    property int axisNameWidth: 30
    function newPointHelper(){
        var pointPos = {
            "m0":m0.configValue || 0.000,
            "m1":m1.configValue || 0.000,
            "m2":m2.configValue || 0.000,
            "m3":m3.configValue || 0.000,
            "m4":m4.configValue || 0.000,
            "m5":m5.configValue || 0.000};
        var pointName = text_name.configValue;
        pointModel.append({"pointName":pointName, "pointPos":pointPos, "fromgcode":false});
    }

    function show(posData, clearOld, confirmHandler){
        if(clearOld)
            pointModel.clear();
        for(var i = 0; i < posData.length; ++i){
            pointModel.append({"pointName":posData[i].pointName, "pointPos":posData[i].pointPos, "fromgcode":posData[i] || false});
        }
        editConfirm.connect(confirmHandler);
        visible = true;
    }

    signal editConfirm(bool accept, variant points, bool onlySend)

    Rectangle {
        id:container
        width: parent.width
        height: parent.height

        border.width: 1
        border.color: "gray"
        color: "#A0A0F0"

        ICFileSelector{
            id:fileSelector
            scan: "*.PNC"
            visible: false;
            width: parent.width * 0.8
            height: parent.height * 0.6
            anchors.centerIn:  parent
            z:10
            onGotFileContent: {
                pointModel.clear();
                PData.hcInterpreter.interprete(content);
                var tMap = {};
                var p;
                for(var i = 0, points = PData.hcInterpreter.interpretedPoints, len = points.length; i < len; ++i)
                {
                    p = points[i];
                    if(tMap.hasOwnProperty(p.m4)){
                        pointModel.insert(tMap[p.m4], {"pointName":qsTr("P") + i,
                                              "pointPos":p, "fromgcode":true});
                        for(var m in tMap)
                            if(tMap[m] >= tMap[p.m4])
                                tMap[m] += 1;
                    }else{
                        pointModel.append({"pointName":qsTr("P") + i,
                                              "pointPos":p, "fromgcode":true});
                        tMap[p.m4] = pointModel.count;
                    }

                }

            }
        }
        ICFileSelector{
            id:fileSelector_dxf
            scan: "*.dxf"
            visible: false;
            width: parent.width * 0.8
            height: parent.height * 0.6
            anchors.centerIn:  parent
            z:10
            function length(x,y)
            {
                return x*x+y*y;
            }

            onGotFileContent: {
                pointModel.clear();
                var tMap = {};
                var p,red = [],green = [],blue = [],tmp = 0,count = 0,dxfpoints = JSON.parse(content);
                for(var k = 0; k < dxfpoints.length; k++)
                {
                    if(dxfpoints[k].m4 == 6){
                        var origin = dxfpoints[k];
                        dxfpoints.splice(k,1);
                        for(var n = 0; n < dxfpoints.length; n++){
                            console.log(origin.m0,origin.m1,dxfpoints[n].m0,dxfpoints[n].m1);
                            dxfpoints[n].m0 -= origin.m0;
                            dxfpoints[n].m1 -= origin.m1;
                            dxfpoints[n].m0 = (dxfpoints[n].m0).toFixed(3);
                            dxfpoints[n].m1 = (dxfpoints[n].m1).toFixed(3);
                        }
                        break;
                    }
                }
                for(var j = 0; j < dxfpoints.length; j++)
                {
                    if(dxfpoints[j].m4 == 1)
                        red.push(dxfpoints[j]);
                    if(dxfpoints[j].m4 == 3)
                        green.push(dxfpoints[j]);
                    if(dxfpoints[j].m4 == 5)
                        blue.push(dxfpoints[j]);
                }
                var l = red.length,red1 = [],green1 = [],blue1 = [],cc = [{"m0":0,"m1":0}];
                for(var ii = 0;ii < l;ii++)
                {
                    for(j = 0; j < red.length; j++)
                    {
                        if(ii == l -1)
                            count = 0;
                        else if(j == 0){
                            count = 0;
//                            if(length(red[0].m0 - cc[0].m0,red[0].m1 - cc[0].m1))
                                tmp = length(red[0].m0 - cc[0].m0,red[0].m1 - cc[0].m1);
//                            else
//                                tmp = length(red[1].m0 - cc[0].m0,red[1].m1 - cc[0].m1)
                        }
                        else if(tmp > length(red[j].m0 - cc[0].m0,red[j].m1 - cc[0].m1)&&length(red[j].m0 - cc[0].m0,red[j].m1 - cc[0].m1)!=0){
                            tmp = length(red[j].m0 - cc[0].m0,red[j].m1 - cc[0].m1);
                            count = j;
                        }
                    }
                    cc[0] = red[count];
                    red1.push(red[count]);
                    red.splice(count,1);
                }
                l = green.length;
                if(l){
                    if(red1.length)
                        cc = [{"m0":red1[red1.length - 1].m0,"m1":red1[red1.length - 1].m1}];
                    else
                        cc = [{"m0":0,"m1":0}];
                }
                for(ii = 0;ii < l;ii++)
                {
                    for(j = 0; j < green.length; j++)
                    {
                        if(ii == l -1)
                            count = 0
                        else if(j == 0){
                            count = 0;
                            if(length(green[0].m0 - cc[0].m0,green[0].m1 - cc[0].m1))
                                tmp = length(green[0].m0 - cc[0].m0,green[0].m1 - cc[0].m1);
                            else
                                tmp = length(green[1].m0 - cc[0].m0,green[1].m1 - cc[0].m1)
                        }
                        else if(tmp > length(green[j].m0 - cc[0].m0,green[j].m1 - cc[0].m1)&&length(green[j].m0 - cc[0].m0,green[j].m1 - cc[0].m1)!=0){
                            tmp = length(green[j].m0 - cc[0].m0,green[j].m1 - cc[0].m1);
                            count = j;
                        }
                    }
                    cc[0] = green[count];
                    green1.push(green[count]);
                    green.splice(count,1);
                }
                l = blue.length;
                if(l){
                    if(green1.length)
                        cc = [{"m0":green1[green1.length - 1].m0,"m1":green1[green1.length - 1].m1}];
                    else if(red1.length)
                        cc = [{"m0":red1[red1.length - 1].m0,"m1":red1[red1.length - 1].m1}];
                    else
                        cc = [{"m0":0,"m1":0}];
                }
                for(ii = 0;ii < l;ii++)
                {
                    for(j = 0; j < blue.length; j++)
                    {
                        if(ii == l -1)
                            count = 0
                        else if(j == 0){
                            count = 0;
                            if(length(blue[0].m0 - cc[0].m0,blue[0].m1 - cc[0].m1))
                                tmp = length(blue[0].m0 - cc[0].m0,blue[0].m1 - cc[0].m1);
                            else
                                tmp = length(blue[1].m0 - cc[0].m0,blue[1].m1 - cc[0].m1)
                        }
                        else if(tmp > length(blue[j].m0 - cc[0].m0,blue[j].m1 - cc[0].m1)&&length(blue[j].m0 - cc[0].m0,blue[j].m1 - cc[0].m1)!=0){
                            tmp = length(blue[j].m0 - cc[0].m0,blue[j].m1 - cc[0].m1);
                            count = j;
                        }
                    }
                    cc[0] = blue[count];
                    blue1.push(blue[count]);
                    blue.splice(count,1);
                }


//                for(var j = 0, dxfpoints = JSON.parse(content); j < dxfpoints.length; j++)
//                {
//                    if(dxfpoints[j].m4 == 1){
//                        if(!red.length)
//                            red.push(dxfpoints[j]);
//                        else{
//                            for(var m = 0;m < red.length;m++){
//                                if(parseFloat(dxfpoints[j].m0) < parseFloat(red[m].m0)){
//                                    red.splice(m,0,dxfpoints[j]);
//                                    break;
//                                }
//                                else if(m == red.length - 1){
//                                    red.splice(red.length,0,dxfpoints[j]);
//                                    break;
//                                }
//                                else if(parseFloat(dxfpoints[j].m0) == parseFloat(red[m].m0)){
//                                    if(parseFloat(dxfpoints[j].m1) <= parseFloat(red[m].m1))
//                                        red.splice(m,0,dxfpoints[j]);
//                                    else{
//                                        for(var equal = 1;equal < red.length - m;equal++){
//                                            if(parseFloat(dxfpoints[j].m0) == parseFloat(red[m + equal].m0)){
//                                                if(parseFloat(dxfpoints[j].m1) <= parseFloat(red[m + equal].m1)){
//                                                    red.splice(m + equal,0,dxfpoints[j]);
//                                                    break;
//                                                }
//                                            }
//                                            else{
//                                                red.splice(m + equal,0,dxfpoints[j]);
//                                                break;
//                                            }
//                                        }
//                                    }
//                                    break;
//                                }
//                            }
//                        }
//                    }
//                    if(dxfpoints[j].m4 == 3){
//                        if(!green.length)
//                            green.push(dxfpoints[j]);
//                        else{
//                            for(m = 0;m < green.length;m++){
//                                if(parseFloat(dxfpoints[j].m0) < parseFloat(green[m].m0)){
//                                    green.splice(m,0,dxfpoints[j]);
//                                    break;
//                                }
//                                else if(m == green.length - 1){
//                                    green.splice(green.length,0,dxfpoints[j]);
//                                    break;
//                                }
//                                else if(parseFloat(dxfpoints[j].m0) == parseFloat(green[m].m0)){
//                                    if(parseFloat(dxfpoints[j].m1) <= parseFloat(green[m].m1))
//                                        green.splice(m,0,dxfpoints[j]);
//                                    else{
//                                        for(equal = 1;equal < green.length - m;equal++){
//                                            if(parseFloat(dxfpoints[j].m0) == parseFloat(green[m + equal].m0)){
//                                                if(parseFloat(dxfpoints[j].m1) <= parseFloat(green[m + equal].m1)){
//                                                    green.splice(m + equal,0,dxfpoints[j]);
//                                                    break;
//                                                }
//                                            }
//                                            else{
//                                                green.splice(m + equal,0,dxfpoints[j]);
//                                                break;
//                                            }
//                                        }
//                                    }
//                                    break;
//                                }
//                            }
//                        }
//                    }
//                    if(dxfpoints[j].m4 == 5){
//                        if(!blue.length)
//                            blue.push(dxfpoints[j]);
//                        else{
//                            for(m = 0;m < blue.length;m++){
//                                if(parseFloat(dxfpoints[j].m0) < parseFloat(blue[m].m0)){
//                                    blue.splice(m,0,dxfpoints[j]);
//                                    break;
//                                }
//                                else if(m == blue.length - 1){
//                                    blue.splice(blue.length + 1,0,dxfpoints[j]);
//                                    break;
//                                }
//                                else if(parseFloat(dxfpoints[j].m0) == parseFloat(blue[m].m0)){
//                                    if(parseFloat(dxfpoints[j].m1) <= parseFloat(blue[m].m1))
//                                        blue.splice(m,0,dxfpoints[j]);
//                                    else{
//                                        for(equal = 1;equal < blue.length - m;equal++){
//                                            if(parseFloat(dxfpoints[j].m0) == parseFloat(blue[m + equal].m0)){
//                                                if(parseFloat(dxfpoints[j].m1) <= parseFloat(blue[m + equal].m1)){
//                                                    blue.splice(m + equal,0,dxfpoints[j]);
//                                                    break;
//                                                }
//                                            }
//                                            else{
//                                                blue.splice(m + equal,0,dxfpoints[j]);
//                                                break;
//                                            }
//                                        }
//                                    }
//                                    break;
//                                }
//                                else if(parseFloat(dxfpoints[j].m0) == parseFloat(blue[m].m0)){
//                                    if(parseFloat(dxfpoints[j].m1) < parseFloat(blue[m].m1))
//                                        blue.splice(m,0,dxfpoints[j]);
//                                    else
//                                        blue.splice(m + 1,0,dxfpoints[j]);
//                                    break;
//                                }
//                            }
//                        }
//                    }
//                }
//                for(j = 0;j < green.length;j++)
//                    red.splice(red.length,0,green[j]);
//                for(j = 0;j < blue.length;j++)
//                    red.splice(red.length,0,blue[j]);
                for(j = 0;j < green1.length;j++)
                    red1.splice(red1.length,0,green1[j]);
                for(j = 0;j < blue1.length;j++)
                    red1.splice(red1.length,0,blue1[j]);
                for(var i = 0, points = red1, len = points.length; i < len; ++i)
                {
                    p = points[i];
                    if(tMap.hasOwnProperty(p.m4)){
                        pointModel.insert(tMap[p.m4], {"pointName":qsTr("P") + i,
                                              "pointPos":p, "fromgcode":true});
                        for(var m in tMap)
                            if(tMap[m] >= tMap[p.m4])
                                tMap[m] += 1;
                    }else{
                        pointModel.append({"pointName":qsTr("P") + i,
                                              "pointPos":p, "fromgcode":true});
                        tMap[p.m4] = pointModel.count;
                    }
                    tmpModel.append({"pointName":qsTr("P") + i,
                                        "pointPos":p, "fromgcode":true});
                }
            }
        }

        ICButton{
            id:reset
            text: qsTr("reset")
            visible: false
            anchors.right: up_point.left
            onButtonClicked: {
                pointModel.clear();
                for(var i = 0;i < tmpModel.count;i++)
                    pointModel.append(tmpModel.get(i));
            }
        }

        ICButton{
            id:up_point
            text: qsTr("up")
            anchors.right: down_point.left
            onButtonClicked: {
                if(pointView.currentIndex <= 0)
                    return;
                pointModel.move(pointView.currentIndex,pointView.currentIndex - 1,1);
            }
        }

        ICButton{
            id:down_point
            text: qsTr("down")
            anchors.right: statistics.left
            onButtonClicked: {
                if(pointView.currentIndex >= pointView.count -1)
                    return;
                pointModel.move(pointView.currentIndex,pointView.currentIndex + 1,1);
            }
        }

        Text{
            id:statistics
            text: qsTr("Total:") + pointModel.count
            anchors.right: close.left
            anchors.rightMargin: 20
        }

        ICButton{
            id:close
            text: qsTr("Close")
            anchors.right: parent.right
            onButtonClicked: {
                instance.visible = false
                editConfirm(false, [], true);
            }
        }
        ICButton{
            id:syncReplace
            text:qsTr("Sync Replace")
            anchors.bottom: pointViewContainer.top
            anchors.bottomMargin: 6
            anchors.left: pointViewContainer.left
            onButtonClicked: {
                var baseCurrent = pointModel.get(pointView.currentIndex).pointPos;
                var toReplace = {"m0":parseFloat(m0.configValue),"m1":parseFloat(m1.configValue),"m2":parseFloat(m2.configValue),
                    "m3":parseFloat(m3.configValue),"m4":parseFloat(m4.configValue),"m5":parseFloat(m5.configValue)};
                var diff = toReplace;
                diff.m0 -= parseFloat(baseCurrent.m0);
                diff.m1 -= parseFloat(baseCurrent.m1);
                diff.m2 -= parseFloat(baseCurrent.m2);
                diff.m3 -= parseFloat(baseCurrent.m3);
                diff.m4 -= parseFloat(baseCurrent.m4);
                diff.m5 -= parseFloat(baseCurrent.m5);

                var tmpPointPos;
                for(var i = 0, len = pointModel.count; i < len; ++i){
                    tmpPointPos = pointModel.get(i).pointPos;
                    tmpPointPos.m0 = (parseFloat(tmpPointPos.m0) + diff.m0).toFixed(3);
                    tmpPointPos.m1 = (parseFloat(tmpPointPos.m1) + diff.m1).toFixed(3);
                    tmpPointPos.m2 = (parseFloat(tmpPointPos.m2) + diff.m2).toFixed(3);
                    tmpPointPos.m3 = (parseFloat(tmpPointPos.m3) + diff.m3).toFixed(3);
                    tmpPointPos.m4 = (parseFloat(tmpPointPos.m4) + diff.m4).toFixed(3);
                    tmpPointPos.m5 = (parseFloat(tmpPointPos.m5) + diff.m5).toFixed(3);
                    pointModel.setProperty(i, "pointPos", tmpPointPos);
                }
            }
        }
        Row{
            anchors.left: syncReplace.right
            anchors.top: syncReplace.top
            spacing: 4
            ICConfigEdit{
                id:aHead
                configName: qsTr("A Code")
                inputWidth: 30
            }
            ICConfigEdit{
                id:bHead
                configName: qsTr("B Code")
                inputWidth: aHead.inputWidth
            }
            ICConfigEdit{
                id:cHead
                configName: qsTr("C Code")
                inputWidth: aHead.inputWidth
            }
            ICButton{
                id:headConfirm
                text: qsTr("Confirm")
                onButtonClicked: {
                    var tmp;
                    for(var i = 0, len = pointModel.count; i < len; ++i){
                        tmp = pointModel.get(i).pointPos;
                        console.log(JSON.stringify(tmp));
                        if(tmp.m4 == aHead.getConfigValue())
                            tmp.m4 = 0.001;
                        else if(tmp.m4 == bHead.getConfigValue())
                            tmp.m4 = 0.002;
                        else if(tmp.m4 == cHead.getConfigValue())
                            tmp.m4 = 0.003;
                        pointModel.setProperty(i, "pointPos", tmp);
                    }
                }
            }
        }

        Row{
            y:365
            x:pointViewContainer.x
            spacing: 6
            ICConfigEdit{
                id:text_name
                isNumberOnly: false
                inputWidth: 165
                configName: qsTr("Point Name:")
                height: 30
            }

            ICButton{
                id:button_delet
                text: qsTr("Delete")
                height: text_name.height
                onButtonClicked: {
                    pointModel.remove(pointView.currentIndex);
                }
            }
            ICButton{
                id:button_replace
                text: qsTr("Replace")
                height: text_name.height
                onButtonClicked: {
                    var pointPos = {"m0":m0.configValue,"m1":m1.configValue,"m2":m2.configValue,
                        "m3":m3.configValue,"m4":m4.configValue,"m5":m5.configValue};
                    pointModel.set(pointView.currentIndex, {"pointName":text_name.configValue, "pointPos":pointPos});
                }
            }
        }
        Column{
            id:leftContainer
            spacing: 3
            x:10
            y:10

            ICButton{
                id:button_setWorldPos
                text: qsTr("Set In")
                onButtonClicked: {
                    m0.configValue = panelRobotController.statusValueText("c_ro_0_32_3_900");
                    m1.configValue = panelRobotController.statusValueText("c_ro_0_32_3_904");
                    m2.configValue = panelRobotController.statusValueText("c_ro_0_32_3_908");
                    m3.configValue = panelRobotController.statusValueText("c_ro_0_32_3_912");
                    m4.configValue = panelRobotController.statusValueText("c_ro_0_32_3_916");
                    m5.configValue = panelRobotController.statusValueText("c_ro_0_32_3_920");
                }
                width: m0.width
            }

            ICConfigEdit{
                id:m0
                configName: qsTr(AxisDefine.axisInfos[0].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth
            }
            ICConfigEdit{
                id:m1
                configName: qsTr(AxisDefine.axisInfos[1].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICConfigEdit{
                id:m2
                configName: qsTr(AxisDefine.axisInfos[2].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICConfigEdit{
                id:m3
                configName: qsTr(AxisDefine.axisInfos[3].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICConfigEdit{
                id:m4
                configName: qsTr(AxisDefine.axisInfos[4].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }
            ICConfigEdit{
                id:m5
                configName: qsTr(AxisDefine.axisInfos[5].name)
                configAddr: "s_rw_0_32_3_1300"
                configNameWidth: axisNameWidth

            }

            ICButton{
                id:button_newLocus
                text: qsTr("New")
                width: button_setWorldPos.width
                height: button_setWorldPos.height
                onButtonClicked: {
                    newPointHelper();
                }
            }


            ICButton{
                id:importFromCYGCode
                text: qsTr("Import From \nCY GCode")
                width: button_setWorldPos.width
                height: button_setWorldPos.height
                onButtonClicked: {
//                    PData.hcInterpreter.interprte()
                    fileSelector.visible = true;
                }
            }
            ICButton{
                id:importFromDXF
                text: qsTr("Import From DXF")
                width: button_setWorldPos.width
                height: button_setWorldPos.height
                onButtonClicked: {
                    fileSelector_dxf.visible = true;
                }
            }
        }

        ICButton{
            id:saveBtn
            text: qsTr("Save")
            width: button_setWorldPos.width
            height: button_setWorldPos.height
            anchors.bottom: pointViewContainer.bottom
            anchors.left: leftContainer.left
            onButtonClicked: {
                var points = [];
                var p;
                for(var i = 0; i < pointModel.count; ++i){
                    p = pointModel.get(i);
                    points.push({"pointName":p.pointName, "pointPos":p.pointPos});
                }
                editConfirm(true, points, false);
            }
        }

        Rectangle  {
            id:pointViewContainer
            width: 460
            height: 270
            x:130
            y:80
            ListModel {
                id:pointModel
            }
            ListModel {
                id:tmpModel
            }

            ListView {
                id:pointView
                width: parent.width
                height: parent.height
                model: pointModel
                clip: true
                highlight: Rectangle { width: 490; height: 20;color: "lightsteelblue"; radius: 2}
                highlightMoveDuration: 1
                delegate: Text {
                    verticalAlignment: Text.AlignVCenter
                    width: pointView.width
                    height: 32
                    text: {ICString.icStrformat("{0}:({1}:{2},{3}:{4},{5}:{6},{7}:{8},{9}:{10},{11}:{12})",
                                               pointName,
                                               AxisDefine.axisInfos[0].name, pointPos.m0,
                                               AxisDefine.axisInfos[1].name, pointPos.m1,
                                               AxisDefine.axisInfos[2].name, pointPos.m2,
                                               AxisDefine.axisInfos[3].name, pointPos.m3,
                                               AxisDefine.axisInfos[4].name, pointPos.m4,
                                               AxisDefine.axisInfos[5].name, pointPos.m5);
                        var ret = pointName + ":(";
                        if(AxisDefine.axisInfos[0].visiable)
                            ret += AxisDefine.axisInfos[0].name + ":" + pointPos.m0 + ","
                        if(AxisDefine.axisInfos[1].visiable)
                            ret += AxisDefine.axisInfos[1].name + ":" + pointPos.m1 + ","
                        if(AxisDefine.axisInfos[2].visiable)
                            ret += AxisDefine.axisInfos[2].name + ":" + pointPos.m2 + ","
                        if(AxisDefine.axisInfos[3].visiable)
                            ret += AxisDefine.axisInfos[3].name + ":" + pointPos.m3 + ","
                        if(fromgcode){
                            ret += qsTr("Head Code") + ":" + pointPos.m4 + ","
                        }
                        else if(AxisDefine.axisInfos[4].visiable)
                            ret += AxisDefine.axisInfos[4].name + ":" + pointPos.m4 + ","
                        if(AxisDefine.axisInfos[5].visiable)
                            ret += AxisDefine.axisInfos[5].name + ":" + pointPos.m5 + ","
                        ret = ret.slice(0, ret.length - 1);
                        ret += ")";
                        return ret;
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var iPoint = pointModel.get(index);
                            text_name.configValue  = iPoint.pointName;
                            var pointPos = iPoint.pointPos;
                            m0.configValue = pointPos.m0 || 0.000;
                            m1.configValue = pointPos.m1 || 0.000;
                            m2.configValue = pointPos.m2 || 0.000;
                            m3.configValue = pointPos.m3 || 0.000;
                            m4.configValue = pointPos.m4 || 0.000;
                            m5.configValue = pointPos.m5 || 0.000;
                            pointView.currentIndex = index;

                        }
                    }
                }
            }
        }
    }

    function onAxisDefinesChanged(){
        m0.visible = AxisDefine.axisInfos[0].visiable;
        m1.visible = AxisDefine.axisInfos[1].visiable;
        m2.visible = AxisDefine.axisInfos[2].visiable;
        m3.visible = AxisDefine.axisInfos[3].visiable;
        m4.visible = AxisDefine.axisInfos[4].visiable;
        m5.visible = AxisDefine.axisInfos[5].visiable;
    }

    Component.onCompleted: {
        AxisDefine.registerMonitors(instance);
        onAxisDefinesChanged();
    }

}
