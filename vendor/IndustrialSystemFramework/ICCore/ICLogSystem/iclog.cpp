#include "iclog.h"
#include <QDateTime>
//#include <QFileInfo>
#include <QFile>
#include <QTextStream>
#include <stdio.h>
#include <stdlib.h>
#include <QDebug>

#define PRIVATE_INFO_HEADER 64

ICLog::ICLog(const QString &logFile, quint64 maxSpace):
    logFile_(logFile), sep_("<:>"), maxSpace_(maxSpace)
{
    if(logFile_.open(QFile::ReadWrite | QFile::Text | QFile::Append))
    {
        quint64 padSize = logFile_.size();
        if(padSize < maxSpace)
        {
            padSize = maxSpace - padSize;
            char *pad = new char[padSize];
            memset(pad, ' ', padSize);
            logFile_.write(pad, padSize);
            delete pad;
        }
        mappedLog_ = logFile_.map(0, maxSpace);
        if(mappedLog_ == NULL)
        {
            qDebug("Mapped fail!");
        }

        logFile_.close();

    }
    endPos_ = GetCurrentEndPos_();
    if(endPos_ < PRIVATE_INFO_HEADER)
    {
        endPos_ = PRIVATE_INFO_HEADER;
        SetCurrentEndPos_(endPos_);
    }
}

void ICLog::Log(const QString &logContent)
{
//    if(LogFileName().isEmpty())
//    {
//        return;
//    }
//    QFileInfo fileInfo(LogFileName());
//    if(fileInfo.size() / 1024 >= MaxSpace())
//    {
//        QFile::remove(LogFileName());
//    }

    QByteArray writeContent = QString("%1%2%3<|>\n").arg(QDateTime::currentDateTime().toString("yyyy/MM/dd hh:mm:ss"))
            .arg(Sep()).arg(logContent).toUtf8();
    if(writeContent.size() < CalcLeftSpace_())
    {
        strncpy(reinterpret_cast<char*>(mappedLog_ + endPos_), writeContent, writeContent.size());
        endPos_ += writeContent.size();
    }
    else
    {
        strncpy(reinterpret_cast<char*>(mappedLog_ + PRIVATE_INFO_HEADER), writeContent, writeContent.size());
        endPos_ = writeContent.size() + PRIVATE_INFO_HEADER;
    }
    SetCurrentEndPos_(endPos_);

//    QFile file(LogFileName());
//    if(file.open(QFile::WriteOnly | QFile::Text | QFile::Append))
//    {
//        QTextStream out(&file);
//        out.setCodec("UTF-8");
//        out<<writeContent<<endl;
//        file.close();
//    }

}


QString ICLog::LogContent() const
{
//    if(LogFileName().isEmpty())
//    {
//        return QString();
//    }
//    QFile file(LogFileName());
//    if(file.open(QFile::ReadOnly | QFile::Text))
//    {
//        QTextStream in(&file);
//        in.setCodec("UTF-8");
//        QString ret = in.readAll();
//        file.close();
//        return ret;
//    }
    return QString::fromUtf8(reinterpret_cast<char*>(mappedLog_), endPos_);
}

void ICLog::MessageOutput(QtMsgType type, const char *msg)
{
    switch (type) {
    case QtDebugMsg:
        fprintf(stderr, "Debug: %s\n", msg);
        break;
    case QtWarningMsg:
        fprintf(stderr, "Warning: %s\n", msg);
        break;
    case QtCriticalMsg:
        fprintf(stderr, "Critical: %s\n", msg);
        break;
    case QtFatalMsg:
        fprintf(stderr, "Fatal: %s\n", msg);
        abort();
    }
    Log(msg);
}

quint64 ICLog::GetCurrentEndPos_()
{
    QString pos;
    for(int i = 0; i < PRIVATE_INFO_HEADER; ++i)
    {
        if(mappedLog_[i] == '\n')
            break;
        pos.append(mappedLog_[i]);
    }
    return pos.toULongLong();
}

void ICLog::SetCurrentEndPos_(quint64 endPos)
{
    QString toSet = QString::number(endPos);
    strcpy(reinterpret_cast<char*>(mappedLog_), toSet.toUtf8());
    int left = PRIVATE_INFO_HEADER - toSet.size();
    memset(mappedLog_ + toSet.size(), ' ', left);
    mappedLog_[PRIVATE_INFO_HEADER - 1] = '\n';
}
