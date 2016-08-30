import QtQuick 1.1

ICCheckBox{
    property string configAddr: ""
    property string configValue: ""
    onConfigValueChanged: {
        isChecked = parseInt(configValue) > 0;
    }
    onIsCheckedChanged: {
        configValue = isChecked ? "1" : "0";
    }
}
