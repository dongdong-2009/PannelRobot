#ifndef ICCOMBOBOXNATIVE_H
#define ICCOMBOBOXNATIVE_H

#include <QGraphicsProxyWidget>
#include <QDebug>
#include <QStaticText>
#include "iccomboboxview.h"

class ICComboBoxNative : public QWidget
{
    Q_OBJECT
//    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
//    Q_PROPERTY(QStringList items READ items WRITE setItems NOTIFY itemsChanged)
public:
    ICComboBoxNative(QWidget * parent = 0);
    QSize sizeHint() const { return QSize(100, 24);}
    QString currentText() const { return view_->currentText();}
    QString text(int index) const { return "";}
    void setItemVisible(int index, bool vi);
    QStringList items() const
    {
        return view_->items();
    }
    void setItems(const QStringList& items)
    {
        view_->setItems(items);
        emit itemsChanged(items);
    }

    int currentIndex() const { return view_->currentIndex();}
    void setCurrentIndex(int index)
    {
        view_->setCurrentIndex(index);
    }
    void setEditorWidth(double ewidth) {view_->setEditorWidth(ewidth);}


protected:
    void mousePressEvent(QMouseEvent *e);
    void paintEvent ( QPaintEvent * event );
signals:
    void currentIndexChanged(int index);
    void itemsChanged(const QStringList& items);

private slots:

private:
    QStaticText downPic_;
    ICComboBoxView* view_;
};

class ICComboBoxQML : public QGraphicsProxyWidget
{
    Q_OBJECT
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(QStringList items READ items WRITE setItems NOTIFY itemsChanged)
public:
    ICComboBoxQML(QGraphicsProxyWidget* parent = 0):
        QGraphicsProxyWidget(parent)
    {
        comboBox_ = new ICComboBoxNative();
        setWidget(comboBox_);
        connect(comboBox_, SIGNAL(currentIndexChanged(int)), SIGNAL(currentIndexChanged(int)));
        connect(comboBox_, SIGNAL(itemsChanged(QStringList)), SIGNAL(itemsChanged(QStringList)));
        connect(this, SIGNAL(widthChanged()), SLOT(onWidthChanged()));

    }
    ~ICComboBoxQML()
    {
        delete comboBox_;
    }

    int currentIndex() const { return comboBox_->currentIndex();}
    void setCurrentIndex(int index) { comboBox_->setCurrentIndex(index);}
    QStringList items() const
    {
        QStringList ret;
        return ret;
    }
    void setItems(const QStringList& items)
    {
        comboBox_->setItems(items);
        emit itemsChanged(items);
    }

    Q_INVOKABLE QString currentText() const { return comboBox_->currentText();}
    Q_INVOKABLE QString text(int index) const { return comboBox_->currentText();}
    Q_INVOKABLE void setItemVisible(int index, bool vi) {comboBox_->setItemVisible(index, vi);}
signals:
    void currentIndexChanged(int index);
    void itemsChanged(const QStringList& items);
private slots:
    void onWidthChanged(){comboBox_->setEditorWidth(rect().width());}
private:
    ICComboBoxNative* comboBox_;
};

#endif // ICCOMBOBOXNATIVE_H
