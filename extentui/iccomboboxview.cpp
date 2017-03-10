#include "iccomboboxview.h"
#include "ui_iccomboboxview.h"
#include "iccomboboxitemdelegate.h"

ICComboBoxView::ICComboBoxView(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ICComboBoxView)
{
    ui->setupUi(this);
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
    return ui->listView->currentIndex().row();
}

QString ICComboBoxView::currentText() const
{
    const QModelIndex i = ui->listView->currentIndex();
    if(i.isValid())
        return model_.data(i, Qt::DisplayRole).toString();
    return "";
}

void ICComboBoxView::setCurrentIndex(int index)
{
    ui->listView->setCurrentIndex(model_.index(index, 0));
}


void ICComboBoxView::on_listView_clicked(const QModelIndex &index)
{
    ui->listView->setCurrentIndex(index);
    hide();
}
