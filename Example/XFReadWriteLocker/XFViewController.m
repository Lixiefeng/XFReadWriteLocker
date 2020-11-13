//
//  XFViewController.m
//  XFReadWriteLocker
//
//  Created by Aron1987@126.com on 11/13/2020.
//  Copyright (c) 2020 Aron1987@126.com. All rights reserved.
//

#import "XFViewController.h"
#import <XFReadWriteLocker.h>

@interface XFViewController ()

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) XFRWDispatch *dispatchLocker;
@property (nonatomic, strong) XFRWCondition *conditionLocker;
@property (nonatomic, strong) XFRWMutex *mutexLocker;
@property (nonatomic, strong) XFRWSemaphore *semLocker;
@property (nonatomic, strong) XFRWPthread *pThreadLocker;

@end

@implementation XFViewController
@synthesize text = _text;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initReadWriteLockers];
    
    [self run];
}

- (void)initReadWriteLockers {
    self.dispatchLocker = [[XFRWDispatch alloc] init];
    self.conditionLocker = [[XFRWCondition alloc] init];
    self.mutexLocker = [[XFRWMutex alloc] init];
    self.semLocker = [[XFRWSemaphore alloc] init];
    self.pThreadLocker = [[XFRWPthread alloc] init];
}

- (void)run {
    // 测试代码,模拟多线程情况下的读写
    for (int i = 0; i < 50; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            self.text = [NSString stringWithFormat:@"=-=-=-%d",i];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSLog(@"读 %@ %@", [self text], [NSThread currentThread]);
        });
    }
}

#pragma mark - GCD模式读写锁

//- (void)setText:(NSString *)text {
//    __weak typeof(self) weakSelf = self;
//    [self.dispatchLocker writeLockWithTaskBlock:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf->_text = text;
//        NSLog(@"写操作 %@ %@",text,[NSThread currentThread]);
//        // 模拟耗时操作,1个1个执行,没有并发
//        sleep(1);
//    }];
//}
//
//- (NSString *)text {
//    __block NSString *t = nil;
//    __weak typeof(self) weakSelf = self;
//    [self.dispatchLocker readLockWithTaskBlock:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            t = strongSelf->_text;
//            // 模拟耗时操作,瞬间执行完,说明是多个线程并发的进入的
//            sleep(1);
//    }];
//    return t;
//}

#pragma mark - 条件变量模式读写锁
//
//- (void)setText:(NSString *)text {
//    __weak typeof(self) weakSelf = self;
//    [self.conditionLocker writeLockWithTaskBlock:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf->_text = text;
//        NSLog(@"写操作 %@ %@",text,[NSThread currentThread]);
//        // 模拟耗时操作,1个1个执行,没有并发
//        sleep(1);
//    }];
//}
//
//- (NSString *)text {
//    __block NSString *t = nil;
//    __weak typeof(self) weakSelf = self;
//    [self.conditionLocker readLockWithTaskBlock:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        t = strongSelf->_text;
//        // 模拟耗时操作,瞬间执行完,说明是多个线程并发的进入的
//        sleep(1);
//    }];
//    return t;
//}

#pragma mark - 互斥量模式读写锁
//
//- (void)setText:(NSString *)text {
//    __weak typeof(self) weakSelf = self;
//    [self.mutexLocker writeLockWithTaskBlock:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf->_text = text;
//        NSLog(@"写操作 %@ %@",text,[NSThread currentThread]);
//        // 模拟耗时操作,1个1个执行,没有并发
//        sleep(1);
//    }];
//}
//
//- (NSString *)text {
//    __block NSString *t = nil;
//    __weak typeof(self) weakSelf = self;
//    [self.mutexLocker readLockWithTaskBlock:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        t = strongSelf->_text;
//        // 模拟耗时操作,瞬间执行完,说明是多个线程并发的进入的
//        sleep(1);
//    }];
//    return t;
//}

#pragma mark - PThread模式读写锁

//- (void)setText:(NSString *)text {
//    __weak typeof(self) weakSelf = self;
//    [self.pThreadLocker writeLockWithTaskBlock:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf->_text = text;
//        NSLog(@"写操作 %@ %@",text,[NSThread currentThread]);
//        // 模拟耗时操作,1个1个执行,没有并发
//        sleep(1);
//    }];
//}
//
//- (NSString *)text {
//    __block NSString *t = nil;
//    __weak typeof(self) weakSelf = self;
//    [self.pThreadLocker readLockWithTaskBlock:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        t = strongSelf->_text;
//        // 模拟耗时操作,瞬间执行完,说明是多个线程并发的进入的
//        sleep(1);
//    }];
//    return t;
//}

#pragma mark - 信号量模式读写锁

- (void)setText:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    [self.semLocker writeLockWithTaskBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_text = text;
        NSLog(@"写操作 %@ %@",text,[NSThread currentThread]);
        // 模拟耗时操作
        sleep(1);
    }];
}

- (NSString *)text {
    __block NSString *t = nil;
    __weak typeof(self) weakSelf = self;
    [self.semLocker readLockWithTaskBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        t = strongSelf->_text;
        // 模拟耗时操作
        sleep(1);
    }];
    return t;
}

@end
