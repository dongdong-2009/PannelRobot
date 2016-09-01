import QtQuick 1.1
import "../../ICCustomElement"
import '..'
import "../../utils/utils.js" as Utils
import "../ShareData.js" as ShareData

Item {
    id:myitem
    function showMenu(){
        configsContainer.visible = false;
        menu.visible = true;
    }
    function onUserChanged(user){
        var isuserEn = ShareData.UserInfo.currentHasUserPerm();
        var issystemEn = ShareData.UserInfo.currentHasSystemPerm();
        var isClientEn = ShareData.UserInfo.currentHasMoldPerm() ||
                ShareData.UserInfo.currentHasSystemPerm();
        usermanegement.enabled = isuserEn;
        maintainMenuBtn.enabled = issystemEn;
        panelMenuBtn.enabled = isClientEn;
        picSettingMenuBtn.enabled = isClientEn;
        networkMenuBtn.enabled = isClientEn;
    }
    property variant pages: []
    Grid{
        id:menu
        x:6
        columns: 4
        spacing: 50
        anchors.centerIn: parent

        CatalogButton{
            id:panelMenuBtn
            text: qsTr("Panel Settings")
            icon: "../images/settings_panel_config.png"
            enabled: false

        }
        CatalogButton{
            id:networkMenuBtn
            text: qsTr("Network Settings")
            icon: "../images/settings_network_config.png"
            enabled: false
        }
        CatalogButton{
            id:picSettingMenuBtn
            text: qsTr("Picture Settings")
            icon: "../images/settings_picture_config.png"
            enabled: false
        }
        CatalogButton{
            id:registerMenuBtn
            text: qsTr("Register")
            icon: "../images/settings_register.png"
            enabled: true
        }

        CatalogButton{
            id:maintainMenuBtn
            text: qsTr("Maintain")
            icon: "../images/settings_maintain.png"
            enabled: false
        }
        CatalogButton{
            id:usermanegement
            text: qsTr("Usermanegement")
            icon: "../images/usermanagement.png"
            enabled: false
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

    }
    onVisibleChanged: {
        if(visible)
            showMenu();
    }

    Component.onCompleted: {
        configsContainer.addNav(maintainMenuBtn, Qt.createComponent('maintainPage.qml'));
        configsContainer.addNav(panelMenuBtn, Qt.createComponent('panelSettingsPage.qml'));
        configsContainer.addNav(picSettingMenuBtn, Qt.createComponent('PictureSettings.qml'));
        configsContainer.addNav(usermanegement, Qt.createComponent('UsermanagementPage.qml'));
        configsContainer.addNav(networkMenuBtn, Qt.createComponent('NetworkSettings.qml'));
        configsContainer.addNav(registerMenuBtn, Qt.createComponent('RegisterUseTimeSettings.qml'));
        ShareData.UserInfo.registUserChangeEvent(myitem);

    }

}

