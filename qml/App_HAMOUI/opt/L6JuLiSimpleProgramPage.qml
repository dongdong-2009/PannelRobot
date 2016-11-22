import QtQuick 1.1
import "../../ICCustomElement"
import "../teach/Teach.js" as Teach
import "../configs/AxisDefine.js" as AxisDefine
import "../teach"
Rectangle {
    id:instance

    function showActionEditorPanel(){}
    function onInsertTriggered(){}
    function onDeleteTriggered(){}
    function onUpTriggered(){}
    function onDownTriggered(){}
    function onFixIndexTriggered(){}
    function onSaveTriggered(){

    }
    Column{
        spacing: 4
        y:4
        ICButtonGroup{
            id:funSel
            isAutoSize: true
            mustChecked: true
            spacing: 40
            checkedIndex: 0
            ICCheckBox{
                id:actionInMold
                text: qsTr("In Mold")
                isChecked: true
            }
            ICCheckBox{
                id:releaseMaterial
                text: qsTr("Rel P")
            }
            ICCheckBox{
                id:getMaterial
                text:qsTr("Get M")
            }
            onButtonClickedID: {
                pageContainer.setCurrentIndex(index);
            }
        }
        Rectangle{
            id:horSplitLine
            height: 1
            color: "black"
            width: instance.width
        }
        ICStackContainer{
            id:pageContainer
            height: instance.height - funSel.height - horSplitLine.height - 90
            width: instance.width
            Component.onCompleted: {
                setCurrentIndex(addPage(inMoldPageContainer));
                addPage(releaseProductPageContainer);
                addPage(getMaterialPageContainer);
            }

            ICFlickable{
                id:inMoldPageContainer

                contentHeight: inMoldPageContent.height
                flickableDirection: Flickable.VerticalFlick
                Column{
                    id:inMoldPageContent
                    spacing: 4
                    Grid{
                        spacing: 4
                        columns: 8
                        Text {id:firstWidth;text: " ";width: 80}
                        Text {text: " "}
                        Text {text: " "}
                        Text {text: AxisDefine.axisInfos[0].name}
                        Text {text: AxisDefine.axisInfos[1].name}
                        Text {text: AxisDefine.axisInfos[2].name}
                        Text {text: AxisDefine.axisInfos[3].name}
                        Text {text: AxisDefine.axisInfos[4].name}

                        Text {text: qsTr("Standby Pos")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:spSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                        }
                        ICConfigEdit{
                            id:spm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:spm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:spm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
                        }
                        ICConfigEdit{
                            id:spm3
                            configAddr: AxisDefine.axisInfos[3].limitAddr
                        }
                        ICConfigEdit{
                            id:spm4
                            configAddr: AxisDefine.axisInfos[4].limitAddr
                        }

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:spm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:spm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:spm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:spm3Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:spm4Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:spm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:spm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:spm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:spm3Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:spm4Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }



                        Text {text: qsTr("Get Pos")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:gpSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                        }
                        ICConfigEdit{
                            id:gpm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:gpm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:gpm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
                        }
                        ICConfigEdit{
                            id:gpm3
                            configAddr: AxisDefine.axisInfos[3].limitAddr
                        }
                        ICConfigEdit{
                            id:gpm4
                            configAddr: AxisDefine.axisInfos[4].limitAddr
                        }

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gpm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gpm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gpm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gpm3Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:gpm4Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gpm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gpm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gpm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gpm3Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:gpm4Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                    }
                    Row{
                        Text {
                            id:getProductVTitle
                            text: qsTr("Get Pro V")
                            width: gpSetIn.x
                        }
                        ICValveSelComponent{
                            id:getProductVSel
                            valvesToSel: ["valve1", "valve2", "valve3", "valve4"]
                            width: inMoldPageContainer.width - getProductVTitle.width - 10
                        }
                    }
                    Grid{
                        spacing: 4
                        columns: 8

                        Text {text: qsTr("Get F B"); width: firstWidth.width}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:gFBSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                        }
                        ICConfigEdit{
                            id:gFBm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm3
                            configAddr: AxisDefine.axisInfos[3].limitAddr
                        }
                        Text {text: " "}

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm3Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        Text {text: " "}

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:gFBm3Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}

                        Text {text: qsTr("Rel M Pos")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:rMPSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                        }
                        ICConfigEdit{
                            id:rMPm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        ICConfigEdit{
                            id:rMPm1
                            configAddr: AxisDefine.axisInfos[1].limitAddr
                        }
                        ICConfigEdit{
                            id:rMPm2
                            configAddr: AxisDefine.axisInfos[2].limitAddr
                        }
                        ICConfigEdit{
                            id:rMPm3
                            configAddr: AxisDefine.axisInfos[3].limitAddr
                        }
                        ICConfigEdit{
                            id:rMPm4
                            configAddr: AxisDefine.axisInfos[4].limitAddr
                        }

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMPm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:rMPm1Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:rMPm2Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:rMPm3Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        ICConfigEdit{
                            id:rMPm4Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMPm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:rMPm1Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:rMPm2Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:rMPm3Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        ICConfigEdit{
                            id:rMPm4Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }

                        Text {text: qsTr("Rel M F B")}
                        Text {text: "(" + AxisDefine.axisInfos[0].unit + ")"}
                        ICButton{
                            id:rMFBSetIn
                            text: qsTr("Set In")
                            height: spm0.height
                        }
                        ICConfigEdit{
                            id:rMFBm0
                            configAddr: AxisDefine.axisInfos[0].limitAddr
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm3
                            configAddr: AxisDefine.axisInfos[3].limitAddr
                        }
                        Text {text: " "}

                        Text {text: qsTr("Speed")}
                        Text {text: qsTr("(%)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm0Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm3Spd
                            configAddr: "s_rw_0_32_1_1200"
                        }
                        Text {text: " "}

                        Text {text: qsTr("Delay")}
                        Text {text: qsTr("(s)")}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm0Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}
                        Text {text: " "}
                        ICConfigEdit{
                            id:rMFBm3Delay
                            configAddr: "s_rw_0_32_2_1100"
                        }
                        Text {text: " "}
                    }
                }
            }

            ICFlickable{
                id:releaseProductPageContainer
                contentHeight: releaseProductPageContent.height
                flickableDirection: Flickable.VerticalFlick
                Column{
                    spacing: 6
                    id:releaseProductPageContent
                    Item {
                        width: 50
                        height: 50
                    }

                    StackActionEditorComponent{
                        id:releaseProductStack
                        isCounterEn: false
                    }

                }
            }

            ICFlickable{
                id:getMaterialPageContainer
                contentHeight: getMaterialPageContent.height
                flickableDirection: Flickable.VerticalFlick
                Column{
                    spacing: 6
                    id:getMaterialPageContent
                    Item {
                        width: 50
                        height: 50
                    }

                    StackActionEditorComponent{
                        id:getMaterialStack
                        isCounterEn: false
                    }

                    Row{
                        Text {
                            id:getMaterialVTitle
                            text: qsTr("Get Pro V")
                            width: gpSetIn.x
                        }
                        ICValveSelComponent{
                            id:getMaterialVSel
                            valvesToSel: ["valve1", "valve2", "valve3", "valve4"]
                            width: inMoldPageContainer.width - getMaterialVTitle.width - 10
                        }
                    }
                }
            }
        }
    }
    //    Component.onStatusChanged: {
    //        console.log(errorString())
    //    }
}
