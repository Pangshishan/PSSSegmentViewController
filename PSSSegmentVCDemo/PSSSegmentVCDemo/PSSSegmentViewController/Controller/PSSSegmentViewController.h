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
 * 描述：分页已经滑到某个位置是调用。加载第一页数据也会调用一次
 * vcModel：里面存着已经显示的控制器 和 区分控制器的属性
 * index：位置
 */
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didShowWithIndex:(NSInteger)index;

@optional
/*
 * 描述：在每一页的viewDidLoad之前调用, 可以在这里对vcModel中的VC做数据配置
 * vcModel：里面存着已经显示的控制器 和 区分控制器的属性
 * index：位置
 */
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didLoadItemWithIndex:(NSInteger)index;

/*
 * 描述：vc达到缓存时间时调用，如果实现了这个代理方法，就不会删除控制器和视图；如果没实现这个方法，到时间之后帮你清除控制器
 * vcModel：里面存着已经显示的控制器 和 区分控制器的属性
 * index：位置
 */
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel timeOutItemWithIndex:(NSInteger)index;

@end

@interface PSSSegmentViewController : UIViewController

@property (nonatomic, weak) id<PSSSegmentVCDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

// 缓存控制器多久刷新一次, 设置为0时(或者小于最小刷新间隔时), 取消此机制
@property (nonatomic, assign) NSTimeInterval refreshTime;
/// 初始页
@property (nonatomic, assign) NSInteger defaultIndex;

// 请用此方法初始化
- (instancetype)initWithViewControllers:(NSArray<PSSViewControllerModel *> *)vcArray;

// 滚动到哪一页
- (void)pss_scrollToItemWithIndex:(NSInteger)index;
- (void)pss_scrollToItemWithIndex:(NSInteger)index animate:(BOOL)animate;

@end
