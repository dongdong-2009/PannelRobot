#ifndef ICROBOTMOLD_H
#define ICROBOTMOLD_H

#include <QtGlobal>
#include <QString>
#include <QSharedPointer>
#include <QVector>
#include <QMap>
#include "icconfigsaddr.h"
#include "icparameterscache.h"
#include "icdalhelper.h"

class ICRobotMold;

struct SI{
    quint32 m0pos:32;
    quint32 m1pos:32;
    quint32 m2pos:32;
    quint32 m3pos:32;
    quint32 m4pos:32;
    quint32 m5pos:32;
    quint32 space0:32;
    quint32 space1:32;
    quint32 space2:32;
    quint32 count0:32;
    quint32 count1:32;
    quint32 count2:32;
    quint32 sequence:5;
    quint32 dir0: 1;
    quint32 dir1: 1;
    quint32 dir2: 1;
    quint32 type:8;
    quint32 doesBindingCounter:1;
    quint32 counterID:15;
    bool isOffsetEn;
    quint32 offsetX;
    quint32 offsetY;
    quint32 offsetZ;
    quint32 dataSourceID;
};

union StackInfoPrivate{
    SI si[2];
    quint32 all[36];
};
struct StackInfo{
    StackInfoPrivate stackData;
    QString dsName;
    int dsHostID;
    QVector<quint32> posData;
};

Q_DECLARE_METATYPE(StackInfo)
//qRegisterMetaType<StackInfo>("StackInfo");
#ifdef NEW_PLAT
typedef QVector<quint32> ICMoldItem;
typedef QVector<ICMoldItem> ICActionProgram;
#else
typedef QList<ICMoldItem> ICActionProgram;
#endif

typedef QSharedPointer<ICRobotMold> ICRobotMoldPTR;
typedef QMap<int, StackInfo> StackInfoMap;
class IRobotMoldError
{
public:
    IRobotMoldError(int errno, const QString& errStr):
        errno_(errno),
        errStr_(errStr){}

    int errNumber() const { return errno_;}
    void setErrNumber(int errno) { errno_ = errno;}

    QString errString() const { return errStr_;}
    void setErrString(const QString& errStr) { errStr_ = errStr;}

private:
    int errno_;
    QString errStr_;
};

class CompileInfo
{
public:
    CompileInfo(){}
    void MapStep(int uiStep, int realStep)
    {
        stepMap_.insert(uiStep, realStep);
//        realStepToUIStepMap_.insert(realStep, uiStep);
        if(realStepToUIStepMap_.contains(realStep))
        {
            QList<int> v = realStepToUIStepMap_.value(realStep);
            v.append(uiStep);
            realStepToUIStepMap_.insert(realStep, v);
        }
        else
            realStepToUIStepMap_.insert(realStep, QList<int>()<<uiStep);
    }
    void MapModuleIDToEntry(int id, int step)
    {
        modulesMap_.insert(id, step);
    }

    void MapModuleLineToModuleID(int line, int id)
    {
        moduleLineToModuleIDMap_.insert(line, id);
    }

    int ModuleIDFromLine(int line) const
    {
        return moduleLineToModuleIDMap_.value(line, -1);
    }

    int ModuleEntry(int id) const { return modulesMap_.value(id, -1);}

    void AddUsedModule(int id) { usedModules_.append(id);}

    bool IsModuleUsed(int id) const { return usedModules_.contains(id);}

    bool HasCalledModule() const { return !usedModules_.isEmpty();}

    void MapFlagToStep(int flag, int step)
    {
        flagsMap_.insert(flag, step);
    }

    int FlagStep(int flag) { return flagsMap_.value(flag, -1);}

    void Clear() { stepMap_.clear();}
    bool IsCompileErr() const { return !errList_.isEmpty();}
    void AddErr(int step, int err) { errList_.insert(step, err);}
    void AddICMoldItem(int uiStep, const ICMoldItem& item)
    {
        int cPS = compiledProgram_.size();
        uiStepToCompiledLine_.insert(uiStep, cPS);
        compiledLineToUIStep_.insert(cPS, uiStep);
        compiledProgram_.append(item);
    }
    ICMoldItem DelLastICMoldItem()
    {
        ICMoldItem ret =  compiledProgram_.last();
        compiledProgram_.pop_back();
        return ret;
    }
//    void InsertICMoldItem(int line, int uiStep, const ICMoldItem& item)
//    {
//        uiStepToComiledLine.insert(uiStep, compiledProgram_.size());
//        compiledProgram_.insert(line, item);
//    }
    void UpdateICMoldItem(int line, const ICMoldItem& item)
    {
        compiledProgram_[uiStepToCompiledLine_.value(line)] = item;
    }

