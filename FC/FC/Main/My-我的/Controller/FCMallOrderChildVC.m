//
//  FCMallOrderChildVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMallOrderChildVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "FCMallOrderListVC.h"

@interface FCMallOrderChildVC ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *listSuperView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@end

@implementation FCMallOrderChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = self.cateTitles;
    _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _categoryView.titleColor = [UIColor blackColor];
    _categoryView.titleSelectedColor = HXControlBg;
    _categoryView.delegate = self;
    _categoryView.listContainer = self.listContainerView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
    
    [self.listSuperView addSubview:self.listContainerView];
}
#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
   
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark -- JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    FCMallOrderListVC *orderList = [[FCMallOrderListVC alloc] init];
    
    return orderList;
}
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView
{
    return self.cateTitles.count;
}
@end
