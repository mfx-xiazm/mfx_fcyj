//
//  FCBillInfoView.h
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^dissmissCall)(void);
@interface FCBillInfoView : UIView
@property (nonatomic, copy) dissmissCall dissmissCall;
@end

NS_ASSUME_NONNULL_END
