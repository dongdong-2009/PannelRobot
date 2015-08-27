#include <unistd.h>
#include <cstdlib>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <time.h>
#include <QSocketNotifier>
#include <QRunnable>
#include <QThreadPool>
//#include <QTimer>
#include <QDebug>
#include "ickeyboardhandler.h"

class ICBeepOff:public QRunnable
{
public:
    ICBeepOff(int beepFd):beepFd_(beepFd){}
    void run()
    {
        timespec spec;
        spec.tv_sec = 0;
        spec.tv_nsec = 100000000;
        nanosleep(&spec, NULL);
        ioctl(beepFd_, 1, NULL);
    }

private:
    int beepFd_;
};

ICKeyboardHandler::ICKeyboardHandler(const QString &device, QObject *parent)
    :QObject(parent)
{
    kbdFd_ = ::open(device.toAscii().constData(), O_RDONLY);
    if(kbdFd_ < 0)
    {
        qCritical("open keyboard fail!");
        return;
    }
    beepFd_ = open("/dev/szhc_beep", O_WRONLY);
    if(beepFd_ < 0)
    {
        qCritical("Open beep fail!");
        return;
    }
    beepOffimpl_ = new ICBeepOff(beepFd_);
    beepOffimpl_->setAutoDelete(false);
    kbdNotifier_ = new QSocketNotifier(kbdFd_, QSocketNotifier::Read, this);
    connect(kbdNotifier_, SIGNAL(activated(int)), this, SLOT(GetKey(int)));
    qDebug("kbd opend");
}

ICKeyboardHandler::~ICKeyboardHandler()
{

    if(kbdFd_ >= 0)
    {
        close(kbdFd_);
        delete kbdNotifier_;
    }
}

void ICKeyboardHandler::GetKey(int dev)
{
    // 读取设备文件
    //
    //    qDebug("kbd pluin read");
    int rd = read(kbdFd_, ev_, sizeof(struct input_event) * 64);
    if (rd < (int) sizeof(struct input_event))
    {
        printf("expected %d bytes, got %d\n", (int) sizeof(struct input_event), rd);
        perror("\nevtest: error reading");
        return;
    }
    for (uint i = 0; i < rd / sizeof(struct input_event); i++)
    {
        printf("Event: time %ld.%06ld, ", ev_[i].time.tv_sec, ev_[i].time.tv_usec);

        if (ev_[i].type == EV_SYN) {
            if (ev_[i].code == SYN_MT_REPORT)
                printf("++++++++++++++ %d ++++++++++++\n", ev_[i].code);
            else
                printf("-------------- %d ------------\n", ev_[i].code);
        } else {
            printf("type %d, code %d, ",
                   ev_[i].type,
                   ev_[i].code);
            if (ev_[i].type == EV_MSC && (ev_[i].code == MSC_RAW || ev_[i].code == MSC_SCAN))
                printf("value %02x\n", ev_[i].value);
            else
                printf("value %d\n", ev_[i].value);
            processKeyEvent(0, keyValue_, Qt::NoModifier, true, false);
        }
    }

    //    memset(readKey_,0,sizeof(readKey_));
    //    if(read(dev_, readKey_, sizeof(readKey_)) < 0 )
    //    {
    //        return;
    //    }
    //    keyValue_ = atoi(readKey_);
    //    if(keyValue_ != 0)
    //    {
    //        ioctl(beepFd_, 0, NULL);
    ////        QTimer::singleShot(100, this, SLOT(BeepOff()));
    //        QThreadPool::globalInstance()->start(beepOffimpl_);
    //    }
    //    qDebug()<<"key"<<keyValue_;

}

