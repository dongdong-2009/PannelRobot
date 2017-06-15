#include "icdxfeditor.h"
#include <QDebug>
#include "qgraphicsarcitem.h"
#include "dl_dxf.h"


ICDxfEditor::ICDxfEditor()
{
    beginBlcok_ = false;
    startPolyLine_ = false;
    beginBlcok_ = false;
    absItems_.clear();
    blocks_.clear();
}

ICDxfEditor::~ICDxfEditor()
{
}

void ICDxfEditor::printAttributes()
{
    printf("  Attributes: Layer: %s, ", attributes.getLayer().c_str());
    printf(" Color: ");
    if (attributes.getColor()==256)	{
        printf("BYLAYER");
    } else if (attributes.getColor()==0) {
        printf("BYBLOCK");
    } else {
        printf("%d", attributes.getColor());
    }
    printf(" Width: ");
    if (attributes.getWidth()==-1) {
        printf("BYLAYER");
    } else if (attributes.getWidth()==-2) {
        printf("BYBLOCK");
    } else if (attributes.getWidth()==-3) {
        printf("DEFAULT");
    } else {
        printf("%d", attributes.getWidth());
    }
    printf(" Type: %s\n", attributes.getLinetype().c_str());
}

void ICDxfEditor::drawBlock(const DL_InsertData &data)
{
    QString name = QString::fromStdString(data.name);

    if(blocks_.contains(name))
    {
        for(int i = 0;i < blocks_[name].length();i++){
            DL_CircleData myData = blocks_[name].at(i);
            myData.cx += data.ipx;
            myData.cy += data.ipy;
            myData.cz += data.ipz;
            absItems_.append(myData);
        }
    }
//    if(blocks_.contains(name))
//    {
//        QList<QGraphicsItem*> items = blocks_.value(name);
//        for(int i = 0; i < items.size(); ++i)
//        {
//            items[i]->moveBy(data.ipx, data.ipy);
//            items[i]->rotate(data.angle);
//            items[i]->scale(data.sx, data.sy);
//            scene_->addItem(items[i]);
//        }
//    }
}

void ICDxfEditor::classifyItem(DL_CircleData item)
{
    if(beginBlcok_)
        blocks_[currentBlockName_].append(item);
    else
    {
        absItems_.append(item);
    }
}


void ICDxfEditor::addLayer(const DL_LayerData& data) {
    printf("LAYER: %s flags: %d\n", data.name.c_str(), data.flags);

//    scene_->setBackgroundBrush(QBrush(QColor::fromRgb(attributes.getColor(), attributes.getColor(), attributes.getColor())));
}

void ICDxfEditor::addBlock(const DL_BlockData & data)
{
    printf("Block: %s flags: %d %6.3f %6.3f\n", data.name.c_str(), data.flags,data.bpx, data.bpy);
    beginBlcok_ = true;
    currentBlockName_ = QString::fromStdString(data.name);
}

void ICDxfEditor::endBlock()
{
    beginBlcok_ = false;
    printf("End Block\n");
}

void ICDxfEditor::addInsert(const DL_InsertData &data)
{
//    printf("Insert %s\n", data.name.c_str());
//    qDebug()<<data.name.c_str();
    drawBlock(data);
}

/**
 * Sample implementation of the method which handles circle entities.
 */
void ICDxfEditor::addCircle(const DL_CircleData& data) {
    printf("CIRCLE   (%6.3f, %6.3f, %6.3f) %6.3f\n",
           data.cx, data.cy, data.cz,
           data.radius);
    DL_CircleData myData = data;
    myData.radius = attributes.getColor();
    if(myData.radius == 1 || myData.radius == 3 || myData.radius == 5)//<RGB
        classifyItem(myData);
}
