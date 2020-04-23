//
//  FCHotelCommentCell.h
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FCHotelCommentLayout,FCHotelCommentCell;

@protocol FCHotelCommentCellDelegate <NSObject>
@optional
/** 点击了全文/收回 */
- (void)didClickMoreLessInCommentCell:(FCHotelCommentCell *)Cell;
@end

@interface FCHotelCommentCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 数据源 */
@property (nonatomic, strong) FCHotelCommentLayout *commentLayout;
/** 代理 */
@property (nonatomic, assign) id<FCHotelCommentCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
