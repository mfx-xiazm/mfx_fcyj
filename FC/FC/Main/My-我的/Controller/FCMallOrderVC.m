//
//  FCMallOrderVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/22.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMallOrderVC.h"
#import "HXTabBarController.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorBackgroundView.h>
#import <JXCategoryListContainerView.h>
#import "FCMallOrderChildVC.h"
#import "HXMallTabBarController.h"

@interface FCMallOrderVC ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *listSuperView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
//@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation FCMallOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCategoryView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.listContainerView.frame = self.listSuperView.bounds;
}
- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    button.hxn_size = CGSizeMake(30, 44);
    // 让按钮内部的所有内容左对齐
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)setUpCategoryView
{
    _categoryView.titles = @[@"民宿订单", @"家政订单", @"开锁订单"];
    _categoryView.layer.cornerRadius = 2.f;
    _categoryView.layer.borderColor = HXControlBg.CGColor;
    _categoryView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    _categoryView.layer.masksToBounds = YES;
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.cellSpacing = 0.f;
    _categoryView.cellWidth = 90.f;
    _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _categoryView.titleColor = [UIColor blackColor];
    _categoryView.titleSelectedColor = [UIColor whiteColor];
    _categoryView.separatorLineShowEnabled = YES;
    _categoryView.separatorLineColor = HXControlBg;
    _categoryView.listContainer = self.listContainerView;
    _categoryView.delegate = self;

    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorCornerRadius = 2;
    backgroundView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[backgroundView];
    
    [self.listSuperView addSubview:self.listContainerView];
}
#pragma mark -- 点击事件
-(void)back
{
    HXTabBarController *tabBarController = [[HXTabBarController alloc] init];
    tabBarController.selectedIndex = ((HXMallTabBarController *)self.navigationController.tabBarController).backSelectedIndex;
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
}
#pragma mark -- JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    
}
#pragma mark -- JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    FCMallOrderChildVC *orderList = [[FCMallOrderChildVC alloc] init];
    if (index == 0) {
        orderList.cateTitles = @[@"全部", @"待付款", @"待使用", @"待评价", @"已完成", @"已取消"];
    }else if(index == 1) {
        orderList.cateTitles = @[@"全部", @"待付款", @"待指派", @"待服务", @"已完成", @"已取消"];
    }else if (index == 2) {
        orderList.cateTitles = @[@"全部", @"待付款", @"待指派", @"待服务", @"已完成", @"已取消"];
    }
    return orderList;
}
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView
{
    return 3.f;
}
/*
- (void)listContainerViewDidScroll:(UIScrollView *)scrollView{
    if ([self isKindOfClass:[FCMallOrderVC class]]) {
        CGFloat index = scrollView.contentOffset.x/scrollView.bounds.size.width;
        CGFloat absIndex = fabs(index - self.currentIndex);
        if (absIndex >= 1) {
            //”快速滑动的时候，只响应最外层VC持有的scrollView“，说实话，完全可以不用处理这种情况。如果你们的产品经理坚持认为这是个问题，就把这块代码加上吧。
            //嵌套使用的时候，最外层的VC持有的scrollView在翻页之后，就断掉一次手势。解决快速滑动的时候，只响应最外层VC持有的scrollView。子VC持有的scrollView却没有响应
            self.listContainerView.scrollView.panGestureRecognizer.enabled = NO;
            self.listContainerView.scrollView.panGestureRecognizer.enabled = YES;
            _currentIndex = floor(index);
        }
    }
}
*/
@end
