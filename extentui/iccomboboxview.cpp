#include "iccomboboxview.h"
#include "ui_iccomboboxview.h"
#include "iccomboboxitemdelegate.h"
#include <QDebug>

ICComboBoxView::ICComboBoxView(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ICComboBoxView)
{
    ui->setupUi(this);
    currentIndex_ = -1;
    itemDelegate_ = new ICComboboxItemDelegate();
    ui->listView->setItemDelegate(itemDelegate_);

//    ui->listView->setUniformItemSizes(true);
    ui->listView->setModel(&model_);
    setWindowFlags(Qt::FramelessWindowHint);
//    ui->listView->grabGesture(Qt::SwipeGesture);
//    ui->listWidget->installEventFilter(this);
}

ICComboBoxView::~ICComboBoxView()
{
    delete itemDelegate_;
    delete ui;
}

bool ICComboBoxView::eventFilter(QObject *o, QEvent *e)
{
//    if(o == ui->listWidget && e->type() == QEvent::Gesture)
//    {
//        qDebug("fsfdfs");
//        e->accept();
//        return true;
//    }
    return QDialog::eventFilter(o, e);
}

QStringList ICComboBoxView::items() const
{
    QStringList ret;
    const int rc = model_.rowCount();
    for(int i = 0; i < rc; ++i)
    {
        ret.append(text(i));
    }
    return ret;
}

void ICComboBoxView::setItems(const QStringList &items)
{
    int mW= 0, mH = 0;
    QFontMetrics fm = fontMetrics();
    QRect rec;
    for(int i = 0; i < items.size(); ++i)
    {
        rec = fm.boundingRect(items.at(i));
        mW = qMax(mW, rec.width());
        mH += rec.height();
    }

    resize(qMax(mW * 1.2, editorWidth_),  mH * 1.2 + items.size() * ui->listView->spacing());
    model_.setStringList(items);
//    ui->listWidget->clear();
//    ui->listWidget->addItems(items);
}

int ICComboBoxView::currentIndex() const
{
    return currentIndex_;
}

QString ICComboBoxView::currentText() const
{
    const QModelIndex i = ui->listView->currentIndex();
    if(i.isValid())
        return model_.data(i, Qt::DisplayRole).toString();
    return "";
}

QString ICComboBoxView::text(int index) const
{
    const QModelIndex i = model_.index(index, 0);
    if(i.isValid())
        return model_.data(i, Qt::DisplayRole).toString();
    return "";
}

void ICComboBoxView::setCurrentIndex(int index)
{
    if(currentIndex_ != index)
    {
        ui->listView->setCurrentIndex(model_.index(index, 0));
        const QModelIndex i = ui->listView->currentIndex();
        qDebug()<<"fssf"<<i.isValid()<<items();
        currentIndex_ = index;
        emit currentIndexChanged(index);
    }
}


void ICComboBoxView::on_listView_clicked(const QModelIndex &index)
{
    setCurrentIndex(index.row());
    hide();
}
