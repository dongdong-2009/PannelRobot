#ifndef ICINSTRUCTIONSVIEW_H
#define ICINSTRUCTIONSVIEW_H

#include <QWidget>

namespace Ui {
class ICInstructionsView;
}

class ICInstructionsView : public QWidget
{
    Q_OBJECT

public:
    explicit ICInstructionsView(QWidget *parent = 0);
    ~ICInstructionsView();

    void reloadInstructions();
protected:
    void showEvent(QShowEvent *);
private:
    Ui::ICInstructionsView *ui;
};

#endif // ICINSTRUCTIONSVIEW_H
