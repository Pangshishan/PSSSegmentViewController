//
//  PSSWeakProxy.h
//  PSSSegmentVCDemo
//
//  Created by pangshishan on 2017/12/28.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSSWeakProxy : NSProxy

@property (weak, nonatomic, readonly) id target;
+ (instancetype)proxyWithTarget:(id)target;
- (instancetype)initWithTarget:(id)target;

@end
