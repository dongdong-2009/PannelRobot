#ifndef ICDALHELPER_H
#define ICDALHELPER_H

#include "stdint.h"
#include <QString>
#include <QStringList>
#include <QRunnable>
#include <QThreadPool>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QVector>
#include "icaddrwrapper.h"
#include "icconfigpermissioncenter.h"
#include "icappsettings.h"

#ifdef TEST_TIME_DEBUG
#include <QTime>
#include <QDebug>
#endif

class RecordDataObject
{
public:
    RecordDataObject(){}
    RecordDataObject(const QString& name, const QString& dt):
        recordName_(name),
        createDatetime_(dt),
    err_(0){}
    RecordDataObject(int err):err_(err){}
    QString recordName() const { return recordName_;}
    void setRecordName(const QString& name) { recordName_ = name;}

    QString createDatetime() const { return createDatetime_;}
    void setCreateDatetime(const QString& dt) { createDatetime_ = dt;}

    int errNumber() const { return err_;}
    void setErrno(int err) { err_ = err;}

    QString toJSON() const
    {
        return QString("{\"recordName\":\"%1\", \"createDatetime\":\"%2\", \"errno\":%3}").arg(recordName_)
                .arg(createDatetime_).arg(err_);
    }

private:
    QString recordName_;
    QString createDatetime_;
    int err_;
};

typedef QList<RecordDataObject> ICRecordInfos;
class __ICUpdateConfigRunnable;

#define DATABASE_ERR_EXIST -2
#define DATABASE_ERR_NOEXIST -3


class ICDALHelper
{
public:

    friend class __ICUpdateConfigRunnable;
    typedef QString (*Wrapper)(const QString& name);
    static uint GetConfigValue(const ICAddrWrapper *addr);
    static QString GetConfigName(const ICAddrWrapper* addr);
    //    static QString GetConfigDescription(uint addr);
    template<typename T>
    static bool UpdateMoldFncValue(int addr, T value, const QString& moldName);
    template<typename T>
    static bool UpdateMachineConfigValue(int addr, T value, const QString& machineName);
//    template<typename T>
//    static bool UpdateAndLogConfigValue(const ICAddrWrapper* addr,
//                                        T value,
//                                        T baseValue,
//                                        const QString& newValueText,
//                                        const QString& oldValueText,
//                                        int moldCount,
//                                        bool isCommit = true);
    static bool UpdateMoldFncValues(const QList<QPair<int, quint32> > &addrValuePairs, const QString& moldName );
    static bool UpdateMachineConfigValues(const QList<QPair<int, quint32> > &addrValuePairs, const QString& machineName );
    static QVector<QPair<quint32, quint32> > GetAllMoldConfig(const QString& name) { return GetAllConfigValues_(MoldConfigNameWrapper(name));}
    static QVector<QVariantList> GetMoldCounterDef(const QString& name);
    static QVector<QVariantList> GetMoldVariableDef(const QString& name);
    static QVector<QPair<quint32, quint32> > GetAllSystemConfig(const QString& name) { return GetAllConfigValues_(SystemConfigNameWrapper(name));}
    static bool GetMoldConfigs(const QString& name, QList<uint>& addrs) { return GetConfigValues_(MoldConfigNameWrapper(name), addrs);}
    static bool GetSystemConfigs(const QString& name, QList<uint>& addrs) { return GetConfigValues_(SystemConfigNameWrapper(name), addrs);}
    static bool LogAlarm(uint alarmNum);
    static bool LogConfigModify(const ICAddrWrapper *addr,
                                const QString& newValue,
                                const QString& oldValue,
                                const int moldCount);

    static QString NewMoldConfig(const QString& name,
                                 const QList<QPair<int, quint32> > & values,
                                 const QVector<QVariantList>& counters,
                                 const QVector<QVariantList>& variables);
    static bool NewSystemConfig(const QString& name, QString& err);
    static bool CopyMoldConfig(const QString& newName, QString& err, const QString& oldName = DefaultMoldConfigTableName);
    static bool CopySystemConfig(const QString& newName, QString& err, const QString& oldName = DefaultSystemConfigTableName);
    static bool DeleteMoldConfig(const QString& name, QString& err);
    static bool DeleteSystemConfig(const QString& name, QString& err);

    static QStringList RecordTableContent(const QString& tableName) { return TableContent_(tableName, MoldConfigNameWrapper);}
    static QStringList SystemTableContent(const QString& tableName) { return TableContent_(tableName, SystemConfigNameWrapper);}
    static QStringList AlarmTableContent(const QString& tableName) { return AlarmTableContent_(tableName, SystemConfigNameWrapper);}
    static QStringList MoldProgramContent(const QString& moldName);

