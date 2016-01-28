#include "icrobotmold.h"
#include <QStringList>
#include <QDebug>
#include "icutility.h"
#include "parser.h"
#include "serializer.h"
#include "hccommparagenericdef.h"

ICRobotMoldPTR ICRobotMold::currentMold_;
ICRobotMold::ICRobotMold()
{
}

typedef int (*ActionCompiler)(ICMoldItem &,const QVariantMap*);

int SimpleActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
#ifdef NEW_PLAT
    item.append(v->value("action").toInt());
    item.append(ICRobotMold::MoldItemCheckSum(item));
#else
#endif
    return ICRobotMold::kCCErr_None;
}

int AxisServoActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
#ifdef NEW_PLAT
    item.append(v->value("action").toInt());
    item.append(v->value("axis", 0).toInt());
    item.append(ICUtility::doubleToInt(v->value("pos", 0).toDouble(), 3));
    item.append(ICUtility::doubleToInt(v->value("speed", 0).toDouble(), 1));
    item.append(ICUtility::doubleToInt(v->value("delay", 0).toDouble(), 2));
    item.append(ICRobotMold::MoldItemCheckSum(item));
#else
    item.SetActualPos(v->value("pos", 0).toDouble() * 100);
    item.SetSVal(v->value("speed", 0).toInt());
    item.SetDVal(v->value("delay", 0).toDouble() * 100);
    item.SetBadProduct(v->value("isBadEn", false).toBool());
    item.SetEarlyEnd(v->value("isEarlyEnd", false).toBool());
    item.SetActualIfPos(v->value("earlyEndPos", 0).toDouble() * 100);
    item.SetEarlySpeedDown(v->value("isEarlyDown", false).toBool());
    item.SetEarlyDownSpeed(v->value("earlyDownSpeed", 0).toInt());
#endif
    return ICRobotMold::kCCErr_None;


}

int WaitActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
#ifdef NEW_PLAT
    item.append(v->value("action").toInt());
    item.append(v->value("type", 0).toInt());
    item.append(v->value("point", 0).toInt());
    item.append(v->value("pointStatus", 0).toInt());
    item.append(ICUtility::doubleToInt(v->value("limit", 50).toDouble(),1));
    item.append(ICRobotMold::MoldItemCheckSum(item));
#else
#endif
    return ICRobotMold::kCCErr_None;
}

static QStringList motorNames = QStringList()<<"m0"<<"m1"<<"m2"<<"m3"<<"m4"<<"m5";
QVector<quint32> PointToPosList(const QVariantMap& point)
{
    QVector<quint32> ret;
    for(int i = 0; i < motorNames.size(); ++i)
    {
        if(point.contains(motorNames.at(i)))
            ret.append(ICUtility::doubleToInt(point.value(motorNames.at(i)).toDouble(), 3));
    }
    return ret;
}

int PathActionCompiler(ICMoldItem & item, const QVariantMap*v)
{
    item.append(v->value("action").toInt());
    QVariantList points = v->value("points").toList();
    if(item.at(0) == F_CMD_LINE2D_MOVE_POINT && points.size() != 1)
        return ICRobotMold::kCCErr_Wrong_Action_Format;
    if(item.at(0) == F_CMD_LINE3D_MOVE_POINT && points.size() != 1)
        return ICRobotMold::kCCErr_Wrong_Action_Format;
    if(item.at(0) == F_CMD_ARC3D_MOVE_POINT && points.size() != 2)
        return ICRobotMold::kCCErr_Wrong_Action_Format;
    if(item.at(0) == F_CMD_MOVE_POSE && points.size() != 1)
        return ICRobotMold::kCCErr_Wrong_Action_Format;
    if(item.at(0) == F_CMD_LINE3D_MOVE_POSE && points.size() != 1)
        return ICRobotMold::kCCErr_Wrong_Action_Format;
    if(item.at(0) == F_CMD_JOINTCOORDINATE && points.size() != 1)
        return ICRobotMold::kCCErr_Wrong_Action_Format;
    if(item.at(0) == F_CMD_COORDINATE_DEVIATION && points.size() != 1)
        return ICRobotMold::kCCErr_Wrong_Action_Format;

    QVariantMap point;
    if(item.at(0) == F_CMD_JOINTCOORDINATE)
    {
        point = points.at(0).toMap().value("pos").toMap();
        int enbits = 0;
        quint32 pos[6];
        for(int i = 0; i < motorNames.size(); ++i)
        {
            if(point.contains(motorNames.at(i)))
            {
                pos[i] = (ICUtility::doubleToInt(point.value(motorNames.at(i)).toDouble(), 3));
                enbits |= (1 << i);

            }
            else
            {
                pos[i] = 0;
            }
        }
        item.append(enbits);
        item.append(pos[0]);
        item.append(pos[1]);
        item.append(pos[2]);
        item.append(pos[3]);
        item.append(pos[4]);
        item.append(pos[5]);
    }
    else
    {
        for(int i= 0; i < points.size(); ++i)
        {
            point = points.at(i).toMap();
            if(point.isEmpty())
                return ICRobotMold::kCCErr_Wrong_Action_Format;
            item += PointToPosList(point.value("pos").toMap());
        }
    }
    item.append(ICUtility::doubleToInt(v->value("speed", 0).toDouble(), 1));
    item.append(ICUtility::doubleToInt(v->value("delay", 0).toDouble(), 2));
    item.append(ICRobotMold::MoldItemCheckSum(item));
    return ICRobotMold::kCCErr_None;
}

int AxisPneumaticActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
#ifdef NEW_PLAT
#else
    item.SetDVal(v->value("delay", 0).toDouble() * 100);
#endif
    return ICRobotMold::kCCErr_None;


}


int OutputActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    item.append(v->value("action").toInt());
    item.append(v->value("type", 0).toInt());
    item.append(v->value("point", 0).toInt());
    item.append(v->value("pointStatus", 0).toInt());
    if(item.at(1) >= 100 )
        item.append(ICUtility::doubleToInt(v->value("acTime", 0).toDouble(), 1));
    else
        item.append(ICUtility::doubleToInt(v->value("delay", 0).toDouble(), 1));
    item.append(ICRobotMold::MoldItemCheckSum(item));
    return ICRobotMold::kCCErr_None;

}

int CheckActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    return ICRobotMold::kCCErr_None;

}

int ConditionActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    int act = v->value("action").toInt();
    int step = v->value("step", -1).toInt();
    if(step < 0 ) return ICRobotMold::kCCErr_Invaild_Flag;
    item.append(act);
    item.append(step);

    if(act == F_CMD_PROGRAM_JUMP1)
    {
        item.append(v->value("type", 0).toInt());
        item.append(ICUtility::doubleToInt(v->value("limit", 0).toDouble(), 1));
        item.append(v->value("inout").toInt());
        item.append(v->value("point").toInt());
        item.append(v->value("pointStatus").toInt());
    }
    else if(act == F_CMD_PROGRAM_JUMP2)
    {
        item.append(v->value("counterID").toUInt());
        item.append(v->value("autoClear").toInt());
        item.append(v->value("pointStatus").toInt());
    }
    item.append(ICRobotMold::MoldItemCheckSum(item));
    return ICRobotMold::kCCErr_None;

}

int OtherActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    return ICRobotMold::kCCErr_None;

}

int ParallelActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    return ICRobotMold::kCCErr_None;

}

int CommentActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    return ICRobotMold::kCCErr_None;

}

int StackActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    item.append(v->value("action").toInt());
    StackInfo si = v->value("stackInfo").value<StackInfo>();
    item.append(si.si[0].m0pos);
    item.append(si.si[0].m1pos);
    item.append(si.si[0].m2pos);
    item.append(si.si[0].m3pos);
    item.append(si.si[0].m4pos);
    item.append(si.si[0].m5pos);
    item.append(ICUtility::doubleToInt(v->value("speed0", 80).toDouble(), 1));
    item.append(si.si[0].space0);
    item.append(si.si[0].space1);
    item.append(si.si[0].space2);
    item.append(si.si[0].count0);
    item.append(si.si[0].count1);
    item.append(si.si[0].count2);
    item.append(si.all[12]);
    //    item.append(si.si[0].doesBindingCounter);
    //    item.append(si.si[0].counterID);

    //    item.append(si.si[1].m0pos);
    //    item.append(si.si[1].m1pos);
    //    item.append(si.si[1].m2pos);
    //    item.append(si.si[1].m3pos);
    //    item.append(si.si[1].m4pos);
    //    item.append(si.si[1].m5pos);
    item.append(si.si[1].space0);
    item.append(si.si[1].space1);
    //    item.append(si.si[1].space2);
    item.append(si.si[1].count0);
    item.append(si.si[1].count1);
    //    item.append(si.si[1].count2);
    item.append(ICUtility::doubleToInt(v->value("speed1", 80).toDouble(), 1));
    //    item.append(si.si[1].doesBindingCounter);
    //    item.append(si.si[1].counterID);
    item.append(si.all[25]);
    item.append(ICRobotMold::MoldItemCheckSum(item));


    return ICRobotMold::kCCErr_None;
}

int CounterActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    item.append(v->value("action").toInt());
    QVariantList ci = v->value("counterInfo").toList();
    item.append(ci.at(0).toUInt());
    item.append(ICRobotMold::MoldItemCheckSum(item));


    return ICRobotMold::kCCErr_None;
}

int CustomAlarmActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    item.append(v->value("action").toInt());
    item.append(v->value("alarmNum").toUInt());
    item.append(ICRobotMold::MoldItemCheckSum(item));


    return ICRobotMold::kCCErr_None;
}

int CallModuleActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    int act = v->value("action").toInt();
    int step = v->value("step", -1).toInt();
    int moduleStep = v->value("moduleStep", -1).toInt();
    if(step < 0 ) return ICRobotMold::kCCErr_Invaild_Flag;
//    if(moduleStep < 0) return ICRobotMold::kCCErr_Invaild_ModuleID;
    item.append(act);
    if(moduleStep < 0)
        item.append(v->value("module").toUInt());
    else
        item.append(moduleStep);
    item.append(step);

    item.append(ICRobotMold::MoldItemCheckSum(item));


    return ICRobotMold::kCCErr_None;
}

QMap<int, ActionCompiler> CreateActionToCompilerMap()
{
    QMap<int, ActionCompiler> ret;
#ifdef NEW_PLAT
    ret.insert(F_CMD_SINGLE, AxisServoActionCompiler);
    ret.insert(F_CMD_LINE2D_MOVE_POINT, PathActionCompiler);
    ret.insert(F_CMD_LINE3D_MOVE_POINT, PathActionCompiler);
    ret.insert(F_CMD_ARC3D_MOVE_POINT, PathActionCompiler);
    ret.insert(F_CMD_MOVE_POSE, PathActionCompiler);
    ret.insert(F_CMD_LINE3D_MOVE_POSE, PathActionCompiler);
    ret.insert(F_CMD_JOINTCOORDINATE, PathActionCompiler);
    ret.insert(F_CMD_COORDINATE_DEVIATION, PathActionCompiler);

    ret.insert(F_CMD_SYNC_END, SimpleActionCompiler);
    ret.insert(F_CMD_SYNC_START, SimpleActionCompiler);
    ret.insert(F_CMD_IO_INPUT, WaitActionCompiler);
    ret.insert(F_CMD_IO_OUTPUT, OutputActionCompiler);
    ret.insert(F_CMD_PROGRAM_JUMP1, ConditionActionCompiler);
    ret.insert(F_CMD_PROGRAM_JUMP0, ConditionActionCompiler);
    ret.insert(F_CMD_PROGRAM_JUMP2, ConditionActionCompiler);

    ret.insert(F_CMD_STACK0, StackActionCompiler);
    ret.insert(F_CMD_COUNTER, CounterActionCompiler);
    ret.insert(F_CMD_COUNTER_CLEAR, CounterActionCompiler);
    ret.insert(F_CMD_TEACH_ALARM, CustomAlarmActionCompiler);

    ret.insert(F_CMD_PROGRAM_CALL_BACK, SimpleActionCompiler);
    ret.insert(F_CMD_PROGRAM_CALL0, CallModuleActionCompiler);
    ret.insert(F_CMD_END, SimpleActionCompiler);

    return ret;
#else
    for(int i = ICRobotMold::GC; i < ICRobotMold::ACTMAINUP; ++i)
    {
        ret.insert(i, AxisServoActionCompiler);
    }
    for(int i = ICRobotMold::ACTMAINUP; i < ICRobotMold::ACT_GASUB; ++i)
    {
        ret.insert(i, AxisPneumaticActionCompiler);
    }
    ret.insert(ICRobotMold::ACT_OTHER, OtherActionCompiler);
    ret.insert(ICRobotMold::ACTCHECKINPUT, ConditionActionCompiler);
    ret.insert(ICRobotMold::ACT_WaitMoldOpened, WaitActionCompiler);
    ret.insert(ICRobotMold::ACT_Cut, CheckActionCompiler);
    ret.insert(ICRobotMold::ACTParallel, ParallelActionCompiler);
    ret.insert(ICRobotMold::ACTEND, SimpleActionCompiler);
    ret.insert(ICRobotMold::ACTCOMMENT, CommentActionCompiler);
    return ret;
#endif
}


