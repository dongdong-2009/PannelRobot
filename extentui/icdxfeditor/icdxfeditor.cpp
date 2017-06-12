#include "icdxfeditor.h"
#include "ui_icdxfeditor.h"
#include <QFileDialog>
#include <QDebug>
#include "qgraphicsarcitem.h"
#include "dl_dxf.h"


ICDxfEditor::ICDxfEditor(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ICDxfEditor)
{
    ui->setupUi(this);
    scene_ = new QGraphicsScene(this);
    ui->view->setScene(scene_);
    QTransform tr = ui->view->transform();
    tr.rotate(180, Qt::XAxis);
    ui->view->setTransform(tr);
//    ui->view->rotate(180);
    beginBlcok_ = false;
}

void ICDxfEditor::init()
{
    beginBlcok_ = false;
    startPolyLine_ = false;
    scene_->clear();
    absItems_.clear();
    blocks_.clear();
}

ICDxfEditor::~ICDxfEditor()
{
    delete scene_;
    delete ui;
}

void ICDxfEditor::changeEvent(QEvent *e)
{
    QWidget::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
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

void ICDxfEditor::on_openBtn_clicked()
{
    init();
    QString dxffile = QFileDialog::getOpenFileName(this, tr("Selete DXF File"), defaultDir_, "*.dxf");
    DL_Dxf dxf;
    if (!dxf.in(dxffile.toStdString(), this)) { // if file open failed
        std::cerr << dxffile.toStdString() << " could not be opened.\n";
        return;
    }
}

void ICDxfEditor::on_zoomIn_clicked()
{
//    QTransform tr = ui->view->transform();
//    tr.rotate(10, Qt::XAxis);
//    ui->view->setTransform(tr);
    ui->view->scale(1.1, 1.1);
}

void ICDxfEditor::on_zoomOut_clicked()
{
//    QTransform tr = ui->view->transform();
//    tr.rotate(-10, Qt::XAxis);
//    ui->view->setTransform(tr);
    ui->view->scale(0.9, 0.9);

}

void ICDxfEditor::drawBlock(const DL_InsertData &data)
{
    QString name = QString::fromStdString(data.name);
    if(blocks_.contains(name))
    {
        QList<QGraphicsItem*> items = blocks_.value(name);
        for(int i = 0; i < items.size(); ++i)
        {
            items[i]->moveBy(data.ipx, data.ipy);
            items[i]->rotate(data.angle);
            items[i]->scale(data.sx, data.sy);
            scene_->addItem(items[i]);
        }
    }
}

void ICDxfEditor::classifyItem(QGraphicsItem *item)
{
    if(beginBlcok_)
        blocks_[currentBlockName_].append(item);
    else
    {
        absItems_.append(item);
        scene_->addItem(item);
    }
}


void ICDxfEditor::addLayer(const DL_LayerData& data) {
    printf("LAYER: %s flags: %d\n", data.name.c_str(), data.flags);

    scene_->setBackgroundBrush(QBrush(QColor::fromRgb(attributes.getColor(), attributes.getColor(), attributes.getColor())));
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

    QGraphicsEllipseItem* item = new QGraphicsEllipseItem(data.cx - data.radius, data.cy - data.radius, data.radius * 2, data.radius * 2);
    item->setPen(QPen(penColor, attributes.getWidth()));
    classifyItem(item);

}
