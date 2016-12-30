#ifndef ICPAINTER_H
#define ICPAINTER_H

#include <QGraphicsWidget>
#include <QPainterPath>
#include <QPainter>
#include <QPointF>
#include <QImage>
#include <QPen>
#include <QBrush>
#include <QColor>
#include <QDebug>
class ICPainter : public QGraphicsWidget
{
    Q_OBJECT
    Q_PROPERTY(int penWidth READ penWidth WRITE setPenWidth)
    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor)
    Q_PROPERTY(bool erasered READ isErasered WRITE setErasered)
public:
    explicit ICPainter(QGraphicsWidget *parent = 0);

public:
    ~ICPainter();
    int penWidth() const { return m_penWidth; }
    void setPenWidth(int width) { m_penWidth = width; }
    QColor penColor() const { return m_brushColor; }
    void setPenColor(QColor color) { m_brushColor = color; }
    bool isErasered() const{ return m_bErasered; }
    void setErasered(bool erasered){ m_bErasered = erasered; }
    Q_INVOKABLE void init();
    Q_INVOKABLE void clear();
    Q_INVOKABLE int pointSize() const { return path_.size();}
    Q_INVOKABLE void setPenEnable(bool en){pen_en = en;}
    Q_INVOKABLE QString converterNow(void);
    void paint(QPainter * painter, const QStyleOptionGraphicsItem * option, QWidget * widget = 0);
protected:
    void mousePressEvent(QGraphicsSceneMouseEvent *event);
    void mouseMoveEvent(QGraphicsSceneMouseEvent *event);
    void mouseReleaseEvent(QGraphicsSceneMouseEvent *event);
private:
    void drawTmpLine();
    void drawBgLine(const QPainterPath &path);
    void drawPenStyle(QPainter *painter);
private:
    QImage m_bgImage;
    QImage m_tempImage;
    QColor m_brushColor;
    QColor m_eraserColor;
    QPointF m_nowPoint;
    QPointF m_lastPoint;
    QPainterPath *m_pDrawPath;
    int m_penWidth;
    bool m_bFlag;
    bool m_bErasered;
    bool pen_en;
    QPointF logLastPoint;
    QList<QPointF> path_;

};

#endif // ICPAINTER_H
