#ifndef ICCOMBOBOXNATIVE_H
#define ICCOMBOBOXNATIVE_H

#include <QGraphicsWidget>
#include <QDebug>
#include <QStaticText>
#include "iccomboboxview.h"

class ICComboBoxNative : public QGraphicsWidget
{
    Q_OBJECT
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(QStringList items READ items WRITE setItems NOTIFY itemsChanged)
public:
    ICComboBoxNative(QGraphicsItem * parent = 0);
    Q_INVOKABLE QString currentText() const { return view_->currentText();}
    Q_INVOKABLE QString text(int index) const { return "";}
    Q_INVOKABLE void setItemVisible(int index, bool vi);
    QStringList items() const
    {
        QStringList ret;
        return ret;
    }
    Q_INVOKABLE void setItems(const QStringList& items)
    {
        view_->setItems(items);
        emit itemsChanged(items);
    }

    int currentIndex() const { return view_->currentIndex();}
    void setCurrentIndex(int index)
    {
        if(view_->currentIndex() != index)
        {
            view_->setCurrentIndex(index);
            emit currentIndexChanged(index);
        }
    }

protected:
    void mousePressEvent(QGraphicsSceneMouseEvent *e);
    void paint ( QPainter * painter, const QStyleOptionGraphicsItem * option, QWidget * widget );
signals:
    void currentIndexChanged(int index);
    void itemsChanged(const QStringList& items);

private slots:


private:
    QStaticText downPic_;
    ICComboBoxView* view_;
};

#endif // ICCOMBOBOXNATIVE_H
