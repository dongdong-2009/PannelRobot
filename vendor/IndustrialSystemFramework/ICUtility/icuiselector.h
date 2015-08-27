#ifndef ICUISELECTOR_H
#define ICUISELECTOR_H

#include <QDialog>

namespace Ui {
class ICUISelector;
}

class ICUISelector : public QDialog
{
    Q_OBJECT

public:
    explicit ICUISelector(QWidget *parent = 0);
    ~ICUISelector();

private slots:
    void OnBrowseClicked();
protected:
    void changeEvent(QEvent *e);

private:
    Ui::ICUISelector *ui;
};

#endif // ICUISELECTOR_H
