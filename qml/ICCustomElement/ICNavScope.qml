import QtQuick 1.1
import '.'

Item {

    id:container
    QtObject{
        id:pData
        property variant triggerItemToPageObject: []
    }

    signal pageSwiched(variant triggerItem, variant page)
    function addNav(triggerItem, pageComponent){
        console.log("addNav:", pageComponent.errorString());
        var pageObject = pageComponent.createObject(pagesContainer);
        pageObject.width = container.width;
        pageObject.height = container.height;
        var pageIndex = pagesContainer.pages.length;
        pagesContainer.addPage(pageObject);
        triggerItem.triggered.connect(function(){
            pagesContainer.setCurrentIndex(pageIndex);
            pageSwiched(triggerItem, pageObject);
        });
    }

    ICStackContainer{
        id:pagesContainer
        width: parent.width
        height: parent.height
    }
}
