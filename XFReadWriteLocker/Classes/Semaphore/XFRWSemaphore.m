//
//  XFRWSemaphore.m
//  XFReadWriteLocker
//
//  Created by Aron.li on 2020/11/13.
//

#import "XFRWSemaphore.h"
#include <semaphore.h>

@interface XFRWSemaphore () {
    sem_t _xf_r_sem;
    sem_t _xf_w_sem;
}

@property (nonatomic, assign) int xf_read_count;

@end

@implementation XFRWSemaphore

- (instancetype)init {
    if (self = [super init]) {
        sem_init(&_xf_r_sem, 0, 1);     //初始化 读信号量
        sem_init(&_xf_w_sem, 0, 1);     //初始化 写信号量
        self.xf_read_count = 0;
    }
    return self;
}

- (void)writeLockWithTaskBlock:(dispatch_block_t)block {
    sem_wait(&_xf_w_sem);
    if (block) {
        block();
    }
    sem_post(&_xf_w_sem);
}

- (void)readLockWithTaskBlock:(dispatch_block_t)block {
    sem_wait(&_xf_r_sem);
    if(self.xf_read_count == 0)
         sem_wait(&_xf_w_sem);
    self.xf_read_count++;
    sem_post(&_xf_r_sem);
    if (block) {
        block();
    }
    sem_wait(&_xf_r_sem);
    self.xf_read_count--;
    if(self.xf_read_count == 0)
         sem_post(&_xf_w_sem);
    sem_post(&_xf_r_sem);
}

@end
