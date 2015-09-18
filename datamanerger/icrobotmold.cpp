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
    QVariantMap point;
    for(int i= 0; i < points.size(); ++i)
    {
        point = points.at(i).toMap();
        if(point.isEmpty())
            return ICRobotMold::kCCErr_Wrong_Action_Format;
        item += PointToPosList(point.value("pos").toMap());
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
    return ICRobotMold::kCCErr_None;

}

int WaitActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    return ICRobotMold::kCCErr_None;

}

int CheckActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    return ICRobotMold::kCCErr_None;

}

int ConditionActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
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

QMap<int, ActionCompiler> CreateActionToCompilerMap()
{
    QMap<int, ActionCompiler> ret;
#ifdef NEW_PLAT
    ret.insert(F_CMD_SINGLE, AxisServoActionCompiler);
    ret.insert(F_CMD_LINE2D_MOVE_POINT, PathActionCompiler);
    ret.insert(F_CMD_SYNC_END, SimpleActionCompiler);
    ret.insert(F_CMD_SYNC_START, SimpleActionCompiler);
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
    ActionCompiler cc = actionToCompilerMap.value(v.value("action").toInt(), SimpleActionCompiler);
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

RecordDataObject ICRobotMold::NewRecord(const QString &name, const QString &initProgram, const QList<QPair<int, quint32> > &values, const QStringList &subPrograms)
{
    if(name.isEmpty()) return RecordDataObject(kRecordErr_Name_Is_Empty);
    if(ICDALHelper::IsExistsRecordTable(name))
    {
        return RecordDataObject(kRecordErr_Name_Is_Exists);
    }
    QStringList programList;
    int err;
    CompileInfo compileInfo = Complie(initProgram, err);
    if(compileInfo.IsCompileErr()) return RecordDataObject(kRecordErr_InitProgram_Invalid);

    programList.append(initProgram);
    for(int i = 0; i < subPrograms.size(); ++i)
    {
        CompileInfo compileInfo = Complie(subPrograms.at(i), err);
        if(compileInfo.IsCompileErr()) return RecordDataObject(kRecordErr_SubProgram_Invalid);
        programList.append(subPrograms.at(i));
    }
    for(int i = programList.size(); i < 9; ++i)
    {
        programList.append(QString("[{\"action\":%1}]").arg(F_CMD_END));
    }
    QList<QPair<int, quint32> > fncs = values;
    //    AddCheckSumToAddrValuePairList(fncs);
    QString dt = ICDALHelper::NewMold(name, programList, fncs);
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



CompileInfo ICRobotMold::Complie(const QString &programText, int &err)
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
    for(int i = 0; i != result.size(); ++i)
    {
        action = result.at(i).toMap();
        act = action.value("action").toInt();
        if(act == F_CMD_NOTES)
        {
            continue;
        }
        ret.AddICMoldItem(VariantToMoldItem(step, action, err));
        if(err != kCCErr_None)
        {
            ret.Clear();
            err = kCCErr_Sync_Nesting;
            ret.AddErr(i, err);
            return ret;
        }
        if(act == F_CMD_SYNC_START)
        {
            if(isSyncBegin)
            {
                ret.Clear();
                err = kCCErr_Sync_Nesting;
                ret.AddErr(i, err);
                return ret;
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
                return ret;
            }
            isSyncBegin = false;
            ++step;
            continue;
        }
        //        else if(act == ACTParallel)
        //        {
        //            if(isGroupBegin)
        //            {
        //                ret.Clear();
        //                err = kCCErr_Group_Nesting;
        //                return ret;
        //            }
        //            isGroupBegin = true;
        //            subStep = 0;
        //            ret.append(VariantToMoldItem(step, action));
        //            continue;
        //        }
        //        else if(act == ACT_GROUP_ACTION_END)
        //        {
        //            if(!isGroupBegin)
        //            {
        //                ret.clear();
        //                err = kCCErr_Group_NoBegin;
        //                return ret;
        //            }
        //            isGroupBegin = false;
        //            subStep = 255;
        //            continue;
        //        }
        //        ret.append(VariantToMoldItem(step, action, subStep));
        ret.MapStep(i, step);
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
        ret.Clear();
        err = kCCErr_Sync_NoEnd;
        ret.AddErr(result.size(), err);
        return ret;
    }
    if(isGroupBegin)
    {
        ret.Clear();
        err = kCCErr_Group_NoEnd;
        ret.AddErr(result.size(), err);
        return ret;
    }
    if(act != F_CMD_END)
    {
        ret.Clear();
        err = kCCErr_Last_Is_Not_End_Action;
        ret.AddErr(result.size(), err);
        return ret;
    }
    err = kCCErr_None;
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
    for(int i = 0; i != programs.size(); ++i)
    {
        programsCode_.append(programs.at(i));
        p = Complie(programs.at(i), err);
        if(p.IsCompileErr()) return false;
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
    CompileInfo aP = Complie(program, err);
    if(err == kCCErr_None)
    {
        programsCode_[which] = program;
        programs_[which] = aP;
        ICDALHelper::SaveMold(moldName_, which, program);
    }
    return err;
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
QList<int> ICRobotMold::RunningStepToProgramLine(int which, int step)
{
    QList<int> ret;
    if(which >= programs_.size())
        return ret;
    return programs_.at(which).RealStepToUIStep(step);
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


QPair<QStringList, QString> ICRobotMold::ExportMold(const QString &name)
{
    QPair<QStringList, QString>  ret;
    QStringList programs = ICDALHelper::MoldProgramContent(name);
    ret.first = programs;

    QVector<QPair<quint32, quint32> > fncs = ICDALHelper::GetAllMoldConfig(ICDALHelper::MoldFncTableName(name));
    QString fncStr;
    for(int i = 0; i != fncs.size(); ++i)
    {
        fncStr += QString("%1, %2\n").arg(fncs.at(i).first).arg(fncs.at(i).second);
    }
    ret.second = fncStr;
    return ret;
}

RecordDataObject ICRobotMold::ImportMold(const QString& name, const QPair<QStringList, QString> &moldInfo)
{
    RecordDataObject ret;
    QList<QPair<int, quint32> > fncs;
    QStringList addrValues = moldInfo.second.split("\n", QString::SkipEmptyParts);
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
    QStringList programs = moldInfo.first;
    ret = NewRecord(name, programs.at(0), fncs, programs.mid(1));
    return ret;

}
