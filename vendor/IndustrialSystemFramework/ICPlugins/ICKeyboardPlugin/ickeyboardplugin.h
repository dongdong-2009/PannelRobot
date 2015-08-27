#ifndef ICKEYBOARDPLUGIN_H
#define ICKEYBOARDPLUGIN_H

#include <QtGui/QKbdDriverPlugin>


class ICKeyboardPlugin : public QKbdDriverPlugin {
    Q_OBJECT
public:
    ICKeyboardPlugin(QObject *parent = 0);
    QWSKeyboardHandler *create(const QString &driverName, const QString &deviceName = QString("/dev/szhc_keyboard"));
                              //create()函数返回一个给定键值的QWSKeyboardHandler派生类的实例
    QStringList keys() const; //   keys()函数返回一个键盘插件的键值
};

#endif // ICKEYBOARDPLUGIN_H
