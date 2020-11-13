//
//  XFRWPthread.m
//  XFReadWriteLocker
//
//  Created by Aron.li on 2020/11/13.
//

#import "XFRWPthread.h"
#include <pthread.h>
/**
 pthread_rwlock_t  rwlock = PTHREAD_RWLOCK_INITIALIZER; //定义和初始化读写锁
  
 写模式：
 pthread_rwlock_wrlock(&rwlock);     //加写锁
 写写写……
 pthread_rwlock_unlock(&rwlock);     //解锁
  
  
  
 读模式：
 pthread_rwlock_rdlock(&rwlock);      //加读锁
 读读读……
 pthread_rwlock_unlock(&rwlock);     //解锁
 */


@interface XFRWPthread () {
    pthread_rwlock_t _xf_rwlock;
}

@end

@implementation XFRWPthread

- (instancetype)init {
    if (self = [super init]) {
        int result = pthread_rwlock_init(&_xf_rwlock, NULL);
//        NSLog(@"=-=-=-pthread_rwlock_init初始化：%@", result == 0 ? @"成功" : @"失败");
    }
    return self;
}

- (void)writeLockWithTaskBlock:(dispatch_block_t)block {
    int lock = pthread_rwlock_wrlock(&_xf_rwlock);
    if (lock != 0) {
        return;
    }
    if (block) {
        block();
    }
    pthread_rwlock_unlock(&_xf_rwlock);
}

- (void)readLockWithTaskBlock:(dispatch_block_t)block {
    int lock = pthread_rwlock_rdlock(&_xf_rwlock);
    if (lock != 0) {
        return;
    }
    if (block) {
        block();
    }
    pthread_rwlock_unlock(&_xf_rwlock);
}

@end
