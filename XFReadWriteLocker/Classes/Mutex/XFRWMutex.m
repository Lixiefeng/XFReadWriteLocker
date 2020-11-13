//
//  XFRWMutex.m
//  XFReadWriteLocker
//
//  Created by Aron.li on 2020/11/13.
//

#import "XFRWMutex.h"
#import <pthread.h>

@interface XFRWMutex () {
    pthread_mutex_t _xf_r_mutex;    // 读锁
    pthread_mutex_t _xf_w_mutex;    // 写锁
}

@property (nonatomic, assign) int xf_read_count;

@end

@implementation XFRWMutex

- (instancetype)init {
    if (self = [super init]) {
//        pthread_mutexattr_t attr;
//        pthread_mutexattr_init (&attr);
//        pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE);
//        pthread_mutex_init (&_xf_r_mutex, &attr);
//        pthread_mutexattr_destroy (&attr);
//
//        pthread_mutexattr_t attr1;
//        pthread_mutexattr_init (&attr1);
//        pthread_mutexattr_settype (&attr1, PTHREAD_MUTEX_RECURSIVE);
//        pthread_mutex_init (&_xf_w_mutex, &attr1);
//        pthread_mutexattr_destroy (&attr1);
        
        pthread_mutex_init(&_xf_r_mutex, NULL);
        pthread_mutex_init(&_xf_w_mutex, NULL);

        self.xf_read_count = 0;
    }
    
    return self;
}

- (void)writeLockWithTaskBlock:(dispatch_block_t)block {
    pthread_mutex_lock(&_xf_w_mutex);
    if (block) {
        block();
    }
    pthread_mutex_unlock(&_xf_w_mutex);
}

- (void)readLockWithTaskBlock:(dispatch_block_t)block {
    pthread_mutex_lock(&_xf_r_mutex);
    if(self.xf_read_count == 0)
         pthread_mutex_lock(&_xf_w_mutex);
    self.xf_read_count++;
    pthread_mutex_unlock(&_xf_r_mutex);
   
    if (block) {
        block();
    }
   
    pthread_mutex_lock(&_xf_r_mutex);
    self.xf_read_count--;
    if(self.xf_read_count == 0)
         pthread_mutex_unlock(&_xf_w_mutex);
    pthread_mutex_unlock(&_xf_r_mutex);
}


@end
