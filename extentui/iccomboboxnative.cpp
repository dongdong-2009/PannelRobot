#include "iccomboboxnative.h"
#include <QPainter>
#include <QGraphicsSceneMouseEvent>

ICComboBoxNative::ICComboBoxNative(QWidget *parent)
    :QWidget(parent),
    downPic_(QString::fromUtf8("▼"))

{

    view_ = new ICComboBoxView();
    connect(view_, SIGNAL(currentIndexChanged(int)), SIGNAL(currentIndexChanged(int)));
    view_->hide();
//    view_->setEditorWidth(rect().width());
}


void ICComboBoxNative::paintEvent(QPaintEvent *event)
{
    QPainter painter(this);
    painter.setPen(Qt::black);
    painter.setBrush(Qt::white);
    painter.drawRect(rect().adjusted(0,0, -1, -1));
    painter.drawStaticText(rect().width() - downPic_.size().width() - 2,
                            (rect().height() - downPic_.size().height()) / 2,
                            downPic_);
    qDebug()<<currentIndex()<<currentText();
    if(currentIndex() >= 0)
        painter.drawText(rect().adjusted(4, 0, 0, 0), Qt::AlignVCenter, currentText());
    QWidget::paintEvent(event);
}

void ICComboBoxNative::mousePressEvent(QMouseEvent *e)
{
    Q_UNUSED(e);
    int vw = view_->width();
    int vh = view_->height();
    int sw = 800;
    int sh = 600;
    QPointF gPos = mapToGlobal(pos());
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
    e->accept();
//    QPointF toMovePos = mapToScene(toMoveX, toMoveY);
    view_->move(toMoveX, toMoveY);
//    qDebug()<<gPos<<vw<<vh<<sw<<sh<<toMoveX<<toMoveY<<toMovePos;
    view_->exec();

}

void ICComboBoxNative::setItemVisible(int index, bool vi)
{
}