QMap<int, ActionCompiler> actionToCompilerMap = CreateActionToCompilerMap();


static inline ICMoldItem VariantToMoldItem(int step, QVariantMap v,  int &err, int subNum = 255)
{
    ICMoldItem item;
#ifdef NEW_PLAT
    int action = v.value("action").toInt();
    ActionCompiler cc = actionToCompilerMap.value(action, SimpleActionCompiler);
    err = cc(item, &v);
#else
    item.SetAction(v.value("action").toInt());
    item.SetNum(step);
    item.SetSubNum(subNum);
    item.SetSeq(programSeq++);
    ActionCompiler cc = actionToCompilerMap.value(item.Action(), SimpleActionCompiler);
    cc(item, &v);
    item.ReSum();
#endif
    return item;
}

#ifdef NEW_PLAT

RecordDataObject ICRobotMold::NewRecord(const QString &name,
                                        const QString &initProgram,
                                        const QList<QPair<int, quint32> > &values,
                                        const QStringList &subPrograms,
                                        const QVector<QVariantList>& counters,
                                        const QVector<QVariantList>& variables)
{
    if(name.isEmpty()) return RecordDataObject(kRecordErr_Name_Is_Empty);
    if(ICDALHelper::IsExistsRecordTable(name))
    {
        return RecordDataObject(kRecordErr_Name_Is_Exists);
    }
    QStringList programList;
    int err;
    QMap<int, StackInfo> sis;
    int subProgramSize = subPrograms.size();

    if(subProgramSize >= 9)
    {
        bool isOk;
        sis = ParseStacks(subPrograms.at(8), isOk);
        subProgramSize = 8;
    }

    QMap<int, CompileInfo> cfs;
    CompileInfo compileInfo = Complie(initProgram, sis, counters, variables, cfs, err);
    if(compileInfo.IsCompileErr()) return RecordDataObject(kRecordErr_InitProgram_Invalid);

    programList.append(initProgram);
    for(int i = 0; i < subProgramSize; ++i)
    {
        CompileInfo compileInfo = Complie(subPrograms.at(i), sis, counters, variables, cfs, err);
        if(compileInfo.IsCompileErr()) return RecordDataObject(kRecordErr_SubProgram_Invalid);
        programList.append(subPrograms.at(i));
    }
    for(int i = programList.size(); i < 9; ++i)
    {
        programList.append(QString("[{\"action\":%1}]").arg(F_CMD_END));
    }
    if(subPrograms.size() >= 9)
        programList.append(subPrograms.at(8));
    QList<QPair<int, quint32> > fncs = values;
    //    AddCheckSumToAddrValuePairList(fncs);
    QString dt = ICDALHelper::NewMold(name, programList, fncs, counters, variables);
    //    qDebug()<<name<<dt;
    return RecordDataObject(name, dt);
    //    return RecordDataObject();
}

RecordDataObject ICRobotMold::CopyRecord(const QString &name, const QString &source)
{
    if(name.isEmpty()) return RecordDataObject(kRecordErr_Name_Is_Empty);
    if(ICDALHelper::IsExistsRecordTable(name))
    {
        return RecordDataObject(kRecordErr_Name_Is_Exists);
    }
    QString dt = ICDALHelper::CopyMold(name, source);
    return RecordDataObject(name, dt);
}


static bool IsJumpAction(int act)
{
    return act == F_CMD_PROGRAM_JUMP1 ||
            act == F_CMD_PROGRAM_JUMP0 ||
            act == F_CMD_PROGRAM_JUMP2 ||
            act == F_CMD_PROGRAM_CALL0;
}

int IsCounterValid(const QVector<QVariantList>& counters, int counterID)
{
    for(int i = 0; i < counters.size(); ++i)
    {
        if(counterID == counters.at(i).at(0).toUInt())
        {
            return i;
        }
    }
    return -1;
}

