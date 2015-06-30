import QtQuick 1.1
import "../ICCustomElement"

Rectangle {
    Column{
        Row{
            Text {
                text: qsTr("Editing")
                anchors.verticalCenter: parent.verticalCenter
            }
            ICComboBox{
                id:editing
                items: [qsTr("main"),
                    qsTr("Sub-1"),
                    qsTr("Sub-2"),
                    qsTr("Sub-3"),
                    qsTr("Sub-4"),
                    qsTr("Sub-5"),
                    qsTr("Sub-6"),
                    qsTr("Sub-7"),
                    qsTr("Sub-8")
                ]
                currentIndex: 0
            }
        }

        Rectangle{
            ListModel{
                id:programListModel
            }

            ListView{
                id:programListView
            }
        }
    }
}
