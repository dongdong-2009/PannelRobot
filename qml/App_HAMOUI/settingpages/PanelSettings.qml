import QtQuick 1.1
import "../../ICCustomElement"
import '..'
import "../../utils/utils.js" as Utils

Item {
    id:myitem
    function showMenu(){
        configsContainer.visible = false;
        menu.visible = true;
    }
    property variant pages: []
    Grid{
        id:menu
        x:6
        columns: 4
        spacing: 20
        anchors.centerIn: parent

        CatalogButton{
            id:panelMenuBtn
            text: qsTr("Panel Settings")
            icon: "../images/settings_panel_config.png"
        }
        CatalogButton{
            id:maintainMenuBtn
            text: qsTr("Maintain")
            icon: "../images/settings_maintain.png"
        }
        CatalogButton{
            id:usermanegement
            text: qsTr("Usermanegement")
            icon: "../images/usermanagement.png"
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
    onVisibleChanged: {
        if(visible)
            showMenu();
    }

    Component.onCompleted: {
        configsContainer.addNav(maintainMenuBtn, Qt.createComponent('maintainPage.qml'));
        configsContainer.addNav(panelMenuBtn, Qt.createComponent('panelSettingsPage.qml'));
        configsContainer.addNav(usermanegement, Qt.createComponent('UsermanagementPage.qml'));
    }

}