CompileInfo ICRobotMold::Complie(const QString &programText,
                                 const QMap<int, StackInfo>& stackInfos,
                                 const QVector<QVariantList>& counters,
                                 const QVector<QVariantList>& variables,
                                 const QMap<int, CompileInfo> &functions,
                                 int &err)
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse (programText.toLatin1(), &ok).toList();
    CompileInfo ret;
    if(!ok)
    {
        err = kCCErr_Invalid;
        ret.AddErr(-1, err);
        return ret;
    }
    QVariantMap action;
    int step = 0;
    int subStep = 255;
    bool isSyncBegin = false;
    bool isGroupBegin = false;
    int act;
    //    int stackCounterID = -1;
    for(int i = 0; i != result.size(); ++i)
    {
        action = result.at(i).toMap();
        act = action.value("action").toInt();
        if(act == F_CMD_NOTES)
        {
            continue;
        }
        else if(act == F_CMD_FLAG)
        {
            ret.MapFlagToStep(action.value("flag").toInt(), step);
            continue;
        }
        else if(IsJumpAction(act))
        {
            int flag = action.value("flag", -1).toInt();
            int toJumpStep = ret.FlagStep(flag);
            action.insert("step", toJumpStep);
            if(act == F_CMD_PROGRAM_CALL0)
            {
                int mID = action.value("module").toInt();
                if(!functions.contains(mID))
                {
                    err = ICRobotMold::kCCErr_Invaild_ModuleID;
                    ret.AddErr(i, err);
//                    continue;
                }

                action.insert("moduleStep", -1);
                ret.AddUsedModule(mID);
            }
        }
        else if(act == F_CMD_STACK0)
        {

            int stackID = action.value("stackID", -1).toInt();
            if(!stackInfos.contains(stackID))
            {
                //                ret.Clear();
                err = ICRobotMold::kCCErr_Invaild_StackID;
                ret.AddErr(i, err);
                continue;
                //                return ret;
            }
            StackInfo si = stackInfos.value(stackID);
            for(int j = 0; j < 2; ++j)
            {
                if(si.si[j].doesBindingCounter)
                {
                    if(IsCounterValid(counters, si.si[j].counterID) < 0)
                    {
                        //                        ret.Clear();
                        err = ICRobotMold::kCCErr_Invaild_CounterID;
                        ret.AddErr(i, err);
                    }
                }
            }
            action.insert("stackInfo", QVariant::fromValue<StackInfo>(si));
        }
        if(act == F_CMD_COUNTER ||
                act == F_CMD_COUNTER_CLEAR ||
                act == F_CMD_PROGRAM_JUMP2)
        {
            int cID =  action.value("counterID", -1).toUInt();
            if(cID >= 0)
            {
                int cIndex = IsCounterValid(counters, cID) ;
                if(cIndex < 0)
                {
                    //                    ret.Clear();
                    err = ICRobotMold::kCCErr_Invaild_CounterID;
                    ret.AddErr(i, err);
                    continue;
                    //                return ret;
                }
                action.insert("counterInfo", counters.at(cIndex));
            }

        }

        ret.AddICMoldItem(i,VariantToMoldItem(step, action, err));
        if(err != kCCErr_None)
        {
            //            ret.Clear();
            //            err = kCCErr_Sync_Nesting;
            ret.AddErr(i, err);
            //            return ret;
        }
        if(act == F_CMD_SYNC_START)
        {
            if(isSyncBegin)
            {
                ret.Clear();
                err = kCCErr_Sync_Nesting;
                ret.AddErr(i, err);
                continue;
                //                return ret;
            }
            isSyncBegin = true;
            continue;
        }
        else if(act == F_CMD_SYNC_END)
        {
            if(!isSyncBegin)
            {
                ret.Clear();
                err = kCCErr_Sync_NoBegin;
                ret.AddErr(i, err);
                continue;

                //                return ret;
            }
            isSyncBegin = false;
            ++step;
            continue;
        }

        ret.MapStep(i, step);
        if(!isGroupBegin && !isSyncBegin)
        {
            ++step;
        }
        if(isGroupBegin)
        {
            ++subStep;
        }

    }
    if(isSyncBegin)
    {
        //        ret.Clear();
        err = kCCErr_Sync_NoEnd;
        ret.AddErr(result.size(), err);

        //        return ret;
    }
    if(isGroupBegin)
    {
        //        ret.Clear();
        err = kCCErr_Group_NoEnd;
        ret.AddErr(result.size(), err);

        //        return ret;
    }

    if(!functions.isEmpty() && ret.HasCalledModule())
    {
        QMap<int, CompileInfo>::const_iterator fp = functions.constBegin();
        int programEndLine = result.size();
        ICMoldItem endProgramItem = ret.GetICMoldItem(ret.CompiledProgramLineCount() -1);
        ICMoldItem jumptoEnd;
        jumptoEnd.append(F_CMD_PROGRAM_JUMP0);
//        ret.AddICMoldItem(programEndLine - 1, jumptoEnd);
        const int beginToFix = ret.CompiledProgramLineCount();
        int fStep = ret.RealStepCount();    //
        isSyncBegin = false;                //

        while(fp != functions.end())
        {
            CompileInfo f = fp.value();
            int cflc = f.CompiledProgramLineCount();
            const int mID = fp.key();
            ret.MapModuleIDToEntry(mID, ret.RealStepCount() + 1);
            ICMoldItem item;
            for(int i = 0; i < cflc; ++i)
            {
                item = f.GetICMoldItem(i);
                ret.AddICMoldItem(programEndLine, item);
                ret.MapModuleLineToModuleID(programEndLine, mID);
                if(item.at(0) == F_CMD_SYNC_START)
                {
                    isSyncBegin = true;
                    continue;
                }
                else if(item.at(0) == F_CMD_SYNC_END)
                {
                    isSyncBegin = false;
                    ++fStep;
                    continue;
                }
                if(!isSyncBegin)
                    ++fStep;
                ret.MapStep(programEndLine, fStep);
                ++programEndLine;
            }
            ++fp;
        }

        jumptoEnd.append(ret.CompiledProgramLineCount());
        jumptoEnd.append(ICRobotMold::MoldItemCheckSum(jumptoEnd));
        ret.UpdateICMoldItem(result.size() - 1, jumptoEnd);
        ret.AddICMoldItem(programEndLine, endProgramItem);
        ICMoldItem toFixLineItem;
        int toFixLineEnd = ret.CompiledProgramLineCount();
        int toFixUIStep;
        for(int i = beginToFix; i < toFixLineEnd; ++i)
        {
            toFixLineItem = ret.GetICMoldItem(i);
            if(toFixLineItem.at(0) == F_CMD_PROGRAM_CALL0)
            {
                toFixUIStep = ret.UIStepFromCompiledLine(i);
                toFixLineItem[1] = ret.ModuleEntry(toFixLineItem.at(1));
                toFixLineItem[2] = ret.UIStepToRealStep(toFixUIStep).first + 1;
                toFixLineItem.pop_back();
                toFixLineItem.append(ICRobotMold::MoldItemCheckSum(toFixLineItem));
                ret.UpdateICMoldItem(toFixUIStep, toFixLineItem);
            }
        }
    }


    if(act != F_CMD_END &&
            act != F_CMD_PROGRAM_CALL_BACK)
    {
        //        ret.Clear();
        err = kCCErr_Last_Is_Not_End_Action;
        ret.AddErr(result.size(), err);
        //        ret.AddErr(programEndLine, err);

        //        return ret;
    }

    // recalc flag step in condition
    QMap<int, int> errList = ret.ErrInfo();
    QMap<int, int>::iterator p = errList.begin();
    while(p != errList.end())
    {
        if(p.key() >= result.size())
        {
            ++p;
            continue;
        }
        action = result.at(p.key()).toMap();
        act = action.value("action").toInt();
        if(IsJumpAction(act))
        {
            int flag = action.value("flag", -1).toInt();
            int toJumpStep = ret.FlagStep(flag);
            if(act == F_CMD_PROGRAM_CALL0)
            {
                int moduleStep = ret.ModuleEntry(action.value("module", -1).toInt());
                if(moduleStep >= 0 &&
                        (p.value() == kCCErr_Invaild_ModuleID ||
                         p.value() == kCCErr_Invaild_Flag))
                {
                    if(flag == -1)
                        action.insert("step", ret.UIStepToRealStep(p.key()).first + 1);
                    else
                        action.insert("step", toJumpStep);
                    action.insert("moduleStep", moduleStep);
                    ret.UpdateICMoldItem(p.key(), VariantToMoldItem(0, action, err));
                    if(err == kCCErr_None)
                    {
                        ret.RemoveErr(p.key());
                    }
                }
            }
            else if((toJumpStep >= 0) && (p.value() == kCCErr_Invaild_Flag))
            {
                action.insert("step", toJumpStep);
                ret.UpdateICMoldItem(p.key(), VariantToMoldItem(0, action, err));
                if(err == kCCErr_None)
                {
                    ret.RemoveErr(p.key());
                }
            }
        }
        ++p;
    }
    //    err = kCCErr_None;
    ret.PrintDebugInfo();
    return ret;

}

