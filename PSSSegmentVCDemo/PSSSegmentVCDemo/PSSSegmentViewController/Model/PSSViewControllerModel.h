//
//  PSSViewControllerModel.h
//  PSSSegmentVCDemo
//
//  Created by 山和霞 on 17/4/18.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PleaseSet // 请设置 :需要使用者设置的属性
#define PleaseNotSet // 请不要设置 :不需要使用者设置的属性

@interface PSSViewControllerModel : NSObject

// 缓存的控制器的class
@property (nonatomic, strong) PleaseSet Class vcClass;
// 表示viewController的ID(比如网络请求的字段), 如果不需要, 可以不对这个属性进行设置; 如果需要添加其他字段, 可在里面添加
@property (nonatomic, assign) PleaseSet NSInteger vcID;

// 缓存的控制器
@property (nonatomic, strong) PleaseNotSet UIViewController *viewController;
// 更新时间
@property (nonatomic, strong) PleaseNotSet NSDate *date;


@end
