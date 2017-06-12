#ifndef QGRAPHICSARCITEM_H
#define QGRAPHICSARCITEM_H

#include <QGraphicsEllipseItem>
#include <QPainter>
#include <QDebug>

class QGraphicsArcItem : public QGraphicsEllipseItem
{
public:
    QGraphicsArcItem ( qreal cx, qreal cy, qreal radius, QGraphicsItem * parent = 0 ) :
        QGraphicsEllipseItem(cx - radius, cy - radius, radius * 2, radius * 2, parent) {
        this->cx = cx;
        this->cy = cy;
        this->radius = radius;
    }

private:
    qreal cx;
    qreal cy;
    qreal radius;

protected:
    void paint ( QPainter * painter, const QStyleOptionGraphicsItem * option, QWidget * widget)
    {
        painter->setPen(pen());
        painter->setBrush(brush());
        painter->drawArc(rect(), startAngle(), spanAngle());
//        if (option->state & QStyle::State_Selected)
//            qt_graphicsItem_highlightSelected(this, painter, option);
    }
};

#endif // QGRAPHICSARCITEM_H
