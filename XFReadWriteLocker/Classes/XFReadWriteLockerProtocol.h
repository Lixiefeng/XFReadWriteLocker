//
//  XFReadWriteLockerProtocol.h
//  XFReadWriteLocker
//
//  Created by Aron.li on 2020/11/13.
//

#ifndef XFReadWriteLockerProtocol_h
#define XFReadWriteLockerProtocol_h

@protocol XFReadWriteLockerProtocol <NSObject>

- (void)writeLockWithTaskBlock:(dispatch_block_t)block;

- (void)readLockWithTaskBlock:(dispatch_block_t)block;

@end

#endif /* XFReadWriteLockerProtocol_h */
