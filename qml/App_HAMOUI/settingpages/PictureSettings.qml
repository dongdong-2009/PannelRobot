import QtQuick 1.1
import "../../ICCustomElement"

Item {
    property int scanType: 0
    ICMessageBox{
        id: tipForInstallation
        x:280
        y:100
        z: 100
        text:qsTr("In installation!")
        visible: false
    }
    Column{
        spacing: 6
        Row{
            spacing: 10
            ICListView{
                id:picView
                width: 350
                height: 300
                border.width: 1
                border.color: "black"
                color: "white"
                highlight: Rectangle { color: "lightsteelblue"; radius: 2; width: picView.width - 2; x:-2 }
                highlightMoveDuration:1
                delegate: Text {
                    text: picname
                    width: picView.width
                    height: 32
                    verticalAlignment: Text.AlignVCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            picView.currentIndex = index;
                            if(scanType==0)
                            displayImg.source = panelRobotController.getPicturesPath(picModel.get(index).picname);
                        }
                    }
                }
                ListModel{
                    id:picModel
                }
            }
            Image {
                id: displayImg
                width: 350
                height: 300
                fillMode: Image.PreserveAspectFit

            }
        }
        Row{
            spacing: 10
            ICButton{
                id:scanPic
                text: qsTr("Scan Pic")
                width: 150
                onButtonClicked: {
                    scanType=0;
                    var pics = JSON.parse(panelRobotController.getPictures());
                    picModel.clear();
                    picView.model = null;
                    for(var i = 0, len = pics.length; i < len; ++i){
                        console.log(pics[i]);
                        picModel.append({"picname": pics[i]});
                    }
                    picView.model = picModel;
                    picView.currentIndex = -1;
                }
            }
            ICButton{
                id:setAsStartUp
                text: qsTr("Set As Start Up")
                width: scanPic.width
                onButtonClicked: {
                    panelRobotController.copyPicture(picModel.get(picView.currentIndex).picname, "startup_page.png");
                }
            }
            ICButton{
                id:setAsStandby
                text: qsTr("Set As Standby")
                width: scanPic.width
                onButtonClicked: {
                    var name = picModel.get(picView.currentIndex).picname;
                    panelRobotController.copyPicture(name, name);
                    panelRobotController.setCustomSettings("StandbyPicName", name);
                }
            }
            ICCheckBox{
                id:machineImgUse
                text: qsTr("Use MachineImg")
                isChecked: panelRobotController.getCustomSettings("MachineImgPicUse", 0);
                onIsCheckedChanged: {
                    panelRobotController.setCustomSettings("MachineImgPicUse",isChecked? 1 : 0);
                }

            }

            ICButton{
                id:setAsMachineImg
                visible: machineImgUse.isChecked
                text: qsTr("Set As MachineImg")
                width: scanPic.width
                onButtonClicked: {
                    var name = picModel.get(picView.currentIndex).picname;
                    panelRobotController.copyPicture(name, name);
                    panelRobotController.setCustomSettings("MachineImgPicName", name);
                }
            }
        }
        Row{
            spacing: 10
            ICButton{
                id:scanInstructions
                text: qsTr("Scan Instructions")
                width: 150
                onButtonClicked: {
                    scanType=1;
                    var pics = panelRobotController.getInstructions();
                    picModel.clear();
                    console.log(JSON.stringify(pics));
                    picView.model = null;
                    for(var i = 0, len = pics.length; i < len; ++i){
                        console.log(pics[i]);
                        picModel.append({"picname": pics[i]});
                    }
                    picView.model = picModel;
                    picView.currentIndex = -1;
                }
            }
            ICButton{
                id:setInstructions
                text: qsTr("Set Instructions")
                width: scanInstructions.width
                onButtonClicked: {
                    if(picView.currentIndex < 0)return;
                    tipForInstallation.runningTip(qsTr("In installation!"))
                    panelRobotController.copyInstructions(picModel.get(picView.currentIndex).picname);
                    tipForInstallation.hide();
                }
            }
        }
    }
}
