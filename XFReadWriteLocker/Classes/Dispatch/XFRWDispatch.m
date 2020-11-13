//
//  XFRWDispatch.m
//  XFReadWriteLocker
//
//  Created by Aron.li on 2020/11/13.
//

#import "XFRWDispatch.h"

@interface XFRWDispatch ()

@property (nonatomic, strong) dispatch_queue_t xf_concurrent_queue;

@end

@implementation XFRWDispatch

- (instancetype)init {
    if (self = [super init]) {
        self.xf_concurrent_queue = dispatch_queue_create("xf_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

// 异步，使用dispatch_barrier_(a)sync可保证每次只有一个线程
- (void)writeLockWithTaskBlock:(dispatch_block_t)block {
    dispatch_barrier_async(self.xf_concurrent_queue, block);
}

// 同步并发 读
- (void)readLockWithTaskBlock:(dispatch_block_t)block {
    dispatch_sync(self.xf_concurrent_queue, block);
}

@end
