//
//  FCHouseMoreView.h
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FCHouseMoreView,FCHouseMoreObject;

#pragma mark -- 协议
@protocol FCHouseMoreViewDelegate <NSObject>
//点击事件
- (void)houseMoreView:(FCHouseMoreView *)houseMoreView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

#pragma mark -- 数据源
@protocol FCHouseMoreViewDataSource <NSObject>
// 返回元素个数
- (NSInteger)houseMoreView:(FCHouseMoreView *)houseMoreView numberOfItemsInSection:(NSInteger)section;
// 返回每行排列几个元素
- (NSInteger)houseMoreView:(FCHouseMoreView *)houseMoreView columnCountOfSection:(NSInteger)section;
// 返回数据实例
- (FCHouseMoreObject *)houseMoreView:(FCHouseMoreView *)houseMoreView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface FCHouseMoreView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id<FCHouseMoreViewDataSource> dataSource;
@property (nonatomic, weak) id<FCHouseMoreViewDelegate> delegate;

-(void)reloadData;
@end

NS_ASSUME_NONNULL_END
