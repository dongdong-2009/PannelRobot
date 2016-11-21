TRANSLATIONS += translations/HAMOUI_zh_CN.ts translations/HAMOUI_en_US.ts translations/L6-2_zh_CN.ts translations/L6-3_zh_CN.ts translations/L6-4_zh_CN.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/*.js \
teach/*.qml \
configs/* \
settingpages/* \
../ICCustomElement/* \
teach/extents/*.qml \
teach/extents/*.js
}

OTHER_FILES += \
    opt/optconfigs.js \
    opt/L6JuLiSimpleProgramPage.qml





