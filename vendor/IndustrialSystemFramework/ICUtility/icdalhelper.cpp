#include "icdalhelper.h"
#include <QDateTime>
#include <QStringList>
#include "icoptimize.h"
#include <QDebug>

const char* ICDALHelper::AddrNameColumnName = "addrName";
const char* ICDALHelper::AlarmTableName = "tb_alarmrecord";
const char* ICDALHelper::ModifyTableName = "tb_modifyrecord";
const char* ICDALHelper::QualityTableName = "tb_product_log";
const char* ICDALHelper::DefaultMoldConfigTableName = "basemoldconfig";
const char* ICDALHelper::DefaultSystemConfigTableName = "basesysconfig";
const char* ICDALHelper::DateTimeFormat = "yyyy/MM/dd hh:mm:ss";
ICDALHelper::ICDALHelper()
{
}

bool ICDALHelper::LogAlarm(uint alarmNum)
{
    int currentSize = CountTableRecords_(AlarmTableName);
    QSqlQuery query;
    if(unlikely(currentSize < MaxAlarmSize))
    {
        query.prepare(QString("INSERT INTO %1 (id, alarmNum, triggerTime)"
                              "VALUES (:id, :alarmNum, :triggerTime)").arg(AlarmTableName));
        query.bindValue(":id", currentSize + 1);
        query.bindValue(":alarmNum", alarmNum);
        query.bindValue(":triggerTime", QDateTime::currentDateTime().toString());
    }
    else
    {
        query.exec("SELECT MIN(id), MAX(id) FROM tb_alarmrecord");
        uint minID;
        uint maxID;
        if(likely(query.next()))
        {
            minID = query.value(0).toUInt();
            maxID = query.value(1).toUInt();
            query.prepare(QString("UPDATE %1 SET id = %2, alarmNum = %3, triggerTime = \'%4\' "
                                  "WHERE id = %5").arg(AlarmTableName)
                          .arg(maxID + 1)
                          .arg(alarmNum)
                          .arg(QDateTime::currentDateTime().toString())
                          .arg(minID));
        }
    }
    return query.exec();
}

bool ICDALHelper::UpdateMoldFncValues(const QList<QPair<int, quint32> > &addrValuePairs, const QString& moldName)
{
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    QTime time;
    time.start();
#endif
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    for(int i = 0; i != addrValuePairs.size(); ++i)
    {
        UpdateMoldFncValue(addrValuePairs.at(i).first, addrValuePairs.at(i).second, moldName);
    }
    bool ok = db.commit();
    //    updateConfigsRunnable_->SetData(addrValuePairs);
    //    bool ok = false;
    //    do
    //    {
    //    ok = QThreadPool::globalInstance()->tryStart(updateConfigsRunnable_.data());
    //    }while(!ok);


#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    if(time.elapsed() >= TEST_TIME_LEVEL)
    {
        qDebug()<<"ICDALHelper::UpdateConfigsValues time test"<<time.restart()<<"ms";
    }
#endif
    return ok;
}

bool ICDALHelper::UpdateMachineConfigValues(const QList<QPair<int, quint32> > &addrValuePairs, const QString& machineName)
{
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    QTime time;
    time.start();
#endif
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    for(int i = 0; i != addrValuePairs.size(); ++i)
    {
        UpdateMachineConfigValue(addrValuePairs.at(i).first, addrValuePairs.at(i).second, machineName);
    }
    bool ok = db.commit();

#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    if(time.elapsed() >= TEST_TIME_LEVEL)
    {
        qDebug()<<"ICDALHelper::UpdateConfigsValues time test"<<time.restart()<<"ms";
    }
#endif
    return ok;
}

