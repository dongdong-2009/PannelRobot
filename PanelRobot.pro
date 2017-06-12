
QT       += script opengl webkit
#TEMPLATE = app
VERSION = 1.0.1
VERSTR = '\\"$${VERSION}\\"'
DEFINES += SW_VER=\"$${VERSTR}\"
DEFINES += UART_COMM
DEFINES += NEW_PLAT

SK_SIZE = 8

unix:QMAKE_CXX = ccache $${QMAKE_CXX}

#DEFINES += COMM_DEBUG
suffix = $${VERSION}
CONFIG(debug, debug|release) {
suffix = $${suffix}_debug
#DEFINES += TEST_STEP
#DEFINES += TEST_ALARM
#DEFINES += COMM_DEBUG
}
else{
suffix = $${suffix}_release
}
DESTDIR = bin_$${suffix}
OBJECTS_DIR = temp_$${suffix}
UI_DIR = temp_$${suffix}
MOC_DIR = temp_$${suffix}
RCC_DIR = temp_$${suffix}

INCLUDEPATH += vendor/protocol/


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
SOURCES += main.cpp \
    icsplashscreen.cpp
# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick1applicationviewer/qtquick1applicationviewer.pri)
include(vendor/IndustrialSystemFramework/ICCore/ICCore.pri)
include(vendor/IndustrialSystemFramework/ICUtility/ICUtility.pri)
include(vendor/IndustrialSystemFramework/QJson/QJson.pri)
include(vendor/quazip/quazip.pri)
#include(vendor/qwt/qwt.pri)

include(virtualhost/virtualhost.pri)
include(datamanerger/datamanerger.pri)
include(controller/controller.pri)
include(common/common.pri)
include(extentui/extentui.pri)
include(vendor/dxflib/dxflib.pri)

qtcAddDeployment()

configAddrTarget.target = .genAddr
contains(DEFINES, NEW_PLAT){
configAddrTarget.commands = python3 tools/addrgen_new_plat.py ./vendor/protocol/hccommparagenericdef.h vendor/IndustrialSystemFramework/ICCore/icaddrwrapper.h ./vendor/protocol/icdefaultconfig.csv common $${RCC_DIR}
#configAddrTarget.commands = python tools/addrgen.py defines/configs.csv common
buildDB.target = .buildDB
buildDB.commands = sqlite3 $${DESTDIR}/RobotDatabase < $${RCC_DIR}/db.sql
buildDB.depends = configAddrTarget
QMAKE_EXTRA_TARGETS += buildDB
#PRE_TARGETDEPS += .buildDB
}else{

configAddrTarget.commands = python tools/addrgen.py defines/configs.csv common
}
QMAKE_EXTRA_TARGETS += configAddrTarget
unix:PRE_TARGETDEPS += .genAddr

reinstallDir = tools/Reinstall/
updateDir = tools/Update

target.path = /opt/Qt/apps

CONFIG(release, debug|release) {
message("in release")
db.path = /opt/Qt/apps/
db.files += $${reinstallDir}/RobotDatabase
}
CONFIG(Reinstall, debug|release|Reinstall){
message("in Reinstall")
INSTALLS += db configs
}

#db.path = /opt/Qt/apps/
#db.files += $${reinstallDir}/RobotDatabase
qmap.path = /home/root
qmap.files += $${reinstallDir}/$${SK_SIZE}-inch-qmap/*
usr_bin_scripts.path = /usr/bin
usr_bin_scripts.files += $${reinstallDir}/usr_bin_scripts/*
usr_bin_scripts.files += $${reinstallDir}/$${SK_SIZE}RunApp/*
usr_sbin_scripts.path = /usr/sbin
usr_sbin_scripts.files += $${reinstallDir}/usr_sbin_scripts/*
configs.path = /opt/Qt/apps/sysconfig
configs.files += $${reinstallDir}/configs/PanelRobot.ini
testapp.path = /opt/Qt/apps
testapp.files += $${reinstallDir}/3a8HardwareTest*
styles.path = /opt/Qt/apps
styles.files += webkit.css

qmls.path = $${target.path}/qml
qmls.files += qml/App_*

INSTALLS += qmap usr_bin_scripts usr_sbin_scripts qmls testapp styles

#INSTALLS += target
message($${INSTALLS})

OTHER_FILES += \
    defines/configs.csv \
    Init/main.qml

UPDir = $${DESTDIR}/HCRobot-$${VERSION}
updateCmd = '"tar xJvf PanelRobot.tar.xz -C / ; cp /opt/Qt/apps/RobotDatabase /mnt/udisk -f"'
UPMakerStr = "mkdir $${UPDir} && mkdir PanelRobot && tar xvf PanelRobot.tar -C PanelRobot && cd  PanelRobot && tar -cJvf PanelRobot.tar.xz * && cd ../ && cp PanelRobot/PanelRobot.tar.xz $${UPDir} && rm -r PanelRobot && cp $${updateDir}/* $${UPDir} && echo $${updateCmd} > $${UPDir}/update_cmd && cd $${DESTDIR} && tar -cf HCRobot-$${VERSION}.tar HCRobot-$${VERSION} && HCbcrypt.sh HCRobot-$${VERSION}.tar  &&  cd ../ && tools/versionUpdater.sh $${DESTDIR} $${UPDir}.tar.bfe"
unix:QMAKE_POST_LINK += "rm -rf $${UPDir} && echo '$${UPMakerStr}'> UPMaker && chmod +x UPMaker && chmod +x tools/versionUpdater.sh"
#unix:QMAKE_PRE_LINK += ""

HEADERS += \
    icsplashscreen.h

TRANSLATIONS += PanelRobot_zh_CN.ts PanelRobot_en_US.ts

RESOURCES += \
    resource.qrc
LIBS += -lz
