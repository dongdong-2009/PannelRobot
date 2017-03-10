#ifndef ICCOMBOBOXVIEW_H
#define ICCOMBOBOXVIEW_H

#include <QDialog>
#include <QStringListModel>
class QListWidgetItem;
class ICComboboxItemDelegate;

namespace Ui {
class ICComboBoxView;
}

class ICComboBoxView : public QDialog
{
    Q_OBJECT

public:
    explicit ICComboBoxView(QWidget *parent = 0);
    ~ICComboBoxView();
    void setItems(const QStringList &items);
    QString currentText() const;
    int currentIndex() const;
    void setCurrentIndex(int index);
    void setEditorWidth(double ewidth)
    {
        editorWidth_ = ewidth;
        if(width() < editorWidth_)
            resize(editorWidth_, height());
    }


protected:
    bool eventFilter(QObject *o, QEvent *e);

private slots:
    void on_listView_clicked(const QModelIndex &index);

private:
    QStringListModel model_;
    Ui::ICComboBoxView *ui;
    double editorWidth_;
    ICComboboxItemDelegate* itemDelegate_;
};

#endif // ICCOMBOBOXVIEW_H