bool ICDALHelper::LogConfigModify(const ICAddrWrapper* addr, const QString &newValue, const QString &oldValue, const int moldCount)
{
    int currentSize = CountTableRecords_(ModifyTableName);
    QSqlQuery query;
    bool isok = false;
    QString mName = addr->ToString().mid(0, 1) + ":";
    if(mName == "m:") mName += ICAppSettings().CurrentMoldConfig();
    else if(mName == "s:") mName += ICAppSettings().CurrentSystemConfig();
    QString nv = newValue;
    QString ov = oldValue;
    nv.replace("'","''");
    ov.replace("'","''");
    if(ov.isEmpty())
    {
        ov = "None";
    }
    if(unlikely(currentSize < MaxAlarmSize))
    {
        query.prepare(QString("INSERT INTO %1 (id, moldName, moldCounter, addr, description, modifiedTime, oldValue, newValue) "
                              "VALUES (:id, :moldName, :moldCounter, :addr, :description, :modifiedTime, :oldValue, :newValue)")
                      .arg(ModifyTableName));
        query.bindValue(":id", currentSize + 1);
        query.bindValue(":moldName", mName);
        query.bindValue(":moldCounter", moldCount);
        query.bindValue(":addr", addr->ToString());
        query.bindValue(":description", addr->ToString());
        query.bindValue(":modifiedTime", QDateTime::currentDateTime().toString(DateTimeFormat));
        query.bindValue(":oldValue", ov);
        query.bindValue(":newValue", nv);
        isok = query.exec();
        //        qDebug()<<query.lastError();

    }
    else
    {
        query.exec("SELECT MIN(id), MAX(id) FROM tb_modifyrecord");
        uint minID;
        uint maxID;
        if(likely(query.next()))
        {
            minID = query.value(0).toUInt();
            maxID = query.value(1).toUInt();
            QString cmd = QString("UPDATE %1 SET id = %2, moldName = \'%3\', moldCounter = %4, addr = \'%5\' , description = \'%6\', modifiedTime = \'%7\', oldValue = \'%8\', newValue = \'%9\' "
                                  "WHERE id = %10").arg(ModifyTableName)
                    .arg(maxID + 1)
                    .arg(mName)
                    .arg(moldCount)
                    .arg(addr->ToString())
                    .arg(addr->ToString())
                    .arg(QDateTime::currentDateTime().toString(DateTimeFormat))
                    .arg(ov)
                    .arg(nv)
                    .arg(minID);
            isok = query.exec(cmd);
        }
    }
    return isok;
}

QStringList ICDALHelper::TableContent_(const QString &name, Wrapper wrapper)
{
    QSqlQuery query(QString("SELECT * FROM %1").arg(wrapper(name)));
    query.exec();
    QStringList ret;
    QSqlRecord record;
    while(query.next())
    {
        record = query.record();
        ret.append(record.value(0).toString() + "," + record.value(1).toString() + "," + record.value(2).toString());
    }
    return ret;
}


QStringList ICDALHelper::AlarmTableContent_(const QString &name, Wrapper wrapper)
{
    QSqlQuery query(QString("SELECT * FROM %1 WHERE addr >= 752 AND addr <= 1007;").arg(wrapper(name)));
    query.exec();
    QStringList ret;
    QSqlRecord record;
    while(query.next())
    {
        record = query.record();
        ret.append(QString("UPDATE %1 SET value = %2 WHERE addr = %3;").arg(wrapper(name)).arg(record.value(1).toString()).arg(record.value(0).toString()));
    }
    return ret;
}

bool ICDALHelper::ImportRecordTable(const QString &tableName, const QStringList &csvData, QString &err)
{
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query;
    query.exec(QString("SELECT COUNT(*) FROM %1").arg(DefaultMoldConfigTableName));
    int moldConfigCount = 0;
    if(query.next())

    {
        moldConfigCount = query.value(0).toInt();
    }
    if(csvData.size() != moldConfigCount)
    {
        err = "Data is incomplite!";
        return false;
    }
    QString wrappedName = MoldConfigNameWrapper(tableName);
    if(!IsExistsRecordTable(tableName))
    {
        query.exec(QString("CREATE TABLE %1(addr INT, value INT)").arg(wrappedName));
    }
    else
    {
        query.exec(QString("DELETE FROM %1").arg(wrappedName));
        qDebug()<<query.lastError().text();
    }
    db.transaction();
    QString dataString;
    QStringList paras;
    const int csvDataSize = csvData.size();
    for(int i = 0; i != csvDataSize; ++i)
    {
        dataString = csvData.at(i);
        paras = dataString.split(',', QString::SkipEmptyParts);
        if(unlikely(paras.size() != 2))
        {
            err = "Wrong CSV Format!";
            db.rollback();
            return false;
        }
        query.exec(QString("INSERT INTO %1(addr, value) VALUES(%2, %3)")
                   .arg(wrappedName)
                   .arg(paras.at(0))
                   .arg(paras.at(1)));
    }
    return db.commit();
    //    return false;
}

