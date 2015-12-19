import QtQuick 1.1
import "../../ICCustomElement"
import '..'

Item {
    function showMenu(){
        configsContainer.visible = false;
        menu.visible = true;
    }
//    function showConfigPage(index){
//        configsContainer.visible = true;
//        menu.visible = false;
//    }

    QtObject{
        id:pData
//        property variant pages: []
    }

    width: parent.width
    height: parent.height
    Grid{
        id:menu
//        x:6
        columns: 4
        spacing: 50
        anchors.centerIn: parent
        CatalogButton{
            id:runningConfigsBtn
            text: qsTr("Running Configs")
            icon: "../images/settings_running_config.png"
//            y:10
//            x:10
        }
        CatalogButton{
            id:axisConfigBtn
            text: qsTr("Axis Configs")
            icon: "../images/settings_struct_config.png"

        }
        CatalogButton{
            id:reserveDefineBtn
            text: qsTr("Reserve Define")
            icon: "../images/product.png"

        }
        CatalogButton{
            id:limitDefineBtn
            text: qsTr("Limit Define")
            icon: "../images/product.png"

        }

        CatalogButton{
            id:timeConfigBtn
            text: qsTr("Time Configs")
            icon: "../images/product.png"

        }

        CatalogButton{
            id:otherConfigBtn
            text: qsTr("Other Configs")
            icon: "../images/product.png"

        }
    }
    ICNavScope{
        id:configsContainer
        width: parent.width
        height: parent.height
        visible: false
        onPageSwiched: {
            visible = true;
            menu.visible = false;
        }

//        triggerItemToPageMapList:[{"triggerItem":axisConfigBtn,"page":"AxisConfigs.qml"}]
    }


    Component.onCompleted: {
        configsContainer.addNav(axisConfigBtn, Qt.createComponent('AxisConfigs.qml'));
        configsContainer.addNav(runningConfigsBtn, Qt.createComponent('RunningConfigs.qml'));
//        console.log(url("./AxisConfigs.qml"));
//        var configs = Qt.createComponent('AxisConfigs.qml');
//        var axisConfig = configs.createObject(configsContainer);
//        configsContainer.addPage(axisConfig);
    }

}
