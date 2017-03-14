#include "iccomboboxview.h"
#include "ui_iccomboboxview.h"
#include "iccomboboxitemdelegate.h"
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
    currentIndex_ = -1;
    itemDelegate_ = new ICComboboxItemDelegate();
    ui->listView->setItemDelegate(itemDelegate_);

//    ui->listView->setUniformItemSizes(true);
    ui->listView->setModel(&model_);

    setWindowFlags(Qt::FramelessWindowHint);
//    ui->listView->setStyleSheet("QAbstractItemView::item{\
//                                selection-background-color:#E96436;\
//                            }");

//    ui->listView->grabGesture(Qt::SwipeGesture);
//    ui->listWidget->installEventFilter(this);
}

ICComboBoxView::~ICComboBoxView()
{
    delete itemDelegate_;
    delete ui;
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
    int mW= 0;
    QFontMetrics fm = fontMetrics();
    QRect rec;
    for(int i = 0; i < items.size(); ++i)
    {
        rec = fm.boundingRect(items.at(i));
        mW = qMax(mW, rec.width());
    }

    resize(qMax(mW * 1.2, editorWidth_) + 1,  qMin(screenHeight_ - 20,  items.size() * (ui->listView->spacing() + 32) + 5));
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
    return text(currentIndex());
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
        currentIndex_ = index;
        emit currentIndexChanged(index);
    }
}


void ICComboBoxView::on_listView_clicked(const QModelIndex &index)
{
    setCurrentIndex(index.row());
    accept();
}

int ICComboBoxView::openView(int editorX, int editorY, int editorW, int editorH, const QStringList &items, int currentIndex)
{
    setEditorWidth(editorW);
    setItems(items);
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
        toMove.setY(0);
    }
//    QWidget* root = qApp->desktop()->screen();
//    qDebug()<<root->mapToGlobal(root->pos());
    this->move(toMove);
    this->setCurrentIndex(currentIndex);
//    ui->listView->selectionModel()->select(ui->listView->currentIndex(), QItemSelectionModel::Select | QItemSelectionModel::Current);
    this->exec();
    return currentIndex_;
}