bool ICDALHelper::ImportSystemTable(const QString &tableName, const QStringList &csvData, QString &err)
{
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query;
    query.exec(QString("SELECT COUNT(*) FROM %1").arg(DefaultSystemConfigTableName));
    int moldConfigCount = 0;
    if(query.next())
    {
        moldConfigCount = query.value(0).toInt();
    }
    if(csvData.size() != moldConfigCount)
    {
        err = "Data is incomplite!";
        return false;
    }
    QString wrappedName = SystemConfigNameWrapper(tableName);
    if(!IsExistsSystemtable(tableName))
    {
        query.exec(QString("CREATE TABLE %1(addr INT, value INT)").arg(wrappedName));
    }
    else
    {
        query.exec(QString("DELETE FROM %1").arg(wrappedName));
    }
    db.transaction();
    QString dataString;
    QStringList paras;
    db.transaction();
    for(int i = 0; i != csvData.size(); ++i)
    {
        dataString = csvData.at(i);
        paras = dataString.split(',', QString::SkipEmptyParts);
        if(unlikely(paras.size() != 2))
        {
            err = "Wrong CSV Format!";
            db.rollback();
            return false;
        }
        query.exec(QString("INSERT INTO %1(addr,value) VALUES(%2, %3)")
                   .arg(wrappedName)
                   .arg(paras.at(0))
                   .arg(paras.at(1)));
    }
    return db.commit();
    //    return false;
}

bool ICDALHelper::IsExistsRecordTable(const QString &tableName)
{
    QSqlQuery query;
    query.exec(QString("SELECT * FROM tb_moldconfig_record WHERE name = \'%1\'").arg(tableName));
    return query.next();
}

bool ICDALHelper::IsExistsSystemtable(const QString &tableName)
{
    QSqlQuery query;
    query.exec(QString("SELECT * FROM tb_systemconfig_record WHERE name = \'%1\'").arg(tableName));
    return query.next();
}

QString ICDALHelper::AlarmDecription(uint alarmNum)
{
    if(unlikely(alarmNum == 0))
    {
        return QString();
    }
    QSqlQuery query(QString("SELECT * FROM tb_alarm_%1 WHERE alarmNum = %2")
                    .arg(ICAppSettings().Locale().name())
                    .arg(alarmNum));
    query.exec();
    if(likely(query.next()))
    {
        return query.record().value(1).toString();
    }
    return QString();

}

bool ICDALHelper::GetConfigValues_(const QString &name, QList<uint> &addrs)
{
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    QTime time;
    time.start();
#endif
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QList<QSqlQuery> querys;
    const QString cmd = "SELECT value FROM " + name + " WHERE ";
    for(int i = 0; i != addrs.size(); ++i)
    {
        querys.append(QSqlQuery(cmd + "addrValue = " + QString::number(addrs.at(i))));
    }
    for(int i = 0; i != querys.size(); ++i)
    {
        querys[i].exec();
    }
    bool ret = db.commit();
    for(int i = 0; i != querys.size(); ++i)
    {
        addrs[i] = querys[i].next() ? querys[i].record().value(0).toUInt() : 0;
    }
#ifdef TEST_TIME_DEBUG
    /*TIME_TEST*/
    if(time.elapsed() >= TEST_TIME_LEVEL)
    {
        qDebug()<<"GetConfigValues time test"<<time.restart()<<"ms";
    }
#endif
    return ret;
}

bool ICDALHelper::DropTable_(const QString &name, QString &err, Wrapper wrapper)
{
    QSqlQuery query;
    bool isOk = query.exec(QString("DROP TABLE %1").arg(wrapper(name)));
    err = query.lastError().text();
    return isOk;
}

bool ICDALHelper::CopyTable_(const QString &newName, const QString &oldName, QString &err, Wrapper wrapper)
{
    QSqlQuery query;
    bool isOk = query.exec(QString("CREATE TABLE %1 as SELECT * FROM %2")
                           .arg(wrapper(newName))
                           .arg(wrapper(oldName)));
    err = query.lastError().text();
    return isOk;
}

static bool IsExistsTempTimerTable_(const QString& table)
{
    QSqlQuery query;
    query.exec(QString("SELECT moldName FROM tb_temp_timer WHERE moldName = \'%1\'").arg(table));
    return query.next();
}

