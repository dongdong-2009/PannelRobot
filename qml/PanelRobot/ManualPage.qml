import QtQuick 1.1
import "."
import "../ICCustomElement"
import "./configs/yDefines.js" as YDefines
import "./ManualPage.js" as ManualPageScript
import "./AppSettings.js" as UISettings
import "./Theme.js" as Theme

ContentPageBase{
    ICStackContainer{
        id:manualContainer
        anchors.fill: parent
        Component.onCompleted:{
            ManualPageScript.generatePages(UISettings.AppSettings.prototype.currentLanguage(),
                                           Theme.defaultTheme)

            var pageCount = manualContainer.pages.length;
            var itemTexts = ["","","","","","",""];
            if(pageCount > 0)
                itemTexts[0] = qsTr("Y010~Y027");
            if(pageCount > 1)
                itemTexts[1] = qsTr("Y030~Y037");
            menuItemTexts = itemTexts;

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
