#-------------------------------------------------
#
# Project created by QtCreator 2011-06-28T07:54:09
#
#-------------------------------------------------

QT       += core

TARGET = ICKeyboardPlugin
TEMPLATE = lib
CONFIG += plugin

DESTDIR =  ../../plugins/kbddrivers

SOURCES += ickeyboardplugin.cpp \
    ickeyboardhandler.cpp

HEADERS += ickeyboardplugin.h \
    ickeyboardhandler.h
symbian {
# Load predefined include paths (e.g. QT_PLUGINS_BASE_DIR) to be used in the pro-files
    load(data_caging_paths)
    MMP_RULES += EXPORTUNFROZEN
    TARGET.UID3 = 0xE0653E88
    TARGET.CAPABILITY = 
    TARGET.EPOCALLOWDLLDATA = 1
    pluginDeploy.sources = ICKeyboardPlugin.dll
    pluginDeploy.path = $$QT_PLUGINS_BASE_DIR/ICKeyboardPlugin
    DEPLOYMENT += pluginDeploy
}

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/lib
    } else {
        target.path = /home/gausscheng/ArmLinux
    }
    INSTALLS += target
}
