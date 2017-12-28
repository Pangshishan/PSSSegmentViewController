//
//  PSSWeakProxy.m
//  PSSSegmentVCDemo
//
//  Created by pangshishan on 2017/12/28.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

#import "PSSWeakProxy.h"

@implementation PSSWeakProxy

- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}
+ (instancetype)proxyWithTarget:(id)target{
    return [[self alloc] initWithTarget:target];
}
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [self.target methodSignatureForSelector:aSelector];
}
- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.target respondsToSelector:aSelector];
}

@end
