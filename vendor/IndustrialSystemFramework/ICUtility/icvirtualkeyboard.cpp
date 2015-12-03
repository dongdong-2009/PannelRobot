#include "icvirtualkeyboard.h"
#include "ui_icvirtualkeyboard.h"
#include <QDebug>
#include <QScreen>
#include <QFile>
#include <QSqlQuery>
#include <QKeyEvent>
#include <qmath.h>
//#include <QRegExp>

static QRegExp realRe("^[-+]?\\d+(\\.\\d+)?$");
QList<QPushButton*> cnButtons;


ICVirtualKeyboard::ICVirtualKeyboard(AddrRangeGetter rangeGetter, QWidget *parent) :
    rangeGetter_(rangeGetter),
    QWidget(parent),
    ui(new Ui::ICVirtualKeyboard)
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

//    this->setWindowFlags(Qt::Tool | Qt::FramelessWindowHint);
    lastFocusedWidget = NULL;
    QList<QToolButton*> btns = ui->numKeyboard->findChildren<QToolButton*>();
    for(int i = 0; i != btns.size(); ++i)
    {
        signalMapper.setMapping(btns[i],btns[i]);
        connect(btns[i],SIGNAL(clicked()), &signalMapper, SLOT(map()));
    }
    connect(&signalMapper, SIGNAL(mapped(QWidget*)), SLOT(buttonClicked(QWidget*)));
    btns = ui->allKeyboard->findChildren<QToolButton*>();

    for(int i = 0; i != btns.size(); ++i)
    {
        connect(btns.at(i),
                SIGNAL(clicked()),
                &signalMapper,
                SLOT(map()));
        signalMapper.setMapping(btns.at(i), btns.at(i)->text());
    }
    connect(&signalMapper,
            SIGNAL(mapped(QString)),
            SLOT(OnInputButtonClicked(QString)));

    ui->matchContainer->hide();
    cnButtons<<ui->cn_1<<ui->cn_2<<ui->cn_3<<ui->cn_4<<ui->cn_5;
    for(int i = 0; i != cnButtons.size(); ++i)
    {
        connect(cnButtons.at(i),
                SIGNAL(clicked()),
                SLOT(OnCnButtonClicked()));
    }
}

ICVirtualKeyboard::~ICVirtualKeyboard()
{
    delete ui;
}

