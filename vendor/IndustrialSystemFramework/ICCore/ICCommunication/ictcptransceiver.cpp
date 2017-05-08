#include "ictcptransceiver.h"
#include <QTcpServer>
#include <QTcpSocket>

ICTcpTransceiver::ICTcpTransceiver()
{
    connHelper_ = new _ConnectionHelper();
    SetBlock(false);
}
ICTcpTransceiver::~ICTcpTransceiver()
{
    delete connHelper_;
}

_ConnectionHelper::_ConnectionHelper()
{
    tcpSocket_ = NULL;
    tcpServer_ = NULL;
    //    tcpServer_ = new QTcpServer();
    //    tcpServer_->listen(QHostAddress::Any, 9760);
    //    connect(tcpServer_,
    //            SIGNAL(newConnection()),
    //            SLOT(OnNewConnection()));
}

_ConnectionHelper::~_ConnectionHelper()
{
    if(tcpServer_ != NULL)
    {
        tcpServer_->close();
        delete tcpServer_;
    }
}

void _ConnectionHelper::StartCommunicate()
{
    if(mode_ == ICTcpTransceiver::kCOMM_Server)
    {
        if(tcpServer_ == NULL)
        {
            tcpServer_ = new QTcpServer();
            connect(tcpServer_,
                    SIGNAL(newConnection()),
                    SLOT(OnNewConnection()));
        }
        tcpServer_->close();
        tcpServer_->listen(QHostAddress::Any, 9760);
    }
    else
    {
        if(tcpServer_ != NULL)
        {
            tcpServer_->close();
        }
        if(tcpSocket_ != NULL)
        {
            delete tcpSocket_;
        }
        tcpSocket_ = new QTcpSocket();
        connect(tcpSocket_, SIGNAL(readyRead()),
                SLOT(OnReadyRead()));
        tcpSocket_->connectToHost(hostAddr_, port_);
        //        tcpSocket_->setSocketOption(QAbstractSocket::LowDelayOption, true);

    }
}

void _ConnectionHelper::StopCommunicate()
{
    if(tcpSocket_ != NULL)
    {
        tcpSocket_->close();
        delete tcpSocket_;
        tcpSocket_ = NULL;
    }
    if(tcpServer_ != NULL)
         tcpServer_->close();
}

int _ConnectionHelper::Read(uint8_t *dest, size_t size)
{
    if(tcpSocket_ == NULL)
    {
        return 0;
    }
    if(tcpSocket_->state() != QTcpSocket::ConnectedState)
    {
        tcpSocket_->connectToHost(hostAddr_, port_);
        return 0;
    }
    if(isBlock_)
    {
        tcpSocket_->waitForReadyRead(-1);
    }
    if(!tcpSocket_->isReadable())
    {
        qDebug()<<tcpSocket_->errorString();
        return 0;
    }
//    qDebug()<<"bytes available:"<<tcpSocket_->bytesAvailable();
    int ret = tcpSocket_->read((char *)dest,size) ;
    return ret;
}

int _ConnectionHelper::Write(const uint8_t *buffer, size_t size)
{
    if(tcpSocket_ == NULL)
    {
        return 0;
    }
    if(tcpSocket_->state() != QTcpSocket::ConnectedState)
    {
        tcpSocket_->connectToHost(hostAddr_, port_);
        return 0;
    }
    return tcpSocket_->write((char *)buffer,size);
}

void _ConnectionHelper::OnNewConnection()
{
    qDebug("TCP Connect");
    if(tcpSocket_ != NULL)
    {
        tcpSocket_->close();
        delete tcpSocket_;
        tcpSocket_ = NULL;
    }
    tcpSocket_ = tcpServer_->nextPendingConnection();
    tcpSocket_->setSocketOption(QAbstractSocket::LowDelayOption, true);
    connect(tcpSocket_, SIGNAL(readyRead()),
            SLOT(OnReadyRead()));
}

void _ConnectionHelper::OnReadyRead()
{
    int bA = tcpSocket_->bytesAvailable();
    QByteArray toRead(bA, '\0');
    Read((uint8_t*)toRead.data(), bA);
//    qDebug()<<"driver:"<<toRead;
    for(int i = 0; i < monitors_.size(); ++i)
    {
        if(monitors_.at(i)->CanIn(toRead))
            monitors_[i]->OnDataComeIn(toRead);
    }
//    emit dataComeIn(toRead);
}

bool _ConnectionHelper::IsConnected() const
{
    if(mode_ == ICTcpTransceiver::kCOMM_Server)
    {
        return true;
    }
    if(tcpSocket_ == NULL)
    {
        return false;
    }
    return (tcpSocket_->state() == QTcpSocket::ConnectedState);
}