bool ICRobotMold::LoadMold(const QString &moldName)
{
    if(moldName == moldName_)
        return false;
    QStringList programs = ICDALHelper::MoldProgramContent(moldName);
    if(programs.size() != 9) return false;
    moldName_ = moldName;
    programs_.clear();
    CompileInfo p;
    int err;
    programsCode_.clear();
    programs_.clear();
    bool ok = false;
    stacks_ = ICDALHelper::MoldStacksContent(moldName);
    stackInfos_ = ParseStacks(stacks_, ok);
    counters_ = ICDALHelper::GetMoldCounterDef(moldName);
    variables_ = ICDALHelper::GetMoldVariableDef(moldName);
    functions_ = ICDALHelper::MoldFunctionsContent(moldName);
    compiledFunctions_ = ParseFunctions(functions_, ok);
    ok = true;
    for(int i = 0; i != programs.size(); ++i)
    {
        programsCode_.append(programs.at(i));
        p = Complie(programs.at(i), stackInfos_, counters_, variables_, compiledFunctions_, err);
        if(p.IsCompileErr()) ok = false;
        programs_.append(p);
    }

    QVector<QPair<quint32, quint32> > fncs = ICDALHelper::GetAllMoldConfig(ICDALHelper::MoldFncTableName(moldName));
    for(int i = 0; i != fncs.size(); ++i)
    {
        fncCache_.UpdateConfigValue(fncs.at(i).first, fncs.at(i).second);
    }
    //    stacks_ = ICDALHelper::MoldStacksContent(moldName);
    //    stackInfos_ = ParseStacks_(stacks_);
    return ok;
}

QMap<int, int> ICRobotMold::SaveMold(int which, const QString &program)
{
    int err;
    CompileInfo aP = Complie(program, stackInfos_, counters_, variables_, compiledFunctions_, err);
    if(err == kCCErr_None)
    {
        programsCode_[which] = program;
        programs_[which] = aP;
        ICDALHelper::SaveMold(moldName_, which, program);
    }
    return aP.ErrInfo();
}


#else

ICActionProgram ICRobotMold::ParseActionProgram_(const QString &content)
{
    ICActionProgram tempmoldContent;
    if(content.isNull())
    {
        qDebug("mold null");
        return tempmoldContent;
    }
    QStringList records = content.split("\n", QString::SkipEmptyParts);
    if(records.size() < 1)
    {
        qDebug("mold less than 4");
        return tempmoldContent;
    }
    QStringList items;
    ICMoldItem moldItem;
    qDebug("before read");
    qDebug()<<"size"<<records.size();
    QString itemsContent;
    for(int i = 0; i != records.size(); ++i)
    {
        itemsContent = records.at(i);
        items = itemsContent.split(' ', QString::SkipEmptyParts);
        if(items.size() > 12)
        {
            QStringList commentItem = items.mid(11);
            while(items.size() > 11)
                items.removeAt(11);
            items.append(commentItem.join(" "));
        }
        if(items.size() != 10 &&
                items.size() != 11 &&
                items.size() != 12)
        {
            qDebug()<<i<<"th line size wrong";
            return tempmoldContent;
        }
        moldItem.SetValue(items.at(0).toUInt(),
                          items.at(1).toUInt(),
                          items.at(2).toUInt(),
                          items.at(3).toUInt(),
                          items.at(4).toUInt(),
                          items.at(5).toUInt(),
                          items.at(6).toUInt(),
                          items.at(7).toUInt(),
                          items.at(8).toUInt(),
                          items.at(9).toUInt());
        if(items.size() > 10)
        {
            moldItem.SetFlag(items.at(10).toUInt());
        }
        if(items.size() > 11)
        {
            moldItem.SetComment(items.at(11));
        }
        tempmoldContent.append(moldItem);
    }
    return tempmoldContent;
}

bool ICRobotMold::LoadMold(const QString &moldName)
{
    if(moldName == moldName_)
        return false;
    QStringList programs = ICDALHelper::MoldProgramContent(moldName);
    if(programs.size() != 9) return false;
    moldName_ = moldName;
    programs_.clear();
    ICActionProgram p;
    int err;
    programsCode_.clear();
    programs_.clear();
    for(int i = 0; i != programs.size(); ++i)
    {
        programsCode_.append(programs.at(i));
        p = Complie(programs.at(i), err);
        if(p.isEmpty()) return false;
        programs_.append(p);
    }

    QVector<QPair<quint32, quint32> > fncs = ICDALHelper::GetAllMoldConfig(ICDALHelper::MoldFncTableName(moldName));
    for(int i = 0; i != fncs.size(); ++i)
    {
        fncCache_.UpdateConfigValue(fncs.at(i).first, fncs.at(i).second);
    }
    return true;
}

int ICRobotMold::SaveMold(int which, const QString &program)
{
    int err;
    ICActionProgram aP = Complie(program, err);
    if(err == kCCErr_None)
    {
        programsCode_[which] = program;
        programs_[which] = aP;
        ICDALHelper::SaveMold(moldName_, which, program);
    }
    return err;
}

