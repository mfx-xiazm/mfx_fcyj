//
//  FCMallHomeHeader.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMallHomeHeader.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import <TYCyclePagerView/TYPageControl.h>
#import "FCBannerCell.h"

@interface FCMallHomeHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
/* 轮播图 */
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
/* page */
@property (nonatomic,strong) TYPageControl *pageControl;
@end
@implementation FCMallHomeHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
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
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cycleView.frame) - 15, CGRectGetWidth(self.cycleView.frame), 15);
    self.pageControl = pageControl;
    [self.cycleView addSubview:pageControl];

    [self.cycleView reloadData];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cycleView.frame) - 15, CGRectGetWidth(self.cycleView.frame), 15);
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
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
@end
