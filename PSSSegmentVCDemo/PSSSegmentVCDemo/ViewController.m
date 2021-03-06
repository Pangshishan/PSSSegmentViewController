//
//  ViewController.m
//  PSSSegmentVCDemo
//
//  Created by 山和霞 on 17/4/18.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

#import "ViewController.h"
#import "PSSSegmentViewController.h"
#import "PSSSegmentControl.h"
#import "PSSTestViewController.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenSize   [UIScreen mainScreen].bounds.size
#define kWindows [[UIApplication sharedApplication].delegate window]

@interface ViewController () <PSSSegmentVCDelegate>

@property (nonatomic, strong) PSSSegmentControl *segmentControl;
@property (nonatomic, strong) PSSSegmentViewController *segmentViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addSomeSubviews];
}
- (void)addSomeSubviews
{
    // 初始化 segmentControl
    NSArray *titleArr = @[@"第一页", @"第二页", @"第三页", @"第四页", @"第五页"];
    PSSSegmentControl *segmentC = [[PSSSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) titleArray:titleArr];
    self.segmentControl = segmentC;
    [self.view addSubview:segmentC];
    __weak typeof(self) weakSelf = self;
    self.segmentControl.buttonBlock = ^(NSInteger index) {
        [weakSelf.segmentViewController pss_scrollToItemWithIndex:index];
    };
    
    // 初始化 segmentVC
    NSMutableArray *vcModelArr = [NSMutableArray new];
    for (int i = 0; i < titleArr.count; i++) {
        PSSViewControllerModel *vcModel = [[PSSViewControllerModel alloc] init];
        vcModel.vcClass = [PSSTestViewController class];
        vcModel.vcID = 101 + i;
        [vcModelArr addObject:vcModel];
    }
    PSSSegmentViewController *segmentVC = [[PSSSegmentViewController alloc] initWithViewControllers:vcModelArr];
    segmentVC.view.frame = CGRectMake(0, CGRectGetMaxY(segmentC.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(segmentC.frame));
    [self.view addSubview:segmentVC.view];
    
    self.segmentViewController = segmentVC;
    [self addChildViewController:segmentVC];

    // 默认在第几页
    segmentVC.defaultIndex = 1;
    
    // 控制器12秒刷新一次缓存
    segmentVC.refreshTime = 12.0;
    
    segmentVC.delegate = self;
}
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didShowWithIndex:(NSInteger)index
{
    // 分页滚到了这一页
    self.segmentControl.selectedIndex = index;
}
// 在控制器调用ViewDidLoad之前调用
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didLoadItemWithIndex:(NSInteger)index
{
    PSSTestViewController *testVC = (PSSTestViewController *)vcModel.viewController;
    testVC.theID = vcModel.vcID;
}
//- (void)pss_segmengVCModel:(PSSViewControllerModel *)vcModel timeOutItemWithIndex:(NSInteger)index
//{
//    // vc达到缓存时间时调用;
//    // 如果实现了这个代理方法，就不会删除控制器和视图；如果没实现这个方法，到时间之后帮你清除控制器
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