    int UIStepFromCompiledLine(int line) { return compiledLineToUIStep_.value(line);}

    ICMoldItem GetICMoldItem(int line) { return compiledProgram_.at(line);}
    int CompiledProgramLineCount() const { return compiledProgram_.size();}
    QVector<QVector<quint32> >ProgramToBareData() const
    {
        return compiledProgram_;
    }
    QList<int> RealStepToUIStep(int step) const
    {
        return realStepToUIStepMap_.value(step);
    }

    QPair<int, int> UIStepToRealStep(int step) const
    {
        QPair<int, int> ret = qMakePair(-1, -1);
        if(!stepMap_.contains(step))
            return ret;
        ret.first = stepMap_.value(step);
        QList<int> row = RealStepToUIStep(ret.first);
        for(int i = 0; row.size(); ++i)
        {
            if(row.at(i) == step)
            {
                ret.second = i;
                break;
            }
        }
        return ret;
    }

    int RealStepCount() const
    {
        QList<int> rs = realStepToUIStepMap_.keys();
        qSort(rs);
        return rs.last();
    }

     QMap<int, int> ErrInfo() const { return errList_;}
     void RemoveErr(int line) { errList_.remove(line);}

     void AddUsedSourceStack(int stackID, int dsID) { usedSourceStacks_.insert(stackID, dsID);}
     QMap<int, int> UsedSourceStack() const { return usedSourceStacks_;}

     quint32 CheckSum() const;

     void PrintDebugInfo() const
     {
         qDebug()<<"Program Begin:";
         for(int i = 0 ; i < compiledProgram_.size(); ++i)
         {
             qDebug()<<UIStepToRealStep(compiledLineToUIStep_.value(i))<< compiledProgram_.at(i);
         }
//         qDebug()<<"Step map_:"<<stepMap_;
//         qDebug()<<"realStepToUIStepMap_"<<realStepToUIStepMap_;
     }

private:
    QMap<int, int> stepMap_;
    QMap<int, int> flagsMap_;
    QMap<int, int> modulesMap_;
    QMap<int, int> moduleLineToModuleIDMap_;
    QList<int> usedModules_;

    QMap<int, QList<int> > realStepToUIStepMap_;
    QMap<int, int> errList_;
    QMap<int, int> uiStepToCompiledLine_;
    QMap<int, int> compiledLineToUIStep_;
    QMap<int, int> usedSourceStacks_;
    ICActionProgram compiledProgram_;
};

#ifdef NEW_PLAT

class ICRobotMold{
public:
    enum {
        kMainProg,
        kSub1Prog,
        kSub2Prog,
        kSub3Prog,
        kSub4Prog,
        kSub5Prog,
        kSub6Prog,
        kSub7Prog,
        kSub8Prog,

    };

    enum {
        kCCErr_None,
        kCCErr_Invalid,
        kCCErr_Sync_Nesting,
        kCCErr_Sync_NoBegin,
        kCCErr_Sync_NoEnd,
        kCCErr_Group_Nesting,
        kCCErr_Group_NoBegin,
        kCCErr_Group_NoEnd,
        kCCErr_Last_Is_Not_End_Action,
        kCCErr_Invaild_Program_Index,
        kCCErr_Wrong_Action_Format,
        kCCErr_Invaild_Flag,
        kCCErr_Invaild_StackID,
        kCCErr_Invaild_CounterID,
        kCCErr_Invaild_ModuleID,
    };

    enum {
        kRecordErr_None,
        kRecordErr_Name_Is_Empty,
        kRecordErr_Name_Is_Exists,
        kRecordErr_InitProgram_Invalid,
        kRecordErr_SubProgram_Invalid,
        kRecordErr_Fnc_Invalid,
        kRecordErr_Program_Framework_Invalid,
    };
    ICRobotMold();
    static ICRobotMoldPTR CurrentMold()
    {
        return currentMold_;
    }
    static void SetCurrentMold(ICRobotMold* mold)
    {
        currentMold_ = ICRobotMoldPTR(mold);
    }

