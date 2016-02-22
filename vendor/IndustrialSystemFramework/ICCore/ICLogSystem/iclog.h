#ifndef ICLOG_H
#define ICLOG_H

#include "ICCore_global.h"
#include <QString>
#include <QStringList>
#include <QFile>



class ICCORESHARED_EXPORT ICLog
{
public:
    explicit ICLog(const QString& logFile, quint64 maxSpace);
    QString LogFileName() const { return logFile_.fileName();}
//    void SetLogFileName(const QString& logFile) { logFile_ = logFile;}
    int MaxSpace() const { return maxSpace_;}
//    void SetMaxSpace(int maxSpace) { maxSpace_ = maxSpace; }
    void Log(const QString& logContent);
    QString LogContent() const;
    QString Sep() const { return sep_;}
    void SetSep(const QString& sep) { sep_ = sep;}
    void MessageOutput(QtMsgType type, const char *msg);

private:
    quint64 GetCurrentEndPos_();
    quint64 CalcLeftSpace_() { return maxSpace_ - endPos_;}
    void SetCurrentEndPos_(quint64 endPos);
    QFile logFile_;
    QString sep_;
    uchar *mappedLog_;
    quint64 endPos_;
    quint64 maxSpace_;
};


#endif // ICLOG_H
