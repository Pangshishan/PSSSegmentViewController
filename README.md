作为一名iOS开发，最常用到的就是分页控制器了，类似于新闻首页；
先看下图，我们做的到底是个什么东西，图中内容虽然有些简略，但是功能并不缺失

![图](http://upload-images.jianshu.io/upload_images/5379614-71ea9fe22ba9569e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

接下来，我们来看一下图中有什么内容
- 头部是一个类似UISegmentControl的控件，我封装的非常简单，用起来也很方便，不过有缺陷，只能显示一行，并且不能滑动，显示五个item就差不多了，如果头部这个控件不能满足需求，可以把它换成别的，集成起来很轻松。这部分先略过

- 第二部分就是我们今天要介绍的，分页控制器；

### 分页控制器 - SSSegmentViewController
> 1. 支持缓存
> 2. 用代理封装出接口，注释非常全面
> 3. 使用了重用机制，实现复用
> 4. 用法非常简单，代码易读，易集成

##### 1. 文件结构

![文件结构](http://upload-images.jianshu.io/upload_images/5379614-b6814aabc3cb40ef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- PSSSegmentViewController 就是我们要用到的控制器
- PSSViewControllerModel 这个里存放了显示的控制器，控制器最后一次被查看时间（用于缓存），控制器ID（用于区分控制器），控制器的类（我来帮你创建控制器）
- PSSSegmentVCConst 这个文件里存了一些常量


##### 2. 头文件暴露出的接口
```Objective-C
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
```

##### 3. 集成方法
```Objective-C
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
    // 如果不保存vc, 只加了vc.view, 当出了这条方法, vc就没有了, vc的view也被干掉了
    self.segmentViewController = segmentVC;
    
    // 控制器12秒刷新一次缓存
    segmentVC.refreshTime = 12.0;
    
    segmentVC.delegate = self;
}
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didShowWithIndex:(NSInteger)index
{
    // 可以对vcModel中的ViewController进行一些操作
    PSSTestViewController *testVC = (PSSTestViewController *)vcModel.viewController;
    testVC.theID = vcModel.vcID;
    self.segmentControl.selectedIndex = index;
}
- (void)pss_segmentVCModel:(PSSViewControllerModel *)vcModel didLoadItemWithIndex:(NSInteger)index
{
    // 还未显示时（控制器加载完成，还未显示），就会回调
    // 可以将上面代理方法的实现拖到这里看看效果
}
- (void)pss_segmengVCModel:(PSSViewControllerModel *)vcModel timeOutItemWithIndex:(NSInteger)index
{
    // vc达到缓存时间时调用，如果实现了这个代理方法，就不会删除控制器和视图；如果没实现这个方法，到时间之后帮你清除控制器
}
@end
```
*如果觉得对您有帮助，就star一下吧。您的star就是对我最大的鼓励！
如果发现什么问题，或者有什么意见，请加我qq或微信：704158807
电子邮箱：pangshishan@aliyun.com*
