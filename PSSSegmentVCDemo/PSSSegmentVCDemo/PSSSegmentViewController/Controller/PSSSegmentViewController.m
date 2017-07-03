//
//  PSSSegmentViewController.m
//  PSSSegmentVCDemo
//
//  Created by 山和霞 on 17/4/18.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

#import "PSSSegmentViewController.h"
#import "PSSSegmentVCConst.h"

static NSString * PSSCollectionViewID = @"PSSCollectionViewID";

@interface PSSSegmentViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) NSArray *modelArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) PSSViewControllerModel *currentVCModel;

@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation PSSSegmentViewController

- (instancetype)initWithViewControllers:(NSArray<PSSViewControllerModel *> *)vcArray
{
    self = [super init];
    if (self) {
        _modelArray = vcArray;
        _selectedIndex = 0;
        _refreshTime = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addCollectionViewInThis];
}
- (void)addCollectionViewInThis
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PSSCollectionViewID];
}
#pragma mark - collectionView代理方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PSSCollectionViewID forIndexPath:indexPath];
    
    [self reloadCellWithIndex:indexPath.item cell: cell];
    
    if ([self.delegate respondsToSelector:@selector(pss_segmentVCModel:didLoadItemWithIndex:)]) {
        [self.delegate pss_segmentVCModel:self.modelArray[indexPath.row] didLoadItemWithIndex:indexPath.row];
    }
    
    // 这里保证：第一次加载时，也调用一次 pss_segmentVCModel:didShowWithIndex: 代理方法，避免遗漏
    if (_selectedIndex == 0 && indexPath.row == 0 && !self.firstLoad) {
        [self didShowWithModel:self.modelArray[indexPath.row] index:indexPath.row];
        self.firstLoad = YES;
    }
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

// 滑到哪里
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    double itemWidth = self.view.bounds.size.width;
    double offSet_x = scrollView.contentOffset.x;
    NSInteger index = offSet_x / itemWidth;
    _selectedIndex = index;
    [self reloadCellWithIndex:index cell: nil];
    [self didShowWithModel:self.modelArray[index] index:index];
}
// 外部调用pss_scrollToItemWithIndex时，滑动动画结束会触发
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    double itemWidth = self.view.bounds.size.width;
    double offSet_x = scrollView.contentOffset.x;
    NSInteger index = offSet_x / itemWidth;
    _selectedIndex = index;
    [self reloadCellWithIndex:index cell: nil];
    [self didShowWithModel:self.modelArray[_selectedIndex] index:_selectedIndex];
}

- (void)reloadCellWithIndex:(NSInteger)index cell:(UICollectionViewCell *)cell
{
    if (!cell) {
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    }
    
    UIViewController *vc = [self getViewControllerAtIndex:index];
    vc.view.frame = self.view.bounds;
    
    [cell.contentView addSubview:vc.view];
    [self removeSubviewsSuperview:cell.contentView Except:vc.view];
    
    // 数据保护
    if (index >= self.modelArray.count) {
        return;
    }
}

// 滚动到哪一条
- (void)pss_scrollToItemWithIndex:(NSInteger)index
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (void)didShowWithModel:(PSSViewControllerModel *)vcModel index:(NSInteger)index
{
    self.currentVCModel = vcModel;
    vcModel.date = [NSDate date];
    if ([self.delegate respondsToSelector:@selector(pss_segmentVCModel:didShowWithIndex:)]) {
        [self.delegate pss_segmentVCModel:vcModel didShowWithIndex:index];
    }
}
- (UIViewController *)getViewControllerAtIndex:(NSInteger)index
{
    if (index < self.modelArray.count) {
        PSSViewControllerModel *vcModel = self.modelArray[index];
        if (!vcModel.viewController) {
            vcModel.viewController = [[vcModel.vcClass alloc] init];
            vcModel.date = [NSDate date];
        }
        return vcModel.viewController;
    }
    return nil;
}
- (void)removeSubviewsSuperview:(UIView *)superview Except:(UIView *)theView
{
    for (UIView *view in superview.subviews) {
        if (![view isEqual:theView]) {
            [view removeFromSuperview];
        }
    }
}
- (void)timerRuning:(NSTimer *)timer
{
    if (self.refreshTime == 0) {
        return;
    }
    NSDate *nowDate = [NSDate date];
    self.currentVCModel.date = nowDate;
    
    for (int i = 0; i < self.modelArray.count; i++) {
        PSSViewControllerModel *vcModel = self.modelArray[i];
        NSTimeInterval duration = [nowDate timeIntervalSinceDate:vcModel.date];
        if (duration > self.refreshTime && ![self.currentVCModel isEqual:vcModel]) {
            if ([self.delegate respondsToSelector:@selector(pss_segmengVCModel:timeOutItemWithIndex:)]) {
                [self.delegate pss_segmengVCModel:vcModel timeOutItemWithIndex:i];
            } else {
                [vcModel.viewController removeFromParentViewController];
                [vcModel.viewController.view removeFromSuperview];
                vcModel.viewController = nil;
            }
        }
    }
}
- (void)setRefreshTime:(NSTimeInterval)refreshTime
{
    _refreshTime = refreshTime > PSSRefreshTimeUnit ? refreshTime : 0;
    if (refreshTime == 0) {
        return;
    }
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:PSSRefreshTimeUnit target:self selector:@selector(timerRuning:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
- (void)dealloc
{
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
