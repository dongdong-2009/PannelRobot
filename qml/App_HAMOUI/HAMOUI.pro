TRANSLATIONS += translations/HAMOUI_zh_CN.ts translations/HAMOUI_en_US.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/*.js \
teach/*.qml \
configs/* \
settingpages/* \
../ICCustomElement/* \
teach/extents/*.qml \
kexuye-pentu-spec/* \
teach/extents/*.js
}

OTHER_FILES += \
    teach/extents/AnalogControlEditor.qml \
    teach/extents/ExtentActionEditorBase.qml \
    teach/extents/ExtentActionEditorBase.js \
    teach/extents/SafeRangeEditor.qml



