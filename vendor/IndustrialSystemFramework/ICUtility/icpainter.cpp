#include "icpainter.h"

#include <QGraphicsSceneMouseEvent>

ICPainter::ICPainter(QGraphicsWidget *parent) :
    QGraphicsWidget(parent)  , m_brushColor(QColor(0, 0, 0 ,255)),
    m_eraserColor(QColor(255,255,255,255)),
    m_bFlag(true),
    m_bErasered(false),
    pen_en(false),
    m_pDrawPath(NULL),
    m_pDrawPath_line(NULL),
    m_penWidth(10)
{
    setAcceptedMouseButtons(Qt::LeftButton);
}

ICPainter::~ICPainter()
{
}

void ICPainter::paint(QPainter * painter, const QStyleOptionGraphicsItem * option, QWidget * widget)
{
    if(m_bFlag)
        painter->drawImage(QRectF(0,0,m_bgImage.width(),m_bgImage.height()),m_bgImage);
    else
    {
        painter->drawImage(QRectF(0,0,m_tempImage.width(),m_tempImage.height()),m_tempImage);
        painter->drawImage(QRectF(0,0,m_bgImage.width(),m_bgImage.height()),m_bgImage);
    }
}

void ICPainter::init()
{
    m_bgImage = QImage(this->size().width(),this->size().height(),QImage::Format_ARGB32);
    m_tempImage = QImage(this->size().width(),this->size().height(),QImage::Format_ARGB32);
    m_bgImage.fill(QColor(255,255,255,0));
    m_tempImage.fill(QColor(255,255,255,0));
    update();
}

void ICPainter::clear()
{
    m_bgImage.fill(QColor(255,255,255,0));
    m_tempImage.fill(QColor(255,255,255,0));
    path_.clear();
    update();
}

bool ICPainter::Calculation(void)
{
    return true;
}
void ICPainter::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
    if(pen_en==false)return;
    if(!(event->button() & acceptedMouseButtons()))
    {
        QGraphicsWidget::mousePressEvent(event);
    }
    else
    {
        if(m_pDrawPath == NULL)
        {
            m_pDrawPath = new QPainterPath();
        }
        if(m_pDrawPath_line == NULL)
        {
            m_pDrawPath_line = new QPainterPath();
        }
        m_pDrawPath->moveTo(event->pos());
        m_pDrawPath_line->moveTo(event->pos());
        m_nowPoint = event->pos();
        logLastPoint = m_nowPoint;
        QPointF m=m_nowPoint;
        m.setX(this->size().width()-m_nowPoint.x());
        path_.append(m);
    }
}

void ICPainter::mouseMoveEvent(QGraphicsSceneMouseEvent *event)
{
    m_lastPoint = m_nowPoint;
    m_nowPoint = event->pos();
    QPointF tmpPoint = m_nowPoint - m_lastPoint;
    if(m_pDrawPath == NULL)
    {
        return;
    }
    if(m_pDrawPath_line == NULL)
    {
        return;
    }
    if(m_nowPoint.x()<0||m_nowPoint.x()>this->size().width()||
            m_nowPoint.y()<0||m_nowPoint.y()>this->size().height())return;
    if(qAbs(tmpPoint.x()) > 0 || qAbs(tmpPoint.y()) >0)
    {
        m_pDrawPath_line->lineTo(m_lastPoint.x() , m_lastPoint.y());
        m_pDrawPath->quadTo(m_lastPoint.x() , m_lastPoint.y() ,(m_nowPoint.x() + m_lastPoint.x())*0.5,(m_nowPoint.y() + m_lastPoint.y())*0.5);
        m_bFlag = false;
        if(m_bErasered)
        {
            drawBgLine(*m_pDrawPath);
            drawBgLine(*m_pDrawPath_line);
        }
        else
            drawTmpLine(); // 临时画
    }
    QGraphicsWidget::mouseMoveEvent(event);
}