    static ICRecordInfos RecordInfos()
    {
        return ICDALHelper::RecordTableInfos();
    }

    static RecordDataObject NewRecord(const QString& name,
                                      const QString& initProgram,
                                      const QList<QPair<int, quint32> >& values,
                                      const QStringList& subPrograms = QStringList(),
                                      const QVector<QVariantList>& counters = QVector<QVariantList>(),
                                      const QVector<QVariantList>& variables = QVector<QVariantList>());

    static RecordDataObject CopyRecord(const QString& name,
                                       const QString& source);

    static bool DeleteRecord(const QString& name)
    {
        return ICDALHelper::DeleteMold(name);
    }

    static int MoldItemCheckSum(const ICMoldItem& item)
    {
#ifdef NEW_PLAT
        int sum = 0;
        for(int i = 0; i < item.size(); ++i)
        {
            sum += (int)item.at(i);
        }
        return (-sum) & 0xFFFF;
#else
        return 0;
#endif
    }

    static CompileInfo Complie(const QString& programText,
                               const QMap<int, StackInfo>& stackInfos,
                               const QVector<QVariantList>& counters,
                               const QVector<QVariantList>& variables,
                               const QMap<int, CompileInfo>& functions,
                               int & err);

//    static QPair<QStringList, QString>  ExportMold(const QString& name);
    static QStringList ExportMold(const QString& name);

    static RecordDataObject ImportMold(const QString &name, const QStringList& moldInfo);

    static QMap<int, StackInfo> ParseStacks(const QString& stacks, bool &isOk);

    static QMap<int, CompileInfo> ParseFunctions(const QString& functions,
                                                 bool &isok,
                                                 const StackInfoMap& stackInfos = StackInfoMap(),
                                                 const QVector<QVariantList>& counters = QVector<QVariantList>(),
                                                 const QVector<QVariantList>& variables = QVector<QVariantList>()
                                                 );

    static QVector<QVector<quint32> > CountersToHost(const QVector<QVariantList>& counters)
    {
        QVector<QVector<quint32> > ret;
        QVector<quint32> tmp;
        for(int i = 0 ; i < counters.size(); ++i)
        {
            tmp.clear();
            tmp<<counters.at(i).at(0).toUInt()<<counters.at(i).at(3).toUInt()<<counters.at(i).at(2).toUInt();
            ret.append(tmp);
        }
        return ret;
    }


    QVector<QVector<quint32> >ProgramToDataBuffer(int program) const
    {
        if(program >= programs_.size()) return QVector<QVector<quint32> >();
        CompileInfo p = programs_[program];
        return p.ProgramToBareData();
    }

    QVector<quint32> MoldFncsBuffer() const
    {
        return fncCache_.SequenceDataList();
    }

    QList<QPair<int, quint32> > BareMachineConfigs() const
    {
        return fncCache_.ToPairList();
    }


    bool LoadMold(const QString& moldName);
    QMap<int, int> SaveMold(int which, const QString& program);

    quint32 MoldFnc(ICAddrWrapperCPTR addr)
    {
        return fncCache_.ConfigValue(addr);
    }

    QList<QPair<int, quint32> >  SetMoldFncs(const ICAddrWrapperValuePairList values);
    quint32 CacheMoldFnc(ICAddrWrapperCPTR addr, quint32 v){
        fncCache_.UpdateConfigValue(addr, v);
        return fncCache_.OriginConfigValue(addr);
    }

    QString MainProgram() const
    {
//        qDebug()<<"dsffs"<<programsCode_.size();
        if(programsCode_.isEmpty()) return "";
        return programsCode_.at(0);
    }
    QString SubProgram(int which) const
    {
        if(which >= programsCode_.size()) return "";
        return programsCode_.at(which);
    }
    QString Stacks() const { return stacks_;}
    bool SaveStacks(const QString& stacks);

    bool HasStackInfo(int which) const
    {
        return stackInfos_.contains(which);
    }

    StackInfo GetStackInfo(int which, bool& isOk) const
    {
        isOk = false;
        if(stackInfos_.contains(which))
        {
            isOk = true;
            return stackInfos_.value(which);
        }
        return StackInfo();
    }

    QMap<int, StackInfo> GetStackInfos() const
    {
        return stackInfos_;
    }


    QPair<int, QList<int> > RunningStepToProgramLine(int which, int step);

    QPair<int, int> UIStepToRealStep(int which, int module, int step) const;

