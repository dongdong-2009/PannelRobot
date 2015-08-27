#ifndef ICKEYBOARDHANDLER_H
#define ICKEYBOARDHANDLER_H

#include <QWSKeyboardHandler>
#include <linux/input.h>

class QSocketNotifier;
class QRunnable;

class ICKeyboardHandler : public QObject, public QWSKeyboardHandler
{
    Q_OBJECT
public:
    explicit ICKeyboardHandler(const QString &device = QString("/dev/event0"), QObject *parent = 0);

    ~ICKeyboardHandler();

signals:

public slots:

private:
    int kbdFd_;
    int beepFd_;
    QSocketNotifier *kbdNotifier_;
//    char readKey_[5];
    struct input_event ev_[64];
    int keyValue_;
    QRunnable *beepOffimpl_;
    //provides support for monitoring activity on a file descriptor.
private slots:
    void GetKey(int dev);

};

#endif // ICKEYBOARDHANDLER_H
