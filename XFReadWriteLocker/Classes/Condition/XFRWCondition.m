//
//  XFRWCondition.m
//  XFReadWriteLocker
//
//  Created by Aron.li on 2020/11/13.
//

#import "XFRWCondition.h"
#import <pthread.h>


@interface XFRWCondition () {
    pthread_mutex_t _xf_mutex;
    pthread_cond_t _xf_cond;
}

@property (nonatomic, assign) int xf_write_count;
@property (nonatomic, assign) int xf_read_count;

@end

@implementation XFRWCondition

- (instancetype)init {
    if (self = [super init]) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init (&attr);
        pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init (&_xf_mutex, &attr);
        pthread_mutexattr_destroy (&attr);
        
        pthread_condattr_t condAttr;
        pthread_condattr_init(&condAttr);
        pthread_condattr_setpshared(&condAttr, 0);
        pthread_cond_init(&_xf_cond, &condAttr);
        pthread_condattr_destroy(&condAttr);
        
        self.xf_write_count = 0;
        self.xf_read_count = 0;
    }
    
    return self;
}

- (void)writeLockWithTaskBlock:(dispatch_block_t)block {
    pthread_mutex_lock(&_xf_mutex); //加锁
    while(self.xf_write_count != 0 || self.xf_read_count > 0)
    {
         pthread_cond_wait(&_xf_cond, &_xf_mutex);  //等待条件变量的成立
    }
    self.xf_write_count = 1;
    pthread_mutex_unlock(&_xf_mutex);
    if (block) {
        block();
    }
    pthread_mutex_lock(&_xf_mutex);
    self.xf_write_count = 0;
    pthread_cond_broadcast(&_xf_cond);  //唤醒其他因条件变量而产生的阻塞
    pthread_mutex_unlock(&_xf_mutex);   //解锁
}

- (void)readLockWithTaskBlock:(dispatch_block_t)block {
    pthread_mutex_lock(&_xf_mutex);
    while(self.xf_write_count != 0)
    {
         pthread_cond_wait(&_xf_cond, &_xf_mutex);  //等待条件变量的成立
    }
    self.xf_read_count++;
    pthread_mutex_unlock(&_xf_mutex);
    if (block) {
        block();
    }
    pthread_mutex_lock(&_xf_mutex);
    self.xf_read_count--;
    if(self.xf_read_count == 0)
         pthread_cond_broadcast(&_xf_cond); //唤醒其他因条件变量而产生的阻塞
    pthread_mutex_unlock(&_xf_mutex);       //解锁
}

@end
