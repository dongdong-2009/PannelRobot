TRANSLATIONS += translations/HAMOUI_zh_CN.ts translations/HAMOUI_en_US.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/*.js \
teach/*.qml \
configs/* \
settingpages/* \
kexuye-pentu-spec/*
}

OTHER_FILES += \
    kexuye-pentu-spec/ProgramFlowPage.qml \
    kexuye-pentu-spec/ProgramActionMenu.qml




