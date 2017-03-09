#ifndef ICCOMBOBOXVIEW_H
#define ICCOMBOBOXVIEW_H

#include <QDialog>
class QListWidgetItem;

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


protected:
    bool eventFilter(QObject *o, QEvent *e);

private slots:
    void on_listWidget_itemClicked(QListWidgetItem *item);

private:
    Ui::ICComboBoxView *ui;
};

#endif // ICCOMBOBOXVIEW_H
