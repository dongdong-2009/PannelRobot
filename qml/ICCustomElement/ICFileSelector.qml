import QtQuick 1.1

MouseArea{
    id:instance
    width: parent.width
    height: parent.height
    signal gotFileContent(string content)
    Rectangle {
        width: parent.width
        height: parent.height
        ListModel{
            id: fileModel
        }
        border.color: "black"
        border.width: 1
        Column{
            width: parent.width - 4
            height: parent.height -4
            spacing: 4
            x:4
            y:4
            ListView{
                id:fileView
                width: parent.width - 10
                height: parent.height - buttonGroup.height - 10

                clip: true
                model:  fileModel
                delegate: Rectangle{
                    width: parent.width - border.width
                    height: 40
                    border.width: 1
                    border.color: "gray"
                    color: fileView.currentIndex == index ? "lightsteelblue" : "white"
                    Row{
                        width: parent.width
                        height: parent.height
                        x:4
                        Item{
                            width: parent.width
                            height: parent.height
                            Row{
                                width: parent.width
                                height: parent.height
                                spacing: 10

                                Text{
                                    text: name
                                    width:parent.width * 0.5
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    fileView.currentIndex = index;
                                }
                            }
                        }
                    }
                }
            }
            Row{
                id:buttonGroup
                spacing: 10
                ICButton{
                    id:okBtn
                    text: qsTr("Ok")
                    bgColor: "lime"
                    onButtonClicked: {
                        gotFileContent(panelRobotController.usbFileContent(fileModel.get(fileView.currentIndex).name, true));
                        instance.visible = false;

                    }
                }
                ICButton{
                    id:cancelBtn
                    text: qsTr("Cancel")
                    bgColor: "yellow"
                    onButtonClicked: {
                        instance.visible = false;
                    }
                }
            }
        }

        onVisibleChanged:{
            if(visible){
                fileModel.clear();
                var files = JSON.parse(panelRobotController.scanUSBFiles("*"));
                for(var i = 0; i < files.length; ++i){
                    fileModel.append({"name":files[i]});
                }
            }
        }
    }
}
