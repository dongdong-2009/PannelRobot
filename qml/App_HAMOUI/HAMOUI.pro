TRANSLATIONS += translations/HAMOUI_zh_CN.ts translations/HAMOUI_en_US.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/*.js \
teach/*.qml \
configs/* \
settingpages/*
}

OTHER_FILES += \
    settingpages/ValveSettings.js \
    settingpages/RunningConfigs.qml \
    ICOperationLogPage.qml





