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
kexuye-pentu-spec/*
teach/extents/*.js
}

DISTFILES += \
    kexuye-pentu-spec/KXYStackAction.qml
OTHER_FILES += \
    teach/extents/ExtentActionDefine.js