    static QString NewMold(const QString& moldName,
                           const QStringList& programs,
                           const QList<QPair<int, quint32> > & values,
                           const QVector<QVariantList>& counters,
                           const QVector<QVariantList>& variables);
    static QString CopyMold(const QString& moldName, const QString& source);
    static bool DeleteMold(const QString& moldName);
    static bool SaveMold(const QString& moldName, int which, const QString& program);

    static bool IsExistsRecordTable(const QString& tableName);
    static bool ImportRecordTable(const QString& tableName, const QStringList& csvData, QString& err);
    static bool IsExistsSystemtable(const QString& tableName);
    static bool ImportSystemTable(const QString& tableName, const QStringList& csvData, QString& err);
    static QString MoldConfigNameWrapper(const QString& name);
    static QString SystemConfigNameWrapper(const QString& name);

    static QString AlarmDecription(uint alarmNum);
    static int TableRowCount(const QString& tableName);
    static QStringList RecordTables();
    static ICRecordInfos RecordTableInfos();
    static void ConfigsFix();

    static QStringList Users(int level = -1);
    static int UserLevel(const QString& user);
    static int CreateUser(const QString& name);
    static int ChangeUserPassword(const QString& name, const QString &password);
    static int DeleteUser(const QString& name);
    static int ChangeUserLevel(const QString& name, int level);
    static int PermissionInformation(const QString &name,
                                     int &level,
                                     bool &hasBasic,
                                     bool &hasFunction,
                                     bool &hasMachine,
                                     bool &hasSystem);

    static QString MoldFncTableName(const QString& moldName);
    static QString MoldCounterTableName(const QString& moldName);
    static QString MoldVariableTableName(const QString& moldName);

    static QString MoldStacksContent(const QString& moldName);

    static bool SaveStacks(const QString& moldName, const QString& stacks);
    static bool SaveFunctions(const QString& moldName, const QString& functions);


    static bool UpdateCounter(const QString& moldname, const QVariantList &counter);
    static bool AddCounter(const QString& moldname, const QVariantList &counter);
    static bool DelCounter(const QString& moldname, quint32 id);
    static bool DelAllCounter(const QString& moldname);

    static bool UpdateVariable(const QString& moldname, const QVariantList &variable);
    static bool AddVariable(const QString& moldname, const QVariantList &variable);
    static bool DelVariable(const QString& moldname, quint32 id);


    static QString MoldFunctionsContent(const QString& moldName);

//    static bool UpdateConfigsValues(const QList<QPair<const ICAddrWrapper *, quint32> > &addrValuePairs, const QString& tableName);


    static const char* AddrNameColumnName;
    const static int ValueColumnIndex = 2;
    static const char* AlarmTableName;
    static const char* ModifyTableName;
    static const char* QualityTableName;
    static const char* DefaultMoldConfigTableName;
    static const char* DefaultSystemConfigTableName;
    static const char* DateTimeFormat;
private:
    static uint CountTableRecords_(const QString& tbName);
    static QString NullWrapper_(const QString& name) { return name;}
    static QVector<QPair<quint32, quint32> > GetAllConfigValues_(const QString& listName);
    static bool GetConfigValues_(const QString& name, QList<uint>& addrs);
    static bool CopyTable_(const QString& newName, const QString& oldName, QString& err, Wrapper wrapper);
    static bool DropTable_(const QString& name, QString& err, Wrapper wrapper);
    static QStringList TableContent_(const QString& name, Wrapper wrapper);
    static QStringList AlarmTableContent_(const QString& name, Wrapper wrapper);
    const static int MaxAlarmSize = 120;
    const static int MaxProductLogSize = 120;
    ICDALHelper();
private:
};

inline uint ICDALHelper::GetConfigValue(const ICAddrWrapper* addr)
{
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    QTime time;
    time.start();
#endif
    QSqlQuery query_;
    QString tb;
    if(addr->AddrType() == ICAddrWrapper::kICAddrTypeSystem)
    {
        tb = SystemConfigNameWrapper(ICAppSettings().CurrentSystemConfig());
    }
    else
    {
        tb = MoldConfigNameWrapper(ICAppSettings().CurrentMoldConfig());
    }
    query_.exec(QString("SELECT value FROM %1 WHERE addr = %2")
                .arg(tb)
                .arg(addr->BaseAddr()));
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    if(time.elapsed() >= TEST_TIME_LEVEL)
    {
        qDebug()<<"GetConfigValue time test"<<time.restart()<<"ms";
    }
#endif
    if(query_.next())
    {
        return query_.value(0).toUInt();
    }
    return 0;
}

