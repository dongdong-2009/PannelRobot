import QtQuick 1.1
import QtQuick 1.0
import "../ICCustomElement"
import "./teach/Teach.js" as Teach
import "configs/AxisDefine.js" as AxisDefine


Rectangle {
    id:container
    width: parent.width
    height: parent.height

    border.width: 1
    border.color: "gray"
    color: "#A0A0F0"

    ICButton{
        id:button_loadin
        text: qsTr("Load in")
        x:80
        y:10
        onButtonClicked: {
            console.log("load in");

        }
    }
    ICButton{
        id:button_new
        text: qsTr("New")
        height: 25
        x:315
        y:350
        onButtonClicked: {
            console.log("new");
            var ma = {"m0":m0.configValue,"m1":m1.configValue,"m2":m2.configValue,
                "m3":m3.configValue,"m4":m4.configValue,"m5":m5.configValue};
            var pa = text_name.configValue;
            var sa = Teach.definedPoints.addNewPoint(pa , ma);
            //var ss = itemText(sa.point,pa);
            mymodel.append(sa);
        }
    }
    ICButton{
        id:button_delet
        text: qsTr("Delet")
        height: 25
        x:450
        y:350
        onButtonClicked: {
            console.log("delet");
            var pl = Teach.definedPoints.pointNameList();
            var ss = Teach.definedPoints.deletePoint(mylist.currentIndex);
//            mymodel.clear();
//            for(var i =0;i<ss.length;i++){
//                mymodel.append(ss[i]);
//            }
            mymodel.remove(mylist.currentIndex);
//            var sd  = mymodel.get(mylist.currentIndex);
//            var ps = Teach.definedPoints.pointNameList();
//            var ss = Teach.definedPoints.definedPoint[];
//            for(var i = 0;i<ps.length;i++){
//                if(ss[i].pID === sd.pID)
//                    Teach.definedPoints.definedPoints[i].point = ma;
//            }
        }
    }
    ICButton{
        id:button_replace
        text: qsTr("Replace")
        height: 25
        x:585
        y:350
        onButtonClicked: {
            console.log("Replace");
            var ma = {"m0":m0.configValue,"m1":m1.configValue,"m2":m2.configValue,
                "m3":m3.configValue,"m4":m4.configValue,"m5":m5.configValue};
            var sd  = mymodel.get(mylist.currentIndex);
            var pl = Teach.definedPoints.pointNameList();
            var ss = Teach.definedPoints.updatePoint(sd ,ma ,pl);
            mymodel.clear();
            for(var i =0;i<ss.length;i++){
                mymodel.append(ss[i]);
            }
           // sd.point = ma;
        }
    }
    ICConfigEdit{
        id:text_name
        isNumberOnly: false
        height: 400
        x:200
        y:350
    }
    ICConfigEdit{
        id:m0
        configName: qsTr(AxisDefine.axisInfos[0].name)
        x:70
        y:50
    }
    ICConfigEdit{
        id:m1
        configName: qsTr(AxisDefine.axisInfos[1].name)
        x:70
        y:100
    }
    ICConfigEdit{
        id:m2
        configName: qsTr(AxisDefine.axisInfos[2].name)
        x:70
        y:150
    }
    ICConfigEdit{
        id:m3
        configName: qsTr(AxisDefine.axisInfos[3].name)
        x:70
        y:200
    }
    ICConfigEdit{
        id:m4
        configName: qsTr(AxisDefine.axisInfos[4].name)
        x:70
        y:250
    }
    ICConfigEdit{
        id:m5
        configName: qsTr(AxisDefine.axisInfos[5].name)
        x:70
        y:300
    }

    Rectangle  {
        width: 490; height: 300
        x:200
        y:50
        Component {
            id: myDelegate
            Item {
                width: 480; height: 40
                Column {
                    Text { text: '<b>Name:</b> ' + name }
                }
            }
        }
        ListModel {
            id:mymodel
            //        ListElement {
            //        }
            //        ListElement {
            //            name: "John Brown"
            //            number: "555 8426"
            //        }
            //        ListElement {
            //            name: "Sam Wise"
            //            number: "555 0473"
            //        }
        }

        Component{
            id:highlight1
            Rectangle {
                width: 490; height: 20
                    color: "lightsteelblue"; radius: 5
//                    y: ListView.currentItem.y
//                    Behavior on y {
//                        SpringAnimation {
//                            spring: 3
//                            damping: 0.2
//                        }
//                    }
                }
        }

        Component{
            id:delegate1
            Item {
                //x:200
                width: 490; height: 20
                //color: "green"
                Text {text: itemText(point, name)}
                //Text {text: "name"}
                MouseArea{
                    anchors.fill: parent
//                    acceptedButtons: Qt.LeftButton | Qt.RightButton
//                             onClicked: {
//                                 if (mouse.button == Qt.RightButton)
//                                     parent.color = 'blue';
//                                 else
//                                     parent.color = 'red';
//                             }
                    onClicked: {
                       // ListView.view.currentIndex = index;
                      //  console.log("delet");
                        mylist.currentIndex = index;
                        console.log(index);

                    }
                }
            }
        }

        ListView {
            id:mylist
            width: 490;height: 300
            model: mymodel
            highlight: highlight1
            delegate: Rectangle {
                //x:200
                width: 490; height: 20
                color: "green"
                Text {text: itemText(point, name)}
                //Text {text: "name"}
                MouseArea{
                    anchors.fill: parent
//                    acceptedButtons: Qt.LeftButton | Qt.RightButton
//                             onClicked: {
//                                 if (mouse.button == Qt.RightButton)
//                                     parent.color = 'blue';
//                                 else
//                                     parent.color = 'red';
//                             }
                    onClicked: {
                       // ListView.view.currentIndex = index;
                      //  console.log("delet");
                        console.log(mymodel.count, mylist.currentIndex);
                        mylist.currentIndex = index;
                        console.log(index);

                    }
                }
            }
//            highlightFollowsCurrentItem : true
        }
    }
    //    Rectangle {
    //              x:200
    //              width: 50; height: 50
    //              color: "red"
    //              MouseArea{
    //                  anchors.fill: parent
    //                  onClicked: {
    //                        console.log("delet");
    ////                      list.model = fruitModel2
    ////                      console.log(list.children[0].children[3].children[0].children[0].objectName)
    ////                      console.log(list.children[0].children[2].children[0].children[1].objectName)
    //                  }
    //              }
    //          }

    function itemText(point, name){

        var ret = "";
        if(name.length !== 0){
            ret = name + "(";
        }

        var m;
        for(var i = 0; i < 6; ++i){
            m = "m" + i;
            if(point.hasOwnProperty(m)){
                ret += AxisDefine.axisInfos[i].name + ":" + point[m] + ","
            }
        }
        ret = ret.substr(0, ret.length - 1);
        if(name.length !== 0){
            ret += ")";
        }
        return ret;
    }


    Component.onCompleted: {
        var ps = Teach.definedPoints.pointNameList();
        for(var i = 0 ;i < ps.length;i++){
            var sa = Teach.definedPoints.getPoint(ps[i]);
            //var ss = itemText(sa.point,ps[i]);
            mymodel.append(sa);
        }
    }
}
