#include "icuiselector.h"
#include "ui_icuiselector.h"
#include <QFileDialog>

ICUISelector::ICUISelector(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ICUISelector)
{
    ui->setupUi(this);
}

ICUISelector::~ICUISelector()
{
    delete ui;
}

void ICUISelector::changeEvent(QEvent *e)
{
    QDialog::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

void ICUISelector::OnBrowseClicked()
{
//    QString path = QFileDialog::getOpenFileName(this,)
}
