import QtQuick 1.1

Item {
    id:container
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
        componentObject.width = container.width - 2;
        componentObject.height = container.height - 2;
        return pages.length - 1;
    }

    function setCurrentIndex(index){
        currentIndex = index;
    }

    function currentPage(){
        return pages[currentIndex];
    }

    onCurrentIndexChanged: {
        for(var i = 0, len = pages.length; i < len; ++i){
            pages[i].visible = false;
        }
        pages[currentIndex].visible = true;
    }
}
