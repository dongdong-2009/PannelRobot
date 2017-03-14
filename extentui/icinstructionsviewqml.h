#ifndef ICINSTRUCTIONSVIEWQML_H
#define ICINSTRUCTIONSVIEWQML_H

#include <QGraphicsProxyWidget>
#include "icinstructionsview.h"

class ICInstructionsViewQML: public QGraphicsProxyWidget
{
    Q_OBJECT
public:
    ICInstructionsViewQML(QGraphicsItem * parent = 0);

private:
    ICInstructionsView* view_;
};

#endif // ICINSTRUCTIONSVIEWQML_H
