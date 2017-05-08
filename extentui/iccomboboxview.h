#ifndef ICCOMBOBOXVIEW_H
#define ICCOMBOBOXVIEW_H

#include <QDialog>
#include <QListWidgetItem>
#include <QVBoxLayout>
class QListWidgetItem;

namespace Ui {
class ICComboBoxView;
}

class ICComboBoxListView: public QListWidget
{
    Q_OBJECT
public:
    ICComboBoxListView(QWidget * parent = 0):
        QListWidget(parent)
    {
        isMoveEn_ = false;
//        grabGesture(Qt::SwipeGesture);

//       grabGesture(Qt::TapGesture);
//       grabGesture(Qt::TapAndHoldGesture);
//       grabGesture(Qt::PanGesture);
//       grabGesture(Qt::PinchGesture);
//       grabGesture(Qt::SwipeGesture);

    }
protected:
    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

private:
    QPoint lastPoint_;
    bool isMoveEn_;

};

class ICComboViewItem: public QListWidgetItem{
public:
    explicit ICComboViewItem(const QString & text, QListWidget * parent = 0, int type = UserType)
        :QListWidgetItem(text, parent, type)
    {
        setSizeHint(QSize(100, 32));
    }
//    QSize sizeHint() const { return QSize(100,32);}
};

class ICComboBoxView : public QDialog
{
    Q_OBJECT

public:
    explicit ICComboBoxView(QWidget *parent = 0);
    ~ICComboBoxView();
    QStringList items() const;
    void setItems(const QStringList &items, const QStringList &hideIndexs);
    Q_INVOKABLE QString currentText() const;
    Q_INVOKABLE QString text(int index) const;
    Q_INVOKABLE int currentIndex() const;
    Q_INVOKABLE void setCurrentIndex(int index);
    Q_INVOKABLE int openView(int editorX, int editorY, int editorW, int editorH,
                              const QStringList& items, int currentIndex, const QStringList &hideIndexs);
    Q_INVOKABLE bool closeView(){return this->close();}
    void setEditorWidth(double ewidth)
    {
        editorWidth_ = ewidth;
        if(width() < editorWidth_)
            resize(editorWidth_, height());
    }


protected:
    void mouseReleaseEvent(QMouseEvent *);
private slots:
    void on_listView_itemClicked(QListWidgetItem *item);

signals:
    void currentIndexChanged(int index);

private:
    QVBoxLayout *verticalLayout_;
    ICComboBoxListView* listView_;
    QWidget* realFrame_;
    double editorWidth_;
    int screenWidth_;
    int screenHeight_;
};

#endif // ICCOMBOBOXVIEW_H
