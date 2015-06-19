#include "icrobotmold.h"
#include <QStringList>
#include "icdalhelper.h"
#include <QDebug>

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
    ICDALHelper::UpdateMoldFncValues(baseValues, moldName_);
}
