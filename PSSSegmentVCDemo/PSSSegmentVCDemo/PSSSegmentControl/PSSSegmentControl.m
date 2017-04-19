//
//  PSSSegmentControl.m
//  PSSSegmentControl
//
//  Created by 庞仕山 on 16/5/20.
//  Copyright © 2016年 庞仕山. All rights reserved.
//

#import "PSSSegmentControl.h"

@interface PSSSegmentControl ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation PSSSegmentControl


- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        if (titleArray == nil) {
            return self;
        }
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.07];
        _titleArray = titleArray;
        NSInteger count = titleArray.count;
        for (int i = 0; i < count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.text = titleArray[i];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat width = self.bounds.size.width / count;
            CGFloat height = self.bounds.size.height - 1;
            CGFloat x = 0 + i * width;
            CGFloat y = 0;
            button.frame = CGRectMake(x, y, width, height);
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [self addSubview:button];
            button.tag = 100 + i;
            button.backgroundColor = [UIColor whiteColor];
            if (i == 0) {
                _selectedIndex = 0;
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
        CGFloat lineHeight = _lineHeight ? _lineHeight : 3;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - lineHeight, frame.size.width / titleArray.count, lineHeight)];
        _lineView.backgroundColor = [UIColor redColor];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)clickButton:(UIButton *)button
{
    [self selectButtonColorWithIndex:button.tag - 100];
    if (self.buttonBlock) {
        self.buttonBlock(button.tag - 100);
    }
}

- (void)selectButtonColorWithIndex:(NSInteger)index
{
    _selectedIndex = index;
    UIColor *normalColor = self.normalColor ? self.normalColor : [UIColor blackColor];
    UIColor *selectColor = self.selectedColor ? self.selectedColor : [UIColor redColor];
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *theButton = (UIButton *)[self viewWithTag:i + 100];
        UIFont *font = [UIFont systemFontOfSize:17];
        font = _labelFont ? _labelFont : font;
        theButton.titleLabel.font = font;
        if (i == index) {
            [theButton setTitleColor:selectColor forState:UIControlStateNormal];
            [self lineAnimationWithIndex:i];
        } else {
            [theButton setTitleColor:normalColor forState:UIControlStateNormal];
        }
    }
}

- (void)lineAnimationWithIndex:(NSInteger)index
{
    CGFloat lineDuration = _lineAnimation ? _lineAnimation : 0.2;
    [UIView animateWithDuration:lineDuration animations:^{
        CGFloat width = _lineWidth ? _lineWidth : self.bounds.size.width / self.titleArray.count;
        CGFloat lineHeight = _lineHeight ? _lineHeight : 3;
        _lineView.frame = CGRectMake((self.bounds.size.width / _titleArray.count - width) / 2 + index * self.bounds.size.width / self.titleArray.count, self.bounds.size.height - lineHeight, width, lineHeight);
    }];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    _lineView.frame = CGRectMake((self.bounds.size.width / _titleArray.count - lineWidth) / 2, _lineView.frame.origin.y, lineWidth, _lineView.frame.size.height);
}
- (void)setLineHeight:(CGFloat)lineHeight
{
    _lineHeight = lineHeight;
    _lineView.frame = CGRectMake(_lineView.frame.origin.x, _lineView.frame.origin.y, _lineView.frame.size.width, lineHeight);
}
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    _lineView.backgroundColor = lineColor;
}
- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    [self selectButtonColorWithIndex:_selectedIndex];
}
- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [self selectButtonColorWithIndex:_selectedIndex];
}
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex >= _titleArray.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    [self selectButtonColorWithIndex:_selectedIndex];
}
- (void)setLabelFont:(UIFont *)labelFont
{
    _labelFont = labelFont;
    [self selectButtonColorWithIndex:_selectedIndex];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