void ICPainter::mouseReleaseEvent(QGraphicsSceneMouseEvent *event)
{
    if(!(event->button() & acceptedMouseButtons()))
    {
        QGraphicsWidget::mousePressEvent(event);
    }
    else{
        if(m_pDrawPath != NULL)
        {
            m_bFlag = true;
            if(quadTo_en)
            {
                if(quadTo_Color_Change)
                setPenColor(quadTo_Color);
                drawBgLine(*m_pDrawPath);
            }
            if(lineTo_en)
            {
                if(lineTo_Color_Change)
                setPenColor(lineTo_Color);
                drawBgLine(*m_pDrawPath_line);
            }
//            qDebug()<<m_pDrawPath->toFillPolygon()<<m_pDrawPath->toFillPolygon().size();
            delete m_pDrawPath;
            m_pDrawPath = NULL;
            delete m_pDrawPath_line;
            m_pDrawPath_line = NULL;
            path_.append(QPointF(-1, -1));
        }
    }
}

void ICPainter::drawTmpLine()
{
    QPainter painter(&m_tempImage);
    drawPenStyle(&painter);
    painter.drawLine(m_lastPoint,m_nowPoint);
    QPointF m=m_nowPoint;
    m.setX(this->size().width()-m_nowPoint.x());
    path_.append(m);
//    if((m_nowPoint - logLastPoint).manhattanLength() > 5)
//    {
//        logLastPoint = m_nowPoint;
//        qDebug()<<m_nowPoint;
//    }

//    qreal rad = this->size().width()/375.0*170;//点周围范围值
//    qDebug() << "rad:" << rad;
//    QRect rect = QRect(m_nowPoint.x() - 5, m_nowPoint.y() - 5,10,10);
//    qDebug() << "x:" << m_nowPoint.x();
//    qDebug() << "y:" << m_nowPoint.y();
//    update(rect.adjusted(-rad,-rad,+rad,+rad));
    update();
}

void ICPainter::drawBgLine(const QPainterPath &path)
{
    QPainter painter(&m_bgImage);
    drawPenStyle(&painter);
    painter.drawPath(path);
    m_tempImage.fill(QColor(255,255,255,0));
    update();
}

void ICPainter::drawPenStyle(QPainter *painter)
{
    painter->setRenderHint(QPainter::Antialiasing);
    QBrush brush(m_brushColor, Qt::SolidPattern);
    if(m_bErasered)
    {
        painter->setCompositionMode(QPainter::CompositionMode_Clear);
        painter->setPen(QPen(brush, 5*m_penWidth, Qt::SolidLine, Qt::RoundCap,Qt::RoundJoin));
    }
    else
    {
        painter->setCompositionMode(QPainter::CompositionMode_SourceOver);
        painter->setPen(QPen(brush, m_penWidth, Qt::SolidLine, Qt::RoundCap,Qt::RoundJoin));
    }
    painter->setBrush(Qt::NoBrush);
}

QString ICPainter::converterNow(double x,double y,double high)
{
    QString ret = "[";
    double xProportion = x/this->size().width();
    double yProportion = y/this->size().height();
    for(int i=0;i<path_.size();i++)
    {
        if(path_.at(i).x()==-1)
        {
            ret += QString("{\"pointName\":\"%3\", \"pointPos\":{\"m0\":%1,\"m1\":%2,\"m2\":%4,\"m3\":0,\"m4\":0,\"m5\":0}},").arg(path_.at(i-1).x()*xProportion).arg(path_.at(i-1).y()*yProportion).arg(i).arg(high);
            int next=i+1;
            if(next<path_.size())
            {
                ret += QString("{\"pointName\":\"%3\", \"pointPos\":{\"m0\":%1,\"m1\":%2,\"m2\":%4,\"m3\":0,\"m4\":0,\"m5\":0}},").arg(path_.at(next).x()*xProportion).arg(path_.at(next).y()*yProportion).arg(i).arg(high);
            }
        }
        else
        ret += QString("{\"pointName\":\"%3\", \"pointPos\":{\"m0\":%1,\"m1\":%2,\"m2\":0,\"m3\":0,\"m4\":0,\"m5\":0}},").arg(path_.at(i).x()*xProportion).arg(path_.at(i).y()*yProportion).arg(i);
    }
    if(!path_.isEmpty())ret.chop(1);
    ret += ']';
    return ret;
}

