//
//  FCEntireHouseDetailHeader.m
//  FC
//
//  Created by huaxin-01 on 2020/4/24.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCEntireHouseDetailHeader.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "FCBannerCell.h"

@interface FCEntireHouseDetailHeader ()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
/* 轮播图 */
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
@property (weak, nonatomic) IBOutlet UILabel *currentPage;

@end
@implementation FCEntireHouseDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.cycleView bringSubviewToFront:self.currentPage];
    
    self.cycleView.isInfiniteLoop = YES;
    self.cycleView.autoScrollInterval = 3.0;
    self.cycleView.dataSource = self;
    self.cycleView.delegate = self;
    // registerClass or registerNib
    [self.cycleView registerNib:[UINib nibWithNibName:NSStringFromClass([FCBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerCell"];

    [self.cycleView reloadData];
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
    layout.itemSize = CGSizeMake(HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*280.f/375.f);
    layout.itemSpacing = 0.f;
    layout.itemHorizontalCenter = YES;
    layout.sectionInset = UIEdgeInsetsZero;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.currentPage.text = [NSString stringWithFormat:@"%zd/3",toIndex+1];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
@end
