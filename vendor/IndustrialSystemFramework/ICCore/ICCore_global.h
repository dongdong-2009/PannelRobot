#ifndef ICCORE_GLOBAL_H
#define ICCORE_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(ICCORE_LIBRARY)
#  define ICCORESHARED_EXPORT Q_DECL_EXPORT
#else
#ifndef Q_OS_WIN32
#  define ICCORESHARED_EXPORT Q_DECL_IMPORT
#else
#  define ICCORESHARED_EXPORT
#endif
#endif

#endif // ICCORE_GLOBAL_H