static bool InsertMoldTempTimer_(const QString& table,
                                 int sun = 0, int mon = 0, int tue = 0, int web = 0, int thu = 0, int fri = 0, int sat = 0)
{
    QSqlQuery query;
    return query.exec(QString("INSERT INTO tb_temp_timer VALUES(\'%1\', %2 , %3 , %4, %5, %6 , %7 , %8)").arg(table)
                      .arg(sun).arg(mon).arg(tue).arg(web).arg(thu).arg(fri).arg(sat));

}

static bool CopyMoldTempTimer_(const QString& newTable, const QString& oldTable)
{
    QSqlQuery query;
    query.exec(QString("SELECT * FROM tb_temp_timer WHERE moldName = \'%1\'").arg(oldTable));
    if(!query.next())
    {
        return false;
    }
    QSqlRecord rec = query.record();
    rec.setValue("moldName", newTable);
    return InsertMoldTempTimer_(newTable, rec.value("sun").toInt(), rec.value("mon").toInt(),
                                rec.value("tue").toInt(), rec.value("web").toInt(),
                                rec.value("thu").toInt(), rec.value("fri").toInt(),
                                rec.value("sat").toInt());
}

static bool DeleteMoldTempTimer_(const QString& table)
{
    QSqlQuery query;
    return query.exec(QString("DELETE FROM tb_temp_timer WHERE moldName = \'%1\'").arg(table));
}

static void FixTempTimerTable_()
{
    QStringList tables = ICDALHelper::RecordTables();
    for(int i = 0; i != tables.size(); ++i)
    {
        if(!IsExistsTempTimerTable_(tables.at(i)))
        {
            InsertMoldTempTimer_(tables.at(i));
        }
    }
}

QString ICDALHelper::NewMoldConfig(const QString &name,
                                   const QList<QPair<int, quint32> > & values,
                                   const QVector<QVariantList>& counters,
                                   const QVector<QVariantList>& variables)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QSqlQuery query;
    query.exec("SELECT MAX(fnc_table_name) FROM tb_moldconfig_record");
    if(!query.next())
    {
        db.rollback();
        return "";
    }
//    qDebug()<<query.lastQuery()<<query.record();
    int maxID = query.value(0).toInt();
    QString dt = QDateTime::currentDateTime().toString(DateTimeFormat);
    query.exec(QString("INSERT INTO tb_moldconfig_record VALUES(\"%1\", %2, \"%3\")")
               .arg(name)
               .arg(maxID + 1)
               .arg(dt));
    QString tableName = QString("tb_mold_%1_moldconfig").arg(maxID + 1);
    QString cmd = QString("CREATE TABLE \"%1\"(addr INT,value TEXT)").arg(tableName);
    query.exec(cmd);
    const QString insertTempl = QString("INSERT INTO %1 VALUES(%2, %3)");
    for(int i = 0; i != values.size(); ++i)
    {
        query.exec(insertTempl.arg(tableName).arg(values.at(i).first).arg(values.at(i).second));
    }
    QString counterTableName = QString("tb_counter_%1_moldconfig").arg(maxID + 1);
    cmd = QString("CREATE TABLE \"%1\"(id INT,name TEXT, current INT, target INT)").arg(counterTableName);
    query.exec(cmd);
    const QString insertTemplCounter = QString("INSERT INTO %1 VALUES(%2, \'%3\', %4, %5)");
    QVariantList c;
    for(int i = 0; i != counters.size(); ++i)
    {
        c = counters.at(i);
        query.exec(insertTemplCounter.arg(counterTableName).arg(c.at(0).toString())
                   .arg(c.at(1).toString()).arg(c.at(2).toString()).arg(c.at(3).toString()));
    }

    QString variableTableName = QString("tb_variable_%1_moldconfig").arg(maxID + 1);
    cmd = QString("CREATE TABLE \"%1\"(id INT,name TEXT, unit TEXT, val INT, decimal INT)").arg(variableTableName);
    query.exec(cmd);
    const QString insertTemplVariable = QString("INSERT INTO %1 VALUES(%2, \'%3\',\'%4\', %5, %6)");
    QVariantList v;
    for(int i = 0; i != variables.size(); ++i)
    {
        v = variables.at(i);
        query.exec(insertTemplVariable.arg(variableTableName)
                   .arg(v.at(0).toString())
                   .arg(v.at(1).toString())
                   .arg(v.at(2).toString())
                   .arg(v.at(3).toString())
                   .arg(v.at(4).toString()));
    }
    if(db.commit())
        return dt;
    return "";
}


