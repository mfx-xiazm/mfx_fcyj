//
//  FCHouseMoreView.m
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHouseMoreView.h"
#import "FCHouseMoreCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "FCHouseMoreObject.h"

static NSString *const HouseMoreCell = @"HouseMoreCell";
@interface FCHouseMoreView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>

@end
@implementation FCHouseMoreView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCHouseMoreCell class]) bundle:nil] forCellWithReuseIdentifier:HouseMoreCell];
}
-(void)reloadData
{
    [self.collectionView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource houseMoreView:self columnCountOfSection:section];
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return [self.dataSource houseMoreView:self columnCountOfSection:section];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FCHouseMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HouseMoreCell forIndexPath:indexPath];
    FCHouseMoreObject *object = [self.dataSource houseMoreView:self cellForItemAtIndexPath:indexPath];
    cell.contentImage.image = HXGetImage(object.imageName);
    cell.name.text = object.cateName;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(houseMoreView:didSelectItemAtIndexPath:)]) {
        [self.delegate houseMoreView:self didSelectItemAtIndexPath:indexPath];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [self.dataSource houseMoreView:self columnCountOfSection:indexPath.section];
    CGFloat width = HX_SCREEN_WIDTH/count;
    CGFloat height = width*0.75;
    return CGSizeMake(width, height);
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10.f;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 10.f;
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return  UIEdgeInsetsMake(5, 12, 5, 12);
//}
@end
