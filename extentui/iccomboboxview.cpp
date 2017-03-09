#include "iccomboboxview.h"
#include "ui_iccomboboxview.h"

ICComboBoxView::ICComboBoxView(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ICComboBoxView)
{
    ui->setupUi(this);
    setWindowFlags(Qt::FramelessWindowHint);
    ui->listWidget->grabGesture(Qt::SwipeGesture);
    ui->listWidget->installEventFilter(this);
}

ICComboBoxView::~ICComboBoxView()
{
    delete ui;
}

bool ICComboBoxView::eventFilter(QObject *o, QEvent *e)
{
    if(e->type() == QEvent::Gesture)
    {
        qDebug("fsfdfs");
        e->accept();
        return true;
    }
    return eventFilter(o, e);
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
    resize(mW,  mH + items.size() * ui->listWidget->spacing());
    ui->listWidget->clear();
    ui->listWidget->addItems(items);
}

int ICComboBoxView::currentIndex() const
{
    return ui->listWidget->currentIndex().row();
}

QString ICComboBoxView::currentText() const
{
    QListWidgetItem* item = ui->listWidget->currentItem();
    if(item == NULL) return "";
    return item->text();
}

void ICComboBoxView::setCurrentIndex(int index)
{
    ui->listWidget->setCurrentItem(ui->listWidget->item(index));
}


void ICComboBoxView::on_listWidget_itemClicked(QListWidgetItem *item)
{
    ui->listWidget->setCurrentItem(item);
    hide();
}
