import QtQuick 1.1

MouseArea
{
    width: 300
    height: 200
    property alias color: container.color
    property int btnWidth: (inputFrame.width - keyboard.columns * keyboard.spacing) / keyboard.columns

    Rectangle {
        id:container
        width: parent.width
        height: parent.height
        border.width: 1
        border.color: "black"

        Rectangle{
            id:inputFrame
            width: 280
            height: 32
            border.width: 1
            border.color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            y:6
            TextInput{
                id:input
                width: parent.width - anchors.rightMargin
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                readOnly: true
                activeFocusOnPress: false
            }
        }

        function onNormalBtnClicked(str){
            var t = input.text;
            var cp = input.cursorPosition;
            input.text = t.slice(0, cp) + str + t.slice(cp);
            input.cursorPosition = cp + 1;
        }

        Grid{
            id:keyboard
            spacing: 4
            rows: 4
            columns: 6
            anchors.top: inputFrame.bottom
            anchors.topMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            ICButton{
                id:btn7
                text: "7"
                width: btnWidth
            }
            ICButton{
                id:btn8
                text: "8"
                width: btnWidth

            }
            ICButton{
                id:btn9
                text: "9"
                width: btnWidth

            }
            ICButton{
                id:btnDiv
                text: "÷"
                width: btnWidth

            }
            ICButton{
                id:btnBS
                text: "BS"
                width: btnWidth
                onButtonClicked: {
                    if(input.text.length > 0){
                        input.text = input.text.slice(0, -1);
                    }
                }

            }
            ICButton{
                id:btnClr
                text: "C"
                width: btnWidth
                onButtonClicked: {
                    input.text = ""
                }

            }
            ICButton{
                id:btn4
                text: "4"
                width: btnWidth
            }
            ICButton{
                id:btn5
                text: "5"
                width: btnWidth
            }
            ICButton{
                id:btn6
                text: "6"
                width: btnWidth
            }
            ICButton{
                id:btnMul
                text: "×"
                width: btnWidth
            }
            ICButton{
                id:btnLBrace
                text: "("
                width: btnWidth
            }
            ICButton{
                id:btnRBrace
                text: ")"
                width: btnWidth
            }
            ICButton{
                id:btn1
                text: "1"
                width: btnWidth
            }
            ICButton{
                id:btn2
                text: "2"
                width: btnWidth
            }
            ICButton{
                id:btn3
                text: "3"
                width: btnWidth
            }
            ICButton{
                id:btnMinus
                text: "-"
                width: btnWidth
            }
            ICButton{
                id:btnSquare
                text: "x" + "y".sup()
                width: btnWidth
            }
            ICButton{
                id:btnSqrt
                text: "√"
                width: btnWidth
            }
            ICButton{
                id:btn0
                text: "0"
                width: btnWidth
            }
            ICButton{
                id:btnDot
                text: "."
                width: btnWidth
            }
            ICButton{
                id:btnMod
                text: "%"
                width: btnWidth
            }
            ICButton{
                id:btnPlus
                text: "+"
                width: btnWidth
            }
        }
        ICButton{
            id:btnEqual
            text: "="
            width: btnWidth * 2 + keyboard.spacing

            x:keyboard.x + (keyboard.columns - 2) * (keyboard.spacing + btnWidth)
            y:keyboard.y + (keyboard.rows - 1) * (keyboard.spacing + height)
            onButtonClicked: {
                var exepr = input.text;
                exepr = exepr.replace(btnDiv.text, "/").replace(btnMul.text, "*");
                console.log(exepr);
                var ret = eval(exepr);
                input.text = ret;
            }
        }

        Component.onCompleted: {
            var normalBtns = [btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7,
                              btn8, btn9, btnPlus, btnMinus, btnMod,
                              btnDot, btnLBrace, btnRBrace,
                              btnDiv, btnMul];
            for(var i = 0; i < normalBtns.length; ++i){
                normalBtns[i].clickedText.connect(onNormalBtnClicked);
            }
        }

    }
}
