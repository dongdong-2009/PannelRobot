#include "icinstructionsview.h"
#include "ui_icinstructionsview.h"
#include "qdir.h"
#include <QWebSettings>

ICInstructionsView::ICInstructionsView(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ICInstructionsView)
{

    ui->setupUi(this);
    this->setWindowFlags(Qt::FramelessWindowHint);

}

ICInstructionsView::~ICInstructionsView()
{
    delete ui;
}
void ICInstructionsView::reloadInstructions()
{
    QDir dir("./");
    ui->webView->settings()->setUserStyleSheetUrl(QUrl::fromLocalFile(dir.absoluteFilePath("./webkit.css")));
//    ui->webView->setMaximumWidth(780);
//    ui->webView->setFixedWidth(780);
//    ui->webView->set


    dir.cd("Instructions");
     QStringList ins = dir.entryList(QStringList()<<"*.htm*");
     if(!ins.isEmpty())
     {
         ui->webView->setUrl(QUrl::fromLocalFile(dir.absoluteFilePath(ins.at(0))));
     }
}
void ICInstructionsView::showEvent(QShowEvent *e)
{
    reloadInstructions();
    QWidget::showEvent(e);
}
