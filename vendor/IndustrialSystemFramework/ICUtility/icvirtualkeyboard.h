#ifndef ICVIRTUALKEYBOARD_H
#define ICVIRTUALKEYBOARD_H

#include <QWidget>
#include <QSignalMapper>
#include <QDoubleValidator>
#include "icdatatype.h"

namespace Ui {
class ICVirtualKeyboard;
}

typedef ICRange (*AddrRangeGetter)(const QString& addrName);

static inline ICRange DefaultRangeGetter(const QString& addrName)
{
    Q_UNUSED(addrName);
    return ICRange();
}

class ICVirtualKeyboard : public QWidget
{
    Q_OBJECT

public:
    explicit ICVirtualKeyboard(AddrRangeGetter rangeGetter = DefaultRangeGetter, QWidget *parent = 0);
    ~ICVirtualKeyboard();
    Q_INVOKABLE void openSoftPanel(int editPosx, int editPosy, int editW, int editH, bool isNumberOnly = true, const QString& configName = "", bool checkRange = false);
    Q_INVOKABLE void openSoftPanel(int editPosx, int editPosy, int editW, int editH, double min, double max, int decimal);
signals:
    void characterGenerated(const QString& text);
    void commit(const QString& text);
    void reject();

protected:
    void changeEvent(QEvent *e);
    void closeEvent(QCloseEvent * event);

private slots:
    void saveFocusWidget(QWidget *oldFocus, QWidget *newFocus);
    void buttonClicked(QWidget *w);
    void OnInputButtonClicked(const QString& text);

    void ShowMaching_(const QStringList& texts);

    void on_btn_ent_clicked();

    void on_btn_sw_clicked();

    void on_btn_bs_clicked();

    void on_btn_space_clicked();

    void on_nextGroup_clicked();

    void on_upGroup_clicked();

    void OnCnButtonClicked();

    void on_btn_cancel_clicked();

private:
    bool IsChEn_() const;
    void openSoftPanelImpl(int editPosx, int editPosy, int editW, int editH, double min, double max, int decimal ,bool isNumberOnly = true, bool checkRange = false);

private:
    Ui::ICVirtualKeyboard *ui;
    QWidget *lastFocusedWidget;
    QSignalMapper signalMapper;
    QString preeditString_;
    int screenWidth_;
    int screenHeight_;
    QDoubleValidator validator_;
    AddrRangeGetter rangeGetter_;
};

#endif // ICVIRTUALKEYBOARD_H
