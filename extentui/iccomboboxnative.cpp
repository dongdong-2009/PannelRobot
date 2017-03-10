#include "iccomboboxnative.h"
#include <QPainter>

ICComboBoxNative::ICComboBoxNative(QGraphicsItem *parent)
    :QGraphicsWidget(parent),
    downPic_(QString::fromUtf8("▼"))

{

    view_ = new ICComboBoxView();
    view_->hide();
    resize(100, 24);
//    view_->setEditorWidth(rect().width());
    connect(this, SIGNAL(widthChanged()),SLOT(onWidthChanged()));

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
    int vw = view_->width();
    int vh = view_->height();
    int sw = 800;
    int sh = 600;
    QPointF gPos = mapToScene(x(), y());
    int toMoveX = 0;
    int toMoveY = 0;
    toMoveX = (gPos.x() + vw <= sw) ? gPos.x() : (gPos.x() - vw - rect().width());
    if(gPos.y() + rect().height() + vh < sh)
    {
        toMoveY = gPos.y() +rect().height();
    }
    else if(gPos.y() - vh >= 0)
    {
        toMoveY = gPos.y() - vh;
    }
    else
        toMoveY = 0;
//    QPointF toMovePos = mapToScene(toMoveX, toMoveY);
    view_->move(toMoveX, toMoveY);
//    qDebug()<<gPos<<vw<<vh<<sw<<sh<<toMoveX<<toMoveY<<toMovePos;
    view_->exec();
    update(rect());
}

void ICComboBoxNative::setItemVisible(int index, bool vi)
{
}

void ICComboBoxNative::onWidthChanged()
{
    view_->setEditorWidth(rect().width());
}
