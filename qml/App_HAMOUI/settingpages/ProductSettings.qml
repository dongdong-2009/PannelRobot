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
            id:productMenuBtn
            text: qsTr("Product")
            icon: "../images/product.png"
            y:10
            x:10
            onButtonClicked: {
                productPage.visible = true;
                menu.visible = false;
            }
        }
        CatalogButton{
            id:stackMenuBtn
            text: qsTr("stack")
            icon: "../images/product.png"
        }
    }

    ICSettingConfigsScope{
        id:productPage
        visible: false
        y:10
        x:10
        //        color: "green"
        //        width: parent.width
        //        height: parent.height
        //        anchors.fill: parent
        //        anchors.top: parent.top
        //        anchors.bottom: parent.bottom
        Row{
            spacing: 10
            Column{
                ICConfigEdit{
                    id:productTarget
                    width: 120
                    height: 32
                    configName: qsTr("Product Target")
                    configAddr: "m_rw_0_16_0_16"
                    alignMode: 1
                    unit: "a"
                }
                Row{
                    height: 32
                    ICConfigEdit{
                        width: 120
                        height: 32
                        id:debugAddr
                        configName: qsTr("Addr")
                        alignMode: 1
                    }
                    ICConfigEdit{
                        width: 120
                        height: 32
                        id:debugVal
                        configName: qsTr("value")
                        alignMode: 1
                    }
                    ICButton{
                        id:debug
                        text: qsTr("Send")
                        onButtonClicked: {
                            panelRobotController.modifyConfigValue(parseInt(debugAddr.configValue),
                                                                   parseInt(debugVal.configValue));
                        }
                    }
                }
            }

            Column{
                spacing: 6
                Text {
                    id: status1
                    text: qsTr("text")
                }
                Text {
                    id: status2
                    text: qsTr("text")
                }
                Text {
                    id: status3
                    text: qsTr("text")
                }
                Text {
                    id: status4
                    text: qsTr("text")
                }
                Text {
                    id: status5
                    text: qsTr("text")
                }
                Text {
                    id: status6
                    text: qsTr("text")
                }
                Text {
                    id: status7
                    text: qsTr("text")
                }
                Text {
                    id: status8
                    text: qsTr("text")
                }
                Text {
                    id: status9
                    text: qsTr("text")
                }
                Text {
                    id: status10
                    text: qsTr("text")
                }
                Text {
                    id: status11
                    text: qsTr("text")
                }
                Text {
                    id: status12
                    text: qsTr("text")
                }
                Text {
                    id: status13
                    text: qsTr("text")
                }
                Text {
                    id: status14
                    text: qsTr("text")
                }
                Text {
                    id: status15
                    text: qsTr("text")
                }
                Text {
                    id: status16
                    text: qsTr("text")
                }
                Timer{
                    id:refreshTimer
                    interval: 50; running: true; repeat: true
                    onTriggered: {
                        status1.text = panelRobotController.statusValue("c_r_0_32_0_900");
                        status2.text = panelRobotController.statusValue("c_r_0_32_0_901");
                        status3.text = panelRobotController.statusValue("c_r_0_32_0_902");
                        status4.text = panelRobotController.statusValue("c_r_0_32_0_903");
                        status5.text = panelRobotController.statusValue("c_r_0_32_0_904");
                        status6.text = panelRobotController.statusValue("c_r_0_32_0_905");
                        status7.text = panelRobotController.statusValue("c_r_0_32_0_906");
                        status8.text = panelRobotController.statusValue("c_r_0_32_0_907");
                        status9.text = panelRobotController.statusValue("c_r_0_32_0_908");
                        status10.text = panelRobotController.statusValue("c_r_0_32_0_909");
                        status11.text = panelRobotController.statusValue("c_r_0_32_0_910");
                        status12.text = panelRobotController.statusValue("c_r_0_32_0_911");
                        status13.text = panelRobotController.statusValue("c_r_0_32_0_912");
                        status14.text = panelRobotController.statusValue("c_r_0_32_0_913");
                        status15.text = panelRobotController.statusValue("c_r_0_32_0_914");
                        status16.text = panelRobotController.statusValue("c_r_0_32_0_915");
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        var ps = [];
        ps.push(productPage);
        pages = ps;
    }

}
