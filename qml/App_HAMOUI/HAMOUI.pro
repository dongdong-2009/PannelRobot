TRANSLATIONS += translations/HAMOUI_zh_CN.ts translations/HAMOUI_en_US.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/*.js \
teach/*.qml \
settingpages/* \
../ICCustomElement/*.qml \
../ICCustomElement/*.js \
teach/extents/*.qml \
teach/extents/*.js
}

DISTFILES += \
    settingpages/CommunicationConfig.qml \
    teach/extents/ParabolaActionEditor.qml \
    AlarmInfo.js \
    teach/extents/BarnLogicEditor.qml \
    ToolsCalibration.js \
    teach/extents/SwitchToolEditor.qml \
    settingpages/QKInfo.js






