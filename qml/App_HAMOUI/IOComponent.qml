import QtQuick 1.1
import "configs/IODefines.js" as IODefines
//import "AppSettings.js" as UISettings
import "../ICCustomElement"
import "IOComponent.js" as PData
Rectangle {
//    QtObject{
//        id:PData
//        property string currentLanguage: UISettings.AppSettings.prototype.currentLanguage()

////        property type name: value
//    }

    Row{
        id:menuContainer
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2
        z:1
        ICButton{
            id:prev
            text: qsTr("Prev")
            width: 40
            onButtonClicked: {
                var currentTypeInfo = PData.ioViewsInfo[ioType.currentIndex];
                var cur = ioContaner.currentIndex;
                --cur;
                if(cur < currentTypeInfo.start)
                    cur = currentTypeInfo.start + currentTypeInfo.count - 1;
                ioContaner.setCurrentIndex(cur)
            }

        }


        ICComboBox{
            id:ioType
            items: [qsTr("Input"), qsTr("Output"), qsTr("EuInput"), qsTr("EuOutput")]
            height: next.height
            currentIndex: 0
            onCurrentIndexChanged: {
                ioContaner.setCurrentIndex(PData.ioViewsInfo[currentIndex].start);
            }
        }

        ICButton{
            id:next
            text: qsTr("Next")
            width: 40
            onButtonClicked: {
                var currentTypeInfo = PData.ioViewsInfo[ioType.currentIndex];
                var cur = ioContaner.currentIndex;
                ++cur;
                if(cur >= currentTypeInfo.start + currentTypeInfo.count)
                    cur = currentTypeInfo.start;
                ioContaner.setCurrentIndex(cur)
            }

        }
    }
    ICStackContainer{
        id:ioContaner
        anchors.top: menuContainer.bottom
        anchors.topMargin: 10
        function ioDefinesToViewDefines(defs, startIndex){
            var ret = [];
            var def;
            for(var i = 0 ; i < defs.length; ++i){
                def = defs[i]
                ret[i] = {"pointNum":def.pointName,
                    "index":i + startIndex,
                    "descr":def.descr
                };
            }
            return ret;
        }

        function generatePageBaseDefines(defs,type){
            var ioView = Qt.createComponent('IOComponentView.qml');
            var ret = [];
            if (ioView.status === Component.Ready){
                var pageCount = Math.ceil(defs.length / 8);
                for(var i = 0; i < pageCount; ++i){
                    ret[i] = ioView.createObject(ioContaner,
                                                 {"ioDefines":ioDefinesToViewDefines(defs.slice(i * 8, (i + 1) * 8), i * 8), "type":type})
                }
            }
            return ret;
        }

        function appendPagesToContainer(pages, pageType, start){
            PData.ioViewsInfo[pageType] = {"start":start, "count":pages.length};
            for(var i = 0; i < pages.length; ++i){
                ioContaner.addPage(pages[i]);
            }
        }

        Component.onCompleted: {
            var xDefs = IODefines.xDefines;
            var yDefs = IODefines.yDefines;
            var euxDefs = IODefines.euxDefines;
            var euyDefs = IODefines.euyDefines;

            PData.xPages = generatePageBaseDefines(xDefs, IODefines.IO_TYPE_INPUT);
            var lastLength = PData.xPages.length;
            appendPagesToContainer(PData.xPages, 0, 0);

            PData.yPages = generatePageBaseDefines(yDefs, IODefines.IO_TYPE_OUTPUT);
            appendPagesToContainer(PData.yPages, 1, lastLength);
            lastLength += PData.yPages.length;

            PData.euxPages = generatePageBaseDefines(euxDefs, IODefines.IO_TYPE_INPUT);
            appendPagesToContainer(PData.euxPages, 2, lastLength);
            lastLength += PData.euxPages.length;

            PData.euyPages = generatePageBaseDefines(euyDefs, IODefines.IO_TYPE_OUTPUT);
            appendPagesToContainer(PData.euyPages, 3, lastLength);

            ioContaner.setCurrentIndex(0)
        }
    }
    Timer{
        interval: 50; running: visible; repeat: true;
        onTriggered: {
            var xStatus = panelRobotController.iStatus(1).toString(2);
            var yStatus = panelRobotController.oStatus(1).toString(2);
            var i;
            for(i = 0; i < PData.xPages.length; ++i){
                PData.xPages[i].status = xStatus;
            }
            for(i = 0; i < PData.yPages.length; ++i){
                PData.yPages[i].status = yStatus;
            }
            xStatus = panelRobotController.iStatus(0).toString(2);
            yStatus = panelRobotController.oStatus(0).toString(2);
            for(i = 0; i < PData.euxPages.length; ++i){
                PData.euxPages[i].status = xStatus;
            }
            for(i = 0; i < PData.euyPages.length; ++i){
                PData.euyPages[i].status = yStatus;
            }

        }
    }
}
