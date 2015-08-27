#-------------------------------------------------
#
# Project created by QtCreator 2012-04-24T11:20:39
#
#-------------------------------------------------

QT       -= gui

TARGET = ICAlgorithm
TEMPLATE = lib

DEFINES += ICALGORITHM_LIBRARY

VERSION = 0.1.0
CONFIG(debug, debug|release) {
    DESTDIR = ../libs_debug
} else {
    DESTDIR = ../libs
}

SOURCES += \
    icfuzzycontroller.cpp \
    icfuzzyimplementationbase.cpp \
    ictriangularfuzzification.cpp \
    icfuzzycommon.cpp \
    icfuzzyrules.cpp \
    ictemperatureproportionrules.cpp \
    iclinguisitcvariable.cpp \
    ictemperatureintegralrules.cpp \
    ictemperaturedifferentialrules.cpp

HEADERS +=\
        ICAlgorithm_global.h \
    icfuzzycontroller.h \
    icfuzzyimplementationbase.h \
    iclinguisitcvariable.h \
    ictriangularfuzzification.h \
    icfuzzycommon.h \
    icfuzzyrules.h \
    ictemperatureproportionrules.h \
    ictemperatureintegralrules.h \
    ictemperaturedifferentialrules.h

symbian {
    MMP_RULES += EXPORTUNFROZEN
    TARGET.UID3 = 0xE760C901
    TARGET.CAPABILITY = 
    TARGET.EPOCALLOWDLLDATA = 1
    addFiles.sources = ICAlgorithm.dll
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
