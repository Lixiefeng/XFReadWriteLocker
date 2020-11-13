#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XFRWCondition.h"
#import "XFRWDispatch.h"
#import "XFRWMutex.h"
#import "XFRWPthread.h"
#import "XFRWSemaphore.h"
#import "XFReadWriteLocker.h"
#import "XFReadWriteLockerProtocol.h"

FOUNDATION_EXPORT double XFReadWriteLockerVersionNumber;
FOUNDATION_EXPORT const unsigned char XFReadWriteLockerVersionString[];

