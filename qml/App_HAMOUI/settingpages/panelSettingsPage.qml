import QtQuick 1.1
import "../../ICCustomElement"
import '..'
import "../../utils/utils.js" as Utils


Item{
    id:panelSettingsPage
    property int rowSpacing: 12
    ICButton{
        id:touchCalibrate
        x:500
        y:30
        text: qsTr("Touch Calibrate")
        width: 120
        onButtonClicked: {
            tip.show(qsTr("Recalibrate need to reboot. Continue?"), qsTr("Yes"), qsTr("No"));
        }
    }

    ICMessageBox{
        id:tip
        z:100
        x: 300
        y: 100
        onAccept: {
            panelRobotController.recal();
        }
    }

    Column{
        spacing: 16
        Row{
            spacing: panelSettingsPage.rowSpacing
            Text {
                id: languageLabel
                text: qsTr("Language")
                anchors.verticalCenter: parent.verticalCenter

            }
            ICButtonGroup{
                spacing: panelSettingsPage.rowSpacing
                mustChecked: true
                ICCheckBox{
                    id:chineseBox
                    text: "中文"
                    onClicked: {
                        if(isChecked){
                            panelRobotController.setCustomSettings("Language", "CN");
                            panelRobotController.setCurrentTranslator("HAMOUI_zh_CN.qm");
                        }
                    }
                }
                ICCheckBox{
                    id:englishBox
                    text:"English"
                    onClicked: {
                        if(isChecked){
                            panelRobotController.setCustomSettings("Language", "US");
                            panelRobotController.setCurrentTranslator("HAMOUI_en_US.qm");
                        }
                    }
                }
            }
        }
        Row{
            spacing: panelSettingsPage.rowSpacing
            Text {
                id: keytoneLabel
                text: qsTr("Key Tone")
                anchors.verticalCenter: parent.verticalCenter

            }
            ICButtonGroup{
                spacing: panelSettingsPage.rowSpacing
                ICCheckBox{
                    id:keyToneOff
                    text:qsTr("Key Tone Off")
                    onClicked: {
                        if(isChecked){
                            panelRobotController.setCustomSettings("Keytone", false);

                        }
                    }
                }
                ICCheckBox{
                    id:keyToneOn
                    text:qsTr("Key Tone On")
                    onClicked: {
                        if(isChecked){
                            panelRobotController.setCustomSettings("Keytone", true);

                        }
                    }
                }
                onButtonClickedItem: {
                    panelRobotController.setKeyTone(item == keyToneOn);
                }
            }
        }
        Row{
            spacing: panelSettingsPage.rowSpacing
            Text {
                id: brightnessLabel
                text: qsTr("Brightness")
                anchors.verticalCenter: parent.verticalCenter


            }
            ICButton{
                id:minusBrightness
                text: qsTr("-")
                width: height
                height: brightness.height
                onButtonClicked: {
                    brightness.setValue(brightness.value() - 1);
                }
            }

            ICProgressBar{
                id:brightness
                progressColor: "#A0A0F0"
                minimum: 1
                maximum: 8
                onValueChanged: {
                    panelRobotController.setBrightness(brightness.value());
                    panelRobotController.setCustomSettings("Brightness", brightness.value());
                }
            }
            ICButton{
                id:plusBrightness
                text: qsTr("+")
                width: height
                height: brightness.height
                onButtonClicked: {
                    brightness.setValue(brightness.value() + 1);
                }

            }

        }
        Row{
            Text {
                id: screensaverLabel
                text: qsTr("Screensaver Time")
                anchors.verticalCenter: parent.verticalCenter
            }
            ICLineEdit{
                id:screensaverTime
                unit: qsTr("min")
                onTextChanged: {
                    panelRobotController.setCustomSettings("ScreensaverTime", text);
                    panelRobotController.setScreenSaverTime(text);
                }
            }
        }

        Row{
            id:datetimeContaner
            spacing: 2
            Text {
                id: datetimeLabel
                text: qsTr("Date time")
                anchors.verticalCenter: parent.verticalCenter
            }
            function setDatetime(){
                if(Utils.isDateTimeValid(year.text,
                                         month.text,
                                         day.text,
                                         hour.text,
                                         minute.text,
                                         second.text))
                {
                    panelRobotController.setDatetime(year.text + "/" +
                                                     month.text + "/" +
                                                     day.text + " " +
                                                     hour.text + ":" +
                                                     minute.text + ":" +
                                                     second.text);
                }
            }

            ICLineEdit{
                id:year
                unit: qsTr("year")
                alignMode: 1

            }
            ICLineEdit{
                id:month
                unit: qsTr("mon")
                alignMode: 1

            }
            ICLineEdit{
                id:day
                unit: qsTr("day")
                alignMode: 1
            }
            ICLineEdit{
                id:hour
                unit: qsTr("hour")
                alignMode: 1
            }
            ICLineEdit{
                id:minute
                unit:qsTr("minute")
                alignMode: 1
            }
            ICLineEdit{
                id:second
                unit: qsTr("sec")
                alignMode: 1
            }
            Connections{
                id:yearConnection
                target: year
                onTextChanged:datetimeContaner.setDatetime();
            }
            Connections{
                id:monthConnection
                target: month
                onTextChanged:datetimeContaner.setDatetime();
            }
            Connections{
                id:dayConnection
                target: day
                onTextChanged:datetimeContaner.setDatetime();
            }
            Connections{
                id:hourConnection
                target: hour
                onTextChanged:datetimeContaner.setDatetime();
            }

            Connections{
                id:minuteConnection
                target: minute
                onTextChanged:datetimeContaner.setDatetime();
            }
            Connections{
                id:secondConnection
                target: second
                onTextChanged:datetimeContaner.setDatetime();
            }
        }
    }


    Component.onCompleted: {
        var lang = panelRobotController.getCustomSettings("Language", "");
        console.log("lang", lang == "");
        if(lang == ""){
            panelRobotController.setCustomSettings("Language", "CN");
            panelRobotController.setCurrentTranslator("HAMOUI_zh_CN.qm");
            lang = "CN";
            console.log("language", panelRobotController.getCustomSettings("Language", ""));
        }
        if(lang == "CN"){
            chineseBox.setChecked(true);
        }else if(lang == "US"){
            englishBox.setChecked(true);
        }
        var keytone = panelRobotController.getCustomSettings("Keytone", true);
        if(keytone == "true")
            keyToneOn.setChecked(true);
        else
            keyToneOff.setChecked(true);
        panelRobotController.setKeyTone(keyToneOn.isChecked);


        var brightnessval = panelRobotController.getCustomSettings("Brightness", 8);
        brightness.setValue(brightnessval);
        panelRobotController.setBrightness(brightness.value());


        var scsT = panelRobotController.getCustomSettings("ScreensaverTime", 5);
        screensaverTime.text = scsT;
        panelRobotController.setScreenSaverTime(screensaverTime.text);

    }

    onVisibleChanged: {
        if(visible){
            yearConnection.target = null;
            monthConnection.target = null;
            dayConnection.target = null;
            hourConnection.target = null;
            minuteConnection.target = null;
            secondConnection.target = null;
            var currentDate = new Date();
            year.text = currentDate.getFullYear();
            month.text = currentDate.getMonth() + 1;
            day.text =  currentDate.getDate();
            hour.text = currentDate.getHours();
            minute.text = currentDate.getMinutes();
            second.text = currentDate.getSeconds();
            yearConnection.target = year;
            monthConnection.target = month;
            dayConnection.target = day;
            hourConnection.target = hour;
            minuteConnection.target = minute;
            secondConnection.target = second;
        }
    }
}
