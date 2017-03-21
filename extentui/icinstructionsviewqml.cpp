#include "icinstructionsviewqml.h"

ICInstructionsViewQML::ICInstructionsViewQML(QGraphicsItem *parent):
    QGraphicsProxyWidget(parent)
{
    view_ = new ICInstructionsView();
    setWidget(view_);
}