void ICRobotMold::SetMoldFncs(const ICAddrWrapperValuePairList values)
{
    QList<QPair<int, quint32> >baseValues;
    ICAddrWrapperValuePair tmp;
    for(int i = 0; i != values.size(); ++i)
    {
        tmp = values.at(i);
        fncCache_.UpdateConfigValue(tmp.first, tmp.second);

        baseValues.append(qMakePair(tmp.first->BaseAddr(), fncCache_.OriginConfigValue(tmp.first)));
    }
    QList<QPair<int, quint32> > fncs = fncCache_.ToPairList();
    fncs.pop_back();
    AddCheckSumToAddrValuePairList(fncs);
    QPair<int, quint32> checkSum = fncs.last();
    baseValues.append(checkSum);
    fncCache_.UpdateConfigValue(checkSum.first, checkSum.second);
    ICDALHelper::UpdateMoldFncValues(baseValues, moldName_);
}

static int programSeq = 0;

ICActionProgram ICRobotMold::Complie(const QString &programText, int &err)
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse (programText.toLatin1(), &ok).toList();
    ICActionProgram ret;
    if(!ok)
    {
        err = kCCErr_Invalid;
        return ret;
    }
    QVariantMap action;
    programSeq = 0;
    int step = 0;
    int subStep = 255;
    bool isSyncBegin = false;
    bool isGroupBegin = false;
    int act;
    for(int i = 0; i != result.size(); ++i)
    {
        action = result.at(i).toMap();
        act = action.value("action").toInt();
        if(act == ACT_SYNC_BEGIN)
        {
            if(isSyncBegin)
            {
                ret.clear();
                err = kCCErr_Sync_Nesting;
                return ret;
            }
            isSyncBegin = true;
            continue;
        }
        else if(act == ACT_SYNC_END)
        {
            if(!isSyncBegin)
            {
                ret.clear();
                err = kCCErr_Sync_NoBegin;
                return ret;
            }
            isSyncBegin = false;
            ++step;
            continue;
        }
        else if(act == ACTParallel)
        {
            if(isGroupBegin)
            {
                ret.clear();
                err = kCCErr_Group_Nesting;
                return ret;
            }
            isGroupBegin = true;
            subStep = 0;
            ret.append(VariantToMoldItem(step, action));
            continue;
        }
        else if(act == ACT_GROUP_ACTION_END)
        {
            if(!isGroupBegin)
            {
                ret.clear();
                err = kCCErr_Group_NoBegin;
                return ret;
            }
            isGroupBegin = false;
            subStep = 255;
            continue;
        }
        ret.append(VariantToMoldItem(step, action, subStep));
        if(!isGroupBegin && !isSyncBegin)
        {
            ++step;
        }
        if(isGroupBegin)
        {
            ++subStep;
        }
        //        if(ret.last().Action() == ACTParallel)
        //        {
        //            QVariantList childrenActions = action.value("childActions").toList();
        //            for(int k = 0; k != childrenActions.size();++k)
        //            {
        //                ret.append(VariantToMoldItem(step, childrenActions.at(k).toMap(), k));
        //            }
        //        }
    }
    if(isSyncBegin)
    {
        ret.clear();
        err = kCCErr_Sync_NoEnd;
        return ret;
    }
    if(isGroupBegin)
    {
        ret.clear();
        err = kCCErr_Group_NoEnd;
        return ret;
    }
    if(ret.last().Action() != ACTEND)
    {
        ret.clear();
        err = kCCErr_Last_Is_Not_End_Action;
        return ret;
    }
    err = kCCErr_None;
    return ret;

}

RecordDataObject ICRobotMold::NewRecord(const QString &name, const QString &initProgram, const QList<QPair<int, quint32> > &values)
{
    if(name.isEmpty()) return RecordDataObject(kRecordErr_Name_Is_Empty);
    if(ICDALHelper::IsExistsRecordTable(name))
    {
        return RecordDataObject(kRecordErr_Name_Is_Exists);
    }
    int err;
    ICActionProgram program = Complie(initProgram, err);
    if(program.isEmpty()) return RecordDataObject(kRecordErr_InitProgram_Invalid);
    QStringList programList;
    programList.append(initProgram);
    for(int i = 0; i < 8; ++i)
    {
        programList.append("[{\"action\":32}]");
    }
    QList<QPair<int, quint32> > fncs = values;
    AddCheckSumToAddrValuePairList(fncs);
    QString dt = ICDALHelper::NewMold(name, programList, fncs);
    return RecordDataObject(name, dt);
}
#endif
QPair<int, QList<int> > ICRobotMold::RunningStepToProgramLine(int which, int step)
{
    QPair<int, QList<int> > ret;
    if(which >= programs_.size())
        return ret;
    CompileInfo pI = programs_.at(which);
    int mID = pI.ModuleIDFromLine(step);
    QList<int> steps;
    if(mID < 0)
        steps = pI.RealStepToUIStep(step);
    else
        steps = compiledFunctions_.value(mID).RealStepToUIStep(step - pI.ModuleEntry(mID));
    return qMakePair<int, QList<int> > (mID, steps);
}

ICMoldItem ICRobotMold::SingleLineCompile(int which, int step, const QString &lineContent, QPair<int, int> &hostStep)
{
    ICMoldItem  ret;
    if(which >= programs_.size())
        return ret;
    hostStep = programs_.at(which).UIStepToRealStep(step);
    QJson::Parser parser;
    bool ok;
    QVariantMap result = parser.parse (lineContent.toLatin1(), &ok).toMap();
    if(!ok) return ret;
    int err;
    ret = VariantToMoldItem(step, result, err);
    return ret;
}

QList<QPair<int, quint32> > ICRobotMold::SetMoldFncs(const ICAddrWrapperValuePairList values)
{
    QList<QPair<int, quint32> >baseValues;
    ICAddrWrapperValuePair tmp;
    for(int i = 0; i != values.size(); ++i)
    {
        tmp = values.at(i);
        fncCache_.UpdateConfigValue(tmp.first, tmp.second);

        baseValues.append(qMakePair(tmp.first->BaseAddr(), fncCache_.OriginConfigValue(tmp.first)));
    }
    //    ICDALHelper::UpdateMachineConfigValues(baseValues, configName_);
    ICDALHelper::UpdateMoldFncValues(baseValues, moldName_);
    return baseValues;
}


