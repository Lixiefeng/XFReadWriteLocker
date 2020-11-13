//
//  XFRWCondition.h
//  XFReadWriteLocker
//
//  Created by Aron.li on 2020/11/13.
//

#import <Foundation/Foundation.h>
#import "XFReadWriteLockerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XFRWCondition : NSObject<XFReadWriteLockerProtocol>

@end

NS_ASSUME_NONNULL_END