bool ICDALHelper::CopyMoldConfig(const QString &newName, QString &err, const QString &oldName)
{
    return CopyTable_(newName, oldName, err, MoldConfigNameWrapper);
}

bool ICDALHelper::DeleteMoldConfig(const QString &name, QString &err)
{
    return DropTable_(name, err, MoldConfigNameWrapper);
}

QStringList ICDALHelper::RecordTables()
{
    QSqlQuery query;
    query.exec(QString("SELECT name FROM tb_moldconfig_record"));
    QStringList ret;
    while(query.next())
    {
        ret.append(query.value(0).toString());
    }
    return ret;
}



void ICDALHelper::ConfigsFix()
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    FixTempTimerTable_();
    db.commit();

}

int ICDALHelper::UserLevel(const QString &user)
{
    QSqlQuery query;
    query.exec(QString("SELECT level FROM tb_user WHERE name=\'%1\'").arg(user));
    if(!query.next())
    {
        return 0;
    }
    return query.value(0).toInt();
}

static bool IsUserExist(const QString &name)
{
    QSqlQuery query;
    query.exec(QString("SELECT name FROM tb_user WHERE name=\'%1\'").arg(name));
    return query.next();
}

int ICDALHelper::CreateUser(const QString &name)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    if(IsUserExist(name))
    {
        db.rollback();
        return DATABASE_ERR_EXIST;
    }
    QSqlQuery query;
    if(query.exec(QString("INSERT INTO tb_user VALUES(\'%1\', 0, 123456, 0, 0, 0, 0)")
                  .arg(name)))
    {
        db.commit();
        return 0;
    }
    db.rollback();
    return -1;
}

int ICDALHelper::ChangeUserPassword(const QString &name, const QString& password)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QSqlQuery query;
    if(!IsUserExist(name))
    {
        db.rollback();
        return DATABASE_ERR_NOEXIST;
    }
    if(query.exec(QString("UPDATE tb_user SET password=\'%1\' WHERE name=\'%2\'")
                  .arg(password).arg(name)))
    {
        db.commit();
        return 0;
    }
    db.rollback();
    return -1;
}

int ICDALHelper::DeleteUser(const QString &name)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QSqlQuery query;
    if(!IsUserExist(name))
    {
        db.rollback();
        return DATABASE_ERR_NOEXIST;
    }
    if(query.exec(QString("DELETE FROM tb_user WHERE name=\'%1\'").arg(name)))
    {
        db.commit();
        return 0;
    }
    db.rollback();
    return -1;
}

int ICDALHelper::ChangeUserLevel(const QString &name, int level)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QSqlQuery query;
    if(!IsUserExist(name))
    {
        db.rollback();
        return DATABASE_ERR_NOEXIST;
    }
    if(query.exec(QString("UPDATE tb_user SET level=%1 WHERE name=\'%2\'").arg(level).arg(name)))
    {
        db.commit();
        return 0;
    }
    db.rollback();
    return -1;
}


int ICDALHelper::PermissionInformation(const QString &name, int &level, bool &hasBasic, bool &hasFunction, bool &hasMachine, bool &hasSystem)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QSqlQuery query;
    if(!IsUserExist(name))
    {
        db.rollback();
        return DATABASE_ERR_NOEXIST;
    }
    query.exec(QString("SELECT * from tb_user WHERE name=\'%1\'").arg(name));
    if(query.next())
    {
        level = query.value(1).toInt();
        hasBasic = query.value(3).toBool();
        hasFunction = query.value(4).toBool();
        hasMachine = query.value(5).toBool();
        hasSystem = query.value(6).toBool();
        db.commit();
        return 0;
    }
    db.rollback();
    return -1;
}

QString ICDALHelper::GetConfigName(const ICAddrWrapper *addr)
{
    QSqlQuery query;
    query.exec(QString("SELECT description FROM tb_config_%1 WHERE addr=\'%2\'")
               .arg(ICAppSettings().Locale().name())
               .arg(addr->ToString()));
    if(query.next())
    {
        return query.value(0).toString();
    }
    return "";
}

ICRecordInfos ICDALHelper::RecordTableInfos()
{
    QSqlQuery query;
    query.exec(QString("SELECT name ,create_at FROM tb_moldconfig_record"));
    ICRecordInfos ret;
    while(query.next())
    {
        ret.append(RecordDataObject(query.value(0).toString(),
                                    query.value(1).toString()));
    }
    return ret;
}