    ICMoldItem SingleLineCompile(int which, int module, int step, const QString& lineContent, QPair<int, int> &hostStep);


    QVector<QVariantList> Counters() const { return counters_;}
    QVector<QVector<quint32> > CountersToHost() const
    {
//        QVector<QVector<quint32> > ret;
//        QVector<quint32> tmp;
//        for(int i = 0 ; i < counters_.size(); ++i)
//        {
//            tmp.clear();
//            tmp<<counters_.at(i).at(0).toUInt()<<counters_.at(i).at(3).toUInt()<<counters_.at(i).at(2).toUInt();
//            ret.append(tmp);
//        }
        return CountersToHost(counters_);
    }

    bool CreateCounter(quint32 id, const QString& name, quint32 current, quint32 target);
    bool DeleteCounter(quint32 id);
    int IndexOfCounter(quint32 id) const;
    QVariantList GetCounter(quint32 id) const
    {
        QVariantList ret;
        int index = IndexOfCounter(id);
        if(index < 0) return ret;
        return counters_.at(index);
    }

    QVector<QVariantList> Variables() const { return variables_;}
    bool CreateVariables(quint32 id, const QString& name, const QString& unit, quint32 v, quint32 decimal);
    bool DeleteVariable(quint32 id);
    int IndexOfVariable(quint32 id) const;

    QString Functions() const { return functions_;}
    QMap<int, QMap<int, int> > SaveFunctions(const QString& functions, bool syncMold = true);

    QMap<int, int> UsedSourceStack(int which = -1) const;

    quint32 CheckSum() const;

private:
//    ICActionProgram ParseActionProgram_(const QString& content);

private:
    QList<CompileInfo> programs_;
    QStringList programsCode_;
    QString stacks_;
    QString functions_;
    QMap<int, StackInfo> stackInfos_;
    QMap<int, CompileInfo> compiledFunctions_;
    QVector<QVariantList> counters_;
    QVector<QVariantList> variables_;
    static ICRobotMoldPTR currentMold_;
    QString moldName_;
    ICParametersCache fncCache_;
};

#else
class ICMoldItem
{
public:
    ICMoldItem():
        seq_(0),
        num_(0),
        subNum_(-1),
        gmVal_(0),
        pos_(0),
        ifVal_(0),
        ifPos_(0),
        sVal_(0),
        dVal_(0),
        flag_(0),
        sum_(0){}

    uint Seq() const { return seq_;}    //序号
    void SetSeq(uint seq) { seq_ = seq; }
    uint Num() const { return num_;}  //步序
    void SetNum(uint nVal) { num_ = nVal; }
    quint8 SubNum() const { return subNum_;}
    void SetSubNum(int num) { subNum_ = num;}
    uint GMVal() const { return gmVal_;}    //类别区分，0是动作组，1是夹具组
    void SetGMVal(uint gmVal) { gmVal_ = gmVal; }
    bool IsAction() const { return (!(GMVal() & 0x80));}
    bool IsClip() const { return GMVal() & 0x80;}
    bool IsEarlyEnd() const { return (IFVal() & 0x80 ) == 0x80;}
    bool IsEarlySpeedDown() const { return (IFVal() & 0x20 ) == 0x20;}

    uint GetEarlyDownSpeed() const { return (IFVal() & 0x1F );}
    void SetEarlyEnd(bool earlyEnd) { earlyEnd ? ifVal_ |= 0x80 : ifVal_ &= 0x7F;}
    void SetEarlySpeedDown(bool earlySpeedDown) { earlySpeedDown ? ifVal_ |= 0x20 : ifVal_ &= 0xDF;}
    void SetEarlyDownSpeed(uint earlyDownSpeed) {ifVal_ = (ifVal_ & ~(0x1f)) | (earlyDownSpeed & 0x1F);}
    bool IsBadProduct() const { return (IFVal() & 0x40) == 0x40;}
    void SetBadProduct(bool badProduct) { badProduct ? ifVal_ |= 0x40 : ifVal_ &= 0xBF;}
    uint IFOtherVal() const { return IFVal() & 0x1F;}
    void SetIFOtherVal(uint val) { ifVal_ &= 0xE0; ifVal_ |= (val & 0x1F);}
    uint Action() const
    {
        if(!IsAction())
        {
            return 0;
        }
        return GMVal() & 0x7F;
    }
    void SetAction(uint action)
    {
        gmVal_ = action;
    }

