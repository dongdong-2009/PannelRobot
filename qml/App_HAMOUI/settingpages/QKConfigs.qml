import QtQuick 1.1
import "../../ICCustomElement"
import "../configs/AxisDefine.js" as AxisDefine
import "QKInfo.js" as QKInfo

Item {
    id: root
    width: parent.width
    height: parent.height

    onVisibleChanged: {
        if(!visible)
            rE2promBtn.isBeginReadEeprom = false;
    }

    ICButtonGroup{
        id:menuArea
        width: parent.width
        height: 32
        mustChecked: true
        checkedItem: paraPageBtn
        checkedIndex: 0
        TabMenuItem{
            id:paraPageBtn
            width: 100
            height: 32
            isChecked: true
            itemText: qsTr("para page")
        }
        TabMenuItem{
            id:statusPageBtn
            width: 100
            height: 32
            itemText: qsTr("status page")
        }
        function onItemChanged() {
            pageContainer.setCurrentIndex(checkedIndex);
        }
    }

    ICSpliteLine{
        id:headLine1
        color: "black"
        anchors.bottom: menuArea.top
        direction:"horizontal"
        wide: 1
        linelong: parent.width
    }
    ICSpliteLine{
        id:headLine2
        color: "black"
        anchors.top: menuArea.bottom
        direction:"horizontal"
        wide: 1
        linelong: parent.width
    }
    ICSpliteLine{
        id:leftLine1
        color: "black"
        anchors.left: menuArea.left
        direction:"verticality"
        wide: 1
        linelong: parent.height
    }

    ICStackContainer{
        id:pageContainer
        anchors.top: headLine2.bottom
        anchors.left: leftLine1.right
        height: parent.height - menuArea.height - headLine2.wide -headLine1.height
        width: parent.width - leftLine1.wide

        Item {
            id: dataPage
            property variant subItems:[subItems0,subItems1,subItems2,subItems3,subItems4,subItems5,subItems6,subItems7,subItems8,
                subItems9,subItems10,subItems11,subItems12,subItems13,subItems14,subItems15,subItems16,subItems17,subItems18,subItems19,subItems20]
            ICMessageBox{
                id: tipBox
                x:300
                y:120
                z: 100
                visible: false
            }
            Item {
                id: mainListArea
                height: parent.height
                width: parent.width/5
                Column{
                    id:funcBtnArea
                    y:5
                    height:parent.height/3-15
                    width: parent.width
                    spacing: 10
                    ICButton{
                        id:paraConfigBtn
                        height: 26
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("para config")
                        onButtonClicked: {
                            tipBox.runningTip(qsTr("para config..."), qsTr("Get it"));
                            var i,j,toSendID=0;
                            var tmpData = [];
                            for(i=0;i<9;++i){
                               tmpData.push(dataPage.subItems[0].get(i).wVal);
                            }
                            panelRobotController.writeMultipleQkPara((toSendID<<8) + 0,9,JSON.stringify(tmpData));
                            tmpData.splice(0,9);

                            for(j=0;j<4;++j){
                                for(i=0;i<16;++i){
                                   tmpData.push(dataPage.subItems[5*j+1].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkPara((toSendID<<8) + 16,16,JSON.stringify(tmpData));
                                tmpData.splice(0,16);

                                for(i=0;i<25;++i){
                                   tmpData.push(dataPage.subItems[5*j+2].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkPara((toSendID<<8) + 48,25,JSON.stringify(tmpData));
                                tmpData.splice(0,25);

                                for(i=0;i<16;++i){
                                   tmpData.push(dataPage.subItems[5*j+3].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkPara((toSendID<<8) + 80,16,JSON.stringify(tmpData));
                                tmpData.splice(0,16);

                                for(i=0;i<10;++i){
                                   tmpData.push(dataPage.subItems[5*j+4].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkPara((toSendID<<8) + 112,10,JSON.stringify(tmpData));
                                tmpData.splice(0,10);

                                for(i=0;i<6;++i){
                                   tmpData.push(dataPage.subItems[5*j+5].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkPara((toSendID<<8) + 177,6,JSON.stringify(tmpData));
                                tmpData.splice(0,6);

                                toSendID ++;
                            }
                            tipBox.hide();
                        }
                    }
                    ICButton{
                        id:rE2promBtn
                        property bool isBeginReadEeprom: false
                        height: paraConfigBtn.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("read e2prom")
                        onButtonClicked: {
                            tipBox.runningTip(qsTr("Eeprom reading..."), qsTr("Get it"));
                            var tmpData = [];
                            tmpData.push(1);
                            panelRobotController.writeMultipleQkEeprom(254,1,JSON.stringify(tmpData));
                            isBeginReadEeprom = true;
                        }
                    }
                    ICButton{
                        id:wE2promBtn
                        height: paraConfigBtn.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("write e2prom")
                        onButtonClicked: {
                            tipBox.runningTip(qsTr("Eeprom config..."), qsTr("Get it"));
                            var i,j,toSendID=0;
                            var tmpData = [];
                            for(i=0;i<9;++i){
                               tmpData.push(dataPage.subItems[0].get(i).wVal);
                            }
                            panelRobotController.writeMultipleQkEeprom((toSendID<<8) + 0,9,JSON.stringify(tmpData));
                            tmpData.splice(0,9);

                            for(j=0;j<4;++j){
                                for(i=0;i<16;++i){
                                   tmpData.push(dataPage.subItems[5*j+1].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkEeprom((toSendID<<8) + 16,16,JSON.stringify(tmpData));
                                tmpData.splice(0,16);

                                for(i=0;i<25;++i){
                                   tmpData.push(dataPage.subItems[5*j+2].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkEeprom((toSendID<<8) + 48,25,JSON.stringify(tmpData));
                                tmpData.splice(0,25);

                                for(i=0;i<16;++i){
                                   tmpData.push(dataPage.subItems[5*j+3].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkEeprom((toSendID<<8) + 80,16,JSON.stringify(tmpData));
                                tmpData.splice(0,16);

                                for(i=0;i<10;++i){
                                   tmpData.push(dataPage.subItems[5*j+4].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkEeprom((toSendID<<8) + 112,10,JSON.stringify(tmpData));
                                tmpData.splice(0,10);

                                for(i=0;i<6;++i){
                                   tmpData.push(dataPage.subItems[5*j+5].get(i).wVal);
                                }
                                panelRobotController.writeMultipleQkEeprom((toSendID<<8) + 177,6,JSON.stringify(tmpData));
                                tmpData.splice(0,6);

                                toSendID ++;
                            }
                            tipBox.hide();
                        }
                    }
                }
                ICSpliteLine{
                    id:subHeadLine1
                    color: "black"
                    anchors.top: funcBtnArea.bottom
                    direction:"horizontal"
                    linelong: parent.width
                    wide: 1
                }
                ListModel{
                    id:mainItems
                    Component.onCompleted: {
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});

                        mainItems.append({"mainItemName":AxisDefine.axisInfos[0].name + qsTr("axis")+qsTr("distributed para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[0].name + qsTr("axis")+qsTr("current loop para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[0].name + qsTr("axis")+qsTr("speed loop para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[0].name + qsTr("axis")+qsTr("position ctrl para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[0].name + qsTr("axis")+qsTr("Initial angle para")});

                        mainItems.append({"mainItemName":AxisDefine.axisInfos[1].name + qsTr("axis")+qsTr("distributed para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[1].name + qsTr("axis")+qsTr("current loop para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[1].name + qsTr("axis")+qsTr("speed loop para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[1].name + qsTr("axis")+qsTr("position ctrl para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[1].name + qsTr("axis")+qsTr("Initial angle para")});

                        mainItems.append({"mainItemName":AxisDefine.axisInfos[2].name + qsTr("axis")+qsTr("distributed para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[2].name + qsTr("axis")+qsTr("current loop para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[2].name + qsTr("axis")+qsTr("speed loop para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[2].name + qsTr("axis")+qsTr("position ctrl para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[2].name + qsTr("axis")+qsTr("Initial angle para")});

                        mainItems.append({"mainItemName":AxisDefine.axisInfos[3].name + qsTr("axis")+qsTr("distributed para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[3].name + qsTr("axis")+qsTr("current loop para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[3].name + qsTr("axis")+qsTr("speed loop para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[3].name + qsTr("axis")+qsTr("position ctrl para")});
                        mainItems.append({"mainItemName":AxisDefine.axisInfos[3].name + qsTr("axis")+qsTr("Initial angle para")});
                    }
                }
                ICListView{
                    id:paraMainView
                    spacing: 2
                    anchors.top: subHeadLine1.bottom
                    height:parent.height - funcBtnArea.height - subHeadLine1.wide -8
                    width: parent.width
                    model:mainItems
                    clip: true
                    delegate: Rectangle{
                        width: parent.width
                        height:30
                        color: ListView.isCurrentItem?"lightsteelblue":"white"
                        Text {
                            anchors.fill: parent
                            verticalAlignment:Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: mainItemName
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                paraMainView.currentIndex = index;
                            }
                        }
                    }
                    onCurrentItemChanged: {
                        if(currentIndex < 0) return;
                        paraSubView.model = dataPage.subItems[currentIndex];
                    }
                }
            }
            ICSpliteLine{
                id:leftLine2
                color: "black"
                anchors.left: mainListArea.right
                direction:"verticality"
                linelong: parent.height
                wide: 1
            }
            Row{
                id:subTitleArea
                anchors.left: leftLine2.right
                anchors.leftMargin: 4
                height: 30
                width: parent.width - mainListArea.width -2
                Text {
                    id:paraNameTextTitle
                    height: parent.height
                    width: paraSubView.tableMargin[0]
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    text: qsTr("para name")
                }
                Text {
                    height: parent.height
                    width: paraSubView.tableMargin[1]
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    text: qsTr("addr")
                }
                Text{
                    height: parent.height
                    width: paraSubView.tableMargin[2]
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    text: qsTr("write val")
                }
                Text {
                    height: parent.height
                    width: paraSubView.tableMargin[3]
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    text: qsTr("read val")
                }
                Text {
                    id:descTextTitle
                    height: parent.height
                    width: parent.width - paraSubView.tableMargin[0] -paraSubView.tableMargin[1] -paraSubView.tableMargin[2] -paraSubView.tableMargin[3] -8
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    text: qsTr("describe")
                }
            }
            ICSpliteLine{
                id:titleLine
                color: "black"
                anchors.top:subTitleArea.bottom
                anchors.topMargin: -1
                anchors.left: leftLine2.right
                wide: 1
                linelong: parent.width
                direction:"horizontal"
            }
            ICFlickable{
                isshowhint: true
                anchors.top:titleLine.bottom
                anchors.topMargin: 2
                anchors.left: paraSubView.right
                anchors.leftMargin: 2
                width: descText.width
                height: descText.height
                clip: true
                contentWidth: descText.width
                contentHeight: descText.height + 10
                Text{
                    id:descText
                    wrapMode: Text.WordWrap
                    height: paraSubView.height
                    width:descTextTitle.width
                }
            }
            ListModel{
                id:subItems0
                Component.onCompleted: {
                    for(var i=0;i<9;++i){
                        subItems0.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems1
                Component.onCompleted: {
                    for(var i=9;i<25;++i){
                        subItems1.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems2
                Component.onCompleted: {
                    for(var i=25;i<50;i++){
                        subItems2.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems3
                Component.onCompleted: {
                    for(var i=50;i<66;i++){
                        subItems3.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems4
                Component.onCompleted: {
                    for(var i=66;i<76;i++){
                       subItems4.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems5
                Component.onCompleted: {
                    for(var i=76;i<82;i++){
                        subItems5.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems6
                Component.onCompleted: {
                    for(var i=9;i<25;++i){
                        subItems6.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+1,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems7
                Component.onCompleted: {
                    for(var i=25;i<50;i++){
                        subItems7.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+1,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems8
                Component.onCompleted: {
                    for(var i=50;i<66;i++){
                        subItems8.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+1,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems9
                Component.onCompleted: {
                    for(var i=66;i<76;i++){
                       subItems9.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+1,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems10
                Component.onCompleted: {
                    for(var i=76;i<82;i++){
                        subItems10.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+1,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems11
                Component.onCompleted: {
                    for(var i=9;i<25;++i){
                        subItems11.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+2,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems12
                Component.onCompleted: {
                    for(var i=25;i<50;i++){
                        subItems12.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+2,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems13
                Component.onCompleted: {
                    for(var i=50;i<66;i++){
                        subItems13.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+2,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems14
                Component.onCompleted: {
                    for(var i=66;i<76;i++){
                       subItems14.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+2,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems15
                Component.onCompleted: {
                    for(var i=76;i<82;i++){
                        subItems15.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+2,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems16
                Component.onCompleted: {
                    for(var i=9;i<25;++i){
                        subItems16.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+3,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems17
                Component.onCompleted: {
                    for(var i=25;i<50;i++){
                        subItems17.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+3,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems18
                Component.onCompleted: {
                    for(var i=50;i<66;i++){
                        subItems18.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+3,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems19
                Component.onCompleted: {
                    for(var i=66;i<76;i++){
                       subItems19.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+3,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ListModel{
                id:subItems20
                Component.onCompleted: {
                    for(var i=76;i<82;i++){
                        subItems20.append({"paraName":QKInfo.qkParaInfo[i].name,"addr":QKInfo.qkParaInfo[i].addr+3,"wVal":QKInfo.qkParaInfo[i].wVal,"rVal":0,"desc":QKInfo.qkParaInfo[i].decs});
                    }
                }
            }
            ICListView{
                id:paraSubView
                property variant tableMargin: [250,60,80,80]
                color: "white"
                anchors.left: leftLine2.right
                anchors.top:titleLine.bottom
                height:parent.height -subTitleArea.height -1
                width: tableMargin[0]+tableMargin[1]+tableMargin[2]+tableMargin[3] +4
                clip: true
                ICSpliteLine{
                    id:leftLine3
                    color: "black"
                    anchors.left: parent.left
                    anchors.leftMargin: paraSubView.tableMargin[0]
                    direction:"verticality"
                    anchors.top: parent.top
                    anchors.topMargin: -31
                    linelong: parent.height+31
                    wide: 1
                }
                ICSpliteLine{
                    id:leftLine4
                    color: "black"
                    anchors.left: leftLine3.right
                    anchors.leftMargin: paraSubView.tableMargin[1]
                    direction:"verticality"
                    anchors.top: parent.top
                    anchors.topMargin: -31
                    linelong: parent.height+31
                    wide: 1
                }
                ICSpliteLine{
                    id:leftLine5
                    color: "black"
                    anchors.left: leftLine4.right
                    anchors.leftMargin: paraSubView.tableMargin[2]
                    direction:"verticality"
                    anchors.top: parent.top
                    anchors.topMargin: -31
                    linelong: parent.height+31
                    wide: 1
                }
                ICSpliteLine{
                    id:leftLine6
                    color: "black"
                    anchors.left: leftLine5.right
                    anchors.leftMargin: paraSubView.tableMargin[3]
                    direction:"verticality"
                    anchors.top: parent.top
                    anchors.topMargin: -31
                    linelong: parent.height+31
                    wide: 1
                }
                delegate: Rectangle{
                    width: parent.width
                    height:30
                    color: ListView.isCurrentItem?"lightsteelblue":"white"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            paraSubView.currentIndex = index;
                        }
                    }
                    Text {
                        id:paraNameText
                        height: parent.height
                        width: paraSubView.tableMargin[0]
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text: paraName
                    }
                    Text{
                        id:addrText
                        anchors.left:paraNameText.right
                        height: parent.height
                        width: paraSubView.tableMargin[1]
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text: addr
                    }
                    ICTextEdit {
                        id:wValText
                        isNeedBorder: false
                        isNumberOnly: true
                        isTransparent: true
                        inputVerticalAlignment:TextEdit.AlignVCenter
                        inputHorizontalAlignment: TextEdit.AlignHCenter
                        anchors.left: addrText.right
                        anchors.leftMargin: -2
                        height: parent.height
                        width: paraSubView.tableMargin[2]
                        text: wVal
                        onInputClicked: {
                            paraSubView.currentIndex = index;
                        }
                        onEditFinished: {
                            paraSubView.model.setProperty(index,"wVal",parseInt(text));
                            var toSendID = 0;
                            if(paraMainView.currentIndex == 0)toSendID =0;
                            else if(paraMainView.currentIndex>0 && paraMainView.currentIndex<=5)toSendID =0;
                            else if(paraMainView.currentIndex>5 && paraMainView.currentIndex<=10)toSendID =1;
                            else if(paraMainView.currentIndex>10 && paraMainView.currentIndex<=15)toSendID =2;
                            else if(paraMainView.currentIndex>15 && paraMainView.currentIndex<=20)toSendID =3;
//                            console.log("addr="+((toSendID<<8)+ addr),"val="+wVal);
                            var tmpArray = [];
                            tmpArray.push(wVal);
                            panelRobotController.writeMultipleQkPara(((toSendID<<8)+addr),1,JSON.stringify(tmpArray));
                        }
                    }
                    Text {
                        id:rValText
                        anchors.left: wValText.right
                        height: parent.height
                        width: paraSubView.tableMargin[3]
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text: rVal
                    }
                    ICSpliteLine{
                        color: "black"
                        anchors.top:parent.bottom
                        anchors.topMargin: -1
                        wide: 1
                        linelong: parent.width
                        direction:"horizontal"
                    }
//                    Component.onCompleted: {
//                        wValText.textChanged.connect(wValText.onConfigChanged);
//                    }
                }
                onCurrentItemChanged: {
                    descText.text = model.get(currentIndex).desc;
                }
            }
        }


        Item {
            id: statusPage
            property variant subItems:[spSubItems0,spSubItems1,spSubItems2,spSubItems3]
            Item {
                id: spMainListArea
                height: parent.height
                width: parent.width/5
                Column{
                    id:spFuncBtnArea
                    y:5
                    height:parent.height/5
                    width: parent.width
                    spacing: 10
                    ICCheckBox{
                        id:refreshEnBtn
                        height: 26
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("refresh en")
                        isChecked: true
                    }
                    ICButton{
                        id:clearAlarm
                        height: refreshEnBtn.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("clear alarm")
                        onButtonClicked: {
                            var tmpData = [];
                            tmpData.push(1);
                            panelRobotController.writeMultipleQkPara(155,1,JSON.stringify(tmpData));
                        }
                    }
                }
                ICSpliteLine{
                    id:spSubHeadLine1
                    color: "black"
                    anchors.top: spFuncBtnArea.bottom
                    direction:"horizontal"
                    linelong: parent.width
                    wide: 1
                }
                ListModel{
                    id:statusMainItems
                    Component.onCompleted: {
                        statusMainItems.append({"mainItemName":AxisDefine.axisInfos[0].name + qsTr("axis")+qsTr("alarm para")});
                        statusMainItems.append({"mainItemName":AxisDefine.axisInfos[1].name + qsTr("axis")+qsTr("alarm para")});
                        statusMainItems.append({"mainItemName":AxisDefine.axisInfos[2].name + qsTr("axis")+qsTr("alarm para")});
                        statusMainItems.append({"mainItemName":AxisDefine.axisInfos[3].name + qsTr("axis")+qsTr("alarm para")});
                    }
                }
                ICListView{
                    id:statusMainView
                    spacing: 2
                    anchors.top: spSubHeadLine1.bottom
                    height:parent.height - spFuncBtnArea.height - spSubHeadLine1.wide - 40
                    width: parent.width
                    model:statusMainItems
                    clip: true
                    delegate: Rectangle{
                        width: parent.width
                        height:30
                        color: ListView.isCurrentItem?"lightsteelblue":"white"
                        Text {
                            anchors.fill: parent
                            verticalAlignment:Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: mainItemName
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                statusMainView.currentIndex = index;
                            }
                        }
                    }
                    onCurrentItemChanged: {
                        if(currentIndex < 0) return;
                        statusSubView.model = statusPage.subItems[currentIndex];
                    }
                }
            }
            ICSpliteLine{
                id:spLeftLine2
                color: "black"
                anchors.left: spMainListArea.right
                direction:"verticality"
                linelong: statusMainView.height + spFuncBtnArea.height + 3
                wide: 1
            }
            ICSpliteLine{
                id:spSubHeadLine2
                color: "black"
                anchors.top: spLeftLine2.bottom
                direction:"horizontal"
                linelong: statusPage.width
                wide: 1
            }
            Row{
                id:spSubTitleArea
                anchors.left: spLeftLine2.right
                anchors.leftMargin: 4
                height: 30
                width: parent.width - spMainListArea.width -2
                Text {
                    id:alarmNameTextTitle
                    height: parent.height
                    width: statusSubView.tableMargin[0]
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    text: qsTr("alarm name")
                }
                Text {
                    height: parent.height
                    width: statusSubView.tableMargin[1]
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    text: qsTr("alarm val")
                }
                Text {
                    id:alarmdescTextTitle
                    wrapMode: Text.WordWrap
                    height: parent.height
                    width: parent.width - statusSubView.tableMargin[0] -statusSubView.tableMargin[1]- 8
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    text: qsTr("describe")
                }
            }
            ICSpliteLine{
                id:spTitleLine
                color: "black"
                anchors.top:spSubTitleArea.bottom
                anchors.topMargin: -1
                anchors.left: spLeftLine2.right
                wide: 1
                linelong: parent.width
                direction:"horizontal"
            }
            Text{
                id:alarmDescText
                anchors.top:spTitleLine.bottom
                anchors.topMargin: 2
                anchors.left: statusSubView.right
                anchors.leftMargin: 2
                height: statusSubView.height
                width:descTextTitle.width
                text: qsTr("0- no fault, 1- fault")
            }
            ListModel{
                id:spSubItems0
                Component.onCompleted: {
                    spSubItems0.append({"alarmName":qsTr("InitFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("EepromFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("AdcFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("ExecTmFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("OverTempFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("OvFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("LvFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("MainPowerOff"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("GateKillFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("OvrTempFlt2"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("OvrLdFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("OvrSpdFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("OvrFrqFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("PosErrOvrFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("MtrEncFlt"),"alarmVal":0});
                    spSubItems0.append({"alarmName":qsTr("OvrCrntFlt"),"alarmVal":0});
                }
            }
            ListModel{
                id:spSubItems1
                Component.onCompleted: {
                    spSubItems1.append({"alarmName":qsTr("InitFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("EepromFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("AdcFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("ExecTmFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("OverTempFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("OvFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("LvFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("MainPowerOff"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("GateKillFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("OvrTempFlt2"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("OvrLdFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("OvrSpdFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("OvrFrqFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("PosErrOvrFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("MtrEncFlt"),"alarmVal":0});
                    spSubItems1.append({"alarmName":qsTr("OvrCrntFlt"),"alarmVal":0});
                }
            }
            ListModel{
                id:spSubItems2
                Component.onCompleted: {
                    spSubItems2.append({"alarmName":qsTr("InitFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("EepromFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("AdcFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("ExecTmFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("OverTempFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("OvFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("LvFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("MainPowerOff"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("GateKillFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("OvrTempFlt2"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("OvrLdFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("OvrSpdFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("OvrFrqFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("PosErrOvrFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("MtrEncFlt"),"alarmVal":0});
                    spSubItems2.append({"alarmName":qsTr("OvrCrntFlt"),"alarmVal":0});
                }
            }
            ListModel{
                id:spSubItems3
                Component.onCompleted: {
                    spSubItems3.append({"alarmName":qsTr("InitFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("EepromFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("AdcFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("ExecTmFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("OverTempFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("OvFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("LvFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("MainPowerOff"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("GateKillFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("OvrTempFlt2"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("OvrLdFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("OvrSpdFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("OvrFrqFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("PosErrOvrFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("MtrEncFlt"),"alarmVal":0});
                    spSubItems3.append({"alarmName":qsTr("OvrCrntFlt"),"alarmVal":0});
                }
            }
            ICListView{
                id:statusSubView
                property variant tableMargin: [150,80]
                color: "white"
                anchors.left: spLeftLine2.right
                anchors.top: spTitleLine.bottom
                anchors.bottom: spSubHeadLine2.top
                width: tableMargin[0]+tableMargin[1] +2
                clip: true
                ICSpliteLine{
                    id:spLeftLine3
                    color: "black"
                    anchors.left: parent.left
                    anchors.leftMargin: statusSubView.tableMargin[0]
                    direction:"verticality"
                    anchors.top: parent.top
                    anchors.topMargin: -31
                    linelong: parent.height+31
                    wide: 1
                }
                ICSpliteLine{
                    id:spLeftLine4
                    color: "black"
                    anchors.left: spLeftLine3.right
                    anchors.leftMargin: statusSubView.tableMargin[1]
                    direction:"verticality"
                    anchors.top: parent.top
                    anchors.topMargin: -31
                    linelong: parent.height+31
                    wide: 1
                }
                delegate: Rectangle{
                    width: parent.width
                    height:30
                    color: ListView.isCurrentItem?"lightsteelblue":"white"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            statusSubView.currentIndex = index;
                        }
                    }
                    Text {
                        id:alarmNameText
                        height: parent.height
                        width: statusSubView.tableMargin[0]
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text: alarmName
                    }
                    Text{
                        id:alarmValText
                        anchors.left:alarmNameText.right
                        height: parent.height
                        width: statusSubView.tableMargin[1]
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text: alarmVal
                    }
                    ICSpliteLine{
                        color: "black"
                        anchors.top:parent.bottom
                        anchors.topMargin: -1
                        wide: 1
                        linelong: parent.width
                        direction:"horizontal"
                    }
                }
//                onCurrentItemChanged: {
//                    alarmDescText.text = model.get(currentIndex).desc;
//                }
            }
            Rectangle{
                id:axisStatusRow
                anchors.top: spSubHeadLine2.bottom
                height:35
                width: parent.width
                Row{
                    x:5
                    height: parent.height
                    spacing:30
                    Repeater{
                        id:statusDisply
                        model:4
                        Row{
                            spacing: 2
                            height:25
                            anchors.verticalCenter: parent.verticalCenter
                            states: [
                                State {
                                    name: "stop"
                                    PropertyChanges {target: colorStatus; color:"yellow";}
                                    PropertyChanges {target: textStatus; text:qsTr("inStop");}
                                },
                                State {
                                    name: "running"
                                    PropertyChanges {target: colorStatus; color:"green";}
                                    PropertyChanges {target: textStatus; text:qsTr("inRunning");}
                                },
                                State {
                                    name: "alarm"
                                    PropertyChanges {target: colorStatus; color:"red";}
                                    PropertyChanges {target: textStatus; text:qsTr("inAlarm");}
                                },
                                State {
                                    name: "noRefresh"
                                    PropertyChanges {target: colorStatus; color:"gray";}
                                    PropertyChanges {target: textStatus; text:qsTr("inNoRefresh");}
                                }
                            ]
                            Rectangle{
                                id:colorStatus
                                height: 20
                                radius: height >> 1
                                width: height
                            }
                            Text {
                                id: axisName
                                verticalAlignment:Text.AlignVCenter
                                text: AxisDefine.axisInfos[index].name + qsTr("axis")+":"
                            }
                            Text {
                                id: textStatus
                                verticalAlignment:Text.AlignVCenter
                            }
                            Component.onCompleted: {
                                state = "stop";
                            }
                        }
                    }
                }
            }
        }

        Timer{
            id:queryTimer
            interval: 300;running: visible;repeat: true
            onTriggered: {
                var i,j;
                if(rE2promBtn.isBeginReadEeprom){
                    var isDataReady = panelRobotController.getQkEepromConfigValue(254);
                    var toSendID=0;
                    var tmpData = [];
                    if(isDataReady != 4){
                        panelRobotController.readMultipleQkEeprom(254,1);
                    }
                    else{
                        rE2promBtn.isBeginReadEeprom = false;
                        panelRobotController.readAllQkEeprom();
                    }
                }
                if(statusPageBtn.isChecked){
                    if(!refreshEnBtn.isChecked || panelRobotController.currentErrNum()==9){
                        for(i=0;i<4;i++){
                            statusDisply.itemAt(i).state = "noRefresh";
                        }
                    }
                    else{
                        var axisStatus,alarmStatus;
                        for(i=0;i<4;i++){
                            axisStatus = panelRobotController.getQkStatusConfigValue(4+i);
                            alarmStatus = panelRobotController.getQkStatusConfigValue(8+i);
                            if(alarmStatus){
                                statusDisply.itemAt(i).state = "alarm";
                            }
                            else{
                                if((axisStatus >>3)&0x01){
                                    statusDisply.itemAt(i).state = "running";
                                }
                                else{
                                    statusDisply.itemAt(i).state = "stop";
                                }
                            }
                            for(j=0;j<16;++j){
                                statusPage.subItems[i].get(j).alarmVal = (axisStatus>>j)&0x01;
                            }
                        }
                        panelRobotController.readMultipleQkStatus((1<<2)+0,8);
                    }
                }
            }
        }


        function onReadEepromFinished(){
            console.log("ReadFinish");
            var i,j,toRefreshID=0,toRefreshAddr;
            var tmpData = [];
            for(i=0;i<9;++i){
                toRefreshAddr = (toRefreshID<<8) + dataPage.subItems[0].get(i).addr;
                dataPage.subItems[0].get(i).rVal = panelRobotController.getQkEepromConfigValue(toRefreshAddr);
            }

            for(j=0;j<4;++j){
                for(i=0;i<16;++i){
                   toRefreshAddr = (toRefreshID<<8) + dataPage.subItems[5*j+1].get(i).addr;
                   dataPage.subItems[5*j+1].get(i).rVal = panelRobotController.getQkEepromConfigValue(toRefreshAddr);
                }
                for(i=0;i<25;++i){
                   toRefreshAddr = (toRefreshID<<8) + dataPage.subItems[5*j+2].get(i).addr;
                   dataPage.subItems[5*j+2].get(i).rVal = panelRobotController.getQkEepromConfigValue(toRefreshAddr);
                }
                for(i=0;i<16;++i){
                   toRefreshAddr = (toRefreshID<<8) + dataPage.subItems[5*j+3].get(i).addr;
                   dataPage.subItems[5*j+3].get(i).rVal = panelRobotController.getQkEepromConfigValue(toRefreshAddr);
                }
                for(i=0;i<10;++i){
                   toRefreshAddr = (toRefreshID<<8) + dataPage.subItems[5*j+4].get(i).addr;
                   dataPage.subItems[5*j+4].get(i).rVal = panelRobotController.getQkEepromConfigValue(toRefreshAddr);
                }
                for(i=0;i<6;++i){
                   toRefreshAddr = (toRefreshID<<8) + dataPage.subItems[5*j+5].get(i).addr;
                   dataPage.subItems[5*j+5].get(i).rVal = panelRobotController.getQkEepromConfigValue(toRefreshAddr);
                }
                toRefreshID ++;
            }
            tipBox.hide();
        }

        Component.onCompleted: {
            pageContainer.addPage(dataPage);
            pageContainer.addPage(statusPage);
            pageContainer.setCurrentIndex(0);
            menuArea.checkedIndexChanged.connect(menuArea.onItemChanged);
            panelRobotController.readQkEepromFinished.connect(onReadEepromFinished);
        }
    }

//    Item {
//        visible: false
//        width: parent.width
//        height: parent.height

//        Row{
//            id:qkConfigContainer
//            spacing: 6
//            ICConfigEdit{
//                id:axisEdit
//                configName: qsTr("Axis")
//            }
//            ICConfigEdit{
//                id:addrEdit
//                configName: qsTr("Addr")
//                isNumberOnly: false
//            }
//            ICConfigEdit{
//                id:dataEdit
//                configName: qsTr("Data")
//                isNumberOnly: false
//            }
//        }
//        Row{
//            spacing: 6
//            ICButton {
//                id:writeBtn
//                text: qsTr("Write")
//                onButtonClicked: {
//                    panelRobotController.writeQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), parseInt(dataEdit.configValue, 16));
//                }
//            }
//            ICButton {
//                id:readBtn
//                text: qsTr("Read")
//                onButtonClicked: {
//                    panelRobotController.readQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16));
//                }
//            }
//            ICButton{
//                id:writeEPBtn
//                text: qsTr("Write EP")
//                onButtonClicked: {
//                    panelRobotController.writeQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), parseInt(dataEdit.configValue, 16), true);
//                }
//            }
//            ICButton{
//                id:readEPBtn
//                text: qsTr("Read EP")
//                onButtonClicked: {
//                    panelRobotController.readQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), true);

//                }
//            }

//            anchors.top: qkConfigContainer.bottom
//            anchors.topMargin: 6
//        }
//        function onReadFinished(data){
//            console.log("onReadFinished", data);
//            dataEdit.configValue = ((data>>16) & 0xFFFF).toString(16);
//        }

//        Component.onCompleted: {
//            panelRobotController.readQKConfigFinished.connect(onReadFinished);
//        }
//    }
}
