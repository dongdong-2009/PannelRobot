import QtQuick 1.1
import "."

Rectangle {
    property int currentIndex: -1
    QtObject{
        id:pData
        property variant pages: []
        property variant menuItems: []
    }
    Rectangle{
        id:menuContainer
        width: parent.width
        height: parent.height * 0.05
        Text {
            id: name
            text: qsTr("text")
        }

    }
    Rectangle{
        id:pageContaner
        width: parent.width
        height: parent.height * 0.95
        Text {
            id: name1
            text: qsTr("text1")
        }
        anchors.top: menuContainer.bottom
    }


    function addPage(componentObject, pageTitle){
        //        componentObject.anchors.fill = this;
        var tmIClass = Qt.createComponent('TabMenuItem.qml');
        if (tmIClass.status == Component.Ready){
            var menuItem = tmIClass.createObject(menuContainer, {"itemText":pageTitle,
                                                 "width":150,"height":32});
            var m = pData.menuItems;
            m.push(menuItem);
            pData.menuItems = m;

            var p = pData.pages;
            p.push(componentObject)
            pData.pages = p;
            componentObject.visible = true;

        }
        return pData.pages.length;
    }
}

