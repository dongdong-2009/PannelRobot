import QtQuick 1.1

import "../../ICCustomElement"
import "Teach.js" as Teach

Rectangle {
    function createActionObjects(){
        var ret = [];
        var action;
        var points = pointEdit.getPoints();
        if(pointEdit.usedMotorCount() === 2){
            if(points.length === 1)
                action = Teach.actions.F_CMD_LINE2D_MOVE_POINT;
        }
        else if(pointEdit.usedMotorCount() === 3){
            if(points.length === 1)
                action = Teach.actions.F_CMD_LINE3D_MOVE_POINT;
            else if(points.length === 2)
                action = Teach.actions.F_CMD_ARC3D_MOVE_POINT;
        }

        ret.push(Teach.generatePathAction(action,
                                          points,
                                          pointEdit.getSpeed(),
                                          pointEdit.getDelay()));
        return ret;
    }
    PointEdit{
        id:pointEdit
        width: parent.width
        height: parent.height
    }
}
