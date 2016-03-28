#ifndef ICTCPTRANSCEIVER_H
#define ICTCPTRANSCEIVER_H

#include "ictransceiverbase.h"
#include <QObject>
#include <QHostAddress>
#include <QRegExp>
#include "ICCore_global.h"
class QTcpSocket;
class QTcpServer;

class ICCORESHARED_EXPORT TCPCommunicateMonitor: public QObject{
    Q_OBJECT
public:
    bool CanIn(const QByteArray& data) const
    {
        if(filter_.isEmpty()) return true;
        return filter_.indexIn(data, 0) == -1;
    }

    void SetFilter(const QRegExp& re ){filter_ = re;}

    void OnDataComeIn(const QByteArray& data){ emit dataComeIn(data);}

signals:
    void dataComeIn(const QByteArray&);
private:
    QRegExp filter_;
};

class ICCORESHARED_EXPORT _ConnectionHelper: public QObject
{
    Q_OBJECT
public:
    _ConnectionHelper();
    ~_ConnectionHelper();

    void StartCommunicate();
    void StopCommunicate();

    int Read(uint8_t *dest, size_t size);
    int Write(const uint8_t *buffer, size_t size);

    void RegisterMonitor(TCPCommunicateMonitor* monitor)
    {
//        connect(this, SIGNAL(dataComeIn(QByteArray)), monitor, SIGNAL(dataComeIn(QByteArray)));
        monitors_.append(monitor);
    }


    QTcpSocket* tcpSocket_;
    QTcpServer* tcpServer_;
//    QList<const CommunicateMonitor*> monitors_;

    int mode_;
    QHostAddress hostAddr_;
    int port_;

    bool isBlock_;
    QList<TCPCommunicateMonitor*> monitors_;

signals:
    void dataComeIn(const QByteArray& data);

private slots:
    void OnNewConnection();
    void OnReadyRead();
};



class ICCORESHARED_EXPORT ICTcpTransceiver : public ICTransceiverBase
{
public:
    enum CommunicateMode{
        kCOMM_Server,
        kCOMM_Client
    };
    ICTcpTransceiver();
    virtual ~ICTcpTransceiver();

    bool IsBlock() { return connHelper_->isBlock_;}
    void SetBlock(bool isBlock) {connHelper_->isBlock_ = isBlock;}
    virtual void StopCommunicate() { connHelper_->StopCommunicate();}
    virtual void StartCommunicate() { connHelper_->StartCommunicate();}

    void SetCommuncateMode(CommunicateMode mode) { connHelper_->mode_ = mode;}
    void SetHostAddr(const QHostAddress & address, quint16 port) { connHelper_->hostAddr_ = address; connHelper_->port_ = port;}

    void RegisterCommMonitor(TCPCommunicateMonitor* monitor) { connHelper_->RegisterMonitor(monitor);}

    int WriteRawData(const QByteArray& data) { return WriteImpl((uint8_t*)(data.data()), data.size());}

protected:

    virtual int ReadImpl(uint8_t *dest, size_t size) { return connHelper_->Read(dest, size);}
    virtual int WriteImpl(const uint8_t *buffer, size_t size) { return connHelper_->Write(buffer, size);}
private:
    _ConnectionHelper*  connHelper_;

};
#endif // ICTCPTRANSCEIVER_H
