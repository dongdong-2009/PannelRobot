import QtQuick 1.1
import "../../ICCustomElement"

Item {
    id: root
    width: parent.width
    height: parent.height

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
            Item {
                id: listArea
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
                    }
                    ICButton{
                        id:rE2promBtn
                        height: paraConfigBtn.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("read e2prom")
                    }
                    ICButton{
                        id:wE2promBtn
                        height: paraConfigBtn.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("write e2prom")
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

                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});

                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});

                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});

                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
                        mainItems.append({"mainItemName":qsTr("common ctrl para")});
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
                anchors.left: listArea.right
                direction:"verticality"
                linelong: parent.height
                wide: 1
            }
            Row{
                id:subTitleArea
                anchors.left: leftLine2.right
                anchors.leftMargin: 4
                height: 30
                width: parent.width - listArea.width -2
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
                    width: parent.width - paraSubView.tableMargin[0] -paraSubView.tableMargin[1] -paraSubView.tableMargin[2] -paraSubView.tableMargin[3]
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
            Text{
                id:descText
                anchors.top:titleLine.bottom
                anchors.topMargin: 2
                anchors.left: paraSubView.right
                anchors.leftMargin: 2
                height: paraSubView.height
                width:descTextTitle.width
            }
            ListModel{
                id:subItems0
                Component.onCompleted: {
                    subItems0.append({"paraName":qsTr("PwmPeriod"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe1")});
                    subItems0.append({"paraName":qsTr("SampleStartDelay"),"addr":1,"wVal":0,"rVal":0,"desc":qsTr("describe2")});
                    subItems0.append({"paraName":qsTr("SpdPosLpRate"),"addr":2,"wVal":0,"rVal":0,"desc":qsTr("describe3")});
                    subItems0.append({"paraName":qsTr("ModScl"),"addr":3,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                    subItems0.append({"paraName":qsTr("PwmDeadTm"),"addr":4,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                    subItems0.append({"paraName":qsTr("SystemConfig"),"addr":5,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                    subItems0.append({"paraName":qsTr("LvAlmMonEnbl"),"addr":6,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                    subItems0.append({"paraName":qsTr("DcBusOffset"),"addr":7,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                    subItems0.append({"paraName":qsTr("BusConfig"),"addr":8,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems1
                Component.onCompleted: {
                    subItems1.append({"paraName":qsTr("DriverCtrl"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems2
                Component.onCompleted: {
                    subItems2.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems3
                Component.onCompleted: {
                    subItems3.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems4
                Component.onCompleted: {
                    subItems4.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems5
                Component.onCompleted: {
                    subItems5.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems6
                Component.onCompleted: {
                    subItems6.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems7
                Component.onCompleted: {
                    subItems7.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems8
                Component.onCompleted: {
                    subItems8.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems9
                Component.onCompleted: {
                    subItems9.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems10
                Component.onCompleted: {
                    subItems10.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems11
                Component.onCompleted: {
                    subItems11.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems12
                Component.onCompleted: {
                    subItems12.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems13
                Component.onCompleted: {
                    subItems13.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems14
                Component.onCompleted: {
                    subItems14.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems15
                Component.onCompleted: {
                    subItems15.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems16
                Component.onCompleted: {
                    subItems16.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems17
                Component.onCompleted: {
                    subItems17.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems18
                Component.onCompleted: {
                    subItems18.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems19
                Component.onCompleted: {
                    subItems19.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ListModel{
                id:subItems20
                Component.onCompleted: {
                    subItems20.append({"paraName":qsTr("PWM period"),"addr":0,"wVal":0,"rVal":0,"desc":qsTr("describe")});
                }
            }
            ICListView{
                id:paraSubView
                property variant tableMargin: [150,80,80,80]
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
                }
                onCurrentItemChanged: {
                    descText.text = model.get(currentIndex).desc;
                }
            }
        }
        Item {
            id: statusPage

        }

        Component.onCompleted: {
            pageContainer.addPage(dataPage);
            pageContainer.addPage(statusPage);
            pageContainer.setCurrentIndex(0);
            menuArea.checkedIndexChanged.connect(menuArea.onItemChanged);
        }

    }



    Item {
        visible: false
        width: parent.width
        height: parent.height

        Row{
            id:qkConfigContainer
            spacing: 6
            ICConfigEdit{
                id:axisEdit
                configName: qsTr("Axis")
            }
            ICConfigEdit{
                id:addrEdit
                configName: qsTr("Addr")
                isNumberOnly: false
            }
            ICConfigEdit{
                id:dataEdit
                configName: qsTr("Data")
                isNumberOnly: false
            }
        }
        Row{
            spacing: 6
            ICButton {
                id:writeBtn
                text: qsTr("Write")
                onButtonClicked: {
                    panelRobotController.writeQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), parseInt(dataEdit.configValue, 16));
                }
            }
            ICButton {
                id:readBtn
                text: qsTr("Read")
                onButtonClicked: {
                    panelRobotController.readQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16));
                }
            }
            ICButton{
                id:writeEPBtn
                text: qsTr("Write EP")
                onButtonClicked: {
                    panelRobotController.writeQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), parseInt(dataEdit.configValue, 16), true);
                }
            }
            ICButton{
                id:readEPBtn
                text: qsTr("Read EP")
                onButtonClicked: {
                    panelRobotController.readQKConfig(axisEdit.configValue, parseInt(addrEdit.configValue, 16), true);

                }
            }

            anchors.top: qkConfigContainer.bottom
            anchors.topMargin: 6
        }
        function onReadFinished(data){
            console.log("onReadFinished", data);
            dataEdit.configValue = ((data>>16) & 0xFFFF).toString(16);
        }

        Component.onCompleted: {
            panelRobotController.readQKConfigFinished.connect(onReadFinished);
        }
    }
}
