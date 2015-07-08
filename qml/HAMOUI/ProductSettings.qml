import QtQuick 1.1
import "../ICCustomElement"

Rectangle {
    function showMenu(){
        for(var i = 0; i < pages.length; ++i){
            pages[i].visible = false;
        }

        menu.visible = true;
    }
    property variant pages: []
    Rectangle{
        id:menu
        CatalogButton{
            id:productMenuBtn
            text: qsTr("Product")
            icon: "images/product.png"
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
            icon: "images/product.png"
            anchors.verticalCenter: productMenuBtn.verticalCenter
            anchors.left: productMenuBtn.right
            anchors.leftMargin: 10
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
