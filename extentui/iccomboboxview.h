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
    QStringList items() const;
    void setItems(const QStringList &items);
    Q_INVOKABLE QString currentText() const;
    Q_INVOKABLE QString text(int index) const;
    Q_INVOKABLE int currentIndex() const;
    Q_INVOKABLE void setCurrentIndex(int index);
    Q_INVOKABLE int openView(int editorX, int editorY, int editorW, int editorH,
                              const QStringList& items, int currentIndex);
    void setEditorWidth(double ewidth)
    {
        editorWidth_ = ewidth;
        if(width() < editorWidth_)
            resize(editorWidth_, height());
    }


protected:

private slots:
    void on_listView_clicked(const QModelIndex &index);

signals:
    void currentIndexChanged(int index);

private:
    QStringListModel model_;
    Ui::ICComboBoxView *ui;
    int currentIndex_;
    double editorWidth_;
    int screenWidth_;
    int screenHeight_;
    ICComboboxItemDelegate* itemDelegate_;
};

#endif // ICCOMBOBOXVIEW_H