template<typename T>
bool ICDALHelper::UpdateMoldFncValue(int addr, T value, const QString& moldName)
{
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    QTime time;
    time.start();
#endif
//    if(addr <= ICAddr_Action || addr >= ICAddr_Write_Section_End )
//    {
//        return false;
//    }
    QSqlQuery query_;
    QString tb = MoldConfigNameWrapper(MoldFncTableName(moldName));
    bool ok = query_.exec(QString("SELECT addr FROM %1 WHERE addr = %2").arg(tb).arg(addr));
    if(query_.next())
    {
        ok = query_.exec(QString("UPDATE %1 SET value = %2 WHERE addr = %3")
                         .arg(tb)
                         .arg(value)
                         .arg(addr));

        if(!ok)
        {
            qDebug()<<query_.lastError();
        }
    }
    else
    {
        ok = query_.exec(QString("INSERT INTO %1 VALUES(%2, %3)")
                         .arg(tb)
                         .arg(addr)
                         .arg(value));
        if(!ok)
        {
            qDebug()<<query_.lastError();
        }
    }
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    if(time.elapsed() >= TEST_TIME_LEVEL)
    {
        qDebug()<<"ICDALHelper::UpdateMoldFncValue time test"<<time.restart()<<"ms"<<ok;
    }
#endif
    return ok;
}

template<typename T>
bool ICDALHelper::UpdateMachineConfigValue(int addr, T value,const QString& machineName)
{
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    QTime time;
    time.start();
#endif
    QSqlQuery query_;
    QString tb = SystemConfigNameWrapper(machineName);

    bool ok = query_.exec(QString("SELECT addr FROM %1 WHERE addr = %2").arg(tb).arg(addr));
    if(query_.next())
    {
        ok = query_.exec(QString("UPDATE %1 SET value = %2 WHERE addr = %3")
                         .arg(tb)
                         .arg(value)
                         .arg(addr));

        if(!ok)
        {
            qDebug()<<query_.lastError();
        }
    }
    else
    {
        ok = query_.exec(QString("INSERT INTO %1 VALUES(%2, %3)")
                         .arg(tb)
                         .arg(addr)
                         .arg(value));
        if(!ok)
        {
            qDebug()<<query_.lastError();
        }
    }
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    if(time.elapsed() >= TEST_TIME_LEVEL)
    {
        qDebug()<<"ICDALHelper::UpdateMachineConfigValue time test"<<time.restart()<<"ms"<<ok;
    }
#endif
    return ok;
}

//template<typename T>
//bool ICDALHelper::UpdateAndLogConfigValue(const ICAddrWrapper* addr,
//                                          T value,
//                                          T baseValue,
//                                          const QString &newValueText,
//                                          const QString &oldValueText,
//                                          int moldCount,
//                                          bool isCommit )
//{
//#ifdef TEST_TIME_DEBUG
//    /*TIME_TEST*/
//    QTime time;
//    time.start();
//#endif
//    QSqlDatabase db = QSqlDatabase::database();
//    if(isCommit)
//    {
//        db.transaction();
//    }
//    addr->UpdateBaseAddrValue(addr, value, &baseValue);
//    bool ok = UpdateConfigValue<T>(addr, baseValue) ;
//    if(ok)
//    {
//        ok = LogConfigModify(addr, newValueText, oldValueText, moldCount);
//    }

////    qDebug()<<db.lastError();
//    if(isCommit)
//    {
//        if(ok)
//        {
//            db.commit();
//        }
//        else
//        {
//            db.rollback();
//        }
//    }


//#ifdef TEST_TIME_DEBUG
//    /*TIME_TEST*/
//    if(time.elapsed() >= TEST_TIME_LEVEL)
//    {
//        qDebug()<<"ICDALHelper::UpdateAndLogConfigValue time test"<<time.restart()<<"ms"<<ok<<addr->ToString();
//    }
//#endif
//    return ok;
//}


inline QVector<QPair<quint32, quint32> > ICDALHelper::GetAllConfigValues_(const QString &listName)
{
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    QTime time;
    time.start();
#endif

    QVector<QPair<quint32, quint32> > ret;
    QSqlQuery query;
    query.exec("SELECT addr, value FROM " + listName);
    while(query.next())
    {
        ret.append(qMakePair(query.value(0).toUInt(), query.value(1).toUInt()));
    }

#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    if(time.elapsed() >= TEST_TIME_LEVEL)
    {
        qDebug()<<"ICDALHelper::GetAllConfigValues time test"<<time.restart()<<"ms";
    }
#endif
    return ret;
}

inline uint ICDALHelper::CountTableRecords_(const QString &tbName)
{
    QSqlQuery query;
    query.exec(QString("SELECT COUNT(*) FROM %1").arg(tbName));
    if(query.next())
    {
        return query.value(0).toUInt();
    }
    return 0;
}

