#include "icrobotmold.h"
#include <QStringList>
#include <QDebug>
#include "parser.h"
#include "serializer.h"

typedef void (*ActionCompiler)(ICMoldItem &,const QVariantMap*);
typedef void (*ActionDecompiler)(QVariantMap&, const ICMoldItem& );

void AxisServoActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    item.SetActualPos(v->value("pos", 0).toDouble() * 100);
    item.SetSVal(v->value("speed", 0).toInt());
    item.SetDVal(v->value("delay", 0).toDouble() * 100);
    item.SetBadProduct(v->value("isBadEn", false).toBool());
    item.SetEarlyEnd(v->value("isEarlyEnd", false).toBool());
    item.SetActualIfPos(v->value("earlyEndPos", 0).toDouble() * 100);
    item.SetEarlySpeedDown(v->value("isEarlyDown", false).toBool());
    item.SetEarlyDownSpeed(v->value("earlyDownSpeed", 0).toInt());
}

void AxisPneumaticActionCompiler(ICMoldItem & item, const QVariantMap* v)
{
    item.SetDVal(v->value("delay", 0).toDouble() * 100);
}


void OutputActionCompiler(ICMoldItem & item, const QVariantMap* v)
{

}

void WaitActionCompiler(ICMoldItem & item, const QVariantMap* v)
{

}

void CheckActionCompiler(ICMoldItem & item, const QVariantMap* v)
{

}

void ConditionActionCompiler(ICMoldItem & item, const QVariantMap* v)
{

}

void OtherActionCompiler(ICMoldItem & item, const QVariantMap* v)
{

}

void ParallelActionCompiler(ICMoldItem & item, const QVariantMap* v)
{

}

void CommentActionCompiler(ICMoldItem & item, const QVariantMap* v)
{

}

void SimpleActionCompiler(ICMoldItem & item, const QVariantMap* v)
{

}

void AxisServoActionDecompiler(QVariantMap& v, const ICMoldItem& item)
{
    //    item.SetActualPos(v->value("pos", 0).toDouble() * 100);
    //    item.SetSVal(v->value("speed", 0).toInt());
    //    item.SetDVal(v->value("delay", 0).toDouble() * 100);
    //    item.SetBadProduct(v->value("isBadEn", false).toBool());
    //    item.SetEarlyEnd(v->value("isEarlyEnd", false).toBool());
    //    item.SetActualIfPos(v->value("earlyEndPos", 0).toDouble() * 100);
    //    item.SetEarlySpeedDown(v->value("isEarlyDown", false).toBool());
    //    item.SetEarlyDownSpeed(v->value("earlyDownSpeed", 0).toInt());
    v.insert("pos", item.Pos() / 100.0);
    v.insert("speed", item.SVal());
    v.insert("delay", item.DVal() / 100.0);
    v.insert("isBadEn", item.IsBadProduct());
    v.insert("isEarlyEnd", item.IsEarlyEnd());
    v.insert("earlyEndPos", item.ActualIfPos() / 100.0);
    v.insert("isEarlyDown", item.IsEarlySpeedDown());
    v.insert("earlyDownSpeed", item.GetEarlyDownSpeed());
}

void SimpleActionDecompiler(QVariantMap&, const ICMoldItem&)
{

}

QMap<int, ActionCompiler> CreateActionToCompilerMap()
{
    QMap<int, ActionCompiler> ret;
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
}

QMap<int, ActionDecompiler> CreateActionToDecompilerMap()
{
    QMap<int, ActionDecompiler> ret;
    return ret;

}

QMap<int, ActionCompiler> actionToCompilerMap = CreateActionToCompilerMap();
QMap<int, ActionDecompiler> actionToDecompilerMap = CreateActionToDecompilerMap();

ICRobotMoldPTR ICRobotMold::currentMold_;
ICRobotMold::ICRobotMold()
{
}

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
    for(int i = 0; i != programs.size(); ++i)
    {
        p = ParseActionProgram_(programs.at(i));
        if(p.isEmpty()) return false;
        programs_.append(p);
    }

    QVector<QPair<quint32, quint32> > fncs = ICDALHelper::GetAllMoldConfig(ICDALHelper::MoldFncTableName(moldName));
    for(int i = 0; i != fncs.size(); ++i)
    {
        fncCache_.UpdateConfigValue(fncs.at(i).first, fncs.at(i).second);
    }
    programsCode_ = Decompile(programs_);
    qDebug()<<programsCode_;
    return true;
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

