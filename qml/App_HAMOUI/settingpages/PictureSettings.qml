import QtQuick 1.1
import "../../ICCustomElement"

Item {
    Column{
        spacing: 6
        Row{
            spacing: 10
            ICListView{
                id:picView
                width: 350
                height: 320
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
                height: 320
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
            ICButton{
                id:setAsMachineImg
                text: qsTr("Set As MachineImg")
                width: scanPic.width
                onButtonClicked: {
                    var name = picModel.get(picView.currentIndex).picname;
                    panelRobotController.copyPicture(name, name);
                    panelRobotController.setCustomSettings("MachineImgPicName", name);
                }
            }
        }
    }
}
