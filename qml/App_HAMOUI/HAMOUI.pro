TRANSLATIONS += translations/HAMOUI_zh_CN.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/*.js \
teach/*.qml \
configs/* \
settingpages/*
}

OTHER_FILES += \
    ICAlarmBar.qml \
    configs/AlarmInfo.js \
    ParaChose.qml \
    teach/IOTeachDescrComponent.qml