QString ICDALHelper::NewMold(const QString &moldName,
                             const QStringList &programs,
                             const QList<QPair<int, quint32> > & values,
                             const QVector<QVariantList>& counters,
                             const QVector<QVariantList> &variables)
{
    QStringList p = programs;
    for(int i = programs.size(); i< 9; ++i)
    {
        p.append("[{\"action\":32}]");
    }
    if(p.size() < 10)
    {
        p.append("\"\"");
    }
    if(p.size() < 11)
    {
        p.append("\"\"");
    }
    QString cmd = "INSERT INTO tb_mold_act VALUES(\"" + moldName + "\",";
    for(int i = 0 ; i < p.size(); ++i)
    {
        cmd += QString("\'%1\',").arg(p.at(i));
    }
    cmd.chop(1);
    cmd += ")";
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QSqlQuery query;
    query.exec(cmd);
        qDebug()<<cmd;
        qDebug()<<query.lastError().text();
    QString ret;
    //ToDo: New Mold act may not delete if fail
    if(db.commit())
    {
        ret = NewMoldConfig(moldName,values, counters, variables);
    }
    else
        db.rollback();
    return ret;
}

QString ICDALHelper::CopyMold(const QString &moldName, const QString &source)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QSqlQuery query;
    QString cmd = QString("SELECT * FROM tb_mold_act WHERE mold_name = \'%1\'").arg(source);
    query.exec(cmd);
    if(!query.next())
    {
        db.rollback();
        return "";
    }

    cmd = QString("INSERT INTO tb_mold_act VALUES(\"%1\",").arg(moldName);
    int count = query.record().count();
    for(int i = 1; i < count; ++i)
    {
        cmd += QString("\'%1\',").arg(query.value(i).toString());
    }
    cmd.chop(1);
    cmd += ")";

    if(!query.exec(cmd))
    {
        db.rollback();
        return "";
    }

    cmd = QString("SELECT * FROM tb_moldconfig_record WHERE name = \'%1\'").arg(source);
    query.exec(cmd);
    if(!query.next())
    {
        db.rollback();
        return "";
    }

    QString fncName = QString("tb_mold_%1_moldconfig").arg(query.value(1).toString());
    QString counterName = QString("tb_counter_%1_moldconfig").arg(query.value(1).toString());
    QString variableName = QString("tb_variable_%1_moldconfig").arg(query.value(1).toString());

    query.exec("SELECT MAX(fnc_table_name) FROM tb_moldconfig_record");
    if(!query.next())
    {
        db.rollback();
        return "";
    }
    int maxID = query.value(0).toInt();
    QString err;
    if(!CopyTable_(QString("tb_mold_%1_moldconfig").arg(maxID + 1), fncName, err, NullWrapper_))
    {
        db.rollback();
        return "";
    }
    if(!CopyTable_(QString("tb_counter_%1_moldconfig").arg(maxID + 1), counterName, err, NullWrapper_))
    {
        db.rollback();
        return "";
    }
    if(!CopyTable_(QString("tb_variable_%1_moldconfig").arg(maxID + 1), variableName, err, NullWrapper_))
    {
        db.rollback();
        return "";
    }
    QString dt = QDateTime::currentDateTime().toString(DateTimeFormat);
    if(!query.exec(QString("INSERT INTO tb_moldconfig_record VALUES(\"%1\", %2, \"%3\")")
               .arg(moldName)
               .arg(maxID + 1)
               .arg(dt)))
    {
        db.rollback();
        return "";
    }

    db.commit();
    return dt;
}

bool ICDALHelper::DeleteMold(const QString &moldName)
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();
    QString err;
    bool ret = DropTable_(MoldFncTableName(moldName), err, MoldConfigNameWrapper);
    ret = ret && DropTable_(MoldCounterTableName(moldName), err, MoldConfigNameWrapper);
    ret = ret && DropTable_(MoldVariableTableName(moldName), err, MoldConfigNameWrapper);
    QSqlQuery query;
    ret = ret && query.exec(QString("DELETE FROM tb_mold_act WHERE mold_name = \"%1\"").arg(moldName));
    ret = ret && query.exec(QString("DELETE FROM tb_moldconfig_record WHERE name = \"%1\"").arg(moldName));
//    ret = ret && query.exec(QString("DELETE FROM tb_moldconfig_record WHERE name = \"%1\"").arg(moldName));
    if(!db.commit())
        db.rollback();
    return ret;

}

