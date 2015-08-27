#-------------------------------------------------
#
# Project created by QtCreator 2012-03-23T08:54:39
#
#-------------------------------------------------

QT       += testlib sql

TARGET = tst_industrialsystemframeworkunittests
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += tst_industrialsystemframeworkunittests.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"

INCLUDEPATH += ../../include
INCLUDEPATH += ../../../ICCustomWidgets/include

CONFIG(debug, debug|release) {
    LIBS += -L../../libs_debug -lICCore -lICGUI -lICUtility -lICCustomWidgets -lICAlgorithm
} else {
    LIBS += -L../../libs -lICCore -lICGUI -lICUtility -lICCustomWidgets -lICAlgorithm
}
