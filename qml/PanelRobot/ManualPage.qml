import QtQuick 1.1
import "."
import "../ICCustomElement"
import "./Theme.js" as Theme

ContentPageBase{
    ICStackContainer{
        id:manualContainer
        anchors.fill: parent
        Component.onCompleted:{
            var yDefinePage1Class = Qt.createComponent('YDefinePage1.qml');
            if (yDefinePage1Class.status == Component.Ready){
                var page = yDefinePage1Class.createObject(manualContainer, {"ioStart":0})
                addPage(page)
                page = yDefinePage1Class.createObject(manualContainer, {"ioStart":16})
                addPage(page)
                menuItemTexts = ["Y010~27", "Y030~47", "", "", "", "",""]
            }
            manualContainer.setCurrentIndex(0)
        }
    }
    Rectangle{
        id:manualMenu
    }

    content: manualContainer

    onMenuItem1Triggered: manualContainer.setCurrentIndex(0)
    onMenuItem2Triggered: manualContainer.setCurrentIndex(1);
//    menu: manualMenu
}
