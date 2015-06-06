import QtQuick 1.1

Rectangle {
    property int currentIndex: -1
    property variant pages: []

    function addPage(componentObject){
        componentObject.anchors.fill = this;
        var p = pages;
        p.push(componentObject)
        pages = p;
        componentObject.visible = false;
        return pages.length;
    }

    function setCurrentIndex(index){
        currentIndex = index;
    }

    onCurrentIndexChanged: {
        for(var i = 0; i < pages.length; ++i){
            pages[i].visible = false;
        }
        pages[currentIndex].visible = true;
    }
}
