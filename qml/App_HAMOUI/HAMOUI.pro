TRANSLATIONS += translations/HAMOUI_zh_CN.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/* \
configs/* \
settingpages/*
}

OTHER_FILES += \
    settingpages/AxisConfigs.qml \
    settingpages/PanelSettings.qml


