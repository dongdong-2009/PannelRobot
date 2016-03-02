///////////////////////////////////////////////////////////
//  icvirtualhost.cpp
//  Implementation of the Class ICVirtualHost
//  Created on:      27-七月-2011 16:38:16
//  Original author: GaussCheng
///////////////////////////////////////////////////////////

#include <QRunnable>
#include <QThreadPool>
#include <QtCore/qmath.h>

//#include "icutility.h"
#include "icvirtualhost.h"


QMap<uint64_t, ICVirtualHostPtr> ICVirtualHostManager::hostAddrs_;
ICVirtualHost::ICVirtualHost(uint64_t hostId, QObject *parent)
    :QObject(parent),
      hostId_(hostId),
      communicateInterval_(10),
      transceiver_(NULL),
      currentAlarmBitIndex_(0),
      commErrCount_(0)
{
    refreshTimer_.setSingleShot(true);
    connect(&refreshTimer_, SIGNAL(timeout()), this, SLOT(RefreshStatus()));
}

ICVirtualHost::~ICVirtualHost()
{
    refreshTimer_.stop();
    queue_.Clear();
}
