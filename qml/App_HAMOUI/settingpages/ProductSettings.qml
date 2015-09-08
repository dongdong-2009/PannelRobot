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
    QtObject{
        id:pData
        property variant useNoUseText: [qsTr("NoUse"), qsTr("Use")]
    }

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
                ICComboBoxConfigEdit{
                    id:program0
                    width: 120
                    height: 32
                    configName: qsTr("Program0")
                    configAddr: "m_rw_0_1_0_357"
                    items: pData.useNoUseText
                }
                ICComboBoxConfigEdit{
                    id:program1
                    width: 120
                    height: 32
                    configName: qsTr("Program1")
                    configAddr: "m_rw_1_1_0_357"
                    items: pData.useNoUseText
                }
                ICComboBoxConfigEdit{
                    id:program2
                    width: 120
                    height: 32
                    configName: qsTr("Program2")
                    configAddr: "m_rw_2_1_0_357"
                    items: pData.useNoUseText
                }
                ICComboBoxConfigEdit{
                    id:program3
                    width: 120
                    height: 32
                    configName: qsTr("Program0")
                    configAddr: "m_rw_3_1_0_357"
                    items: pData.useNoUseText
                }
                ICComboBoxConfigEdit{
                    id:program4
                    width: 120
                    height: 32
                    configName: qsTr("Program0")
                    configAddr: "m_rw_4_1_0_357"
                    items: pData.useNoUseText
                }
                ICComboBoxConfigEdit{
                    id:program5
                    width: 120
                    height: 32
                    configName: qsTr("Program0")
                    configAddr: "m_rw_5_1_0_357"
                    items: pData.useNoUseText
                }
                ICComboBoxConfigEdit{
                    id:program6
                    width: 120
                    height: 32
                    configName: qsTr("Program0")
                    configAddr: "m_rw_6_1_0_357"
                    items: pData.useNoUseText
                }
                ICComboBoxConfigEdit{
                    id:program7
                    width: 120
                    height: 32
                    configName: qsTr("Program0")
                    configAddr: "m_rw_7_1_0_357"
                    items: pData.useNoUseText
                }
                ICComboBoxConfigEdit{
                    id:program8
                    width: 120
                    height: 32
                    configName: qsTr("Program0")
                    configAddr: "m_rw_8_1_0_357"
                    items: pData.useNoUseText
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
