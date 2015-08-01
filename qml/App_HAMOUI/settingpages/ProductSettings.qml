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
    }

    Component.onCompleted: {
        var ps = [];
        ps.push(productPage);
        pages = ps;
    }

}