void ICVirtualKeyboard::changeEvent(QEvent *e)
{
    QWidget::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

 void ICVirtualKeyboard::saveFocusWidget(QWidget * /*oldFocus*/, QWidget *newFocus)
 {
     if (newFocus != 0 && !this->isAncestorOf(newFocus)) {
         lastFocusedWidget = newFocus;
     }
 }



 void ICVirtualKeyboard::buttonClicked(QWidget *w)
 {
     QToolButton* b = qobject_cast<QToolButton*>(w);
     QString curText = b->text();
     if(curText == "Ent"){
         QString toCommit = QString("%1").arg(preeditString_.toDouble(),
                                              0,
                                              'f',
                                              validator_.decimals(),
                                              QLatin1Char('0'));
         emit commit(toCommit);
         preeditString_.clear();
         this->hide();
         return;
     }
     if(curText == "Cancel")
     {
         preeditString_.clear();
//         emit characterGenerated(preeditString_);
         emit reject();
         this->hide();
         return;
     }
     if(curText == "CE")
     {
         preeditString_.clear();
         ui->inputEdit->setText(preeditString_);
         emit characterGenerated(preeditString_);
         return;
     }
     if(curText == "BS")
     {
         preeditString_.chop(1);
         ui->inputEdit->setText(preeditString_);
         emit characterGenerated(preeditString_);
         return;
     }
     if(preeditString_.isEmpty())
     {
         if(curText == ".")
             preeditString_ += "0";
         else if(curText == "+")
             return;
         else if(curText == "-")
         {
             preeditString_ = curText;
             ui->inputEdit->setText(preeditString_);
             emit characterGenerated(preeditString_);
             return;
         }
     }
     else if(curText == "+")
     {
         if(preeditString_.at(0) == '-')
             preeditString_ = preeditString_.mid(1);
         ui->inputEdit->setText(preeditString_);
         emit characterGenerated(preeditString_);
         return;
     }
     else if(curText == "-")
     {
         if(preeditString_.at(0) == '-')
             return;
         preeditString_ = "-" + preeditString_;
         ui->inputEdit->setText(preeditString_);
         emit characterGenerated(preeditString_);
         return;
     }
     int p = 0;
     QString tmp = preeditString_ + curText;
     if(validator_.validate(tmp, p) == QValidator::Acceptable)
     {
         preeditString_ += curText;
         ui->inputEdit->setText(preeditString_);
         emit characterGenerated(preeditString_);
     }
//     if(preeditString_.isEmpty())
//     {
//         if(curText == ".")
//             preeditString_ += "0";
//         else if(curText == "+")
//             return;
//         preeditString_ += curText;
//     }
//     else if(curText == "+")
//     {
//         if(preeditString_.at(0) == '-')
//             preeditString_ = preeditString_.mid(1);
//     }
//     else if(curText == "-")
//     {
//         preeditString_ = "-" + preeditString_;
//     }
//     else if(curText == ".")
//     {
//         if(preeditString_.contains("."))
//             return;
//         preeditString_ += curText;
//     }
//     else if(curText == "0")
//     {
//         QString tmp = preeditString_;
//         tmp += curText;
//         if(realRe.indexIn(tmp) == -1)
//             return;
//         preeditString_ += curText;
//     }
//     else
//         preeditString_ += curText;
//     int p = 0;
//     qDebug()<<validator_.validate(preeditString_, p)<<preeditString_<<validator_.top();
//     ui->inputEdit->setText(preeditString_);
//     emit characterGenerated(preeditString_);
 }

 void ICVirtualKeyboard::openSoftPanel(int editPosx, int editPosy, int editW, int editH, bool isNumberOnly, const QString& configName, bool checkRange)
 {
     ICRange ranges = rangeGetter_(configName);
     openSoftPanelImpl(editPosx, editPosy, editW, editH, ranges.min, ranges.max, ranges.decimal, isNumberOnly, checkRange);
 }

 void ICVirtualKeyboard::openSoftPanel(int editPosx, int editPosy, int editW, int editH, double min, double max, int decimal)
 {
     openSoftPanelImpl(editPosx, editPosy, editW, editH, min, max, decimal, true, true);
 }


 QString currentPy;
 QStringList matchingList;
 int currentMachingGroup = 0;

 QStringList Matching(const QString& py)
 {
     QStringList ret;
     QSqlQuery query;
 //    query.exec(QString("SELECT DISTINCT HanZi FROM tb_zh_CN_gb2312 WHERE PinYin Like '%0%' ORDER BY Freq DESC LIMIT %1, %2")
 //               .arg(py).arg(currentMachingGroup * cnButtons.size()).arg(cnButtons.size()));
     query.exec(QString("SELECT HanZi FROM tb_zh_CN_gb2312 WHERE PinYin Like '%0%' ORDER BY Freq DESC LIMIT %1, %2")
                .arg(py).arg(currentMachingGroup * cnButtons.size()).arg(cnButtons.size()));
     while(query.next())
     {
         ret.append(query.value(0).toString());
     }
     return ret;
 }

 void ICVirtualKeyboard::on_btn_ent_clicked()
 {
     emit commit(ui->inputEdit->text());
     preeditString_.clear();
     this->hide();
 }

 void ICVirtualKeyboard::OnInputButtonClicked(const QString &text)
 {
     QLineEdit *editor_ = ui->inputEdit;
     if(ui->btn_shift->isChecked())
     {
         if(text.at(0).isDigit())
             editor_->insert(text);
         else if(text.size() > 1)
             editor_->insert(text.left(1));
         else
             editor_->insert(text.toUpper());
     }
     else
     {
         if(text.at(0).isDigit())
             editor_->insert(text);
         else if(text.size() > 1)
             editor_->insert(text.right(1));
         else if(IsChEn_())
         {
 //            editor_->insertPlainText(text.toLower());
             currentPy += text;
             ui->pyLabel->setText(currentPy.toLower());
             matchingList =  Matching(currentPy);
             currentMachingGroup = 0;
             if(matchingList.size() > cnButtons.size())
             {
                 ShowMaching_(matchingList.mid(0, cnButtons.size()));
             }
             else
             {
                 ShowMaching_(matchingList);
             }

         }
         else
         {
             editor_->insert(text.toLower());
         }
     }
 }

 bool ICVirtualKeyboard::IsChEn_() const
 {
     return ui->btn_sw->text() == "CH";
 }

 void ICVirtualKeyboard::ShowMaching_(const QStringList &texts)
 {
     int restSize = cnButtons.size() - texts.size();
     for(int i = 0 ; i != texts.size(); ++i)
     {
         cnButtons[i]->setText(texts.at(i));
     }
     for(int i = texts.size(); i < restSize; ++i)
     {
         cnButtons[i]->setText("");
     }
 //    ui->label->setText(texts.join(" "));
 }

 void ICVirtualKeyboard::on_nextGroup_clicked()
 {
 //    int groups = matchingList.size() / cnButtons.size();
 //    groups = matchingList.size() % cnButtons.size() ? groups + 1 : groups;

 //    currentMachingGroup = ++currentMachingGroup % groups;
     ++currentMachingGroup;
     matchingList = Matching(currentPy);
     ShowMaching_(matchingList.mid(0, cnButtons.size()));
 }

 void ICVirtualKeyboard::on_upGroup_clicked()
 {
 //    int groups = matchingList.size() / cnButtons.size();
 //    groups = matchingList.size() % cnButtons.size() ? groups + 1 : groups;

 //    if(currentMachingGroup == 0) currentMachingGroup = groups - 1;
 //    else
 //        currentMachingGroup = --currentMachingGroup % groups;
     if(currentMachingGroup > 0)
     {
         --currentMachingGroup;
     }
     matchingList = Matching(currentPy);
     ShowMaching_(matchingList.mid(0, cnButtons.size()));
 }

 void ICVirtualKeyboard::OnCnButtonClicked()
 {
     QLineEdit *editor_ = ui->inputEdit;
     QPushButton *btn = qobject_cast<QPushButton*>(sender());
     editor_->insert(btn->text());
     QSqlQuery query;
     query.exec(QString("UPDATE tb_zh_CN_gb2312 SET Freq = Freq + 1 WHERE HanZi = '%1' AND PinYin = '%2'")
                .arg(btn->text()).arg(currentPy.toLower()));
     currentPy.clear();
     matchingList.clear();
     ShowMaching_(QStringList());
     currentMachingGroup = 0;
     ui->pyLabel->setText(currentPy);
 }

 void ICVirtualKeyboard::on_btn_sw_clicked()
 {
     if(IsChEn_())
     {
         ui->btn_sw->setText("EN");
         ui->matchContainer->hide();
     }
     else
     {
         ui->btn_sw->setText("CH");
         ui->matchContainer->show();
     }
 }

 void ICVirtualKeyboard::on_btn_bs_clicked()
 {
     if(IsChEn_() && !currentPy.isEmpty())
     {
         currentPy.chop(1);
         if(currentPy.isEmpty())
         {
             matchingList.clear();
         }
         else
             matchingList =  Matching(currentPy);
         ui->pyLabel->setText(currentPy.toLower());
         currentMachingGroup = 0;
         if(matchingList.size() > cnButtons.size())
         {
             ShowMaching_(matchingList.mid(0, cnButtons.size()));
         }
         else
         {
             ShowMaching_(matchingList);
         }
     }
     else
     {
         QKeyEvent *e = new QKeyEvent(QKeyEvent::KeyPress,
                                      Qt::Key_Backspace,
                                      Qt::NoModifier);
         qApp->postEvent(ui->inputEdit, e);
     }
 }

 void ICVirtualKeyboard::on_btn_space_clicked()
 {
     ui->inputEdit->insert(" ");
 }

 void ICVirtualKeyboard::openSoftPanelImpl(int editPosx, int editPosy, int editW, int editH, double min, double max, int decimal, bool isNumberOnly, bool checkRange)
 {
     ui->inputEdit->clear();
     if(isNumberOnly)
     {
         ui->keyboardContainer->setCurrentIndex(0);
         this->resize(404, 356);
//         ui->inputEdit->resize(341, 31);
         ui->tipLabel->show();

     }
     else
     {
         ui->keyboardContainer->setCurrentIndex(1);
         this->resize(788, 398);
         ui->tipLabel->hide();
     }
     if(checkRange)
     {
         validator_.setRange(min,
                             max,
                             decimal);
         ui->tipLabel->setText(QString(tr("Min:%1\nMax:%2\nPrec:%3")).arg(validator_.bottom(),0, 'f',decimal, '0')
                               .arg(validator_.top(),0, 'f', decimal, '0')
                               .arg(1.0 / qPow(10,validator_.decimals())));
     }
     else
     {
         validator_.setRange(0, 0xFFFFFFFFu,0);
     }

     QPoint topLeft(editPosx, editPosy);
     QPoint toMove;
     if(topLeft.x() + this->width() <= screenWidth_)
     {
         toMove.setX(topLeft.x());
     }
     else if(topLeft.x() + editW - this->width() >= 0)
     {
         toMove.setX(topLeft.x() + editW - this->width());
     }
     else
     {
         toMove.setX(screenHeight_/2);
     }
     if(topLeft.y() + 48 + this->height() <= screenHeight_)
     {
         toMove.setY(topLeft.y() + 48);
     }
     else
     {
         toMove.setY(screenHeight_ - this->height() - 48);
     }
     this->move(toMove);
     this->show();
 }
