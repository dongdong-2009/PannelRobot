import QtQuick 1.1
import "../ICCustomElement"

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
            id:runningConfigsBtn
            text: qsTr("Running Configs")
            icon: "images/product.png"
            y:10
            x:10
            onButtonClicked: {
                productPage.visible = true;
                menu.visible = false;
            }
        }
        CatalogButton{
            id:axisConfigBtn
            text: qsTr("Axis Configs")
            icon: "images/product.png"

        }
        CatalogButton{
            id:structConfigsBtn
            text: qsTr("Struct Configs")
            icon: "images/product.png"

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
        ICConfigEdit{
            id:productTarget
            configName: qsTr("Product Target")
            configAddr: "m_rw_0_16_0_16"
            alignMode: 1
            unit: "a"
        }
    }

    Component.onCompleted: {
        var ps = [];
        ps.push(productPage);
        pages = ps;
    }

}