    uint Clip() const
    {
        if(!IsClip())
        {
            return 0;
        }
        return GMVal() & 0x7F;
    }
    void SetClip(uint clip)
    {
        gmVal_ = clip;
        gmVal_ |= 0x80;
    }

    int Pos() const { return pos_;}    //X位置
    void SetPos(int pos) { pos_ = pos; }
    uint IFVal() const { return ifVal_;}
    void SetIFVal(uint val) { ifVal_ = val; }
    uint IFPos() const { return ifPos_;}
    void SetIFPos(uint pos) { ifPos_ = pos;}


    uint SVal() const { return sVal_;}  //速度，在clip中是次数，堆叠中是选择

    void SetSVal(uint sVal) { sVal_ = sVal; }
    uint DVal() const { return dVal_;}  //延时
    void SetDVal(uint dVal) { dVal_ = dVal; }


    uint Sum() const { return sum_;}  //
    uint ReSum() const
    {
        int sum = seq_ + num_ + subNum_ + gmVal_ + pos_ + ifVal_ + ifPos_ + sVal_ + dVal_;
        while(sum & 0xFF00)
        {
            sum = ((sum >> 8) & 0x00FF) + (sum & 0x00FF);
        }
        sum_ = sum;
        return sum_;
    }

    void SetValue(uint seq,
                  uint num,
                  quint8 subNum,
                  uint gmVal,
                  uint pos,
                  uint ifVal,
                  uint ifPos,
                  uint sVal,
                  uint dVal,
                  uint sum)
    {
        seq_ = seq;
        num_ = num;
        subNum_ = subNum;
        gmVal_ = gmVal;
        pos_ = pos;
        ifVal_ = ifVal;
        ifPos_ = ifPos;
        sVal_ = sVal;
        dVal_ = dVal;
        sum_ = sum;
    }
    QByteArray ToString() const
    {
        QByteArray ret;

        QString tmp = (QString().sprintf("%u %u %u %u %u %u %u %u %u %u ",
                                         seq_, num_, subNum_, gmVal_, pos_, ifVal_, ifPos_, sVal_, dVal_, sum_));

        tmp += QString::number(flag_);
        tmp += " ";
        tmp += comment_;
        ret = tmp.toUtf8();
        return ret;
    }
    QVector<quint32> ToDataBuffer() const
    {
        QVector<quint32> ret;
        ret<<(quint16)seq_<<(quint16)num_<<(quint16)((subNum_<< 8) | gmVal_)<<(quint16)pos_
          <<(quint16)((ifVal_<< 8) | (ifPos_>>8))<<(quint16)(((ifPos_ & 0xFF) << 8) | (dVal_ >> 8))
            <<(quint16)(((dVal_ & 0xFF) << 8) | sVal_)<<(quint16)sum_;
        return ret;
    }

    int ActualPos() const
    {
        return (QString::number(Pos()) + QString::number(IFPos() & 0xF)).toInt();
    }
    void SetActualPos(int pos)
    {
        int p = pos / 10;
        int d = pos % 10;
        SetPos(p);
        ifPos_ &= 0xFFFFFFF0;
        ifPos_ |= d;
    }

    int ActualIfPos() const
    {
        return IFPos() >> 4;
    }

    void SetActualIfPos(uint pos)
    {
        ifPos_ &= 0x0000000F;
        ifPos_ |= (pos << 4);
    }

    int ActualMoldCount() const
    {
        return ((IFPos() & 0xFF) << 8) | SVal();
    }

    void SetActualMoldCount(uint count)
    {
//        SetIFVal((count >> 8) & 0xFF);
        ifPos_ &= 0xFFFFFF00;
        ifPos_ |= (count >> 8) & 0xFF;
        SetSVal(count & 0xFF);
    }

    QString Comment() const { return comment_;}
    void SetComment(const QString& comment) { comment_ = comment;}

    int Flag() const { return flag_;}
    void SetFlag(int flag) { flag_ = flag;}

private:
    uint seq_;
    uint num_;
    quint8 subNum_;
    uint gmVal_;
    int pos_;
    uint ifVal_;
    uint ifPos_;
    uint sVal_;
    uint dVal_;
    QString comment_;
    int flag_;
    mutable uint sum_;
};

