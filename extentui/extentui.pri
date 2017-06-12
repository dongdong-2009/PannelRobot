INCLUDEPATH += $$PWD
DEPENDPATH += $$PWD

HEADERS += \
    $$PWD/iccomboboxview.h \
    $$PWD/icinstructionsview.h \
    $$PWD/icinstructionsviewqml.h

SOURCES += \
    $$PWD/iccomboboxview.cpp \
    $$PWD/icinstructionsview.cpp \
    $$PWD/icinstructionsviewqml.cpp

FORMS += \
    $$PWD/icinstructionsview.ui

include(icdxfeditor/icdxfeditor.pri)