QStringList ICRobotMold::ExportMold(const QString &name)
{
    QStringList ret = ICDALHelper::MoldProgramContent(name);
    ret.append(ICDALHelper::MoldStacksContent(name));
    ret.append(ICDALHelper::MoldFunctionsContent(name));

    QVector<QPair<quint32, quint32> > fncs = ICDALHelper::GetAllMoldConfig(ICDALHelper::MoldFncTableName(name));
    QString fncStr;
    for(int i = 0; i != fncs.size(); ++i)
    {
        fncStr += QString("%1, %2\n").arg(fncs.at(i).first).arg(fncs.at(i).second);
    }
    ret.append(fncStr);
    QVector<QVariantList> counters = ICDALHelper::GetMoldCounterDef(name);
    QString countersStr;
    QVariantList tmp;
    for(int i = 0; i < counters.size(); ++i)
    {
        tmp = counters.at(i);
        for(int j = 0; j < tmp.size(); ++j)
        {
            countersStr += tmp.at(j).toString() + ",";
        }
        if(!tmp.isEmpty())
        {
            countersStr.chop(1);
            countersStr += "\n";
        }
    }
    ret.append(countersStr);

    QVector<QVariantList> variables = ICDALHelper::GetMoldVariableDef(name);
    QString variablesStr;
    for(int i = 0; i < variables.size(); ++i)
    {
        tmp = variables.at(i);
        for(int j = 0; j < tmp.size(); ++j)
        {
            variablesStr += tmp.at(j).toString() + ",";
        }
        if(!tmp.isEmpty())
        {
            variablesStr.chop(1);
            variablesStr += "\n";
        }
    }
    ret.append(variablesStr);
    return ret;
}

RecordDataObject ICRobotMold::ImportMold(const QString& name, const QStringList &moldInfo)
{
    RecordDataObject ret;
    QList<QPair<int, quint32> > fncs;
    QStringList addrValues = moldInfo.at(11).split("\n", QString::SkipEmptyParts);
    QStringList addrValuePair;
    for(int i = 0; i < addrValues.size(); ++i)
    {
        addrValuePair = addrValues.at(i).split(",", QString::SkipEmptyParts);
        if(addrValuePair.size() < 2)
        {
            ret.setErrno(kRecordErr_Fnc_Invalid);
            return ret;
        }
        fncs.append(qMakePair<int, quint32>(addrValuePair.at(0).toInt(),
                                            addrValuePair.at(1).toUInt()));
    }
    QVector<QVariantList> counters;
    QStringList cStr = moldInfo.at(12).split("\n", QString::SkipEmptyParts);
    for(int i = 0; i < cStr.size(); ++i)
    {
        QStringList vs = cStr.at(i).split(",", QString::SkipEmptyParts);
        QVariantList tmp;
        tmp.append(vs.at(0).toUInt());
        tmp.append(vs.at(1));
        tmp.append(vs.at(2).toUInt());
        tmp.append(vs.at(3).toUInt());
        counters.append(tmp);
    }
    QVector<QVariantList> variables;
    QStringList vStr = moldInfo.at(13).split("\n", QString::SkipEmptyParts);
    for(int i = 0; i < vStr.size(); ++i)
    {
        QStringList vs = vStr.at(i).split(",");
        QVariantList tmp;
        tmp.append(vs.at(0).toUInt());
        tmp.append(vs.at(1));
        tmp.append(vs.at(2));
        tmp.append(vs.at(3).toUInt());
        tmp.append(vs.at(4).toUInt());
        variables.append(tmp);
    }
    QStringList programs = moldInfo.mid(0, 11);
    ret = NewRecord(name, programs.at(0), fncs, programs.mid(1), counters, variables);
    return ret;

}

QMap<int, StackInfo> ICRobotMold::ParseStacks(const QString &stacks, bool &isOk)
{
    QJson::Parser parser;
    //    bool ok;
    QVariantMap result = parser.parse (stacks.toUtf8(), &isOk).toMap();
    QMap<int, StackInfo> ret;
    if(!isOk) return ret;
    QVariantMap::iterator p = result.begin();
    StackInfo stackInfo;
    while(p != result.end())
    {
        QVariantMap stackMap = p.value().toMap().value("si0").toMap();
        stackInfo.si[0].m0pos = ICUtility::doubleToInt(stackMap.value("m0pos").toDouble(), 3);
        stackInfo.si[0].m1pos = ICUtility::doubleToInt(stackMap.value("m1pos").toDouble(), 3);
        stackInfo.si[0].m2pos = ICUtility::doubleToInt(stackMap.value("m2pos").toDouble(), 3);
        stackInfo.si[0].m3pos = ICUtility::doubleToInt(stackMap.value("m3pos").toDouble(), 3);
        stackInfo.si[0].m4pos = ICUtility::doubleToInt(stackMap.value("m4pos").toDouble(), 3);
        stackInfo.si[0].m5pos = ICUtility::doubleToInt(stackMap.value("m5pos").toDouble(), 3);
        stackInfo.si[0].space0 = ICUtility::doubleToInt(stackMap.value("space0").toDouble(), 3);
        stackInfo.si[0].space1 = ICUtility::doubleToInt(stackMap.value("space1").toDouble(), 3);
        stackInfo.si[0].space2 = ICUtility::doubleToInt(stackMap.value("space2").toDouble(), 3);
        stackInfo.si[0].count0 = stackMap.value("count0").toInt();
        stackInfo.si[0].count1 = stackMap.value("count1").toInt();
        stackInfo.si[0].count2 = stackMap.value("count2").toInt();
        stackInfo.si[0].sequence = stackMap.value("sequence").toInt();
        stackInfo.si[0].dir0 = stackMap.value("dir0").toInt();
        stackInfo.si[0].dir1 = stackMap.value("dir1").toInt();
        stackInfo.si[0].dir2 = stackMap.value("dir2").toInt();
        stackInfo.si[0].type = p.value().toMap().value("type").toInt();
        stackInfo.si[0].doesBindingCounter = stackMap.value("doesBindingCounter").toInt();
        stackInfo.si[0].counterID = stackMap.value("counterID").toInt();

        stackMap = p.value().toMap().value("si1").toMap();
        stackInfo.si[1].m0pos = ICUtility::doubleToInt(stackMap.value("m0pos").toDouble(), 3);
        stackInfo.si[1].m1pos = ICUtility::doubleToInt(stackMap.value("m1pos").toDouble(), 3);
        stackInfo.si[1].m2pos = ICUtility::doubleToInt(stackMap.value("m2pos").toDouble(), 3);
        stackInfo.si[1].m3pos = ICUtility::doubleToInt(stackMap.value("m3pos").toDouble(), 3);
        stackInfo.si[1].m4pos = ICUtility::doubleToInt(stackMap.value("m4pos").toDouble(), 3);
        stackInfo.si[1].m5pos = ICUtility::doubleToInt(stackMap.value("m5pos").toDouble(), 3);
        stackInfo.si[1].space0 = ICUtility::doubleToInt(stackMap.value("space0").toDouble(), 3);
        stackInfo.si[1].space1 = ICUtility::doubleToInt(stackMap.value("space1").toDouble(), 3);
        stackInfo.si[1].space2 = ICUtility::doubleToInt(stackMap.value("space2").toDouble(), 3);
        stackInfo.si[1].count0 = stackMap.value("count0").toInt();
        stackInfo.si[1].count1 = stackMap.value("count1").toInt();
        stackInfo.si[1].count2 = stackMap.value("count2").toInt();
        stackInfo.si[1].sequence = stackMap.value("sequence").toInt();
        stackInfo.si[1].dir0 = stackMap.value("dir0").toInt();
        stackInfo.si[1].dir1 = stackMap.value("dir1").toInt();
        stackInfo.si[1].dir2 = stackMap.value("dir2").toInt();
        stackInfo.si[1].type = stackInfo.si[0].type;
        stackInfo.si[1].doesBindingCounter = stackMap.value("doesBindingCounter").toInt();
        stackInfo.si[1].counterID = stackMap.value("counterID").toInt();
        ret.insert(p.key().toInt(), stackInfo);
        ++p;
    }
    return ret;
}

