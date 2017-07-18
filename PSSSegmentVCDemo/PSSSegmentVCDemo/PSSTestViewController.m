//
//  PSSTestViewController.m
//  PSSSegmentVCDemo
//
//  Created by 山和霞 on 17/4/18.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

#import "PSSTestViewController.h"

@interface PSSTestViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation PSSTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加显示ID的label
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, 100, 100);
    label.center = self.view.center;
    [self.view addSubview:label];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24];
    _label = label;
    if (self.theID) {
        label.text = [NSString stringWithFormat:@"ID=%ld", self.theID];
    }
}

@end
