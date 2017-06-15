#ifndef ICDXFEDITOR_H
#define ICDXFEDITOR_H

#include <QGraphicsScene>
#include <QPolygonF>
#include <QAbstractGraphicsShapeItem>
#include "dl_creationadapter.h"

class ICDxfEditor : public DL_CreationAdapter
{
public:
    explicit ICDxfEditor();
    ~ICDxfEditor();

    virtual void addLayer(const DL_LayerData& data);
    virtual void addBlock(const DL_BlockData&);
    virtual void endBlock();
    virtual void addInsert(const DL_InsertData&);
    virtual void addCircle(const DL_CircleData& data);

    void drawBlock(const DL_InsertData &data);
    void classifyItem(DL_CircleData item);

    void printAttributes();
    QString pos_m(){
        QString str;
        str.append("[");
        for(int i = 0;i < absItems_.length();i++){
            str.append("{\"m0\":\"");
            str.append(QString::number(absItems_.at(i).cx,'f',3));
            str.append("\",\"m1\":\"");
            str.append(QString::number(absItems_.at(i).cy,'f',3));
            str.append("\",\"m2\":\"");
            str.append(QString::number(absItems_.at(i).cz,'f',3));
            str.append("\",\"m3\":\"");
            str.append("0");
            str.append("\",\"m4\":\"");
            str.append(QString::number(absItems_.at(i).radius,'g',3));
            str.append("\",\"m5\":\"");
            str.append("0");
            if(i == absItems_.length()-1)
                str.append("\"}");
            else
                str.append("\"},");
        }
        str.append("]");
        return str;
    }
private:
    bool startPolyLine_;
    QPolygonF polyLine_;
    int polyLineNum_;
    QString defaultDir_;
    const QColor penColor = Qt::white;

    bool beginBlcok_;
    QMap<QString, QList<DL_CircleData> > blocks_;
    QList<DL_CircleData> absItems_;
    QString currentBlockName_,cInsertName;
};

#endif // ICDXFEDITOR_H
