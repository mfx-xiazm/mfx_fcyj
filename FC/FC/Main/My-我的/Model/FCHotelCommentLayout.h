//
//  FCHotelCommentLayout.h
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCHotelComment.h"

NS_ASSUME_NONNULL_BEGIN
#define kMomentTopPadding 15 // 顶部间隙
#define kMomentMarginPadding 10 // 内容间隙
#define kMomentPortraitWidthAndHeight 24 // 头像高度
#define kMomentLineSpacing 5 // 文本行间距
#define kMomentHandleButtonHeight 30 // 可操作的按钮高度
#define kMomentMarginLeftRight 12 // 左右内容间隙
@interface FCHotelCommentLayout : NSObject
/** 数据源 */
@property(nonatomic,strong) FCHotelComment *comment;
/** 文本内容布局 */
@property(nonatomic,strong) YYTextLayout *textLayout;
/** 图片内容布局 */
@property(nonatomic,assign) CGSize photoContainerSize;
/** 计算得出的布局高度 */
@property(nonatomic,assign) CGFloat height;

- (instancetype)initWithModel:(FCHotelComment *)model;
/** 重置布局 */
- (void)resetLayout;
@end

NS_ASSUME_NONNULL_END
