import QtQuick 1.1

Item {
    property int currentIndex: -1
    property variant pages: []

    function addPage(componentObject){
//        componentObject.anchors.fill = this;
        var p = pages;
        p.push(componentObject)
        pages = p;
        componentObject.visible = false;
        componentObject.x = 2;
        componentObject.y = 2;
        componentObject.width = parent.width;
        componentObject.height = parent.height;
        return pages.length;
    }

    function setCurrentIndex(index){
        currentIndex = index;
    }

    function currentPage(){
        return pages[currentIndex];
    }

    onCurrentIndexChanged: {
        for(var i = 0; i < pages.length; ++i){
            pages[i].visible = false;
        }
        pages[currentIndex].visible = true;
    }
}
