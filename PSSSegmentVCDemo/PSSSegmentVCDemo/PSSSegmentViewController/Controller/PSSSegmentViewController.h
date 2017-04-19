//
//  PSSSegmentViewController.h
//  PSSSegmentVCDemo
//
//  Created by 山和霞 on 17/4/18.
//  Copyright © 2017年 庞仕山. All rights reserved.
//  分页控制器
/*
    实现原理
 */
#import <UIKit/UIKit.h>
#import "PSSViewControllerModel.h"

@protocol PSSSegmentVCDelegate <NSObject>

@required
/*
 * 描述：分页已经滑到某个位置是调用，手动滑动到这个位置，才会触发。第一次初始化显示第一页也会触发一次，避免遗漏。
 * vcModel：里面存着已经显示的控制器 和 区分控制器的属性
 * index：位置
 */
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didShowWithIndex:(NSInteger)index;

@optional
/*
 * 描述：index位置的分页控制器加载完成, 可以在这里对vcModel中的VC做数据配置，创建工作已经在内部完成，可以说这是一种预加载
 * vcModel：里面存着已经显示的控制器 和 区分控制器的属性
 * index：位置
 */
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didLoadItemWithIndex:(NSInteger)index;

/*
 * 描述：vc达到缓存时间时调用，如果实现了这个代理方法，就不会删除控制器和视图；如果没实现这个方法，到时间之后帮你清除控制器
 * vcModel：里面存着已经显示的控制器 和 区分控制器的属性
 * index：位置
 */
- (void)pss_segmengVCModel:(PSSViewControllerModel *)vcModel timeOutItemWithIndex:(NSInteger)index;

@end

@interface PSSSegmentViewController : UIViewController

@property (nonatomic, weak) id<PSSSegmentVCDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

// 缓存控制器多久刷新一次
@property (nonatomic, assign) NSTimeInterval refreshTime;

// 请用此方法初始化
- (instancetype)initWithViewControllers:(NSArray<PSSViewControllerModel *> *)vcArray;

// 滚动到哪一页
- (void)pss_scrollToItemWithIndex:(NSInteger)index;

@end