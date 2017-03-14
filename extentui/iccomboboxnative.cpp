#include "iccomboboxnative.h"
#include <QPainter>

ICComboBoxNative::ICComboBoxNative(QGraphicsItem *parent)
    :QGraphicsWidget(parent),
    downPic_(QString::fromUtf8("▼"))

{

    view_ = new ICComboBoxView();
    view_->hide();
    resize(100, 24);

}


void ICComboBoxNative::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option);
    Q_UNUSED(widget);
    painter->setPen(Qt::black);
    painter->setBrush(Qt::white);
    painter->drawRect(rect());
    painter->drawStaticText(rect().width() - downPic_.size().width() - 2,
                            (rect().height() - downPic_.size().height()) / 2,
                            downPic_);
    if(currentIndex() >= 0)
        painter->drawText(rect().adjusted(4, 0, 0, 0), Qt::AlignVCenter, currentText());
}

void ICComboBoxNative::mousePressEvent(QGraphicsSceneMouseEvent * e)
{
    Q_UNUSED(e);
    view_->exec();
    update(rect());
}

void ICComboBoxNative::setItemVisible(int index, bool vi)
{
}

