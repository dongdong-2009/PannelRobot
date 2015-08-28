TRANSLATIONS += translations/HAMOUI_zh_CN.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/* \
configs/* \
settingpages/*
}

OTHER_FILES += \
    teach/ProgramListItem.qml \
    teach/ProgramFlowPage.js




