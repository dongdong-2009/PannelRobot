TRANSLATIONS += translations/HAMOUI_zh_CN.ts translations/HAMOUI_en_US.ts
lupdate_only{
SOURCES = *.qml \
          *.js \
teach/*.js \
teach/*.qml \
configs/* \
settingpages/* \
../ICCustomElement/*
}

OTHER_FILES += \
<<<<<<< HEAD
    ../tests/GcodeTests.qml
=======
    teach/CounterActionEditorComponent.qml \
    teach/CounterActionEditor.js

>>>>>>> vision_develop_manual_ds



