#ifndef ICCOMBOBOXITEMDELEGATE_H
#define ICCOMBOBOXITEMDELEGATE_H

#include <QStyledItemDelegate>

class ICComboboxItemDelegate : public QStyledItemDelegate
{
    Q_OBJECT
public:
    ICComboboxItemDelegate( QObject * parent = 0);
    QSize sizeHint(const QStyleOptionViewItem &option, const QModelIndex &index) const
    {
        return QSize(100, 24);
    }
};

#endif // ICCOMBOBOXITEMDELEGATE_H