bool ICDALHelper::SaveMold(const QString &moldName, int which, const QString &program)
{
    QString colName = (which == 0 ?  "content" : QString("Sub%1").arg(which));
    QString cmd = QString("UPDATE tb_mold_act set %1 = \'%2\' WHERE mold_name = \"%3\"")
            .arg(colName).arg(program).arg(moldName);
    QSqlQuery query;
    query.exec(cmd);
    //    qDebug()<<query.lastError().text();
    return query.lastError().type() == QSqlError::NoError;
}

QVector<QVariantList> ICDALHelper::GetMoldCounterDef(const QString &name)
{
    QSqlQuery query;
    query.exec("SELECT * FROM " + MoldConfigNameWrapper(MoldCounterTableName(name)));
    QVector<QVariantList> ret;
    QVariantList tmp;
    while(query.next())
    {
        tmp.clear();
        tmp<<query.value(0)<<query.value(1)<<query.value(2)<<query.value(3);
        ret.append(tmp);
    }
    return ret;
}

QVector<QVariantList> ICDALHelper::GetMoldVariableDef(const QString &name)
{
    QSqlQuery query;
    query.exec("SELECT * FROM " + MoldConfigNameWrapper(MoldVariableTableName(name)));
    QVector<QVariantList> ret;
    QVariantList tmp;
    while(query.next())
    {
        tmp.clear();
        tmp<<query.value(0)<<query.value(1)<<query.value(2)<<query.value(3)<<query.value(4);
        ret.append(tmp);
    }
    return ret;
}


bool ICDALHelper::UpdateCounter(const QString &moldname, const QVariantList& counter)
{
    QSqlQuery query;
    QString cmd = QString("UPDATE %1 SET id=%2, name=\"%3\", current=%4, target=%5 WHERE id=%2").arg(MoldConfigNameWrapper(MoldCounterTableName(moldname)))
            .arg(counter.at(0).toUInt()).arg(counter.at(1).toString()).arg(counter.at(2).toUInt()).arg(counter.at(3).toUInt());
    return query.exec(cmd);
}


bool ICDALHelper::AddCounter(const QString &moldname, const QVariantList& counter)
{
    QSqlQuery query;
    QString cmd = QString("INSERT INTO %1 VALUES(%2, \"%3\", %4, %5)").arg(MoldConfigNameWrapper(MoldCounterTableName(moldname)))
            .arg(counter.at(0).toUInt()).arg(counter.at(1).toString()).arg(counter.at(2).toUInt()).arg(counter.at(3).toUInt());
    return  query.exec(cmd);
}

bool ICDALHelper::DelCounter(const QString &moldname, quint32 id)
{
    QSqlQuery query;
    QString cmd = QString("DELETE FROM %1 WHERE id = %2").arg(MoldConfigNameWrapper(MoldCounterTableName(moldname)))
            .arg(id);
    return query.exec(cmd);
}

bool ICDALHelper::UpdateVariable(const QString &moldname, const QVariantList& variable)
{
    QSqlQuery query;
    QString cmd = QString("UPDATE %1 SET id=%2, name=\"%3\", unit=\"%4\", val=%5, decimal=%6 WHERE id=%2").arg(MoldConfigNameWrapper(MoldVariableTableName(moldname)))
            .arg(variable.at(0).toUInt())
            .arg(variable.at(1).toString())
            .arg(variable.at(2).toString())
            .arg(variable.at(3).toUInt())
            .arg(variable.at(4).toUInt());
    return query.exec(cmd);
}


bool ICDALHelper::AddVariable(const QString &moldname, const QVariantList& variable)
{
    QSqlQuery query;
    QString cmd = QString("INSERT INTO %1 VALUES(%2, \"%3\", \"%4\", %5, %6)").arg(MoldConfigNameWrapper(MoldVariableTableName(moldname)))
            .arg(variable.at(0).toUInt())
            .arg(variable.at(1).toString())
            .arg(variable.at(2).toString())
            .arg(variable.at(3).toUInt())
            .arg(variable.at(4).toUInt());
    return  query.exec(cmd);
}

bool ICDALHelper::DelVariable(const QString &moldname, quint32 id)
{
    QSqlQuery query;
    QString cmd = QString("DELETE FROM %1 WHERE id = %2").arg(MoldConfigNameWrapper(MoldVariableTableName(moldname)))
            .arg(id);
    return query.exec(cmd);
}