static inline ICMoldItem VariantToMoldItem(int step, QVariantMap v, int subNum = 255)
{
    ICMoldItem item;
    item.SetAction(v.value("action").toInt());
    item.SetNum(step);
    item.SetSubNum(subNum);
    item.SetSeq(programSeq++);
    ActionCompiler cc = actionToCompilerMap.value(item.Action(), SimpleActionCompiler);
    cc(item, &v);
    item.ReSum();
    return item;
}

static inline QVariantMap MoldItemToVariant(const ICMoldItem& item)
{
    QVariantMap ret;
    ret.insert("action", item.GMVal());
    ActionDecompiler deCC = actionToDecompilerMap.value(item.Action(), SimpleActionDecompiler);
    deCC(ret, item);
    return ret;
}

ICActionProgram ICRobotMold::Complie(const QString &programText)
{
    QJson::Parser parser;
    bool ok;
    QVariantList result = parser.parse (programText.toLatin1(), &ok).toList();
    ICActionProgram ret;
    if(!ok) return ret;
    QVariantList groupActions;
    programSeq = 0;
    for(int i = 0; i != result.size(); ++i)
    {
        groupActions = result.at(i).toList();
        for(int j = 0; j != groupActions.size(); ++j)
        {
            ret.append(VariantToMoldItem(i, groupActions.at(j).toMap()));
            if(ret.last().Action() == ACTParallel)
            {
                QVariantList childrenActions = groupActions.at(j).toMap().value("childActions").toList();
                for(int k = 0; k != childrenActions.size();++k)
                {
                    ret.append(VariantToMoldItem(i, childrenActions.at(k).toMap(), k));
                }
            }
        }
    }
    return ret;

}

QString ICRobotMold::Decompile(const QList<ICActionProgram> &programs)
{
    QVariantList allStep;
    QVariantList stepAction;
    ICMoldItem moldItem;
    ICActionProgram program;
    for(int p = 0 ; p != programs.size(); ++p)
    {
        program = programs.at(p);
        for(int i = 0;  i != program.size(); ++i)
        {
            moldItem = program.at(i);
            QVariantMap actionMap = MoldItemToVariant(moldItem);
            if(moldItem.Action() == ICRobotMold::ACTParallel)
            {
                ICMoldItem subItem;
                QVariantList childrenActions;
                int currentIndex = i + 1;
                while(currentIndex < program.size())
                {
                    subItem = program.at(currentIndex);
                    if(subItem.SubNum() == 255)
                    {
                        actionMap.insert("childActions", childrenActions);
                        break;
                    }
                    childrenActions.append(MoldItemToVariant(subItem));
                    ++currentIndex;
                }
            }
            stepAction.append(actionMap);
        }

        allStep.append(stepAction);
    }
    QJson::Serializer serializer;
    return serializer.serialize(allStep);
}

RecordDataObject ICRobotMold::NewRecord(const QString &name, const QString &initProgram, const QList<QPair<int, quint32> > &values)
{
    if(name.isEmpty()) return RecordDataObject();
    if(ICDALHelper::IsExistsRecordTable(name))
    {
        return RecordDataObject();
    }
    ICActionProgram program = Complie(initProgram);
    if(program.isEmpty()) return RecordDataObject();
    QStringList programList;
    programList.append(ActionProgramToStore(program));
    for(int i = 0; i < 8; ++i)
    {
        programList.append("0 0 255 32 0 0 0 0 0  32");
    }
    QList<QPair<int, quint32> > fncs = values;
    AddCheckSumToAddrValuePairList(fncs);
    QString dt = ICDALHelper::NewMold(name, programList, fncs);
    return RecordDataObject(name, dt);
}

QString ICRobotMold::ActionProgramToStore(const ICActionProgram &program)
{
    QByteArray ret;
    for(int i = 0; i != program.size(); ++i)
    {
        ret += program.at(i).ToString() + "\n";
    }
    return ret;
}
