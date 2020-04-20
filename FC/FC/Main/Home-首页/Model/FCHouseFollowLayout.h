//
//  FCHouseFollowLayout.h
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCHouseFollow.h"

NS_ASSUME_NONNULL_BEGIN

#define kMomentTopPadding 12 // 顶部间隙
#define kMomentMarginPadding 10 // 内容间隙
#define kMomentMarginLeftRight 12 // 内容间隙
#define kMomentPortraitWidthAndHeight 24 // 头像高度
#define kMomentLineSpacing 5 // 文本行间距
#define kMomentHandleButtonHeight 30 // 可操作的按钮高度
#define kMomentContentWidth [UIScreen mainScreen].bounds.size.width - kMomentMarginLeftRight*2 // 内容宽度高度

@interface FCHouseFollowLayout : NSObject
/** 数据源 */
@property(nonatomic,strong) FCHouseFollow *follow;
/** 文本内容布局 */
@property(nonatomic,strong) YYTextLayout *summaryLayout;
/** 文本内容布局 */
@property(nonatomic,strong) YYTextLayout *textLayout;
/** 图片内容布局 */
@property(nonatomic,assign) CGSize photoContainerSize;
/** 计算得出的布局高度 */
@property(nonatomic,assign) CGFloat height;

- (instancetype)initWithModel:(FCHouseFollow *)model;
/** 重置布局 */
- (void)resetLayout;
@end

NS_ASSUME_NONNULL_END
