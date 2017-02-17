import QtQuick 1.1
import "../../ICCustomElement"
import '..'
import "../ShareData.js" as ShareData


Item {
    id:container
    function showMenu(){
        configsContainer.visible = false;
        menu.visible = true;
    }

    function onUserChanged(user){
        var isEn = ShareData.UserInfo.currentHasSystemPerm();
        runningConfigsBtn.enabled = isEn;
        axisConfigBtn.enabled = isEn;
        structConfigBtn.enabled = isEn;
        systemConfigBtn.enabled = ShareData.UserInfo.currentSZHCPerm();
        qkConfigBtn.enabled = isEn;
        safeAreaBtn.enabled = isEn;
        originSettingBtn.enabled = isEn;
        autoDebugBtn.enabled = isEn;
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
            enabled: false
        }
        CatalogButton{
            id:axisConfigBtn
            text: qsTr("Motor Configs")
            icon: "../images/settings_motor_config.png"
            enabled: false

        }
        CatalogButton{
            id:structConfigBtn
            text: qsTr("Struct Configs")
            icon: "../images/settings_struct_config.png"
            enabled: false
        }

        CatalogButton{
            id:systemConfigBtn
            text: qsTr("System Configs")
            icon: "../images/settings_system_config.png"
            enabled: false

        }

        CatalogButton{
            id:qkConfigBtn
            text: qsTr("QK Configs")
            icon: "../images/settings_qk.png"
            enabled: false
            visible: false

        }

        CatalogButton{
            id:safeAreaBtn
            text: qsTr("SafeArea Configs")
            icon: "../images/logo.png"
            enabled: false
        }

        CatalogButton{
            id:originSettingBtn
            text: qsTr("Origin Setting")
            icon: "../images/origin1.png"
            enabled: safeAreaBtn.enabled
        }
        
        CatalogButton{
            id:autoDebugBtn
            text: qsTr("Auto Debug")
            icon: "../images/modeAuto.png"
            enabled: false
            visible: false
        }


//        CatalogButton{
//            id:otherConfigBtn
//            text: qsTr("Other Configs")
//            icon: "../images/product.png"

//        }
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
        configsContainer.addNav(axisConfigBtn, Qt.createComponent('AxisConfigs.qml'));
        configsContainer.addNav(runningConfigsBtn, Qt.createComponent('RunningConfigs.qml'));
        configsContainer.addNav(structConfigBtn, Qt.createComponent('StructConfigs.qml'));
        configsContainer.addNav(systemConfigBtn, Qt.createComponent('SystemConfigs.qml'));
        configsContainer.addNav(qkConfigBtn, Qt.createComponent('QKConfigs.qml'));
        configsContainer.addNav(safeAreaBtn, Qt.createComponent('SafeAreaConfigs.qml'));
        configsContainer.addNav(originSettingBtn, Qt.createComponent('OriginSetting.qml'));
        configsContainer.addNav(autoDebugBtn, Qt.createComponent('AutoDebugMachine.qml'));
        ShareData.UserInfo.registUserChangeEvent(container);
    }

}
