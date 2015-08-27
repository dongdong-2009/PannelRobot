#-------------------------------------------------
#
# Project created by QtCreator 2011-07-18T16:12:38
#
#-------------------------------------------------

TARGET = ICGUI
TEMPLATE = lib
VERSION = 0.1.0
DEFINES += ICGUI_LIBRARY

QT += sql

SOURCES += \
    icmainframe.cpp \
    icpagebase.cpp \
    icmenubarbase.cpp \
    icmenubarpage.cpp \
    icvirtualkeyboard.cpp \
    ichcstyle.cpp \
    icconfigmodifyrulebase.cpp \
    icsqlmodelmirror.cpp \
    icparameterrange.cpp \
    ictranslator.cpp
#    ichcstyle.cpp

HEADERS +=\
        ICGUI_global.h \
    icmainframe.h \
    icpagebase.h \
    icmenubarbase.h \
    icmenubarpage.h \
    icvirtualkeyboard.h \
    icguiutility.h \
    ichcstyle.h \
    icconfigmodifyrulebase.h \
    icsqlmodelmirror.h \
    icparameterrange.h \
    ictranslator.h

INCLUDEPATH += ../include
INCLUDEPATH += ../../ICCustomWidgets/include

CONFIG(debug, debug|release) {
    DESTDIR = ../libs_debug
    unix:LIBS += -L../libs_debug -lICCore -lICCustomWidgets
    win32:LIBS += -L../libs_debug -lICCore0 -lICCustomWidgets
    OBJECTS_DIR = temp_debug
    UI_DIR = temp_debug
    MOC_DIR = temp_debug
    RCC_DIR = temp_debug
} else {
    DESTDIR = ../libs
    unix:LIBS += -L../libs -lICCore -lICCustomWidgets
    win32:LIBS += -L../libs -lICCore0 -lICCustomWidgets
    OBJECTS_DIR = temp_release
    UI_DIR = temp_release
    MOC_DIR = temp_release
    RCC_DIR = temp_release
}

symbian {
    MMP_RULES += EXPORTUNFROZEN
    TARGET.UID3 = 0xE7A6698E
    TARGET.CAPABILITY = 
    TARGET.EPOCALLOWDLLDATA = 1
    addFiles.sources = ICGUI.dll
    addFiles.path = !:/sys/bin
    DEPLOYMENT += addFiles
}

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/lib
    } else {
        target.path = /usr/lib
    }
    INSTALLS += target
}

FORMS += \
    icvirtualkeyboard.ui

RESOURCES += \
    image.qrc

