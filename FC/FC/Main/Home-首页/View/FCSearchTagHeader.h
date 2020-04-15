//
//  FCSearchTagHeader.h
//  FC
//
//  Created by huaxin-01 on 2020/4/15.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^clearHistoryCall)(void);
@interface FCSearchTagHeader : UICollectionReusableView
/* 清空历史记录 */
@property(nonatomic,copy) clearHistoryCall clearHistoryCall;
@end

NS_ASSUME_NONNULL_END
