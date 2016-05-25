#! /bin/sh
v=`cat qml/App_HAMOUI/settingpages/maintainPage.qml | grep 'qsTr("UI Version:")' | awk -F '+' '{print $2}' | sed  's/"//g' | sed 's/ //g'`
echo $2
echo $1/HCRobot-${v}.tar.bfe
cp $2 $1/HCRobot-${v}.tar.bfe
