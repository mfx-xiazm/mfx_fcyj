//
//  FCHomeVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/13.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHomeVC.h"
#import "HXSearchBar.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import <TYCyclePagerView/TYPageControl.h>
#import "LMJVerticalScrollText.h"
#import "FCBannerCell.h"
#import "DVPieChart.h"
#import "DVFoodPieModel.h"
#import "FCCityVC.h"
#import "FCMsgVC.h"
#import "FCNoticeVC.h"
#import "FCSearchVC.h"
#import "FCEntireRentHouseVC.h"
#import "FCStoreHouseVC.h"
#import "FCStoreClientVC.h"
#import "FCContractManageVC.h"

@interface FCHomeVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, UITextFieldDelegate>
/* 轮播图 */
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
/* page */
@property (nonatomic,strong) TYPageControl *pageControl;
/* 公告 */
@property (weak, nonatomic) IBOutlet UIView *scrollTextView;
@property (strong, nonatomic) LMJVerticalScrollText *scrollText;
/* 饼状图 */
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (nonatomic, strong) DVPieChart *chart;
/* 业绩控制按钮 */
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

/* 定位按钮 */
@property(nonatomic,strong) SPButton *locationBtn;
@end

@implementation FCHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCycleView];
    [self setUpPieChart];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cycleView.frame) - 35, CGRectGetWidth(self.cycleView.frame), 15);
    self.scrollText.frame = self.scrollTextView.bounds;
    self.chart.frame = self.chartView.bounds;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    SPButton *item = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
    item.hxn_size = CGSizeMake(60, 30);
    item.imageTitleSpace = 5.f;
    item.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [item setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
    [item setImage:HXGetImage(@"筛选下拉") forState:UIControlStateNormal];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName]) {
//        [item setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName] forState:UIControlStateNormal];
//    }else{
        [item setTitle:@"武汉" forState:UIControlStateNormal];
//    }
    [item addTarget:self action:@selector(cityClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.locationBtn = item;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(60, 10, HX_SCREEN_WIDTH- 60.f*2, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入名称查询";
    searchBar.searchIcon = @"首页搜索";
    [searchBar setShadowWithCornerRadius:5.f shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.1 shadowRadius:5.f];
    [self.navigationItem setTitleView:searchBar];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(msgClicked) nomalImage:HXGetImage(@"消息") higeLightedImage:HXGetImage(@"消息") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpCycleView
{
    self.cycleView.isInfiniteLoop = YES;
    self.cycleView.autoScrollInterval = 3.0;
    self.cycleView.dataSource = self;
    self.cycleView.delegate = self;
    // registerClass or registerNib
    [self.cycleView registerNib:[UINib nibWithNibName:NSStringFromClass([FCBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerCell"];
    
    TYPageControl *pageControl = [[TYPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = 3;
    pageControl.currentPageIndicatorSize = CGSizeMake(12, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"轮播白"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"轮播当前"];
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cycleView.frame) - 35, CGRectGetWidth(self.cycleView.frame), 15);
    self.pageControl = pageControl;
    [self.cycleView addSubview:pageControl];

    [self.cycleView reloadData];
    
    self.scrollText = [[LMJVerticalScrollText alloc] initWithFrame:self.scrollTextView.bounds];
    self.scrollText.layer.cornerRadius = 2;
    self.scrollText.layer.masksToBounds = YES;
    self.scrollText.backgroundColor    = [UIColor whiteColor];
    self.scrollText.textDataArr               = @[@"枫巢蚁家2020年5月6日火爆上线，速来围观..."];
    self.scrollText.textColor          = UIColorFromRGB(0x1A1A1A);
    self.scrollText.textFont           = [UIFont systemFontOfSize:12];
    self.scrollText.textAlignment              = NSTextAlignmentLeft;
    
    [self.scrollTextView addSubview:self.scrollText];
    
    [self.scrollText startScrollBottomToTopWithNoSpace];
}
-(void)setUpPieChart
{
    self.chart = [[DVPieChart alloc] initWithFrame:self.chartView.bounds];
    [self.chartView addSubview:self.chart];
    
    DVFoodPieModel *model1 = [[DVFoodPieModel alloc] init];
    model1.rate = 0.25;
    model1.name = @"已定250套";
    model1.value = 250;
    
    DVFoodPieModel *model2 = [[DVFoodPieModel alloc] init];
    model2.rate = 0.3;
    model2.name = @"已租300套";
    model2.value = 300;
    
    
    DVFoodPieModel *model3 = [[DVFoodPieModel alloc] init];
    model3.rate = 0.45;
    model3.name = @"未租450套";
    model3.value = 450;

    NSArray *dataArray = @[model1, model2, model3];
    self.chart.dataArray = dataArray;
    self.chart.title = @"套数";
    [self.chart draw];
}
#pragma mark -- 点击事件
-(void)cityClicked
{
    FCCityVC *cvv = [FCCityVC new];
    [self.navigationController pushViewController:cvv animated:YES];
}
-(void)msgClicked
{
    FCMsgVC *mvc = [FCMsgVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
- (IBAction)noticeClicked:(UIButton *)sender {
    FCNoticeVC *nvc = [FCNoticeVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)houseCateBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        FCEntireRentHouseVC *rvc = [FCEntireRentHouseVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (sender.tag == 2) {
        if (arc4random_uniform(2)%2) {
            FCStoreClientVC *cvc = [FCStoreClientVC new];
            [self.navigationController pushViewController:cvc animated:YES];
        }else{
            FCStoreHouseVC *hvc = [FCStoreHouseVC new];
            [self.navigationController pushViewController:hvc animated:YES];
        }
    }else if (sender.tag == 3) {
        FCContractManageVC *mvc = [FCContractManageVC new];
        [self.navigationController pushViewController:mvc animated:YES];
    }
}

- (IBAction)scoreChangeBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        self.agreementBtn.selected = YES;
        self.recordBtn.selected = NO;
        [self.agreementBtn setBackgroundColor:[UIColor colorWithHexString:@"#6D74FF"]];
        [self.recordBtn setBackgroundColor:[UIColor whiteColor]];
    }else{
        self.agreementBtn.selected = NO;
        self.recordBtn.selected = YES;
        [self.agreementBtn setBackgroundColor:[UIColor whiteColor]];
        [self.recordBtn setBackgroundColor:[UIColor colorWithHexString:@"#6D74FF"]];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    FCSearchVC *svc = [FCSearchVC new];
    [self.navigationController pushViewController:svc animated:YES];
    return NO;
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 3;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FCBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndex:index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0.f;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
@end