class ICRobotMold
{
public:
    enum {
        kMainProg,
        kSub1Prog,
        kSub2Prog,
        kSub3Prog,
        kSub4Prog,
        kSub5Prog,
        kSub6Prog,
        kSub7Prog,
        kSub8Prog,

    };

    enum {
        kCCErr_None,
        kCCErr_Invalid,
        kCCErr_Sync_Nesting,
        kCCErr_Sync_NoBegin,
        kCCErr_Sync_NoEnd,
        kCCErr_Group_Nesting,
        kCCErr_Group_NoBegin,
        kCCErr_Group_NoEnd,
        kCCErr_Last_Is_Not_End_Action
    };

    enum {
        kRecordErr_None,
        kRecordErr_Name_Is_Empty,
        kRecordErr_Name_Is_Exists,
        kRecordErr_InitProgram_Invalid,
    };

    enum
    {
        GC          =0,		//0
        GX,			//1
        GY,			//2
        GZ,			//3
        GP,			//4
        GQ,			//5
        GA,			//6
        GB,			//7

        ACTMAINUP,		//8
        ACTMAINDOWN,	//9
        ACTMAINFORWARD,	//10
        ACTMAINBACKWARD,//11

        ACTPOSEHORI,	//12   水平1
        ACTPOSEVERT,	//13   垂直1
        ACTVICEUP,		//14
        ACTVICEDOWN,	//15

        ACTVICEFORWARD,	//16
        ACTVICEBACKWARD,//17
        ACTGOOUT,		//18
        ACTCOMEIN,		//19

        ACT_PoseHori2,		//20  水平2
        ACT_PoseVert2,   //21  垂直2

        ACT_GASUB,
        ACT_GAADD,
        ACT_GBSUB,
        ACT_GBADD,
        ACT_GCSUB,
        ACT_GCADD,

        ACT_OTHER = 27,
        ACTCHECKINPUT=28,
        ACT_WaitMoldOpened = 29,
        ACT_Cut,
        ACTParallel = 31,
        ACTEND,
        ACTCOMMENT,
        ACTOUTPUT = 0x80,
        ACT_GROUP_ACTION_END = 125,
        ACT_SYNC_BEGIN = 126,
        ACT_SYNC_END = 127
    };

    ICRobotMold();
    static ICRobotMoldPTR CurrentMold()
    {
        return currentMold_;
    }
    static void SetCurrentMold(ICRobotMold* mold)
    {
        currentMold_ = ICRobotMoldPTR(mold);
    }

    static ICRecordInfos RecordInfos()
    {
        return ICDALHelper::RecordTableInfos();
    }

    static RecordDataObject NewRecord(const QString& name,
                                      const QString& initProgram,
                                      const QList<QPair<int, quint32> >& values);

    static bool DeleteRecord(const QString& name)
    {
        return ICDALHelper::DeleteMold(name);
    }


    static ICActionProgram Complie(const QString& programText, int & err);

//    static QString ActionProgramToStore(const ICActionProgram& program);

    static void AddCheckSumToAddrValuePairList(QList<QPair<int, quint32> >& values)
    {
        quint32 checkSum = 0;
        for(int i = 0; i != values.size(); ++i)
        {
            checkSum += values.at(i).second;
        }
        checkSum = (-checkSum) & 0xFFFF;
        values.append(qMakePair(values.last().first + 1, checkSum));
    }

    QVector<quint32> ProgramToDataBuffer(int program) const
    {
        QVector<quint32> ret;
        ICActionProgram p = programs_[program];
        for(int i = 0; i != p.size(); ++i)
        {
            ret += p.at(i).ToDataBuffer();
        }
        return ret;
    }

    QVector<quint32> MoldFncsBuffer() const
    {
        return fncCache_.SequenceDataList();
    }

    bool LoadMold(const QString& moldName);
    int SaveMold(int which, const QString& program);

    quint32 MoldFnc(ICAddrWrapperCPTR addr)
    {
        return fncCache_.ConfigValue(addr);
    }

    void SetMoldFncs(const ICAddrWrapperValuePairList values);

    QString MainProgram() const { return programsCode_.at(0);}
    QString SubProgram(int which) const { return programsCode_.at(which);}

private:
    ICActionProgram ParseActionProgram_(const QString& content);

private:
    QList<ICActionProgram> programs_;
    QStringList programsCode_;
    static ICRobotMoldPTR currentMold_;
    QString moldName_;
    ICParametersCache fncCache_;
};
#endif

#endif // ICROBOTMOLD_H