bool ICRobotMold::SaveStacks(const QString &stacks)
{
    bool ret = false;
    QMap<int, StackInfo> statcksMap = ParseStacks(stacks, ret);
    if(!ret)
        return false;
    stacks_ = stacks;
    stackInfos_ = statcksMap;
    return ICDALHelper::SaveStacks(moldName_, stacks);
}

int ICRobotMold::IndexOfCounter(quint32 id) const
{
    for(int i = 0; i < counters_.size(); ++i)
    {
        if(counters_.at(i).at(0).toUInt() == id)
            return i;
    }
    return -1;
}

bool ICRobotMold::CreateCounter(quint32 id, const QString &name, quint32 current, quint32 target)
{
    int indexOfCounter = IndexOfCounter(id);
    QVariantList newCounter;
    newCounter<<id<<name<<current<<target;
    if(indexOfCounter >= 0)
    {
        counters_[indexOfCounter] = newCounter;
        return ICDALHelper::UpdateCounter(moldName_, newCounter);
    }
    else
    {
        counters_.append(newCounter);
        return ICDALHelper::AddCounter(moldName_, newCounter);
    }
}

bool ICRobotMold::DeleteCounter(quint32 id)
{
    int indexOfCounter = IndexOfCounter(id);
    if(indexOfCounter >= 0)
    {
        counters_.remove(indexOfCounter);
        return ICDALHelper::DelCounter(moldName_, id);
    }
    return false;
}

bool ICRobotMold::CreateVariables(quint32 id, const QString &name, const QString &unit, quint32 v, quint32 decimal)
{
    int indexOfVariable = IndexOfVariable(id);
    QVariantList newVariable;
    newVariable<<id<<name<<unit<<v<<decimal;
    if(indexOfVariable >= 0)
    {
        variables_[indexOfVariable] = newVariable;
        return ICDALHelper::UpdateCounter(moldName_, newVariable);
    }
    else
    {
        variables_.append(newVariable);
        return ICDALHelper::AddVariable(moldName_, newVariable);
    }
}

bool ICRobotMold::DeleteVariable(quint32 id)
{
    int indexOfVariable = IndexOfVariable(id);
    if(indexOfVariable >= 0)
    {
        variables_.remove(indexOfVariable);
        return ICDALHelper::DelVariable(moldName_, id);
    }
    return false;
}

int ICRobotMold::IndexOfVariable(quint32 id) const
{
    for(int i = 0; i < variables_.size(); ++i)
    {
        if(variables_.at(i).at(0).toUInt() == id)
        {
            return i;
        }
    }
    return -1;
}

QMap<int, CompileInfo> ICRobotMold::ParseFunctions(const QString &functions, bool &isok)
{
    QJson::Parser parser;
    //    bool ok;
    QVariantList result = parser.parse (functions.toUtf8(), &isok).toList();
    QMap<int, CompileInfo> ret;
    if(!isok) return ret;
    QVariantMap fun;
    int err;
    QString funStr;
    for(int i = 0; i < result.size(); ++i)
    {
        fun = result.at(i).toMap();
        funStr = fun.value("program").toString();
        CompileInfo p = Complie(funStr,stackInfos_, counters_, variables_, QMap<int, CompileInfo>(), err);
        ret.insert(fun.value("id").toInt(), p);
    }
    return ret;
}

QMap<int, QMap<int, int> > ICRobotMold::SaveFunctions(const QString &functions)
{
    QMap<int, QMap<int, int> > ret;
    bool isOk;
    QMap<int, CompileInfo> functionsMap = ParseFunctions(functions, isOk);
    if(!isOk)
        return ret;
    functions_ = functions;
    compiledFunctions_ = functionsMap;
    QMap<int, CompileInfo>::const_iterator p = functionsMap.constBegin();
    QMap<int, int> eI;
    while(p != functionsMap.constEnd())
    {
        eI = p.value().ErrInfo();
        if(!eI.isEmpty())
        {
            isOk = false;
            break;
        }
        ret.insert(p.key(), eI);
        ++p;
    }
    if(isOk)
        ICDALHelper::SaveFunctions(moldName_, functions);

    for(int i = 0 ; i < programs_.size(); ++i)
    {
        if(programs_.at(i).HasCalledModule())
        {
            SaveMold(i, programsCode_.at(i));
        }
    }
    return ret;
}
