import QtQuick 1.1
import "../../ICCustomElement"
import '..'

Item {
    function showMenu(){
        for(var i = 0; i < pages.length; ++i){
            pages[i].visible = false;
        }

        menu.visible = true;
    }
    property variant pages: []
    Grid{
        id:menu
        x:6
        columns: 4
        spacing: 20
        CatalogButton{
            id:maintainMenuBtn
            text: qsTr("Maintain")
            icon: "../images/product.png"
            y:10
            x:10
            onButtonClicked: {
                maintainPage.visible = true;
                menu.visible = false;
            }
        }
    }

    ICSettingConfigsScope{
        id:maintainPage
        visible: false
        y:2
        x:2
        Row{
            spacing: 6
            Rectangle{
                id:listViewContainer
                width: 600
                height: 380
                ListModel{
                    id:updaterModel
                }

                ListView{
                    id:updaterView
                    width: parent.width
                    height: parent.height
                    model: updaterModel
                    delegate: Rectangle{
                        width: parent.width
                        height: 32
                        border.width: 1
                        border.color: "black"
                        color: updaterView.currentIndex == index ? "lightsteelblue" : "white"

                        Text{
                            text: name
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                updaterView.currentIndex = index;
                            }
                        }
                    }
                }
            }
            Column{
                spacing: 6
                ICButton{
                    id:scanUpdater
                    text: qsTr("Scan Updater")
                    width: 150
                    height: 32
                    onButtonClicked: {
                        var updatersJSON = panelRobotController.scanUSBUpdaters("HCRobot");

                        var upaaters = JSON.parse(updatersJSON);
                        updaterModel.clear();
                        for(var i = 0; i < upaaters.length; ++i){
                            updaterModel.append({"name":upaaters[i]});
                        }
                    }
                }
                ICButton{
                    id:startUpdate
                    text: qsTr("Start Update")
                    width: 150
                    height: 32
                    onButtonClicked: {
                        panelRobotController.startUpdate(updaterModel.get(updaterView.currentIndex).name)
                    }
                }

            }
        }
    }

    Component.onCompleted: {
        var ps = [];
        ps.push(maintainPage);
        pages = ps;
    }

}
