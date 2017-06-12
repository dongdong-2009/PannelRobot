#ifndef ICDXFEDITOR_H
#define ICDXFEDITOR_H

#include <QWidget>
#include <QGraphicsScene>
#include <QPolygonF>
#include <QAbstractGraphicsShapeItem>
#include "dl_creationadapter.h"


namespace Ui {
class ICDxfEditor;
}

class ICDxfEditor : public QWidget, public DL_CreationAdapter
{
    Q_OBJECT

public:
    explicit ICDxfEditor(QWidget *parent = 0);
    ~ICDxfEditor();

    void setDefaultOpenDir(const QString& dir) { defaultDir_ = dir;}

    virtual void addLayer(const DL_LayerData& data);
    virtual void addBlock(const DL_BlockData&);
    virtual void endBlock();
    virtual void addInsert(const DL_InsertData&);
    virtual void addCircle(const DL_CircleData& data);

    void drawBlock(const DL_InsertData &data);
    void classifyItem(QGraphicsItem* item);

    void init();

    void printAttributes();

protected:
    void changeEvent(QEvent *e);

private slots:
    void on_openBtn_clicked();

    void on_zoomIn_clicked();

    void on_zoomOut_clicked();

private:
    Ui::ICDxfEditor *ui;
    bool startPolyLine_;
    QPolygonF polyLine_;
    int polyLineNum_;
    QString defaultDir_;
    QGraphicsScene* scene_;
    const QColor penColor = Qt::white;

    bool beginBlcok_;
    QMap<QString, QList<QGraphicsItem*> > blocks_;
    QList<QGraphicsItem*> absItems_;
    QString currentBlockName_;
};

#endif // ICDXFEDITOR_H
