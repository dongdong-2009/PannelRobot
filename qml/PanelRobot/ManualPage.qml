import QtQuick 1.1
import "."


ContentPageBase{
    Component {
        id: content
        Rectangle{
            id:manualContainer
            color: "green"

        }
    }
    Component {
        id: menu
        Rectangle{
            id:manualMenu
//            color: "green"
        }
    }

    content: content
    menu: menu
}
