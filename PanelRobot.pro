VERSION = 10.0.0
VERSTR = '\\"$${VERSION}\\"'
DEFINES += SW_VER=\"$${VERSTR}\"
DEFINES += UART_COMM
QMAKE_CXX = ccache $${QMAKE_CXX}

suffix = $${VERSION}
CONFIG(debug, debug|release) {
suffix = $${suffix}_debug
}
else{
suffix = $${suffix}_release
}
DESTDIR = bin_$${suffix}
OBJECTS_DIR = temp_$${suffix}
UI_DIR = temp_$${suffix}
MOC_DIR = temp_$${suffix}
RCC_DIR = temp_$${suffix}


# Add more folders to ship with the application, here
folder_01.source = qml/PanelRobot
folder_01.target = qml
ICCustomElement.source = qml/ICCustomElement
ICCustomElement.target = qml
configs.source = qml/PanelRobot
configs.target = qml
DEPLOYMENTFOLDERS = folder_01 ICCustomElement configs

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick1applicationviewer/qtquick1applicationviewer.pri)
qtcAddDeployment()

target.path = /opt/Qt/apps/
#INSTALLS += target
message($${INSTALLS})

OTHER_FILES += \
    qml/PanelRobot/Theme.js \
    qml/ICCustomElement/ICStackContainer.qml \
    qml/PanelRobot/configs/yDefines.js

