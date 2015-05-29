import QtQuick 1.1
import "."


ContentPageBase{
    Component {
        id: content
        Rectangle{
            id:settingContainer
            color: "blue"

        }
    }
    Component {
        id: menu
        Rectangle{
            id:settingMenu
//            color: "green"
        }
    }

    content: content
    menu: menu
}