inline QString ICDALHelper::MoldConfigNameWrapper(const QString &name)
{
    return "tb_" + name + "_moldconfig";
}

inline QString ICDALHelper::SystemConfigNameWrapper(const QString &name)
{
    return "tb_" + name + "_systemconfig";
}

inline bool ICDALHelper::NewSystemConfig(const QString &name, QString& err)
{
    return CopyTable_(SystemConfigNameWrapper(name), DefaultSystemConfigTableName, err, NullWrapper_);
}


inline bool ICDALHelper::CopySystemConfig(const QString &newName, QString &err, const QString &oldName)
{
    return CopyTable_(newName, oldName, err, SystemConfigNameWrapper);
}


inline bool ICDALHelper::DeleteSystemConfig(const QString &name, QString &err)
{
    return DropTable_(name, err, SystemConfigNameWrapper);
}

inline int ICDALHelper::TableRowCount(const QString &tableName)
{
    QSqlQuery query;
    query.exec(QString("SELECT COUNT(*) FROM %1").arg(tableName));
    if(query.next())
    {
        return query.value(0).toInt();
    }
    return 0;
}

inline QStringList ICDALHelper::MoldProgramContent(const QString &moldName)
{
    QStringList ret;
    QSqlQuery query;
    query.exec(QString("SELECT content, sub1, sub2, sub3, sub4, sub5, sub6, sub7, sub8 stacks FROM %1 WHERE mold_name = '%2'").arg("tb_mold_act").arg(moldName));
    if(query.next())
    {
        ret.append(query.value(0).toString());
        ret.append(query.value(1).toString());
        ret.append(query.value(2).toString());
        ret.append(query.value(3).toString());
        ret.append(query.value(4).toString());
        ret.append(query.value(5).toString());
        ret.append(query.value(6).toString());
        ret.append(query.value(7).toString());
        ret.append(query.value(8).toString());
//        ret.append(query.value(9).toString());
    }
    return ret;
}

inline QString ICDALHelper::MoldStacksContent(const QString &moldName)
{
    QString ret;
    QSqlQuery query;
    query.exec(QString("SELECT stacks FROM %1 WHERE mold_name = '%2'").arg("tb_mold_act").arg(moldName));
    if(query.next())
    {
        ret = (query.value(0).toString());

    }
    return ret;
}

inline QString ICDALHelper::MoldFunctionsContent(const QString &moldName)
{
    QString ret;
    QSqlQuery query;
    query.exec(QString("SELECT functions FROM %1 WHERE mold_name = '%2'").arg("tb_mold_act").arg(moldName));
    if(query.next())
    {
        ret = (query.value(0).toString());

    }
    return ret;
}

inline QString ICDALHelper::MoldFncTableName(const QString &moldName)
{
    QSqlQuery query;
    query.exec(QString("SELECT fnc_table_name FROM %1 WHERE name = '%2'").arg("tb_moldconfig_record").arg(moldName));
    if(query.next())
        return QString("mold_%1").arg(query.value(0).toString());
    return "";
}

inline QString ICDALHelper::MoldCounterTableName(const QString &moldName)
{
    QSqlQuery query;
    query.exec(QString("SELECT fnc_table_name FROM %1 WHERE name = '%2'").arg("tb_moldconfig_record").arg(moldName));
    if(query.next())
        return QString("counter_%1").arg(query.value(0).toString());
    return "";
}

inline QString ICDALHelper::MoldVariableTableName(const QString &moldName)
{
    QSqlQuery query;
    query.exec(QString("SELECT fnc_table_name FROM %1 WHERE name = '%2'").arg("tb_moldconfig_record").arg(moldName));
    if(query.next())
        return QString("variable_%1").arg(query.value(0).toString());
    return "";
}

inline bool ICDALHelper::SaveStacks(const QString &moldName, const QString &stacks)
{
    QString colName = ("stacks");
    QString cmd = QString("UPDATE tb_mold_act set %1 = \'%2\' WHERE mold_name = \"%3\"")
            .arg(colName).arg(stacks).arg(moldName);
    QSqlQuery query;
    query.exec(cmd);
    //    qDebug()<<query.lastError().text();
    return query.lastError().type() == QSqlError::NoError;
}

inline bool ICDALHelper::SaveFunctions(const QString &moldName, const QString &functions)
{
    QString colName = ("functions");
    QString cmd = QString("UPDATE tb_mold_act set %1 = \'%2\' WHERE mold_name = \"%3\"")
            .arg(colName).arg(functions).arg(moldName);
    QSqlQuery query;
    query.exec(cmd);
//        qDebug()<<query.lastError().text();
    return query.lastError().type() == QSqlError::NoError;
}

#endif // ICDALHELPER_H
