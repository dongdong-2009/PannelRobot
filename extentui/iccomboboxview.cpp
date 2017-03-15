#include "iccomboboxview.h"
#include "ui_iccomboboxview.h"
#ifdef Q_WS_QWS
#include <QScreen>
#endif
#include <QDesktopWidget>
#include <QDebug>

ICComboBoxView::ICComboBoxView(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ICComboBoxView)
{
    ui->setupUi(this);
#ifdef Q_WS_QWS
    QScreen* screen = QScreen::instance();
    screenWidth_ = screen->width();
    screenHeight_ = screen->height();
#else
    screenWidth_ = 800;
    screenHeight_ = 600;
#endif

    setWindowFlags(Qt::FramelessWindowHint);

//    ui->listView->grabGesture(Qt::SwipeGesture);
//    ui->listView->installEventFilter(this);
}

ICComboBoxView::~ICComboBoxView()
{
    delete ui;
}

bool ICComboBoxView::eventFilter(QObject *o, QEvent *e)
{
    if(o == ui->listView)
    {
        e->accept();
        return true;
    }
    return QDialog::eventFilter(o, e);
}

QStringList ICComboBoxView::items() const
{
    QStringList ret;
    for(int i = 0; i < ui->listView->count(); ++i)
    {
        ret.append(ui->listView->item(i)->text());
    }
    return ret;
}

void ICComboBoxView::setItems(const QStringList &items, const QStringList& hideIndexs)
{
    int mW= 0;
    QFontMetrics fm = fontMetrics();
    QRect rec;
    ui->listView->clear();
    for(int i = 0; i < items.size(); ++i)
    {
        rec = fm.boundingRect(items.at(i));
        mW = qMax(mW, rec.width());
        ui->listView->addItem(new ICComboViewItem(items.at(i)));
        if(hideIndexs.contains(QString::number(i)))
        {
            ui->listView->setRowHidden(i, true);
        }
    }

    resize(qMax(mW * 1.2, editorWidth_) + 1,  qMin(screenHeight_ - 20,  (items.size() - hideIndexs.size()) * (ui->listView->spacing() + 32) + 5));

//    ui->listWidget->clear();
//    ui->listWidget->addItems(items);
}

int ICComboBoxView::currentIndex() const
{
    return ui->listView->currentRow();
}

QString ICComboBoxView::currentText() const
{
    return ui->listView->currentItem()->text();
}

QString ICComboBoxView::text(int index) const
{
    QListWidgetItem* item = ui->listView->item(index);
    return item == NULL ? "" : item->text();
}

void ICComboBoxView::setCurrentIndex(int index)
{
    if(ui->listView->currentRow() != index)
    {
        ui->listView->setCurrentRow(index, QItemSelectionModel::SelectCurrent);
        emit currentIndexChanged(index);
    }
}



int ICComboBoxView::openView(int editorX, int editorY, int editorW, int editorH, const QStringList &items, int currentIndex, const QStringList& hideIndexs)
{
    setEditorWidth(editorW);
    setItems(items, hideIndexs);
    setCurrentIndex(currentIndex);
//    QPoint topLeft(editorX, editorY);
    QPoint toMove;
    if(editorX + this->width() <= screenWidth_)
    {
        toMove.setX(editorX);
    }
    else if(int newX = (editorX - (this->width() - editorW)) >= 0)
    {
        toMove.setX(newX);
    }
    else
    {
        toMove.setX(0);
    }

    int newY =  editorY + editorH;
    if(newY + this->height() <= screenHeight_)
    {
        toMove.setY(newY);
    }
    else if((newY = editorY - this->height()) >= 0)
    {
        toMove.setY(newY);
    }
    else
    {
        toMove.setY(10);
    }
//    QWidget* root = qApp->desktop()->screen();
//    qDebug()<<root->mapToGlobal(root->pos());
    this->move(toMove);
    this->setCurrentIndex(currentIndex);
//    ui->listView->selectionModel()->select(ui->listView->currentIndex(), QItemSelectionModel::Select | QItemSelectionModel::Current);
    this->exec();
    return this->currentIndex();
}

void ICComboBoxView::on_listView_itemClicked(QListWidgetItem *item)
{
    this->accept();
}
