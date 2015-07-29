
QT       += script
#TEMPLATE = app
VERSION = 10.0.0
VERSTR = '\\"$${VERSION}\\"'
DEFINES += SW_VER=\"$${VERSTR}\"
DEFINES += UART_COMM
DEFINES += NEW_PLAT

SK_SIZE = 8

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

INCLUDEPATH += vendor/procotol/


# Add more folders to ship with the application, here
#folder_01.source = qml/PanelRobot
#folder_01.target = qml
#teach.source = qml/PanelRobot/teach
#teach.target = qml/PanelRobot
ICCustomElement.source = qml/ICCustomElement
ICCustomElement.target = qml
#configs.source = qml/PanelRobot
#configs.target = qml
utils.source = qml/utils
utils.target = qml
init.source = Init
init.target = .
DEPLOYMENTFOLDERS =  ICCustomElement utils init

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick1applicationviewer/qtquick1applicationviewer.pri)
include(vendor/IndustrialSystemFramework/ICCore/ICCore.pri)
include(vendor/IndustrialSystemFramework/ICUtility/ICUtility.pri)
include(vendor/IndustrialSystemFramework/QJson/QJson.pri)

include(virtualhost/virtualhost.pri)
include(datamanerger/datamanerger.pri)
include(controller/controller.pri)
include(common/common.pri)


qtcAddDeployment()

configAddrTarget.target = .genAddr
configAddrTarget.commands = python tools/addrgen.py defines/configs.csv common

QMAKE_EXTRA_TARGETS += configAddrTarget
PRE_TARGETDEPS += .genAddr

reinstallDir = tools/Reinstall/

target.path = /opt/Qt/apps/

db.path = /opt/Qt/apps/
db.files += $${reinstallDir}/RobotDatabase
qmap.path = /home/root
qmap.files += $${reinstallDir}/$${SK_SIZE}-inch-qmap/*
usr_bin_scripts.path = /usr/bin
usr_bin_scripts.files += $${reinstallDir}/usr_bin_scripts/*
usr_bin_scripts.files += $${reinstallDir}/$${SK_SIZE}RunApp/*
INSTALLS += db qmap usr_bin_scripts
#INSTALLS += target
message($${INSTALLS})

OTHER_FILES += \
    defines/configs.csv \
    qml/ICCustomElement/ICLineEdit.qml \
    Init/main.qml

