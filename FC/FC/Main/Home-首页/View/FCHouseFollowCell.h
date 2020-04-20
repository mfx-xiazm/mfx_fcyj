//
//  FCHouseFollowCell.h
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FCHouseFollowLayout,FCHouseFollowCell;

@protocol FCHouseFollowCellDelegate <NSObject>
@optional
/** 展开收起 */
- (void)didClickExpandInCell:(FCHouseFollowCell *)Cell;
@end

@interface FCHouseFollowCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) UIViewController *targetVc;
/** 数据源 */
@property (nonatomic, strong) FCHouseFollowLayout *followLayout;
/** 代理 */
@property (nonatomic, assign) id<FCHouseFollowCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
