//
//  FCHotelCommentHeader.h
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^lookMoreCall)(void);
@interface FCHotelCommentHeader : UIView
@property (nonatomic, copy) lookMoreCall lookMoreCall;
@end

NS_ASSUME_NONNULL_END
