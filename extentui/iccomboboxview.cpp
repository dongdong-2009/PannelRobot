#include "iccomboboxview.h"
#ifdef Q_WS_QWS
#include <QScreen>
#endif
#include <QEvent>
#include <QMouseEvent>
#include <QScrollBar>
#include <QDebug>

void ICComboBoxListView::mousePressEvent(QMouseEvent *event)
{
    lastPoint_ = event->pos();
    isMoveEn_ = false;
    QListWidget::mousePressEvent(event);
}

void ICComboBoxListView::mouseReleaseEvent(QMouseEvent *event)
{
    if(isMoveEn_)
    {
        event->accept();
        isMoveEn_ = false;
        return;
    }
    return QListWidget::mouseReleaseEvent(event);
}

void ICComboBoxListView::mouseMoveEvent(QMouseEvent *event)
{
    if(event->buttons() == Qt::LeftButton)
    {
        QScrollBar* bar = verticalScrollBar();
        if(bar->maximum() > 0)
        {
            int dy = event->pos().y() -lastPoint_.y();
            if(qAbs(dy) > 16)
                isMoveEn_ = true;
            if(isMoveEn_)
            {
                lastPoint_ = event->pos();
                bar->setSliderPosition(bar->value() - dy);
            }
            event->accept();
            return;
        }
    }
    QListWidget::mouseMoveEvent(event);
}

ICComboBoxView::ICComboBoxView(QWidget *parent) :
    QDialog(parent)
  //    ui(new Ui::ICComboBoxView)
{
    //    ui->setupUi(this);
//    this->setStyleSheet("background:white");
    realFrame_ = new QWidget(this);
    verticalLayout_ = new QVBoxLayout(realFrame_);
    verticalLayout_->setContentsMargins(0, 0, 0, 0);
    listView_ = new ICComboBoxListView(realFrame_);
    listView_->setFocusPolicy(Qt::NoFocus);
    listView_->setFrameShape(QFrame::Box);
    listView_->setFrameShadow(QFrame::Plain);
    listView_->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    listView_->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    listView_->setEditTriggers(QAbstractItemView::NoEditTriggers);
    listView_->setSelectionBehavior(QAbstractItemView::SelectRows);
    listView_->setVerticalScrollMode(QAbstractItemView::ScrollPerPixel);

    verticalLayout_->addWidget(listView_);
    connect(listView_,SIGNAL(itemClicked(QListWidgetItem*)), SLOT(on_listView_itemClicked(QListWidgetItem*)));
#ifdef Q_WS_QWS
    QScreen* screen = QScreen::instance();
    screenWidth_ = screen->width();
    screenHeight_ = screen->height();
#else
    screenWidth_ = 800;
    screenHeight_ = 600;
#endif
    this->resize(screenWidth_, screenHeight_);

    setWindowFlags(Qt::FramelessWindowHint);
    this->move(0, 0);

    //    listView_->grabGesture(Qt::TapGesture);
    //    listView_->grabGesture(Qt::TapAndHoldGesture);
    //    listView_->grabGesture(Qt::PanGesture);
    //    listView_->grabGesture(Qt::PinchGesture);
    //    listView_->grabGesture(Qt::SwipeGesture);

    //    listView_->installEventFilter(this);
}

ICComboBoxView::~ICComboBoxView()
{
    delete listView_;
    delete verticalLayout_;
}

QStringList ICComboBoxView::items() const
{
    QStringList ret;
    for(int i = 0; i < listView_->count(); ++i)
    {
        ret.append(listView_->item(i)->text());
    }
    return ret;
}

void ICComboBoxView::setItems(const QStringList &items, const QStringList& hideIndexs)
{
    int mW= 0;
    QFontMetrics fm = fontMetrics();
    QRect rec;
    listView_->clear();
    for(int i = 0; i < items.size(); ++i)
    {
        rec = fm.boundingRect(items.at(i));
        mW = qMax(mW, rec.width());
        listView_->addItem(new ICComboViewItem(items.at(i)));
        if(hideIndexs.contains(QString::number(i)))
        {
            listView_->setRowHidden(i, true);
        }
    }

    realFrame_->resize(qMax(mW * 1.2, editorWidth_) + 1,  qMin(screenHeight_ - 20,  (items.size() - hideIndexs.size()) * (listView_->spacing() + 32) + 5));

    //    ui->listWidget->clear();
    //    ui->listWidget->addItems(items);
}

int ICComboBoxView::currentIndex() const
{
    return listView_->currentRow();
}

QString ICComboBoxView::currentText() const
{
    return listView_->currentItem()->text();
}

QString ICComboBoxView::text(int index) const
{
    QListWidgetItem* item = listView_->item(index);
    return item == NULL ? "" : item->text();
}

void ICComboBoxView::setCurrentIndex(int index)
{
    if(listView_->currentRow() != index)
    {
        listView_->setCurrentRow(index, QItemSelectionModel::SelectCurrent);
        emit currentIndexChanged(index);
    }
}



int ICComboBoxView::openView(int editorX, int editorY, int editorW, int editorH, const QStringList &items, int currentIndex, const QStringList& hideIndexs)
{
    if(this->isVisible())
    {
        this->accept();
        return currentIndex;
    }
    setEditorWidth(editorW);
    setItems(items, hideIndexs);
    setCurrentIndex(currentIndex);
    //    QPoint topLeft(editorX, editorY);
    QPoint toMove;
    if(editorX + realFrame_->width() <= screenWidth_)
    {
        toMove.setX(editorX);
    }
    else if(int newX = (editorX - (realFrame_->width() - editorW)) >= 0)
    {
        toMove.setX(newX);
    }
    else
    {
        toMove.setX(0);
    }

    int newY =  editorY + editorH;
    if(newY + realFrame_->height() <= screenHeight_)
    {
        toMove.setY(newY);
    }
    else if((newY = editorY - realFrame_->height()) >= 0)
    {
        toMove.setY(newY);
    }
    else
    {
        toMove.setY(10);
    }
    //    QWidget* root = qApp->desktop()->screen();
    //    qDebug()<<root->mapToGlobal(root->pos());
//    qDebug()<<this->geometry();
    realFrame_->move(toMove);
    this->setCurrentIndex(currentIndex);
    //    listView_->selectionModel()->select(listView_->currentIndex(), QItemSelectionModel::Select | QItemSelectionModel::Current);
    this->exec();
    return this->currentIndex();
}

void ICComboBoxView::on_listView_itemClicked(QListWidgetItem *item)
{
    this->accept();
}
