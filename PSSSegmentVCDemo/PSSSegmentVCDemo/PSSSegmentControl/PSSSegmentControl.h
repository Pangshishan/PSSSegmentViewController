//
//  PSSSegmentControl.h
//  PSSSegmentControl
//
//  Created by 庞仕山 on 16/5/20.
//  Copyright © 2016年 庞仕山. All rights reserved.
//  与UISegmentControl功能相似

#import <UIKit/UIKit.h>

typedef void(^PSSButtonBlock)(NSInteger index);

@interface PSSSegmentControl : UIView
// 下划移动线高度(有多粗)
@property (nonatomic, assign) CGFloat lineHeight;
// 下划移动线长度(有多长)
@property (nonatomic, assign) CGFloat lineWidth;
// 整条下划线颜色
@property (nonatomic, strong) UIColor *lineColor;
// 正常状态下按钮字体颜色
@property (nonatomic, strong) UIColor *normalColor;
// 选中状态下按钮字体颜色
@property (nonatomic, strong) UIColor *selectedColor;
// 选中的行数, set方法具有平移动画效果
@property (nonatomic, assign) NSInteger selectedIndex;
// 平移动画时长
@property (nonatomic, assign) CGFloat lineAnimation;
// 按钮字体
@property (nonatomic, assign) UIFont *labelFont;

// 选中按钮的block回调, 参数为 index
@property (nonatomic, copy) PSSButtonBlock buttonBlock;
- (void)setButtonBlock:(PSSButtonBlock)buttonBlock;

- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray *)titleArray;

@end
